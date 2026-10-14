part of helper_widgets;

class AppSkeletonizer extends StatelessWidget {
  const AppSkeletonizer({
    super.key,
    required this.child,
    this.isEnabled = true,
    this.containersColor,
    this.effect,
  });
  final Widget child;
  final bool isEnabled;
  final Color? containersColor;
  final ShimmerEffect? effect;
  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isEnabled,
      containersColor: containersColor ?? context.appColors.neutral.shade100,
      // containersColor: ,
      effect: ShimmerEffect(
        baseColor: context.appColors.neutral.shade100,
        highlightColor: context.appColors.neutral.shade200,
      ),
      child: child,
    );
  }
}
