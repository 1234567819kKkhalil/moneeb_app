part of app_material;

//Un comment when needed
/*
class AppShaderMask extends StatefulWidget {
  final Widget child;
  final Widget? shimmer;
  final Color? beginColor;
  final Color? endColor;
  final bool isLoading;

  const AppShaderMask(
      {super.key,
      required this.child,
      this.beginColor,
      this.endColor,
      this.shimmer,
      this.isLoading = false});

  @override
  State<AppShaderMask> createState() => _AppShaderMaskState();
}

class _AppShaderMaskState extends State<AppShaderMask>
    with SingleTickerProviderStateMixin {
  late AnimationController _animatedContainer;
  late Animation<Color?> animation;
  late Animation<Color?> animationTwo;

  late final Color _shaderBeingColor = context.appColors.neutral.shade50;
  late final Color _shaderEndColor = context.appColors.neutral.shade50;

  @override
  void initState() {
    super.initState();
    _animatedContainer = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = ColorTween(
      begin: widget.beginColor ?? _shaderBeingColor,
      end: widget.endColor ?? _shaderEndColor,
    ).animate(_animatedContainer);
    animationTwo = ColorTween(
            begin: widget.endColor ?? _shaderEndColor,
            end: widget.beginColor ?? _shaderBeingColor)
        .animate(_animatedContainer);
    _animatedContainer.forward();
    _animatedContainer.addListener(() {
      if (_animatedContainer.status == AnimationStatus.completed) {
        _animatedContainer.reverse();
      } else if (_animatedContainer.status == AnimationStatus.dismissed) {
        _animatedContainer.forward();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animatedContainer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !widget.isLoading
        ? widget.child
        : ShaderMask(
            child: widget.shimmer,
            shaderCallback: (rect) {
              return LinearGradient(
                      colors: [animation.value!, animationTwo.value!])
                  .createShader(rect);
            });
  }
}


class AppShimmer extends StatefulWidget {
  final Color? beginColor;
  final Color? endColor;
  final bool isLoading;

  const AppShimmer(
      {super.key,
        this.beginColor,
        this.endColor,
        this.isLoading = false});

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animatedContainer;
  late Animation<Color?> animation;
  late Animation<Color?> animationTwo;
  @override
  void initState() {
    super.initState();
    _animatedContainer = AnimationController(
        duration: const Duration(milliseconds: 1500), vsync: this);
    animation = ColorTween(
      begin: widget.beginColor ?? _shaderBeingColor,
      end: widget.endColor ?? _shaderEndColor,
    ).animate(_animatedContainer);
    animationTwo = ColorTween(
        begin: widget.endColor ?? _shaderEndColor,
        end: widget.beginColor ?? _shaderBeingColor)
        .animate(_animatedContainer);
    _animatedContainer.forward();
    _animatedContainer.addListener(() {
      if (_animatedContainer.status == AnimationStatus.completed) {
        _animatedContainer.reverse();
      } else if (_animatedContainer.status == AnimationStatus.dismissed) {
        _animatedContainer.forward();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animatedContainer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: const SizedBox(height: 70,width: 70,),
        shaderCallback: (rect) {
          return LinearGradient(
              colors: [animation.value!, animationTwo.value!])
              .createShader(rect);
        });
  }
}
*/
