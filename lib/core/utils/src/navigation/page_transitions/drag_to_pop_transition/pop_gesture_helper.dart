part of app_utils;

const double _kMinFlingVelocity = 1.0; // Screen heights per second.
const int _kMaxDroppedSwipePageForwardAnimationTime = 800; // Milliseconds.
const int _kMaxPageBackAnimationTime = 300; // Milliseconds.

class PopGestureHelper {
  static bool isPopGestureInProgress(PageRoute<dynamic> route) {
    return route.navigator!.userGestureInProgress;
  }

  static bool isPopGestureEnabled<T>(PageRoute<T> route) {
    if (route.isFirst) return false;
    if (route.willHandlePopInternally) return false;
    if (route.popDisposition != RoutePopDisposition.pop) return false;
    if (route.fullscreenDialog) return false;
    if (route.animation!.status != AnimationStatus.completed) return false;
    if (route.secondaryAnimation!.status != AnimationStatus.dismissed) return false;

    return true;
  }

  static Widget buildPopGestureDetector<T>(PageRoute<T> route, Widget child) {
    return _BackGestureDetector<T>(
      enabledCallback: () => isPopGestureEnabled<T>(route),
      backGestureController: _BackGestureController<T>(
        navigator: route.navigator,
        animationController: route.controller,
      ),
      child: child,
    );
  }
}

class _BackGestureDetector<T> extends StatefulWidget {
  const _BackGestureDetector({
    super.key,
    required this.enabledCallback,
    required this.backGestureController,
    required this.child,
  });

  final Widget child;

  final bool Function() enabledCallback;

  final _BackGestureController<T> backGestureController;

  @override
  _BackGestureDetectorState<T> createState() => _BackGestureDetectorState<T>();
}

class _BackGestureDetectorState<T> extends State<_BackGestureDetector<T>> {
  late _BackGestureController<T> _backGestureController;
  int _lastPointer = -1;
  bool _rejected = false;

  //This is to detect the vertical drag gestures and handle their callbacks
  late VerticalDragGestureRecognizer _recognizer;

  @override
  void initState() {
    super.initState();
    _backGestureController = widget.backGestureController;

    _recognizer = VerticalDragGestureRecognizer(debugOwner: this)
      ..onStart = _handleDragStart
      ..onUpdate = _handleDragUpdate
      ..onEnd = _handleDragEnd
      ..onCancel = _handleDragCancel;
  }

  @override
  void dispose() {
    _recognizer.dispose();
    super.dispose();
  }

  bool isDraggingFromTop = false;
  bool isDragUpdate = false;

  void _handleDragStart(DragStartDetails details) {
    if(!mounted) return;
    isDragUpdate = false;

    _backGestureController.navigator?.didStartUserGesture();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if(!mounted) return;

    if(!isDragUpdate){
      isDraggingFromTop = details.delta.dy >= 0;
    }

    isDragUpdate = true;

    if(isDraggingFromTop){
      _backGestureController.dragUpdate(
          (details.primaryDelta! / (context.height / 6))
      );
    }else{
      _backGestureController.dragUpdate(
          - (details.primaryDelta! / (context.height / 6))
      );
    }

  }

  void _handleDragEnd(DragEndDetails details) {
    if(!mounted) return;

    isDragUpdate = false;

    if (!_rejected) {
      if(isDraggingFromTop){
        _backGestureController.dragEnd((
            details.velocity.pixelsPerSecond.dy / context.size!.height));
      }else{
        _backGestureController.dragEnd(-(
            details.velocity.pixelsPerSecond.dy / context.size!.height));
      }

    } else {
      _backGestureController.dragEnd(0.0, cancel: true);
    }
  }

  void _handleDragCancel() {
    if(!mounted) return;
    _backGestureController.dragEnd(0.0, cancel: true);
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (_lastPointer >= 0) {
      // If another pointer is down, reject this gesture
      _rejected = true;
      _recognizer.rejectGesture(_lastPointer);
      _lastPointer = -1;
    } else if (widget.enabledCallback() && _lastPointer < 0) {
      _rejected = false;
      _lastPointer = event.pointer;
      _recognizer.addPointer(event);
    }
  }

  void _handlePointerCancel(PointerEvent event) {
    if (event.pointer == _lastPointer) {
      _lastPointer = -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        widget.child,
        PositionedDirectional(
          start: 0.0,
          end: 0.0,
          top: 0.0,
          bottom: 0.0,
          child: Listener(
            onPointerDown: _handlePointerDown,
            onPointerUp: _handlePointerCancel,
            onPointerCancel: _handlePointerCancel,
            behavior: HitTestBehavior.translucent,
          ),
        ),
      ],
    );
  }
}

class _BackGestureController<T> {
  _BackGestureController({
    required this.navigator,
    required this.animationController,
  });

  final AnimationController? animationController;
  final NavigatorState? navigator;

  void dragUpdate(double delta) {
    animationController?.value -= delta;
  }

  void dragEnd(double velocity, {bool cancel = false}) {
    const Curve animationCurve = Curves.fastLinearToSlowEaseIn;
    bool animateForward;

    if (velocity.abs() >= _kMinFlingVelocity || cancel) {
      animateForward = velocity <= 0;
    } else {
      animateForward = animationController!.value > 0.5;
    }

    if (animateForward) {
      final int droppedPageForwardAnimationTime = min(
        lerpDouble(_kMaxDroppedSwipePageForwardAnimationTime, 0,
            animationController!.value)!
            .floor(),
        _kMaxPageBackAnimationTime,
      );
      animationController?.animateTo(1.0,
          duration: Duration(milliseconds: droppedPageForwardAnimationTime),
          curve: animationCurve);
    } else {
      navigator?.pop();

      if (animationController!.isAnimating) {
        final int droppedPageBackAnimationTime = lerpDouble(0,
            _kMaxDroppedSwipePageForwardAnimationTime, animationController!.value)!
            .floor();
        animationController?.animateBack(0.0,
            duration: Duration(milliseconds: droppedPageBackAnimationTime),
            curve: animationCurve);
      }
    }

    if(animationController != null){
      if (animationController!.isAnimating) {
        late AnimationStatusListener animationStatusCallback;
        animationStatusCallback = (AnimationStatus status) {
          navigator!.didStopUserGesture();
          animationController!.removeStatusListener(animationStatusCallback);
        };
        animationController!.addStatusListener(animationStatusCallback);
      } else {
        if(navigator?.userGestureInProgress ?? false){
          navigator!.didStopUserGesture();
        }

      }
    }

  }
}