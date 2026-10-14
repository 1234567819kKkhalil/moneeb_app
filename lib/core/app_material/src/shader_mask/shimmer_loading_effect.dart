part of app_material;

class ShimmerLoadingEffect extends StatefulWidget {
  final Widget child;
  final bool startAnim;
  final Color? startColor;
  final Color? endColor;

  ShimmerLoadingEffect(
      {Key? key,
      required this.child, this.startAnim = true,
      this.startColor,
      this.endColor,})
      : super(key: key ?? UniqueKey());

  @override
  State<ShimmerLoadingEffect> createState() => _ShimmerLoadingEffectState();
}

class _ShimmerLoadingEffectState extends State<ShimmerLoadingEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late Animation<Color?> colorTween;
  late Animation<Color?> colorTweenReverse;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    // We will initialize the colorTween and colorTweenReverse in didChangeDependencies()
    colorTween = ColorTween(
      begin: widget.startColor ?? Colors.transparent, // Default fallback
      end: widget.endColor ?? Colors.transparent, // Default fallback
    ).animate(animationController);

    colorTweenReverse = ColorTween(
      begin: widget.endColor ?? Colors.transparent, // Default fallback
      end: widget.startColor ?? Colors.transparent, // Default fallback
    ).animate(animationController);

    if (widget.startAnim) {
      animationController.forward();
    }

    animationController.addListener(() {
      if (widget.startAnim) {
        if (animationController.isCompleted) {
          animationController.reverse();
        } else if (animationController.isDismissed) {
          animationController.forward();
        }
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final appColors = context.appColors; // Access the theme colors

    colorTween = ColorTween(
      begin: widget.startColor ?? appColors.neutral.shade200,
      end: widget.endColor ?? appColors.primary.shade50,
    ).animate(animationController);

    colorTweenReverse = ColorTween(
      begin: widget.endColor ?? appColors.primary.shade200,
      end: widget.startColor ?? appColors.neutral.shade50,
    ).animate(animationController);

    // Start the animation if needed
    if (widget.startAnim) {
      animationController.forward();
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.startAnim,
      child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            if (!widget.startAnim) {
              return child!;
            }

            return ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) {
                return LinearGradient(
                        colors: [colorTween.value!, colorTweenReverse.value!])
                    .createShader(bounds);
              },
              child: child,
            );
          },
          child: widget.child),
    );
  }
}
