part of app_material;

class AppPageProgress extends StatelessWidget {
  const AppPageProgress({
    super.key,
    required this.count,
    required this.progressIndex,
    this.selectedColor,
    this.unSelectedColor,
    this.minWidth = 9,
    this.maxWidth = 30,
    this.height = 1,
    this.animationDuration,
    this.spacing = 4,
  });

  final int count;
  final int progressIndex;
  final Color? selectedColor;
  final Color? unSelectedColor;
  final double? minWidth;
  final double? maxWidth;
  final double? height;
  final Duration? animationDuration;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(
          count,
          (index) => Expanded(
            child: AnimatedContainer(
                  margin: EdgeInsets.all(spacing ?? 4),
                  duration:
                      animationDuration ?? const Duration(milliseconds: 400),
                  width:  maxWidth,
                  height: 6,
                  decoration: BoxDecoration(
                      color: getCircleColor(index,context),
                      border:
                          Border.all(color: _getBorderColor(index,context), width: 1.2),
                      borderRadius: BorderRadius.circular(15)),
                ),
          )).toList(),
    );
  }

  Color getCircleColor(int index,BuildContext context) {
    if (progressIndex == index) {
      return selectedColor ?? context.appColors.neutral.shade800;
    } else {
      if (progressIndex > index) {
        return unSelectedColor ?? context.appColors.neutral.shade800;
      } else {
        return Colors.transparent;
      }
    }
  }

  Color _getBorderColor(int index,BuildContext context) {
    if (progressIndex == index) {
      return selectedColor ?? context.appColors.neutral.shade800;
    } else {
      return unSelectedColor ?? context.appColors.neutral.shade800;
    }
  }
}
