import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:moneeb/core/config/config.dart';
import 'package:moneeb/features/omrah/common/data/endpoints/omrah_endpoint.dart';
import 'package:moneeb/features/omrah/provider/domain/models/omrah/omrah_step_entity.dart';
import 'package:moneeb/features/omrah/user/domain/models/tracking/omrah_route_entity.dart';

@lazySingleton
class OmrahInspectorRepo {
  /// Max page size the tracking history endpoint accepts.
  static const int _historyPageSize = 5000;

  /// Upper bound on pages walked, i.e. 100k points — far beyond any real
  /// omrah, but it keeps a bad `totalPages` from looping forever.
  static const int _maxHistoryPages = 20;

  final DioHelper _dioHelper;
  OmrahInspectorRepo(this._dioHelper);

  Future<List<OmrahStepEntity>> getRitualSteps(String orderId) async {
    final response = await _dioHelper.get(
      OmrahEndpoint.omrahSteps(orderId),
    );

    final ritualSteps = ((response.data['data'] as List?)??[])
      .map((item) => OmrahStepEntity.fromJson(item))
      .toList();

    return ritualSteps;
  }

  /// Fetches the provider's tracked route for [orderId] so it can be drawn as
  /// a polyline.
  ///
  /// Primary source is `tracking/{orderId}/route`, which returns a road-snapped
  /// GeoJSON LineString built for rendering. When it has nothing to draw we
  /// retry against `tracking/{orderId}/path`: `POST tracking/{orderId}/location`
  /// stores points in a 24h Redis window, so an in-flight order can have live
  /// points there that have not reached the durable store yet.
  ///
  /// Returns an empty route rather than throwing when the order has no tracking
  /// data at all.
  Future<OmrahRouteEntity> getTrackingRoute(String orderId) async {
    final routePayload = await _getTrackingPayload(
      OmrahEndpoint.trackingRoute(orderId),
    );

    final route = OmrahRouteEntity.fromRouteJson(routePayload);
    if (route.isDrawable) return route;

    final pathPayload = await _getTrackingPayload(
      OmrahEndpoint.trackingPath(orderId),
    );

    final livePath = OmrahRouteEntity.fromPathJson(pathPayload);

    return livePath.isDrawable ? livePath : route;
  }

  /// Route source for an omrah that is already completed.
  ///
  /// Reads the durable history first, then falls back to the live sources: an
  /// omrah that finished moments ago can still have its points sitting in the
  /// 24h Redis window before they are flushed to the durable store.
  Future<OmrahRouteEntity> getCompletedOmrahRoute(String orderId) async {
    final history = await getTrackingHistory(orderId);
    if (history.isDrawable) return history;

    return getTrackingRoute(orderId);
  }

  /// Fetches the durable GPS history for [orderId], walking the paginated
  /// endpoint so a long omrah comes back as one continuous route.
  ///
  /// This is the source for a completed omrah: the live 24h window `/path`
  /// reads from has expired by then, and `/route` map-matches a trail that is
  /// no longer changing.
  Future<OmrahRouteEntity> getTrackingHistory(String orderId) async {
    final pages = <OmrahRouteEntity>[];

    final firstPayload = await _fetchHistoryPage(orderId, page: 1);
    pages.add(OmrahRouteEntity.fromHistoryJson(firstPayload));

    final totalPages = OmrahRouteEntity.totalPagesOf(firstPayload);

    // Bound the walk so a runaway page count can never hang the map.
    final pagesToFetch = totalPages.clamp(0, _maxHistoryPages);

    for (var page = 2; page <= pagesToFetch; page++) {
      final payload = await _fetchHistoryPage(orderId, page: page);
      pages.add(OmrahRouteEntity.fromHistoryJson(payload));
    }

    if (totalPages > _maxHistoryPages) {
      log(
        'Tracking history for $orderId has $totalPages pages; '
        'drawing the first $_maxHistoryPages only.',
      );
    }

    return OmrahRouteEntity.fromHistoryPages(pages);
  }

  Future<Map<String, dynamic>?> _fetchHistoryPage(
    String orderId, {
    required int page,
  }) async {
    return _getTrackingPayload(
      OmrahEndpoint.trackingHistory(orderId),
      query: {'page': page, 'limit': _historyPageSize},
    );
  }

  /// Single place every tracking request goes through, so all three endpoints
  /// share one place to fetch and unwrap the response envelope.
  Future<Map<String, dynamic>?> _getTrackingPayload(
    String url, {
    Map<String, dynamic>? query,
  }) async {
    final response = await _dioHelper.get(url, query: query);

    return _payloadOf(response.data);
  }

  Map<String, dynamic>? _payloadOf(dynamic responseData) {
    if (responseData is! Map) return null;

    final data = responseData['data'];

    return data is Map ? Map<String, dynamic>.from(data) : null;
  }

  Future<void> addReview(String orderId, {required double score, required String comment}) async {
    await _dioHelper.post(
      OmrahEndpoint.addReview(orderId),
      data: {
        'score': score.toInt(),
        'comment': comment,
      },
    );
  }
}