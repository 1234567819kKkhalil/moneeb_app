part of app_utils;

class FadeTransitionRoute<T> extends PageRoute<T> {
  FadeTransitionRoute({
    required this.child,
    this.duration,
    this.routeName,
    this.isFullscreenDialog = false,
    this.barrierBgColor = Colors.white,
  });

  @override
  bool get fullscreenDialog => isFullscreenDialog;

  @override
  RouteSettings get settings => RouteSettings(name: routeName);

  @override
  Color get barrierColor => barrierBgColor;

  @override
  String? get barrierLabel => null;

  @override
  bool get opaque => false;

  final Widget child;
  final Duration? duration;
  final String? routeName;
  final bool isFullscreenDialog;
  final Color barrierBgColor;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration =>
      duration ?? const Duration(milliseconds: 250);
}