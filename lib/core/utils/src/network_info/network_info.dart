part of app_utils;

@singleton
class NetworkInfo extends Disposable {
  final InternetConnectionChecker internetConnectionChecker;

  //StreamSubscription<InternetConnectionStatus>? _statusListener;
  NetworkInfo(this.internetConnectionChecker) {
    /* _statusListener = internetConnectionChecker.onStatusChange.listen((event) {
      //when the user closed the wifi or internet
      if(event == InternetConnectionStatus.disconnected){
        _updateConnectionState(false);
      }
      print("Detected lose of internet (maybe wifi is closed): $event");
    },);*/
  }

  Timer? _periodicChecker;
  Timer? _lostConnectionTimer;
  bool? _lastConnectionState;

  final StreamController<bool> _connectionController =
  StreamController.broadcast();

  Stream<bool> get connectivityStream => _connectionController.stream;

  Future<bool> get hasConnection async {
    final hasInternet = await internetConnectionChecker.hasConnection;

    _updateConnectionState(hasInternet);

    return hasInternet;
  }

  void _updateConnectionState(bool hasInternet) {
    if (hasInternet) {
      _cancelLostConnectionTimer();

      if (_lastConnectionState == false && _lastConnectionState != null) {
        _connectionController.add(true);
      }

      _lastConnectionState = true;
    } else {
      _startNetworkPeriodicChecker();

      if (_lastConnectionState == true && _lastConnectionState != null) {
        _connectionController.add(false);
      }

      _lastConnectionState = false;
    }
  }

  void _startNetworkPeriodicChecker() {
    _cancelLostConnectionTimer();
    _lostConnectionTimer = Timer(const Duration(seconds: 1), () {
      debugPrint("NetworkPeriodicChecker..");
      hasConnection;
    });
  }

  void _cancelLostConnectionTimer() {
    _lostConnectionTimer?.cancel();
    _lostConnectionTimer = null;
  }

  //Start this periodic checker in cases that you have to check for internet in interval, and the only place i need this is in chat, so this will be used in ChatManager and will be closed after closing the chat manager
  void startPeriodicCheckerInInterval() {
    _periodicChecker ??= Timer.periodic(
      const Duration(seconds: 10),
          (_) {
        if (_lostConnectionTimer == null) {
          hasConnection;
        }
      },
    );
  }

  void cancelIntervalPeriodicChecker() {
    _periodicChecker?.cancel();
    _periodicChecker = null;
  }

  @override
  FutureOr onDispose() {
    _cancelLostConnectionTimer();
    cancelIntervalPeriodicChecker();
    _connectionController.close();
  }
}
