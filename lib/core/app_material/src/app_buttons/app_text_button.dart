part of app_material;

class AppTextButton extends StatefulWidget {
  final void Function()? onPressed;
  final String text;
  final List<Color>? gradientColors;
  // final Color? textColor;

  final double? fontSize;

  final bool isLoading;
  final TextStyle? textStyle;
  final TextDecoration? textDecoration;
  final EdgeInsetsGeometry? padding;

  const AppTextButton({
    super.key,
    this.onPressed,
    required this.text,
    this.fontSize,
    // this.textColor,
    this.isLoading = false,
    this.textStyle,
    this.textDecoration,
    this.padding,
  }) : gradientColors = null;

  const AppTextButton.gradient({
    super.key,
    this.onPressed,
    required this.text,
    this.gradientColors,
    this.fontSize,
    this.isLoading = false,
    this.textStyle,
    this.textDecoration,
    this.padding,
  });// : textColor = null;

  @override
  State<AppTextButton> createState() => _AppTextButtonState();
}

class _AppTextButtonState extends State<AppTextButton> {
  final Throttler _throttler = Throttler(milliseconds: 1250);

  @override
  void dispose() {
    _throttler.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: widget.padding == null ? null : context.theme.textButtonTheme.style?.copyWith(
          padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(widget.padding!),
          textStyle: widget.textStyle != null ? WidgetStatePropertyAll<TextStyle?>(widget.textStyle) : null,
        ),
        onPressed: widget.isLoading ? null : () {
          Feedback.forTap(context);
          _throttler.throttle(onThrottle: () {
            widget.onPressed?.call();
          });
        },
        child: widget.isLoading
            ? const AppProgressIndicator()
            : widget.gradientColors != null
            ? ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (Rect bounds) {
            return LinearGradient(colors: widget.gradientColors!)
                .createShader(bounds);
          },
          child: _buildText(context),
        )
            : _buildText(context)
    );
  }

  Widget _buildText(BuildContext context) {
    return Text(
      widget.text,
      style: widget.textStyle,
    );
  }
}
