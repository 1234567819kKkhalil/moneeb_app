part of core;

class CustomizedPopScope extends StatefulWidget {
  final Widget child;
  final VoidCallback action;

  const CustomizedPopScope({
    super.key,
    required this.child,
    required this.action,
  });

  @override
  State<CustomizedPopScope> createState() => _CustomizedPopScopeState();
}

class _CustomizedPopScopeState extends State<CustomizedPopScope> {
  double _dragDistance = 0;
  final GlobalKey _childKey = GlobalKey();
  double _childHeight = 0;

  @override
  void initState() {
    super.initState();
    // Post-frame callback to get size after first layout
    WidgetsBinding.instance.addPostFrameCallback((_) => _getChildHeight());
  }

  void _getChildHeight() {
    final RenderBox? renderBox = _childKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && mounted) {
      setState(() {
        _childHeight = renderBox.size.height;
      });
    }
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _dragDistance += details.primaryDelta ?? 0;
  }

  void _onDragEnd(BuildContext context) {
    bool isArabic = context.read<AppLanguageCubit>().state.langCode.isArabic;

    if (isArabic && _dragDistance < -20) {
      widget.action();
    } else if (!isArabic && _dragDistance > 20) {
      widget.action();
    }

    _dragDistance = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Stack(
      children: [
        _popScope,
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragUpdate: _onDragUpdate,
            onHorizontalDragEnd: (_) => _onDragEnd(context),
            child: SizedBox(
              width: 20,
              height: _childHeight > 0 ? _childHeight : null,
            ),
          ),
        ),
      ],
    )
        : _popScope;
  }

  Widget get _popScope {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        widget.action();
      },
      child: KeyedSubtree(
        key: _childKey,
        child: widget.child,
      ),
    );
  }
}
