part of app_utils;

class LocationService {
  LocationService._();
  static final LocationService instance = LocationService._();
  StreamSubscription<ServiceStatus>? _serviceStatusSub;

  Future<Position> getCurrentLocation({
    LocationAccuracy accuracy = LocationAccuracy.high,
    Duration timeLimit = const Duration(seconds: 10),
    bool requestPermissionsIfNeeded = true
  }) async {
    try{
      if(requestPermissionsIfNeeded){
        await checkAndRequestPermission();
      }

      return await _fetchPosition(accuracy: accuracy, timeLimit: timeLimit);

    } catch(e){
      if(e is LocationFailure){
        rethrow;
      } else {
        throw LocationFailure("Error fetching your location");
      }
    }
  }

  void dispose() {
    _stopServiceStatusListener();
  }

  // -------------------------------------------------------------------------
  // Permission helpers
  // -------------------------------------------------------------------------

  // void listenToLocationService(){
  //   // -- Service enabled --
  //   final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     _startServiceStatusListener(
  //       onLocationReady: onLocationReady,
  //       accuracy: accuracy,
  //       timeLimit: timeLimit,
  //     );
  //
  //     throw LocationFailure("Location service is disabled", isLocationServiceDisabled: true);
  //   }
  // }


  Future<void> checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      developer.log(
        '[LocationService] Permission permanently denied.',
        name: 'LocationService',
      );

