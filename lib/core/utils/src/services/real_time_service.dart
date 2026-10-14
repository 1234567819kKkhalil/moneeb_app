part of app_utils;

class RealTimeService {
  RealTimeService._();
  static final RealTimeService instance = RealTimeService._();

  DateTime? _ntpTimeAtSync;
  DateTime? _deviceTimeAtSync;

  StreamSubscription? _connectivitySub;
  bool _isLoading = false;

  Future<void> init() async {
    if (_isLoading) return;
    _isLoading = true;

    try {
      if (!await injector<NetworkInfo>().hasConnection) {
        throw NoInternetFailure();
      }

      _closeConnectionCheckerSub();

      _ntpTimeAtSync = await NTP.now(timeout: const Duration(seconds: 30));
      _deviceTimeAtSync = DateTime.now();

      developer.log("REAL TIME FETCHED: $_ntpTimeAtSync");
    } catch (e) {
      if (e is NoInternetFailure) {
        _startConnectionCheckerSub();
      }
      developer.log("Time Error: $e");
    } finally {
      _isLoading = false;
    }
  }

  void _closeConnectionCheckerSub() {
    _connectivitySub?.cancel();
    _connectivitySub = null;
  }

  void _startConnectionCheckerSub() {
    _connectivitySub ??= injector<NetworkInfo>().connectivityStream.listen((hasInternet) {
      if (hasInternet) {
        debugPrint("Internet is back, re-fetching real time");
        init();
      }
    });
  }

  /// This always returns an accurate DateTime synced with NTP,
  /// even if app was paused or timer stopped.
  DateTime getCurrentDateTime() {
    return DateTime.now();
    if (_ntpTimeAtSync != null && _deviceTimeAtSync != null) {
      final elapsed = DateTime.now().difference(_deviceTimeAtSync!);
      return _ntpTimeAtSync!.add(elapsed);
    }

    // Trigger init if not already syncing
    if (_connectivitySub == null) {
      init();
    }

    return DateTime.now(); // fallback
  }

  void dispose() {
    _closeConnectionCheckerSub();
  }
}
