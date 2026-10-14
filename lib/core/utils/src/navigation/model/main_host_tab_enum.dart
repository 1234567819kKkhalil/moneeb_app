part of app_utils;

enum MainHostPageTabsEnum { home, orders, requestOmra, zad, profile }

extension BottomNabTabTypeExtension on MainHostPageTabsEnum {
  String getName() {
    switch (this) {
      case MainHostPageTabsEnum.home:
        return appLocalizer.homeNav;
      case MainHostPageTabsEnum.orders:
        return appLocalizer.ordersNav;
      case MainHostPageTabsEnum.requestOmra:
        return appLocalizer.requestOmraNav;
      case MainHostPageTabsEnum.zad:
        return appLocalizer.zadNav;
      case MainHostPageTabsEnum.profile:
        return appLocalizer.settingsNav;
    }
  }

  Widget getIcon({bool isSelected = false}) {
    //todo: refactor
    String iconPath;
    switch (this) {
      case MainHostPageTabsEnum.home:
        iconPath = isSelected
            ? AssetPaths.iconHomeActive
            : AssetPaths.iconHome;
        break;
      case MainHostPageTabsEnum.orders:
        iconPath = isSelected
            ? AssetPaths.iconOrdersActive
            : AssetPaths.iconOrders;
        break;
      case MainHostPageTabsEnum.requestOmra:
        iconPath = SvgPaths.man_with_ehram_clothe;
        break;
      case MainHostPageTabsEnum.zad:
        iconPath = isSelected
            ? AssetPaths.iconZadActive
            : AssetPaths.iconZad;
        break;
      case MainHostPageTabsEnum.profile:
        iconPath = isSelected
            ? AssetPaths.iconProfileActive
            : AssetPaths.iconProfile;
        break;
    }
    return AppSvg(
      svgPath: iconPath,
      width: 24,
      height: 24,
      color: isSelected ? AppColors.secondary500 : AppColors.neutral50,
    );
  }

  List<Color> getShadeColors(BuildContext context) {
    final primaryColor = context.appColors.primary.shade900;
    switch (this) {
      case MainHostPageTabsEnum.home:
      case MainHostPageTabsEnum.orders:
      case MainHostPageTabsEnum.requestOmra:
      case MainHostPageTabsEnum.zad:
      case MainHostPageTabsEnum.profile:
        return [primaryColor, primaryColor];
    }
  }

  Color getBackgroundColor(BuildContext context) {
    switch (this) {
      case MainHostPageTabsEnum.home:
      case MainHostPageTabsEnum.orders:
      case MainHostPageTabsEnum.requestOmra:
      case MainHostPageTabsEnum.zad:
      case MainHostPageTabsEnum.profile:
        return context.appColors.appBackgroundColor;
    }
  }
}
