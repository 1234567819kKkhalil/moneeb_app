part of app_utils;

class DeviceSpecsUtils{
  static final DeviceSpecsUtils instance = DeviceSpecsUtils._();
  DeviceSpecsUtils._();

  void init() async{
    try{
      _setScreenSize();
    }catch(e){
      logDebug("ERROR INITIALIZING DEVICE SPECS UTILS: $e");
    }
  }

  // --- SCREEN SIZE ---
  double? _screenHeight;
  double? _screenWidth;
  double? _physicalScreenWidth;
  double? _physicalScreenHeight;
  double? _devicePixelRatio;

  double? get screenHeight {
    if (_screenHeight == null) {
      _setScreenSize();
    }

    return _screenHeight;
  }

  double? get screenWidth {
    if (_screenWidth == null) {
      _setScreenSize();
    }

    return _screenWidth;
  }

  double? get physicalScreenWidth {
    if (_physicalScreenWidth == null) {
      _setScreenSize();
    }

    return _physicalScreenWidth;
  }

  double? get physicalScreenHeight {
    if (_physicalScreenHeight == null) {
      _setScreenSize();
    }

    return _physicalScreenHeight;
  }

  double? get devicePixelRatio {
    if (_devicePixelRatio == null) {
      _setScreenSize();
    }

    return _devicePixelRatio;
  }

  void _setScreenSize(){
    double? pixelRatio = PlatformDispatcher.instance.views.firstOrNull?.devicePixelRatio;
    _devicePixelRatio = pixelRatio;

    if(pixelRatio != null) {
      Size? physicalSize = PlatformDispatcher.instance.views.firstOrNull?.physicalSize;

      if(physicalSize != null){
        _screenWidth = physicalSize.width / pixelRatio;
        _screenHeight = physicalSize.height / pixelRatio;

        _physicalScreenWidth = physicalSize.width;
        _physicalScreenHeight = physicalSize.height;
      }

    }

    logDebug("SCREEN WIDTH: $screenWidth, SCREEN HEIGHT: $screenHeight, PHYSICAL SCREEN WIDTH: $_physicalScreenWidth, PHYSICAL SCREEN HEIGHT: $_physicalScreenHeight");
  }

}