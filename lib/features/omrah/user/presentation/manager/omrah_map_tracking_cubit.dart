import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moneeb/core/base/di/data_injector.dart';
import 'package:moneeb/core/base/helpers/helpers.dart';
import 'package:moneeb/features/omrah/user/data/repo/omrah_inspector_repo.dart';
import 'package:moneeb/features/omrah/user/domain/models/tracking/omrah_route_entity.dart';
import 'package:moneeb/features/omrah/user/presentation/manager/socket/omrah_socket.dart';

part 'omrah_map_tracking_state.dart';

/// Owns every source of tracking data for the map inspector page:
/// the already-walked route fetched over REST, and the live points streamed
/// over the tracking socket. The page only renders what this exposes.
class OmrahMapTrackingCubit extends Cubit<OmrahMapTrackingState> {
  late final OmrahInspectorRepo _repo;
  late final OmrahSocket _socket;

  final String orderId;

  /// A finished omrah is a closed record: its route comes from the durable
  /// history endpoint, and there is no provider left to stream live pings.
  final bool isOmrahCompleted;

  StreamSubscription<Map<String, dynamic>>? _locationSubscription;

  OmrahMapTrackingCubit(this.orderId, {this.isOmrahCompleted = false})
      : super(const OmrahMapTrackingState.initial()) {
    _repo = injector();
    _socket = OmrahSocket(injector());
  }

  /// Loads the route already walked, then — for an omrah still in progress —
  /// starts listening for live updates.
  ///
  /// The two are independent: a socket failure still leaves the historical
  /// route on screen, and an empty/failed route still allows live tracking.
  Future<void> init() async {
    await getTrackingRoute();

    if (isOmrahCompleted) return;

    await _listenToLiveLocation();
  }

  Future<void> getTrackingRoute() async {
    if (state.route.isLoading) return;

    emit(state.copyWith(route: const StateBox.loading()));

    await collect(
      task: () async {
        final route = isOmrahCompleted
            ? await _repo.getCompletedOmrahRoute(orderId)
            : await _repo.getTrackingRoute(orderId);

        emit(state.copyWith(route: StateBox.success(route)));
      },
      onError: (failure) {
        emit(state.copyWith(route: StateBox.failure(failure)));
      },
    );
  }

  Future<void> _listenToLiveLocation() async {
    try {
       await _socket.connect();
      _socket.subscribe(orderId);

      _locationSubscription = _socket.locationUpdates.listen(
        _onLocationUpdate,
        onError: (Object error) {
          log('OmrahMapTrackingCubit location stream error: $error');
        },
      );
    } catch (e) {
      log('OmrahMapTrackingCubit failed to connect to tracking socket: $e');
    }
  }

  void _onLocationUpdate(Map<String, dynamic> event) {
    final payload = LocationUpdatePayload.fromJson(event);

    final latitude = payload.lat;
    final longitude = payload.lng;
    if (latitude == null || longitude == null) return;

    final point = OmrahRoutePointEntity(
      latitude: latitude,
      longitude: longitude,
    );

    // Drop malformed fixes and repeated pings from a stationary provider so
    // the polyline does not grow without moving.
    if (!point.isValid) return;
    if (state.livePoints.isNotEmpty && state.livePoints.last == point) return;

    emit(state.copyWith(livePoints: [...state.livePoints, point]));
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    _socket.dispose();

    return super.close();
  }
}
