part of app_utils;

typedef TapFunctionType = void Function()?;

extension WidgetExtenstions on Widget {
  Widget onTap(TapFunctionType onTap, {bool withHoverColor = true}) {
    return InkWell(
      splashColor: withHoverColor ? null : Colors.transparent,
      highlightColor: withHoverColor ? null : Colors.transparent,
      focusColor: withHoverColor ? null : Colors.transparent,
      hoverColor: withHoverColor ? null : Colors.transparent,
      onTap: onTap,
      child: this,
    );
  }

  Widget toolTop(BuildContext context, {required String message}) {
    return Tooltip(
      message: message,
      decoration: BoxDecoration(color: context.appColors.secondary.shade500),
      textStyle: context.medium.copyWith(fontSize: Dimensions.normal),
      child: this,
    );
  }

  Container roundedRectangleBorder(
    BuildContext context, {
    Color? backgroundColor,
    List<Color>? gradiantColors,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    Color? borderColor,
    double? borderWidth,
    EdgeInsetsGeometry? margin,
    double? horizontalMargin,
    double? verticalMargin,
    EdgeInsetsGeometry? padding,
    double? horizontalPadding,
    double? verticalPadding,
    bool isShadow = false,
    Color? shadowColor,
    bool isExpanded = false,
    BorderRadiusGeometry? borderRadius,
    double? radius,
  }) {
    assert(radius == null || borderRadius == null);
    assert(padding == null || horizontalPadding == null);
    assert(padding == null || verticalPadding == null);
    assert(margin == null || horizontalMargin == null);
    assert(margin == null || verticalMargin == null);
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: margin ?? EdgeInsets.symmetric(
        horizontal: horizontalMargin ?? PaddingDimensions.normal,
        vertical: verticalMargin ?? PaddingDimensions.normal,
      ),
      padding: padding ?? EdgeInsets.symmetric(
        horizontal: horizontalPadding ?? PaddingDimensions.normal,
        vertical: verticalPadding ?? PaddingDimensions.normal,
      ),
      width: isExpanded ? double.infinity : null,
      decoration: BoxDecoration(
        color: backgroundColor ?? context.appColors.neutral.shade50,
        gradient: gradiantColors == null
            ? null
            : LinearGradient(
          colors: gradiantColors,
          begin: begin ?? Alignment.topLeft,
          end: end ?? Alignment.bottomCenter,
        ),
        border: Border.all(
            color: borderColor ?? context.appColors.neutral.shade50,
            width: borderWidth ?? 1,
        ),
        borderRadius: borderRadius ?? BorderRadius.circular(radius ?? 16),
        boxShadow: isShadow
            ? [
                BoxShadow(
                  color: shadowColor ?? context.appColors.neutral.shade500,
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ]
            : [],
      ),
      child: this,
    );
  }
}
