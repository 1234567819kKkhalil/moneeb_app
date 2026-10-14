part of app_material;

class AppPrimaryButton extends StatefulWidget {
  final void Function()? onPressed;
  final String? text;
  final bool isLoading;
  final bool? isExpanded;
  final Widget? leadingWidget;
  final Widget? trailingWidget;
  final double? buttonHeight;
  final bool isAnimated;

  final ButtonStyle? Function(ButtonStyle? currentStyle)? buttonStyle;
  final Color? textColor;
  final TextStyle? textStyle;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final bool isOutlined;
  final bool enableThrottler;

  const AppPrimaryButton({
    super.key,
    this.onPressed,
    this.text,
    this.isLoading = false,
    this.isExpanded = false,
    this.leadingWidget,
    this.trailingWidget,
    this.buttonHeight,
    this.isAnimated = false,
    this.buttonStyle,
    this.textColor,
    this.borderColor,
    this.textStyle,
    this.padding,
    this.enableThrottler = false,
    this.isOutlined = false,
  });

  const AppPrimaryButton.outline({
    super.key,
    this.onPressed,
    this.text,
    this.isLoading = false,
    this.isExpanded = true,
    this.leadingWidget,
    this.trailingWidget,
    this.buttonHeight,
    this.isAnimated = false,
    this.buttonStyle,
    this.textColor,
    this.textStyle,
    this.padding,
    this.borderColor,
    this.enableThrottler = false,
  }) : isOutlined = true;

  @override
  State<AppPrimaryButton> createState() => _AppPrimaryButtonState();
}

class _AppPrimaryButtonState extends State<AppPrimaryButton> {
  final Throttler _throttler = Throttler(milliseconds: 800);
  ButtonStyle? style;

  @override
  void didChangeDependencies() {
    style = widget.isOutlined
        ? context.theme.outlinedButtonTheme.style
        : ElevatedButtonTheme.of(context).style;

    EdgeInsetsGeometry? padding = widget.padding;

    if (padding == null && widget.buttonHeight == Dimensions.buttonMinHeight) {
      padding = const EdgeInsets.symmetric(horizontal: 10);
    }

    style = style?.copyWith(
      padding: padding == null ? null : WidgetStatePropertyAll(padding),
      fixedSize: widget.buttonHeight == null
          ? null
          : WidgetStatePropertyAll(Size.fromHeight(widget.buttonHeight!)),
      side: widget.borderColor == null
          ? null
          : WidgetStatePropertyAll(
              style?.side?.resolve({})?.copyWith(color: widget.borderColor!),
            ),
      foregroundColor: widget.textColor == null
          ? null
          : WidgetStatePropertyAll(widget.textColor!),
      textStyle: widget.textStyle == null
          ? null
          : WidgetStatePropertyAll(widget.textStyle),
    );

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _throttler.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (widget.isLoading || widget.onPressed == null)
          ? null
          : () {
              Feedback.forTap(context);
              FocusManager.instance.primaryFocus?.unfocus();

              if (widget.enableThrottler) {
                _throttler.throttle(
                  onThrottle: () {
                    widget.onPressed?.call();
                  },
                );
              } else {
                widget.onPressed?.call();
              }
            },
      style: widget.buttonStyle?.call(style) ?? style,
      child: widget.isAnimated
          ? AnimatedSize(
              curve: Curves.decelerate,
              clipBehavior: Clip.none,
              duration: const Duration(milliseconds: 350),
              reverseDuration: const Duration(milliseconds: 200),
              child: _getButtonContent(context),
            )
          : _getButtonContent(context),
    );
  }

  Widget _getButtonContent(BuildContext context) {
    return Row(
      mainAxisSize: widget.isExpanded ?? false
          ? MainAxisSize.max
          : MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.leadingWidget != null) widget.leadingWidget!,

        if (!widget.isLoading && (widget.text?.isNotEmpty ?? false))
          Flexible(
            child: FittedBox(
              child: Text(
                widget.text!,
                //the text style will be used from ThemeData
              ),
            ),
          ),

        if (widget.isLoading)
          Center(
            child: Padding(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: PaddingDimensions.normal,
              ),
              child: SizedBox(
                height: IconDimensions.xSmall,
                width: IconDimensions.xSmall,
                child: CircularProgressIndicator(
                  color: context.appColors.secondary.shade500,
                  strokeWidth: 3,
                ),
              ),
            ),
          ),

        if (widget.trailingWidget != null) widget.trailingWidget!,
      ],
    );
  }
}
