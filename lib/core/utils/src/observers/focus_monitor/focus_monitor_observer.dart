part of app_utils;

class FocusMonitorObserver {
  final Route? route;
  final MainHostPageTabsEnum? myTab;
  final List<String> ignorePages;

  final void Function(HideType hiddenBy)? onHidden;
  final void Function()? onFocus;

  FocusMonitorObserver({
    required this.route,
    required this.myTab,
    required this.ignorePages,
    this.onHidden,
    this.onFocus,
  }) {
    injector<FocusMonitorUpdater>().attachObserver(this);
  }

  String get routeName => route?.settings.name ?? '';

  bool get isCurrent => route?.isCurrent ?? false;

  void dispose() {
    injector<FocusMonitorUpdater>().deAttachObserver(this);
  }
}
