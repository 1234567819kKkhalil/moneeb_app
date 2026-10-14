import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moneeb/core/app_material/material.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/features/omrah/provider/domain/models/enums/omrah_steps_enum.dart';
import 'package:moneeb/features/omrah/user/domain/models/tracking/omrah_route_entity.dart';
import 'package:moneeb/features/omrah/user/presentation/manager/omrah_map_tracking_cubit.dart';

const double kaabaLongitude = 39.826206;
const double kaabaLatitude = 21.422487;

/// Google zoom levels sit one step above the Mapbox values this page used
/// before (256px vs 512px tiles), so 8.5 / 17 frame the same area the old
/// 7.5 / 16 did.
const double _initialZoom = 8.5;
const double _followZoom = 17;

const double _routeFramingPadding = 70;

/// The 25px marker asset at the 3.1x scale the old map rendered it at.
const double _markerWidth = 24;

class UserOmrahMapInspectorPage extends StatelessWidget {
  final String orderId;

  /// Progress of the omrah. [OmrahStepsEnum.finished] means it is completed,
  /// which switches the page to the durable tracking history and drops the
  /// "waiting for the provider" hint. Null when the caller does not know,
  /// which is treated as still in progress.
  final OmrahStepsEnum? currentStep;

  const UserOmrahMapInspectorPage({
    super.key,
    required this.orderId,
    this.currentStep,
  });

  static const String routeName = "UserOmrahMapInspectorPage";

  bool get _isOmrahCompleted => currentStep == OmrahStepsEnum.finished;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OmrahMapTrackingCubit(
        orderId,
        isOmrahCompleted: _isOmrahCompleted,
      )..init(),
      lazy: false,
      child: const _UserOmrahMapInspectorBody(),
    );
  }
}

class _UserOmrahMapInspectorBody extends StatefulWidget {
  const _UserOmrahMapInspectorBody();

  @override
  State<_UserOmrahMapInspectorBody> createState() =>
      _UserOmrahMapInspectorBodyState();
}

