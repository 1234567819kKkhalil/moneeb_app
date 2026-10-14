part of app_material;

class AppRadioTile<T> extends StatelessWidget {
  final T? value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final String title;
  final EdgeInsetsGeometry? paddingInsets;
  final Color? unSelectedColor;
  final Color? selectedColor;

  const AppRadioTile({
    super.key,
    this.value,
    this.groupValue,
    this.onChanged,
    required this.title,
    this.paddingInsets,
    this.unSelectedColor,
    this.selectedColor,
  });

  bool get isSelected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    final bgColor = isSelected
        ? selectedColor ?? appColors.primary.shade400
        : unSelectedColor ?? appColors.neutral.shade800;

    final foregroundColor = isSelected
        ? appColors.neutral.shade900
        : appColors.primary.shade400;

    final borderRadius = BorderRadius.circular(16);

    return Material(
      color: bgColor,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: () {
          if (value != null && onChanged != null) {
            onChanged!(value!);
          }
        },
        borderRadius: borderRadius,
        child: Container(
          padding:
              paddingInsets ??
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: !isSelected
                ? Border.all(color: AppColors.neutral300)
                : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: context.semiBold.copyWith(color: foregroundColor),
                ),
              ),
              const SizedBox(width: 12),
              _AnimatedAppRadioIcon(
                isSelected: isSelected,
                iconColor: foregroundColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedAppRadioIcon extends StatefulWidget {
  const _AnimatedAppRadioIcon({
    required this.isSelected,
    required this.iconColor,
  });

  final bool isSelected;
  final Color iconColor;

  @override
  State<_AnimatedAppRadioIcon> createState() => _AnimatedAppRadioIconState();
}

class _AnimatedAppRadioIconState extends State<_AnimatedAppRadioIcon>
    with SingleTickerProviderStateMixin {
  static const double _kDiamondAngle = 0.78;

  late final AnimationController _controller;

  late final Animation<double> _fade;
  late final Animation<double> _frameScale;
  late final Animation<double> _diamondRotation;
  late final Animation<double> _dotScale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
      reverseDuration: const Duration(milliseconds: 280),
    );

    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    _frameScale = Tween<double>(begin: 0.35, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeInBack,
      ),
    );

    _diamondRotation = Tween<double>(begin: 0, end: _kDiamondAngle).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.06, 0.78, curve: Curves.easeOutCubic),
        reverseCurve: const Interval(0.06, 0.78, curve: Curves.easeInCubic),
      ),
    );

    _dotScale = Tween<double>(begin: 0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.38, 1.0, curve: Curves.easeOutBack),
        reverseCurve: const Interval(0.38, 1.0, curve: Curves.easeInBack),
      ),
    );

    if (widget.isSelected) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant _AnimatedAppRadioIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected != oldWidget.isSelected) {
      if (widget.isSelected) {
        _controller.forward(from: 0);
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _visible =>
      widget.isSelected || _controller.isAnimating || _controller.value > 0.001;

  @override
  Widget build(BuildContext context) {
    if (!_visible) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: 24,
      height: 24,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fade,
            child: Transform.scale(
              scale: _frameScale.value,
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      border: Border.all(color: widget.iconColor, width: 1.5),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Transform.rotate(
                    angle: _diamondRotation.value,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        border: Border.all(color: widget.iconColor, width: 1.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: _dotScale.value,
                    alignment: Alignment.center,
                    child: Container(
                      width: 7.5,
                      height: 7.5,
                      decoration: BoxDecoration(
                        color: widget.iconColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
