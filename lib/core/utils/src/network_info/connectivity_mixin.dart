part of app_utils;

mixin ConnectivityMonitorMixin<T extends StatefulWidget> on State<T>{
  StreamSubscription? connectivitySub;

  void onConnectivityChanges(bool isHasInternet);

  @override
  void initState() {
    connectivitySub = injector<NetworkInfo>().connectivityStream.listen(onConnectivityChanges);
    super.initState();
  }

  @override
  void dispose() {
    connectivitySub?.cancel();
    connectivitySub = null;
    super.dispose();
  }
}