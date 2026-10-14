part of app_material;

enum AppBarCloseIconType { backArrow, x, closeCircle }

extension AppBarCloseIconTypeExtenstion on AppBarCloseIconType {
  IconData get icon {
    switch (this) {
      case AppBarCloseIconType.x:
        return Icons.close;
      case AppBarCloseIconType.closeCircle:
        return Icons.close;
      case AppBarCloseIconType.backArrow:
        return Icons.arrow_back_ios_rounded;
    }
  }
}

class AppBars extends AppBar {
  final BuildContext context;
  final bool useCloseButton;
  final String? text;
  final double? counts;
  final AppBarCloseIconType appBarCloseIconType;
  final bool? simplifyCountNumber;
  final Color? bgColor;
  final Color? tintColor;
  final Function()? onBackPressed;
  final Color? closeIconColor;
  final bool isCloseIconColorGradient;
  final String? previousPageName;
  final double? leadingIconWidth;
  final bool showDivider;
  final double appBarElevation;

  AppBars.defaultBar(
    this.context, {
    super.key,
    this.useCloseButton = false,
    this.closeIconColor,
    this.text,
    super.actions,
    super.centerTitle,
    this.appBarCloseIconType = AppBarCloseIconType.backArrow,
    this.isCloseIconColorGradient = false,
    this.bgColor,
    this.tintColor,
    this.onBackPressed,
    this.showDivider = false,
    this.appBarElevation = 0,
  }) : counts = null,
       simplifyCountNumber = null,
       previousPageName = null,
       leadingIconWidth = null;

  AppBars.countedTitle(
    this.context, {
    super.key,
    this.useCloseButton = false,
    this.closeIconColor,
    required this.counts,
    required this.text,
    this.simplifyCountNumber = false,
    this.appBarCloseIconType = AppBarCloseIconType.x,
    this.isCloseIconColorGradient = false,
    this.bgColor,
    this.tintColor,
    super.actions,
    this.onBackPressed,
    this.showDivider = false,
    this.appBarElevation = 0,
  }) : leadingIconWidth = null,
       previousPageName = null;

  AppBars.withPreviousPageName(
    this.context, {
    required this.previousPageName,
    super.key,
    this.bgColor,
    super.actions,
    this.closeIconColor,
    this.onBackPressed,
    this.text,
    super.centerTitle = true,
    this.leadingIconWidth = 100.0,
    this.showDivider = false,
    this.appBarElevation = 0,
  }) : counts = null,
       tintColor = null,
       useCloseButton = true,
       simplifyCountNumber = false,
       appBarCloseIconType = AppBarCloseIconType.backArrow,
       isCloseIconColorGradient = false;

  AppBars.withAppLogo(
    this.context, {
    super.key,
    this.bgColor,
    this.closeIconColor,
    this.tintColor,
    this.showDivider = false,
    super.actions,
    this.appBarElevation = 0,
  }) : useCloseButton = false,
       counts = null,
       text = null,
       onBackPressed = null,
       leadingIconWidth = null,
       appBarCloseIconType = AppBarCloseIconType.backArrow,
       isCloseIconColorGradient = false,
       simplifyCountNumber = null,
       previousPageName = null;

  @override
  Color? get backgroundColor => bgColor;

  @override
  double? get elevation => appBarElevation;

  @override
  PreferredSizeWidget? get bottom => showDivider
      ? PreferredSize(
          preferredSize: preferredSize,
          child: const AppDivider(top: 0, bottom: 0, thickness: 1),
        )
      : null;

  @override
  bool get forceMaterialTransparency => false;

  @override
  bool get automaticallyImplyLeading => false;

  @override
  Widget? get leading {
    if (previousPageName != null) {
      return _backWithPreviousPageName;
    }
    if (useCloseButton) {
      if (isCloseIconColorGradient) {
        return AppShader(child: _closeIcon);
      } else {
        return _closeIcon;
      }
    }

    return null;
  }

  Widget get _closeIcon {
    return AppIconButton(
      startPadding: PaddingDimensions.pageHorizontalPadding,
      iconData: appBarCloseIconType.icon,
      color: closeIconColor ?? tintColor ?? context.appColors.neutral.shade900,
      size: IconDimensions.small,
      //   langAdaptive: true,
      onPressed: () {
        _onBackPressed(context);
      },
    );
  }

  @override
  Color? get surfaceTintColor => context.appColors.appBackgroundColor;

  @override
  Widget? get title {
    if (counts != null) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: text ?? '',
              style: context.semiBold.copyWith(
                color: tintColor,
                fontSize: Dimensions.xxLarge,
              ),
            ),
            TextSpan(
              text: counts == null
                  ? "-"
                  : " (${(simplifyCountNumber ?? false) ? counts!.simplifyLargeNumber : counts})",
              style: context.regular.copyWith(color: tintColor),
            ),
          ],
        ),
        overflow: TextOverflow.ellipsis,
      );
    } else if (text != null) {
      return Text(
        text!,
        style: context.semiBold.copyWith(
          color: tintColor ?? context.appColors.neutral.shade900,
          fontSize: Dimensions.xxLarge,
          fontWeight: FontWeight.bold,
        ),
        overflow: TextOverflow.ellipsis,
      );
    }

    return null;
  }

  @override
  double? get titleSpacing =>
      (useCloseButton ? -(PaddingDimensions.xSmall + 2) : null);

  @override
  double? get leadingWidth => leadingIconWidth ?? Dimensions.toolbarHeight;

  void _onBackPressed(BuildContext context) {
    if (onBackPressed != null) {
      onBackPressed!();
    } else {
      AppRouteNavigator.pop(context);
    }
  }

  Widget get _backWithPreviousPageName {
    return GestureDetector(
      onTap: () => _onBackPressed(context),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            LangAdaptiveWidget(
              child: Icon(
                appBarCloseIconType.icon,
                color: context.appColors.primary.shade900,
              ),
            ),
            Flexible(
              child: Text(
                overflow: TextOverflow.ellipsis,
                previousPageName ?? '',
                style: context.regular,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
