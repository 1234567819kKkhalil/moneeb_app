part of tab_bar_imports;

class TabBarAttributes {
  final bool showTabsAbovePages;
  final double paddingBetweenItems;
  final bool centerItems;
  final Color? focusColor;
  final Color? disableColor;
  final Widget? suffixWidget;
  final BoxDecoration? barBoxDecoration;
  final double? fontSize;
  final double? lineWidth;
  final EdgeInsetsGeometry tabBarPadding;
  final bool expandItemWidth;

  const TabBarAttributes({
    this.showTabsAbovePages = false,
    this.paddingBetweenItems = PaddingDimensions.xLarge,
    this.focusColor,
    this.disableColor,
    this.suffixWidget,
    this.barBoxDecoration,
    this.fontSize,
    this.lineWidth,
    this.expandItemWidth = false,
    this.tabBarPadding = const EdgeInsets.all(1),
  }) : centerItems = false;

  const TabBarAttributes.centerMode({
    this.showTabsAbovePages = false,
    this.focusColor,
    this.disableColor,
    this.suffixWidget,
    this.barBoxDecoration,
    this.fontSize,
    this.lineWidth,
    this.expandItemWidth = true,
    this.tabBarPadding = EdgeInsets.zero,
  })  : centerItems = true,
        paddingBetweenItems = 10;
}
