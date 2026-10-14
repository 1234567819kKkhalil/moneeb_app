part of app_material;

class AppSvg extends StatelessWidget {
  const AppSvg({
    super.key,
    this.svgPath,
    this.iconName,
    this.color,
    this.width,
    this.height,
    this.size,
    this.withIconBackground = false,
    this.iconBackgroundColor,
    this.showLoading = false,
    this.useLangAdaptive = false,
  });

  final String? svgPath;
  final IconData? iconName;
  final Color? color;
  final bool withIconBackground;
  final Color? iconBackgroundColor;
  final double? width;
  final double? height;
  final double? size;
  final bool showLoading;
  final bool useLangAdaptive;

  @override
  Widget build(BuildContext context) {
    return (svgPath != null)
        ? SvgPicture.asset(
            svgPath!,
            width: size ?? width,
            height: size ?? height,
            matchTextDirection: useLangAdaptive,
            colorFilter: color != null
                ? ColorFilter.mode(color!, BlendMode.srcIn)
                : null,
            placeholderBuilder: (BuildContext context) => showLoading
                ? const AppProgressIndicator()
                : SizedBox(
                    width: size ?? 12,
                    height: size ?? 12,
                  ),
          )
        : withIconBackground
            ? Container(
                decoration: BoxDecoration(
                    color: iconBackgroundColor ??
                        context.appColors.neutral.shade50,
                    shape: BoxShape.circle),
                padding: const EdgeInsets.all(PaddingDimensions.normal),
                child: _buildIcon,
              )
            : _buildIcon;
  }

  Widget get _buildIcon {
    return Icon(
      iconName,
      size: size,
      color: color,
    );
  }
}
