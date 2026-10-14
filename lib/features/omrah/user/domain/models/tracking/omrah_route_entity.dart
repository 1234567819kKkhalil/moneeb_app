import 'package:equatable/equatable.dart';

/// A single geographic point of the provider's tracked route.
///
/// Kept free of any map-SDK type so the data/domain layers stay independent of
/// the rendering SDK; the presentation layer maps it to a Google Maps `LatLng`.
class OmrahRoutePointEntity extends Equatable {
  final double latitude;
  final double longitude;

  const OmrahRoutePointEntity({
    required this.latitude,
    required this.longitude,
  });

  /// Guards against the malformed coordinates a GPS trail can contain:
  /// out-of-range values and the "null island" (0,0) fix devices emit when
  /// they have no lock yet.
  bool get isValid =>
      latitude >= -90 &&
      latitude <= 90 &&
      longitude >= -180 &&
      longitude <= 180 &&
      !(latitude == 0 && longitude == 0);

  /// Parses a `{lat, lng}` object as returned by `tracking/{orderId}/path`.
  static OmrahRoutePointEntity? fromLatLngJson(dynamic json) {
    if (json is! Map) return null;

    final latitude = (json['lat'] as num?)?.toDouble();
    final longitude = (json['lng'] as num?)?.toDouble();
    if (latitude == null || longitude == null) return null;

    return OmrahRoutePointEntity(latitude: latitude, longitude: longitude);
  }

  /// Parses a GeoJSON `[lng, lat]` pair as returned by
  /// `tracking/{orderId}/route`.
  static OmrahRoutePointEntity? fromGeoJsonPair(dynamic json) {
    if (json is! List || json.length < 2) return null;

    final longitude = (json[0] as num?)?.toDouble();
    final latitude = (json[1] as num?)?.toDouble();
    if (latitude == null || longitude == null) return null;

    return OmrahRoutePointEntity(latitude: latitude, longitude: longitude);
  }

  @override
  List<Object?> get props => [latitude, longitude];
}

/// The provider's tracked route for an order, ready to be drawn as a polyline.
class OmrahRouteEntity extends Equatable {
  final List<OmrahRoutePointEntity> points;

  /// Total route distance in meters. `0` when the backend could not snap the
  /// trail to the road network.
  final double distanceMeters;

  /// Estimated travel duration in seconds. `0` when not snapped.
  final double durationSeconds;

  /// `true` when the geometry follows the road network (OSRM map-matched),
  /// `false` when it is the raw GPS line.
  final bool snapped;

  const OmrahRouteEntity({
    required this.points,
    this.distanceMeters = 0,
    this.durationSeconds = 0,
    this.snapped = false,
  });

  const OmrahRouteEntity.empty() : this(points: const []);

  bool get isEmpty => points.isEmpty;

  /// A polyline needs at least two distinct points to be renderable.
  bool get isDrawable => points.length >= 2;

  /// Parses the `data` payload of `GET tracking/{orderId}/route`:
  /// `{ geometry: { type, coordinates: [[lng, lat], ...] }, distanceMeters, ... }`
  factory OmrahRouteEntity.fromRouteJson(Map<String, dynamic>? json) {
    if (json == null) return const OmrahRouteEntity.empty();

    final geometry = json['geometry'];
    final coordinates = geometry is Map ? geometry['coordinates'] : null;

    return OmrahRouteEntity(
      points: _parsePoints(coordinates, OmrahRoutePointEntity.fromGeoJsonPair),
      distanceMeters: (json['distanceMeters'] as num?)?.toDouble() ?? 0,
      durationSeconds: (json['durationSeconds'] as num?)?.toDouble() ?? 0,
      snapped: json['snapped'] as bool? ?? false,
    );
  }

  /// Parses the `data` payload of `GET tracking/{orderId}/path`:
  /// `{ points: [{ lat, lng, timestamp, ... }, ...] }`.
  ///
  /// Used as a fallback: `/location` writes to the 24h Redis window, so a
  /// still-running order can have points here before they reach the durable
  /// store `/route` is derived from.
  factory OmrahRouteEntity.fromPathJson(Map<String, dynamic>? json) {
    if (json == null) return const OmrahRouteEntity.empty();

    return OmrahRouteEntity(
      points: _parsePoints(json['points'], OmrahRoutePointEntity.fromLatLngJson),
    );
  }

  /// Parses one page of `GET tracking/{orderId}/history`:
  /// `{ items: [{ lat, lng, timestamp, ... }, ...], meta: {...} }`.
  ///
  /// The durable store behind a completed omrah, where the 24h live window has
  /// already expired.
  factory OmrahRouteEntity.fromHistoryJson(Map<String, dynamic>? json) {
    if (json == null) return const OmrahRouteEntity.empty();

    return OmrahRouteEntity(
      points: _parsePoints(json['items'], OmrahRoutePointEntity.fromLatLngJson),
    );
  }

  /// Reads `meta.totalPages` so the caller knows how many pages to walk.
  static int totalPagesOf(Map<String, dynamic>? json) {
    final meta = json?['meta'];
    if (meta is! Map) return 0;

    return (meta['totalPages'] as num?)?.toInt() ?? 0;
  }

  /// Builds a single route out of the pages walked from the history endpoint.
  factory OmrahRouteEntity.fromHistoryPages(
    Iterable<OmrahRouteEntity> pages,
  ) {
    return OmrahRouteEntity(
      points: [for (final page in pages) ...page.points],
    );
  }

  /// Maps a raw coordinate list, dropping anything malformed and collapsing
  /// consecutive duplicates so the polyline stays clean.
  static List<OmrahRoutePointEntity> _parsePoints(
    dynamic rawList,
    OmrahRoutePointEntity? Function(dynamic) parse,
  ) {
    if (rawList is! List) return const [];

    final points = <OmrahRoutePointEntity>[];

    for (final raw in rawList) {
      final point = parse(raw);
      if (point == null || !point.isValid) continue;
      if (points.isNotEmpty && points.last == point) continue;

      points.add(point);
    }

    return points;
  }

  @override
  List<Object?> get props => [points, distanceMeters, durationSeconds, snapped];
}
