part of app_material;

class AppSnackBars extends StatelessWidget {
  const AppSnackBars({
    super.key,
    this.duration,
    this.leadingIcon,
    required this.title,
    this.subTitle,
    this.borderSide,
    this.elevation,
    this.color,
    this.snackBarBehavior,
    this.snackBarPosition,
    this.leadingWidget,
    this.dismissDirection,
  });

  final int? duration;
  final IconData? leadingIcon;
  final String title;
  final String? subTitle;
  final BorderSide? borderSide;
  final double? elevation;
  final Color? color;
  final SnackBarBehavior? snackBarBehavior;
  final SnackBarPosition? snackBarPosition;
  final Widget? leadingWidget;
  final DismissDirection? dismissDirection;

  static void success(BuildContext context, {required String title, String? subTitle}) {
    ScaffoldMessenger.of(context).showSnackBar(
      AppSnackBars(
        title: title,
        subTitle: subTitle,
        leadingIcon: Icons.check_circle,
        borderSide: BorderSide(width: 1.2, color: context.appColors.success.shade500),
      ).build(context) as SnackBar,
    );
  }

  static void error(BuildContext context, {required String title, String? subTitle}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      AppSnackBars(
        title: title,
        subTitle: subTitle,
        color: context.appColors.danger.shade500,
        leadingIcon: Icons.info,
        // snackBarPosition: SnackBarPosition.top,
        // dismissDirection: DismissDirection.up,
        borderSide: BorderSide(width: 1, color: context.appColors.danger.shade500),
      ).build(context) as SnackBar,
    );
  }

  static void warning(BuildContext context, {required String title, String? subTitle}) {
    ScaffoldMessenger.of(context).showSnackBar(
      AppSnackBars(
        title: title,
        subTitle: subTitle,
        color: context.appColors.warning.shade500,
        leadingIcon: Icons.warning,
        borderSide: BorderSide(width: 1, color: context.appColors.warning.shade500),
      ).build(context) as SnackBar,
    );
  }

  static void networkError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      AppSnackBars(
        title: appLocalizer.networkError,
        color: context.appColors.danger.shade500,
        leadingIcon: Icons.info,
        borderSide: BorderSide(width: 1, color: context.appColors.danger.shade500),
      ).build(context) as SnackBar,
    );
  }

  static void internetConnection(BuildContext context, {bool hasConnection = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      AppSnackBars(
        snackBarPosition: SnackBarPosition.bottom,
        title: hasConnection
            ? appLocalizer.hasInternetConnection
            : appLocalizer.noInternetConnection,
        leadingWidget: hasConnection
            ? const Icon(
                Icons.wifi,
                size: 20,
              )
            : const Icon(
                Icons.wifi_off_outlined,
                size: 20,
              ),
        borderSide: BorderSide(width: 1, color: context.appColors.neutral.shade500),
      ).build(context) as SnackBar,
    );
  }

  static void hint(BuildContext context, {required String title, IconData? icon}) {
    ScaffoldMessenger.of(context).showSnackBar(
      AppSnackBars(
        title: title,
        leadingIcon: icon ?? Icons.info ,
        borderSide: BorderSide(width: 1, color: context.appColors.neutral.shade500),
      ).build(context) as SnackBar,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      margin: toastMargin(context, snackBarPosition),
      dismissDirection: dismissDirection ?? DismissDirection.down,
      behavior: snackBarBehavior ?? SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          side: borderSide ?? BorderSide.none),
      duration: Duration(seconds: duration ?? 1),
      backgroundColor: color ?? Colors.white,
      elevation: elevation,
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _leading(),
          const SizedBox(width: Dimensions.small),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: context.medium.copyWith(
                    fontSize: Dimensions.normal,
                  ),
                ),
                subTitle != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Text(
                          subTitle!,
                          style: context.regular.copyWith(
                              color: context.appColors.neutral.shade700,
                              fontSize: Dimensions.normal,
                              height: 1.1),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _leading() {
    if (leadingIcon != null) {
      return Icon(leadingIcon!, size: 20);
    } else if (leadingWidget != null) {
      return leadingWidget!;
    } else {
      return const SizedBox();
    }
  }

  static const double toastHorizontalMargin = 16;

  EdgeInsetsGeometry? toastMargin(BuildContext context, SnackBarPosition? snackBarPosition) {
    switch (snackBarPosition) {
      case null:
      case SnackBarPosition.normal:
        return null;
      case SnackBarPosition.bottom:
        return EdgeInsets.only(
          bottom: (MediaQuery.of(context).viewPadding.bottom + 45),
          right: toastHorizontalMargin,
          left: toastHorizontalMargin,
        );
      case SnackBarPosition.center:
        return EdgeInsets.only(
          bottom: (MediaQuery.of(context).size.height * .46),
          right: toastHorizontalMargin,
          left: toastHorizontalMargin,
        );
      case SnackBarPosition.top:
        return EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height -
              (MediaQuery.of(context).viewPadding.top + kToolbarHeight + 35),
          right: toastHorizontalMargin,
          left: toastHorizontalMargin,
        );
    }
  }
}

enum SnackBarPosition { bottom, center, top, normal }
