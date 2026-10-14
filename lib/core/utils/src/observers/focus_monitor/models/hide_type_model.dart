part of app_utils;

abstract class HideType {}

class HiddenByChangingTab implements HideType {
  final MainHostPageTabsEnum? tabName;

  HiddenByChangingTab(this.tabName);
}

class HiddenByPage implements HideType {
  final String routeName;

  HiddenByPage(this.routeName);
}

class HiddenByAppLoader implements HideType {}

class HiddenByAppLifeCycle implements HideType {}
