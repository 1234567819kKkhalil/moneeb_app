part of app_utils;

@lazySingleton
class FocusMonitorUpdater extends Disposable with WidgetsBindingObserver {
  FocusMonitorUpdater() {
    WidgetsBinding.instance.addObserver(this);
    AppBlockerLoader.addListener(_appLoaderListener);
    NavObserver.instance.addListener(_navigationObserver);
  }

  final List<FocusMonitorObserver> _observers = [];

  void attachObserver<T>(FocusMonitorObserver observer){
    _observers.add(observer);
  }

  void deAttachObserver(FocusMonitorObserver observer){
    _observers.remove(observer);
  }

  void notifyHidden(FocusMonitorObserver observer, HideType hiddenBy){
    if (hiddenBy is HiddenByPage) {
      bool ignoreNotifier = observer.ignorePages.contains(hiddenBy.routeName);

      if (ignoreNotifier) {
        return;
      }
    }

    observer.onHidden?.call(hiddenBy);
  }

  void notifyFocus(FocusMonitorObserver observer) {
    if (isCurrentPage(observer) && isOnMyTab(observer.myTab)) {
      observer.onFocus?.call();
    }
  }

  bool isCurrentPage(FocusMonitorObserver observer) {
    return NavObserver.instance.isCurrentPage(observer.routeName, includeId: true) && observer.isCurrent;
  }

  bool isOnMyTab(MainHostPageTabsEnum? tabName) {
    if (tabName == null) {
      return true;
    }

    return NavObserver.instance.isCurrentTab(tabName);
  }

  void _appLoaderListener(isLoading) {
    for (var observer in _observers) {
      if (isOnMyTab(observer.myTab) && isCurrentPage(observer)) {
        if (isLoading) {
          notifyHidden(observer, HiddenByAppLoader());
        } else {
          notifyFocus(observer);
        }
      }
    }
  }

  void _navigationObserver() {
    for (var observer in _observers) {
      if (isCurrentPage(observer)) {
        if (isOnMyTab(observer.myTab)) {
          notifyFocus(observer);
        } else {
          notifyHidden(observer, HiddenByChangingTab(NavObserver.instance.currentTab));
        }
      } else {
        notifyHidden(observer, HiddenByPage(NavObserver.instance.currentPage ?? ''));
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    //pause the record if the app went to background
    debugPrint("DID CHANGE LIFECYCLE FROM MONITOR: $state");

    for (var observer in _observers) {
      if (isCurrentPage(observer) && isOnMyTab(observer.myTab)) {
        if (state == AppLifecycleState.paused || state == AppLifecycleState.hidden) {
          notifyHidden(observer, HiddenByAppLifeCycle());
        } else {
          notifyFocus(observer);
        }
      }
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  FutureOr onDispose() {
    NavObserver.instance.removeListener(_navigationObserver);
    WidgetsBinding.instance.removeObserver(this);
    AppBlockerLoader.removeListener(_appLoaderListener);

    _observers.clear();
  }
}
