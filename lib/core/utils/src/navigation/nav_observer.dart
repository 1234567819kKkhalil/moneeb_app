part of app_utils;

class NavObserver extends NavigatorObserver {
  NavObserver._();
  static NavObserver _instance = NavObserver._();
  static NavObserver get instance => _instance;

  static reset() {
    _instance = NavObserver._();
  }

  final ValueNotifier<NavObserverModel<MainHostPageTabsEnum>> _navStack =
  ValueNotifier<NavObserverModel<MainHostPageTabsEnum>>(
      const NavObserverModel<MainHostPageTabsEnum>(pages: []));

  void addListener(void Function() listener){
    _navStack.addListener(listener);
  }

  void removeListener(void Function() listener){
    _navStack.removeListener(listener);
  }

  List<String> get navStackRouteNames => _navStack.value.pages.map((e) => e.settings.name ?? '').toList();

  bool _isTabChanged = false;

  bool get isTabChanged => _isTabChanged;

  MainHostPageTabsEnum? get currentTab => _navStack.value.currentTab;

  String? get currentPage => NavObserver.instance._navStack.value.pages.lastOrNull?.settings.name;

  bool isCurrentPage(String routeName, {bool includeId = false, bool ignoreDialogs = false, bool ignoreBottomSheets = false}) {
    for(int i = _navStack.value.pages.length - 1; i >= 0; i--){
      final currentRoute = _navStack.value.pages[i].settings.name ?? '';

      if(ignoreDialogs && currentRoute.startsWith(AppRouteNavigator.dialogRoutePrefix)){
        continue;
      }else if(ignoreBottomSheets && currentRoute.startsWith(AppRouteNavigator.bottomSheetRoutePrefix)){
        continue;
      }

      if(!includeId){
        String? routeNameWithoutId = routeName.split(AppRouteNavigator.routeIdIdentifier).firstOrNull;
        String? lastElementWithoutId = currentRoute.split(AppRouteNavigator.routeIdIdentifier).firstOrNull;

        return lastElementWithoutId == routeNameWithoutId;
      }

      return currentRoute == routeName;
    }

    return false;
  }

  String? get previousPage{
    final pages = NavObserver.instance._navStack.value.pages;
    int indexBeforeLast = pages.length - 2;

    if(indexBeforeLast >= 0 && indexBeforeLast < pages.length){
      return pages[indexBeforeLast].settings.name;
    }

    return null;
  }

  bool isBeforeMainHostPage() {
    return _navStack.value.currentTab == null;
  }

  void changeTab(MainHostPageTabsEnum? newTab) {
    if (newTab == null) {
      //reset tabs
      _navStack.value =
          NavObserverModel(currentTab: newTab, pages: _navStack.value.pages);
    } else {
      _isTabChanged = true;
      _navStack.value = _navStack.value.copyWith(currentTab: newTab);
      //injector<BottomNavBarUtils>().showNavBar();
    }
  }

  bool isCurrentTab(MainHostPageTabsEnum? tab) {
    return tab == _navStack.value.currentTab;
  }

  void _removePage(Route route) {
    _isTabChanged = false;

    if (_navStack.value.pages.isNotEmpty) {
      _navStack.value.pages.remove(route);
      _navStack.notifyListeners();
    }
  }

  void _addPage(Route route) {
    _isTabChanged = false;

    final List<Route> newList = List.from(_navStack.value.pages);

    newList.add(route);
    _navStack.value = _navStack.value.copyWith(pages: newList);
  }

  void _replace(Route oldRoute, Route newRoute) {
    _isTabChanged = false;

    if (_navStack.value.pages.isNotEmpty) {
      final replaceIndex = _navStack.value.pages.indexOf(oldRoute);

      if(replaceIndex != -1){
        _navStack.value.pages[replaceIndex] = newRoute;
        _navStack.notifyListeners();
      }
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (previousRoute != null && route.settings.name != null) {
      _removePage(route);
    }
    developer.log("from didPop: ${_logger()}");

    //  AppToasts.dismissToast();
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    if(route.settings.name != null){
      _addPage(route);
    }

    developer.log("from didPush: ${_logger()}");

    AppToasts.dismissToast();
    super.didPush(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    if (previousRoute != null && route.settings.name != null) {
      _removePage(route);
    }
    developer.log("from didRemove: ${_logger()}");
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    if (oldRoute?.settings.name != null && newRoute?.settings.name != null) {
      _replace(oldRoute!, newRoute!);
    }

    developer.log("from didReplace: ${_logger()}");

    AppToasts.dismissToast();
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  String _logger() {
    return "Tab: ${_navStack.value.currentTab}, Pages: ${_navStack.value.pages.map((e) => e.settings.name.toString(),)}";
  }
}

