part of app_utils;

typedef TransitionBackgroundBuilder = Widget Function(BuildContext context, Widget child);

class DragToPopMaterialPageRoute extends MaterialPageRoute {
  DragToPopMaterialPageRoute({required super.builder, required super.settings});

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return _SlideAndFadeTransition(
      primaryRouteAnimation: animation,
      secondaryRouteAnimation: secondaryAnimation,
      linearTransition: PopGestureHelper.isPopGestureInProgress(this),
      backgroundColor: context.appColors.neutral.shade900,
      child: PopGestureHelper.buildPopGestureDetector(this, child),
    );
  }
}


class _SlideAndFadeTransition extends StatelessWidget {
  _SlideAndFadeTransition({
    super.key,
    required Animation<double> primaryRouteAnimation,
    required Animation<double> secondaryRouteAnimation,
    required bool linearTransition,
    required this.child,
    Color? backgroundColor,
    TransitionBackgroundBuilder? backgroundBuilder,
  })  : _primaryAnimation1 = (
      linearTransition
          ? primaryRouteAnimation
          : CurvedAnimation(
        parent: primaryRouteAnimation,
        curve: Curves.linearToEaseOut,
      ))
      .drive(Tween<double>(
    begin: 0.0,
    end: 1.0,
  )),
  _primaryAnimation2 = (
      linearTransition
          ? primaryRouteAnimation
          : CurvedAnimation(
        parent: primaryRouteAnimation,
        curve: Curves.linearToEaseOut,
      ))
      .drive(Tween<Offset>(
    begin: const Offset(0.0, 0.1),
    end: const Offset(0.0, 0.0),
  )),

  _backgroundBuilder = (backgroundBuilder ?? (context, child) => DecoratedBox(
    decoration: BoxDecoration(
      color: backgroundColor ?? Colors.white,
    ),
    child: child,
  ));

  final Animation<double> _primaryAnimation1;
  final Animation<Offset> _primaryAnimation2;
  final TransitionBackgroundBuilder _backgroundBuilder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _primaryAnimation1,
      child: _backgroundBuilder(
        context,
        SlideTransition(
          position: _primaryAnimation2,
          child: child,
        ),
      ),
    );
  }
}