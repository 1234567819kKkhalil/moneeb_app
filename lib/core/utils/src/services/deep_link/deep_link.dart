part of app_utils;

class DeepLinks {
  static final DeepLinks _instance = DeepLinks._();

  DeepLinks._();

  factory DeepLinks() => _instance;

  AppLinks? _appLinks;
  StreamSubscription? streamSubscription;

  void initDeepLink() {
    _appLinks ??= AppLinks();
    streamSubscription ??= _appLinks!.uriLinkStream.listen((uri) async {
      //todo:
      //ExternalForwardingHandler.handleDeeplink(uri.pathSegments);
    });
  }

  void dispose() {
    streamSubscription?.cancel();
    streamSubscription = null;
    _appLinks = null;
  }
}