class _UserOmrahMapInspectorBodyState
    extends State<_UserOmrahMapInspectorBody> {
  GoogleMapController? _mapController;

  /// Marker icon built from the bundled asset. The marker is not drawn until
  /// it is ready; if loading definitively fails, the default pin steps in so
  /// the last known position is never silently hidden.
  BitmapDescriptor? _markerIcon;
  bool _markerIconFailed = false;

  /// The camera only starts responding once the map exists; tracking data can
  /// land before or after that, so both paths funnel into [_syncCamera].
  bool _isMapReady = false;

  /// The route is framed once, so a later live ping is free to follow the
  /// provider instead of snapping back to the whole route.
  bool _hasFramedRoute = false;

  @override
  void initState() {
    super.initState();
    _loadMarkerIcon();
  }

  Future<void> _loadMarkerIcon() async {
    try {
      final byteData = await rootBundle.load(AssetPaths.mapMarker);
      if (!mounted) return;

      setState(() {
        _markerIcon = BytesMapBitmap(
          byteData.buffer.asUint8List(),
          width: _markerWidth,
        );
      });
    } catch (e) {
      log("Error loading marker image: $e");

      if (!mounted) return;
      setState(() => _markerIconFailed = true);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _isMapReady = true;

    // Data may already have arrived while the map was still initializing.
    _syncCamera();
  }

  /// Moves the camera for the current tracking state. Safe to call at any
  /// point: it no-ops until the map is ready, and every platform call is
  /// wrapped so a camera failure can never take the page down.
  ///
  /// The route line and marker themselves need no such syncing anymore:
  /// they are declarative sets diffed by [GoogleMap] on every build.
  Future<void> _syncCamera() async {
    final controller = _mapController;
    if (!_isMapReady || controller == null || !mounted) return;

    final state = context.read<OmrahMapTrackingCubit>().state;

    // Follow the provider only while they are actually reporting live.
    final location = state.lastKnownLocation;
    if (state.hasLiveLocation && location != null) {
      try {
        await controller.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(location.latitude, location.longitude),
            _followZoom,
          ),
          duration: const Duration(milliseconds: 1000),
        );
      } catch (e) {
        log("Error following the provider location: $e");
      }
      return;
    }

    // Frame the whole route once, before any live ping takes over the camera.
    if (!_hasFramedRoute && state.canDrawPolyline) {
      _hasFramedRoute = true;
      await _fitCameraToRoute(state.polylinePoints);
    }
  }

  Future<void> _fitCameraToRoute(List<OmrahRoutePointEntity> points) async {
    if (points.isEmpty) return;

    double minLatitude = points.first.latitude;
    double maxLatitude = points.first.latitude;
    double minLongitude = points.first.longitude;
    double maxLongitude = points.first.longitude;

    for (final point in points) {
      if (point.latitude < minLatitude) minLatitude = point.latitude;
      if (point.latitude > maxLatitude) maxLatitude = point.latitude;
      if (point.longitude < minLongitude) minLongitude = point.longitude;
      if (point.longitude > maxLongitude) maxLongitude = point.longitude;
    }

    try {
      await _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLatitude, minLongitude),
            northeast: LatLng(maxLatitude, maxLongitude),
          ),
          _routeFramingPadding,
        ),
        duration: const Duration(milliseconds: 1200),
      );
    } catch (e) {
      log("Error fitting the camera to the route: $e");
    }
  }

  Set<Polyline> _buildPolylines(OmrahMapTrackingState state) {
    // Nothing renderable yet — leave the map untouched rather than drawing a
    // degenerate line.
    if (!state.canDrawPolyline) return const {};

    final points = state.polylinePoints
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList(growable: false);

    // Google Maps polylines have no border, so the old 1px white outline is a
    // second, slightly wider line drawn underneath the route.
    return {
      Polyline(
        polylineId: const PolylineId('route_border'),
        points: points,
        color: Colors.white,
        width: 7,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ),
      Polyline(
        polylineId: const PolylineId('route'),
        points: points,
        color: AppColors.primary400,
        width: 5,
        zIndex: 1,
        jointType: JointType.round,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ),
    };
  }

  Set<Marker> _buildMarkers(OmrahMapTrackingState state) {
    final location = state.lastKnownLocation;
    if (location == null) return const {};

    final icon = _markerIcon;
    if (icon == null && !_markerIconFailed) return const {};

    return {
      Marker(
        markerId: const MarkerId('provider'),
        position: LatLng(location.latitude, location.longitude),
        icon: icon ?? BitmapDescriptor.defaultMarker,
        // Bottom-center, matching the old IconAnchor.BOTTOM.
        anchor: const Offset(0.5, 1),
      ),
    };
  }

  @override
  void dispose() {
    _mapController?.dispose();
    _mapController = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.defaultBar(
        context,
        text: appLocalizer.trackLocation,
        centerTitle: true,
        useCloseButton: true,
      ),
      body: SafeArea(
        child: BlocConsumer<OmrahMapTrackingCubit, OmrahMapTrackingState>(
          listener: (context, state) => _syncCamera(),
          builder: (context, state) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: GoogleMap(
                    key: const ValueKey('inspector_map'),
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(kaabaLatitude, kaabaLongitude),
                      zoom: _initialZoom,
                    ),
                    onMapCreated: _onMapCreated,
                    polylines: _buildPolylines(state),
                    markers: _buildMarkers(state),
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                    myLocationButtonEnabled: false,
                  ),
                ),

                Positioned(
                  bottom: 16,
                  child: _TrackingStatusBanner(state: state),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Bottom pill that reports what the map is currently able to show:
/// loading the route, a failure with a retry, or waiting on the provider.
/// Renders nothing once the provider is reporting live.
class _TrackingStatusBanner extends StatelessWidget {
  final OmrahMapTrackingState state;
  const _TrackingStatusBanner({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.hasLiveLocation) return const SizedBox.shrink();

    final cubit = context.read<OmrahMapTrackingCubit>();

    if (state.route.isFailure) {
      return _Pill(
        text: state.route.failure?.errorMessage ?? appLocalizer.unexpectedError,
        onRetry: cubit.getTrackingRoute,
      );
    }

    if (state.route.isLoading || state.route.isInitial) {
      return _Pill(text: appLocalizer.loadingRoute);
    }

    // Route settled with nothing drawable and no live ping yet.
    if (state.hasNoTrackingData) {
      // A completed omrah has no provider left to wait for, so the waiting
      // hint would be misleading — say the route simply was not recorded.
      return _Pill(
        text: cubit.isOmrahCompleted
            ? appLocalizer.noRouteRecorded
            : appLocalizer.waitProviderLocation,
      );
    }

    return const SizedBox.shrink();
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final VoidCallback? onRetry;
  const _Pill({required this.text, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: context.width * 0.9,
        minWidth: 0,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary500.withAlpha(180),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              text,
              style: context.medium.copyWith(
                color: Colors.white,
                fontSize: 11,
              ),
            ),
          ),

          if (onRetry != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onRetry,
              child: Text(
                appLocalizer.retry,
                style: context.medium.copyWith(
                  color: AppColors.secondary500,
                  fontSize: 11,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.secondary500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
