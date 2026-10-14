part of 'omrah_map_tracking_cubit.dart';

class OmrahMapTrackingState extends Equatable {
  /// The route already walked, loaded once when the page opens.
  final StateBox<OmrahRouteEntity> route;

  /// Points received over the tracking socket since the page opened, in order.
  final List<OmrahRoutePointEntity> livePoints;

  const OmrahMapTrackingState({
    required this.route,
    required this.livePoints,
  });

  const OmrahMapTrackingState.initial()
      : this(route: const StateBox.initial(), livePoints: const []);

  /// The full polyline: the fetched route continued by everything that has
  /// arrived live, so the drawn line keeps up with the moving marker.
  List<OmrahRoutePointEntity> get polylinePoints => [
        ...?route.data?.points,
        ...livePoints,
      ];

  /// A polyline needs at least two points; anything less is not drawable.
  bool get canDrawPolyline => polylinePoints.length >= 2;

  /// Latest known position of the provider — a live ping when there is one,
  /// otherwise the end of the fetched route.
  OmrahRoutePointEntity? get lastKnownLocation =>
      polylinePoints.isEmpty ? null : polylinePoints.last;

  bool get hasLiveLocation => livePoints.isNotEmpty;

  /// True once the request settled and there was nothing to draw, and no live
  /// point has arrived either — the "waiting for the provider" case.
  bool get hasNoTrackingData =>
      !hasLiveLocation && (route.isSuccess && !(route.data?.isDrawable ?? false));

  OmrahMapTrackingState copyWith({
    StateBox<OmrahRouteEntity>? route,
    List<OmrahRoutePointEntity>? livePoints,
  }) {
    return OmrahMapTrackingState(
      route: route ?? this.route,
      livePoints: livePoints ?? this.livePoints,
    );
  }

  @override
  List<Object?> get props => [route, livePoints];
}
