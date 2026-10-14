part of app_material;

class AppIconButton extends StatefulWidget {
  final VoidCallback onPressed;
  final AlignmentGeometry? alignment;
  final double? size;
  final String? svgIconPath;
  final Color? color;
  final IconData? iconData;
  final bool langAdaptive;
  final String? tooltip;
  final double? endPadding;
  final double? startPadding;
  final double? topPadding;
  final double? bottomPadding;
  final bool enableFeedback;

  const AppIconButton.fromSvg({
    super.key,
    required this.onPressed,
    this.alignment,
    required this.size,
    required this.svgIconPath,
    this.color,
    this.langAdaptive = false,
    this.tooltip,
    this.endPadding,
    this.startPadding,
    this.topPadding,
    this.bottomPadding,
    this.enableFeedback = true,
  }) : iconData = null;

  const AppIconButton({
    super.key,
    required this.onPressed,
    this.alignment,
    this.size,
    required this.iconData,
    this.color,
    this.langAdaptive = false,
    this.tooltip,
    this.endPadding,
    this.startPadding,
    this.topPadding,
    this.bottomPadding,
    this.enableFeedback = true,
  }) : svgIconPath = null;

  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> {
  final Throttler _throttler = Throttler(milliseconds: 1250);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.enableFeedback) {
          Feedback.forTap(context);
        }

        _throttler.throttle(onThrottle: () {
          widget.onPressed();
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          end: widget.endPadding ?? 4,
          start: widget.startPadding ?? 4,
          top: widget.topPadding ?? 4,
          bottom: widget.bottomPadding ?? 4,
        ),
        child: widget.langAdaptive
          ? LangAdaptiveWidget(child: _buildIcon())
          : _buildIcon(),
      ),
    );
  }

  Widget _buildIcon() {
    if(widget.iconData != null){
      return Icon(
        widget.iconData,
        color: widget.color,
        size: widget.size ?? IconDimensions.medium,
      );
    }

    return AppSvg(
      svgPath: widget.svgIconPath ?? '',
      size: widget.size ?? IconDimensions.normal,
      color: widget.color,
    );
  }
}
