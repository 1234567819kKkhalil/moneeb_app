part of zad;

class QiblahPage extends StatefulWidget {
  static const String routeName = '/qiblah';
  const QiblahPage({super.key});

  @override
  State<QiblahPage> createState() => _QiblahPageState();
}

class _QiblahPageState extends State<QiblahPage>
    with SingleTickerProviderStateMixin {
  double? _heading;
  double? _qiblaDirection;

  late final AnimationController _refreshController;
  StreamSubscription<StateBox<LocationData>>? _locationSub;
  StateBox<LocationData> _locationState =
      LocationService.instance.currentLocationState;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();

    _refreshController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _locationSub = LocationService.instance.locationStream.listen(
      _onLocationState,
    );
    _initLocation();

    FlutterCompass.events?.listen((event) {
      if (mounted) {
        setState(() {
          _heading = event.heading;
        });
      }
    });
  }

  @override
  void dispose() {
    _locationSub?.cancel();
    _refreshController.dispose();
    super.dispose();
  }

  void _onLocationState(StateBox<LocationData> state) {
    if (!mounted) return;

    setState(() => _locationState = state);

    if (state.isLoading) {
      _refreshController.repeat();
    } else {
      _refreshController
        ..stop()
        ..value = 0;
    }

    final data = state.data;
    if (data?.latitude != null && data?.longitude != null) {
      setState(() {
        _qiblaDirection = _calculateQibla(data!.latitude!, data.longitude!);
      });
    }

    if (state.isFailure && _isRefreshing) {
      _handleLocationFailure(state.failure);
    }
    if (!state.isLoading) _isRefreshing = false;
  }

  /// Cold start: uses the cached location instantly if available, otherwise
  /// triggers acquisition. If the reactive flow still yields no coordinates
  /// (e.g. its permission/service checks fail), falls back to the last-known
  /// position or the profile's saved location so the compass still works.
  Future<void> _initLocation() async {
    final cached = LocationService.instance.currentLocationState.data;
    if (cached?.latitude != null && cached?.longitude != null) {
      _qiblaDirection = _calculateQibla(cached!.latitude!, cached.longitude!);
    } else {
      await LocationService.instance.initLocation();
    }

    if (_qiblaDirection == null) {
      await _useFallbackLocation();
    }
  }

  Future<void> _useFallbackLocation() async {
    Position? pos;
    try {
      pos = await LocationService.instance.getCurrentLocation();
    } catch (e) {
      try {
        pos = await LocationService.instance.lastKnownPosition();
      } catch (e) {
        logDebug("error in location: $e");
      }
    }

    if (pos == null) {
      final LocationEntity? loc = AppRouteNavigator.navigatorKey.currentContext
          ?.read<AuthenticationBloc>()
          .getUserModel
          .location;

      if (loc?.long != null && loc?.lat != null) {
        pos = Position(
          longitude: double.parse(loc!.long!),
          latitude: double.parse(loc.lat!),
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          heading: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
          altitudeAccuracy: 0.0,
          headingAccuracy: 0.0,
        );
      }
    }

    if (pos != null && mounted) {
      setState(() {
        _qiblaDirection = _calculateQibla(pos!.latitude, pos.longitude);
      });
    }
  }

  Future<void> _onRefresh() async {
    if (_locationState.isLoading) return;
    _isRefreshing = true;
    await LocationService.instance.refreshLocation();
  }

  void _handleLocationFailure(Failure? failure) {
    if (failure is! LocationFailure) return;

    if (failure.isDeniedForEver) {
      AppAlerts.showOpenPermissionsSettingsDialog(
        context,
        onOpenSettingsPressed: () {
          LocationService.instance.openAppLocationSettings();
        },
      );
    } else {
      AppToasts.error(context, message: failure.errorMessage);
    }
  }

  double _calculateQibla(double lat, double lng) {
    const double kaabaLat = 21.4225;
    const double kaabaLng = 39.8262;

    double latRad = _degToRad(lat);
    double lngRad = _degToRad(lng);
    double kaabaLatRad = _degToRad(kaabaLat);
    double kaabaLngRad = _degToRad(kaabaLng);

    double dLng = kaabaLngRad - lngRad;

    double y = sin(dLng);
    double x = cos(latRad) * tan(kaabaLatRad) - sin(latRad) * cos(dLng);

    double brng = atan2(y, x);
    return (_radToDeg(brng) + 360) % 360;
  }

  double _degToRad(double deg) => deg * pi / 180;
  double _radToDeg(double rad) => rad * 180 / pi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.defaultBar(
        context,
        text: appLocalizer.qiblah,
        centerTitle: true,
        useCloseButton: true,
      ),

      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: context.appColors.appBackgroundColor),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: _buildLocationChip(context),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _heading == null || _qiblaDirection == null
                      ? const CustomAnimationLoading()
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            AnimatedRotation(
                              // The asset's arrow points right (east = +90° from up),
                              // so subtract 90° to align it with the up = north frame.
                              turns:
                                  ((_qiblaDirection! - _heading! + 270) / 360),
                              duration: const Duration(milliseconds: 300),
                              // The asset's circle center sits at 42.8% of its width
                              // (the arrow adds width on the right). Padding the left
                              // by 2 * (0.5 - 0.428) * size shifts the circle center
                              // onto the widget center, so rotation pivots around the
                              // circle and not the bounding box.
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 2 * (0.5 - 0.428) * 250,
                                ),
                                child: Image.asset(
                                  AssetPaths.qiblaIcon,
                                  width: 250,
                                  height: 250,
                                ),
                              ),
                            ),
                            // Static Kaaba icon centered on the circle (does not
                            // rotate with the compass).
                            const AppSvg(
                              svgPath: AssetPaths.iconKaaba,
                              width: 54,
                            ),
                          ],
                        ),
                  const SizedBox(height: 64),
                  Text(
                    appLocalizer.qiblahDescription,
                    textAlign: TextAlign.center,
                    style: context.bold.copyWith(
                      color: context.appColors.neutral.shade900,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationChip(BuildContext context) {
    final bool isLoading = _locationState.isLoading || _locationState.isInitial;
    final String? label = _locationState.data?.label;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.appColors.neutral.shade100,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 4),
          /* Icon(
            Icons.location_on_rounded,
            size: 18,
            color: context.appColors.neutral.shade900,
          ),
           */
          Flexible(
            child: isLoading
                ? AppSkeletonizer(
                    isEnabled: true,
                    containersColor: context.appColors.neutral.shade400,
                    child: Text(
                      appLocalizer.updateLocationTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.bold.copyWith(fontSize: 13),
                    ),
                  )
                : Text(
                    label ?? appLocalizer.selectLocationHint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.bold.copyWith(
                      fontSize: 13,
                      color: context.appColors.neutral.shade900,
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: isLoading ? null : _onRefresh,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: context.appColors.primary.shade400,
                shape: BoxShape.circle,
              ),

              child: RotationTransition(
                turns: _refreshController,
                child: Icon(
                  Icons.refresh_rounded,
                  size: 20,
                  color: isLoading
                      ? context.appColors.neutral.shade400
                      : context.appColors.neutral.shade900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