      throw LocationFailure("Permission is denied permanently", isDeniedForEver: true);
    }

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        developer.log(
          '[LocationService] Permission denied by user.',
          name: 'LocationService',
        );

        throw LocationFailure("Permission is denied permanently", isDenied: true);
      }

      if (permission == LocationPermission.deniedForever) {
        developer.log(
          '[LocationService] Permission permanently denied after request.',
          name: 'LocationService',
        );
        throw LocationFailure("Permission is denied permanently", isDeniedForEver: true);
      }
    }
  }

  // Helpers
  Future<void> openGpsSettings() async {
    developer.log(
      '[LocationService] Location service disabled – opening settings.',
      name: 'LocationService',
    );
    await Geolocator.openLocationSettings();
  }

  Future<void> openAppLocationSettings() async {
    developer.log(
      '[LocationService] Location service disabled – opening settings.',
      name: 'LocationService',
    );
    await Geolocator.openAppSettings();
  }

  void _startServiceStatusListener({
    void Function(Position position)? onLocationReady,
    required LocationAccuracy accuracy,
    required Duration timeLimit,
  }) {
    if (_serviceStatusSub != null) return;

    developer.log(
      '[LocationService] Started listening to service status.',
      name: 'LocationService',
    );

    _serviceStatusSub =
        Geolocator.getServiceStatusStream().listen((status) async {
      if (status == ServiceStatus.enabled) {
        developer.log(
          '[LocationService] Service enabled – retrying location fetch.',
          name: 'LocationService',
        );

        final pos = await _fetchPosition(
          accuracy: accuracy,
          timeLimit: timeLimit,
        );

        onLocationReady?.call(pos);

        _stopServiceStatusListener();
      }
    });
  }

  void _stopServiceStatusListener() {
    _serviceStatusSub?.cancel();
    _serviceStatusSub = null;
  }

  Future<Position> _fetchPosition({
    required LocationAccuracy accuracy,
    required Duration timeLimit,
  }) async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: accuracy,
          timeLimit: timeLimit,
        ),
      );
      developer.log(
        '[LocationService] Current position: ${position.latitude}, ${position.longitude}',
        name: 'LocationService',
      );

      return position;
    } catch (e) {
      developer.log(
        '[LocationService] getCurrentPosition failed: $e — trying last known.',
        name: 'LocationService',
      );
      throw LocationFailure(appLocalizer.couldNotFetchLocation);
    }
  }

  Future<Position?> lastKnownPosition() async {
    try {
      final position = await Geolocator.getLastKnownPosition();
      if (position != null) {
        developer.log(
          '[LocationService] Using last known position: '
          '${position.latitude}, ${position.longitude}',
          name: 'LocationService',
        );
      }
      return position;
    } catch (e) {
      developer.log(
        '[LocationService] getLastKnownPosition failed: $e',
        name: 'LocationService',
      );
      return null;
    }
  }

  // -------------------------------------------------------------------------
  // Set Location feature: persistence + reverse geocoding + reactive stream
  // -------------------------------------------------------------------------

  /// Broadcasts the current location state to the UI (e.g. the home top bar).
  final BehaviorSubject<StateBox<LocationData>> _locationSubject =
      BehaviorSubject<StateBox<LocationData>>.seeded(
    const StateBox<LocationData>.initial(),
  );

  /// Reactive stream of the latest location state.
  Stream<StateBox<LocationData>> get locationStream => _locationSubject.stream;

  /// Latest emitted location state (synchronous access).
  StateBox<LocationData> get currentLocationState => _locationSubject.value;
  bool _isAcquiring = false;

  /// Cold-start entry point.
  ///
  /// Scenario A — a cached location exists: it is emitted immediately with no
  /// GPS or geocoding calls. Scenario B — no cache: the acquisition flow runs.
  Future<void> initLocation() async {
    final cached = await getCachedLocation();
    if (cached != null) {
      _locationSubject.add(StateBox.success(cached));
    } else {
      await refreshLocation(ignoreError: true);
    }
  }

  /// Runs the acquisition flow and pushes loading/success/failure to the
  /// stream. Used both on cold start and for the user-triggered "Yes, Update".
  Future<void> refreshLocation({bool ignoreError = false}) async {
    if (_isAcquiring) return;
    _isAcquiring = true;

    final oldData = _locationSubject.value.data;
    _locationSubject.add(const StateBox<LocationData>.loading());

    try {
      final data = await acquireAndSaveLocation();
      _locationSubject.add(StateBox.success(data));
    } on LocationFailure catch (failure) {
      if(ignoreError) {
        _locationSubject.add(StateBox.initial());
      } else{
        _locationSubject.add(StateBox.failure(failure));
      }

      if(oldData != null){
        _locationSubject.add(StateBox.success(oldData));
      }
    } catch (_) {
      if(ignoreError) {
        _locationSubject.add(StateBox.initial());
      } else{
        _locationSubject.add(
          StateBox.failure(LocationFailure(appLocalizer.couldNotFetchLocation)),
        );
      }

      if(oldData != null){
        _locationSubject.add(StateBox.success(oldData));
      }
    } finally {
      _isAcquiring = false;
    }
  }

  Future<LocationData> acquireAndSaveLocation() async {
    // 1) GPS service check.
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationFailure(
        appLocalizer.enableLocationServicePrompt,
        isLocationServiceDisabled: true,
      );
    }

    // 2) Permission + 3) high-accuracy coordinates (reuses existing logic).
    final position = await getCurrentLocation();

    await Future.delayed(Duration(seconds: 2));

    // 4) Reverse geocoding via the native geocoding package.
    final placemark = await _reverseGeocode(
      position.latitude,
      position.longitude,
    );

    final data = LocationData(
      latitude: position.latitude,
      longitude: position.longitude,
      city: _extractCity(placemark),
      country: placemark?.country,
    );

    // 5) Persist all four values as a single JSON string.
    _cacheLocation(data);

    return data;
  }

  Future<Placemark?> _reverseGeocode(double latitude, double longitude) async {
    try {
      // Localize results to the app's current language where supported.
      try {
        await setLocaleIdentifier(appLocalizer.localeName);
      } catch (_) {}

      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      return placemarks.isNotEmpty ? placemarks.first : null;
    } catch (e) {
      developer.log(
        '[LocationService] reverse geocoding failed: $e',
        name: 'LocationService',
      );
      return null;
    }
  }

  String? _extractCity(Placemark? placemark) {
    if (placemark == null) return null;
    final candidates = [
      placemark.locality,
      placemark.subAdministrativeArea,
      placemark.administrativeArea,
      placemark.subLocality,
    ];
    for (final value in candidates) {
      if (value != null && value.trim().isNotEmpty) return value;
    }
    return null;
  }

  LocationData? getCachedLocation() {
    return injector<SharedPreferencesHelper>().getCacheUserLocation();
  }

  void _cacheLocation(LocationData data)  {
    injector<SharedPreferencesHelper>().cacheUserLocation(data);
  }

  Future<LatLng?> get getLatLng async {
    LatLng? pos;

    try {
      final cachedPos = LocationService.instance.getCachedLocation();

      if(cachedPos != null && cachedPos.latitude != null && cachedPos.longitude != null){
        pos = LatLng(
          latitude: cachedPos.latitude??0,
          longitude: cachedPos.longitude??0
        );
      } else {
        final fetchedPos = await LocationService.instance.getCurrentLocation();

        pos = LatLng(
          latitude: fetchedPos.latitude,
          longitude: fetchedPos.longitude,
        );
      }
    } catch (e) {
      try {
        final fetchedLastKnownPos = await LocationService.instance.lastKnownPosition();

        if(fetchedLastKnownPos != null){
          pos = LatLng(
            latitude: fetchedLastKnownPos.latitude,
            longitude: fetchedLastKnownPos.longitude,
          );
        }
      } catch (e) {
        print("error in location: $e");
      }
    }

    if (pos != null) {
      return pos;
    } else {
      final LocationEntity? loc = AppRouteNavigator.navigatorKey.currentContext
          ?.read<AuthenticationBloc>()
          .getUserModel
          .location;

      final lat = parseDynamicToDouble(loc?.lat);
      final long = parseDynamicToDouble(loc?.long);
      if (lat != null && long != null) {
        return LatLng(latitude: lat, longitude: long);
      }
    }

    return null;
  }
}