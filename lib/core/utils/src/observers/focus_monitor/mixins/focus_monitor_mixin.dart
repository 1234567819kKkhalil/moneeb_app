part of app_utils;

mixin FocusMonitorObserverMixin<T extends StatefulWidget> on State<T>{
  FocusMonitorObserver? _monitorObserver;
  bool isFocused = true;

  initFocusMonitor({
    MainHostPageTabsEnum? myTabName,
    bool? useAutoTabRecognizer,
    List<String> ignorePages = const [],
    void Function()? onFocus,
    void Function(HideType hideType)? onHidden,
  }){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(!mounted) return;

      MainHostPageTabsEnum? mainHostTabName = myTabName;
      final modalRoute = ModalRoute.of(context);

      if(mainHostTabName == null && useAutoTabRecognizer == true){
        //get tab name dynamically
        if(modalRoute?.settings.name == BuilderScreen.routeName && modalRoute?.settings.name == NavObserver.instance.currentPage){
          mainHostTabName = NavObserver.instance.currentTab;
        }
      }

      _monitorObserver ??= FocusMonitorObserver(
          route: modalRoute,
          myTab: mainHostTabName,
          ignorePages: ignorePages,

          onFocus: () {
            if(!isFocused){
              isFocused = true;
              onFocus?.call();

              debugPrint("From Monitor: Page got focused => ${ModalRoute.of(context)?.settings.name ?? ''}");
              if(mainHostTabName != null){
                debugPrint("From Monitor: Tab got focused => $mainHostTabName");
              }
            }
          },
          onHidden: (hiddenBy) {
            if(isFocused){
              isFocused = false;
              onHidden?.call(hiddenBy);

              debugPrint("From Monitor: Page got hidden => ${ModalRoute.of(context)?.settings.name ?? ''}");
              if(mainHostTabName != null){
                debugPrint("From Monitor: Tab got hidden => $mainHostTabName");
              }
            }
          },
      );
    });
  }

  @override
  void dispose() {
    _monitorObserver?.dispose();
    _monitorObserver = null;
    super.dispose();
  }
}