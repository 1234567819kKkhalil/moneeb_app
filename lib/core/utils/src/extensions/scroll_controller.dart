part of app_utils;

extension ScrollControllerExtension on ScrollController {
  /// [scrollToDesiredPosition] scrolls to the desired position [targetKey] of the widget.
  /// [widgetKey] is the key of the widget u want it to scroll up.
  /// [offsetAdjustment] is the offset adjustment to be added to the target offset.
  void scrollToDesiredPosition({
    required GlobalKey targetKey,
    required GlobalKey widgetKey,
    double offsetAdjustment = 0,
  }) {
    final targetBox = targetKey.currentContext?.findRenderObject() as RenderBox?;
    final currentBox = widgetKey.currentContext?.findRenderObject() as RenderBox?;

    if (targetBox == null || currentBox == null) return;

    final targetOffset =
        targetBox.localToGlobal(Offset.zero).dy + targetBox.size.height;
    final currentOffset = currentBox.localToGlobal(Offset.zero).dy + offsetAdjustment ;

    if (currentOffset > targetOffset) {
      final scrollOffset = currentOffset - targetOffset;
      animateTo(
        offset + scrollOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
