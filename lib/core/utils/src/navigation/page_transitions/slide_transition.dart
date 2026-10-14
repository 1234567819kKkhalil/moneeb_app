part of app_utils;

class SlideTransitionRoute<T> extends PageRoute<T> {
  SlideTransitionRoute(this.child, {this.currentTapOffset, super.settings});

  final Offset? currentTapOffset;

  @override
  Color get barrierColor => Colors.transparent;

  @override
  String? get barrierLabel => null;

  final Widget child;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    const begin = Offset(1, 0);
    const end = Offset.zero;
    const curve = Curves.ease;

    var tween = Tween(begin: currentTapOffset ?? begin, end: end)
        .chain(CurveTween(curve: curve));
    return SlideTransition(
      position: animation.drive(tween),
      child: child,
      transformHitTests: false,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 330);

  @override
  Duration get reverseTransitionDuration => const Duration(milliseconds: 310);
}