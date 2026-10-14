part of app_material;

class AppProgressIndicator extends StatelessWidget {
  final Color? color;
  final double strokeWidth;
  final double size;

  const AppProgressIndicator({
    super.key,
    this.color,
    this.strokeWidth = 4.0,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: FittedBox(
        child: CircularProgressIndicator.adaptive(
          valueColor: AlwaysStoppedAnimation<Color>(color ?? context.appColors.primary.shade500),
          backgroundColor: color ?? context.appColors.primary.shade500,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}
