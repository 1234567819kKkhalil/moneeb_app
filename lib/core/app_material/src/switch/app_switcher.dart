part of app_material;

class AppSwitcher extends StatefulWidget {
  final bool value;
  final void Function(bool value) onChange;
  final bool applySwitchOffColor;

  const AppSwitcher({
    required this.value,
    required this.onChange,
    super.key,
    this.applySwitchOffColor = false,
  });

  @override
  State<AppSwitcher> createState() => _AppSwitcherState();
}

class _AppSwitcherState extends State<AppSwitcher> {
  bool _isToggled = true;

  @override
  void initState() {
    super.initState();
    _isToggled = widget.value;
  }

  final Throttler throttler = Throttler(milliseconds: 500);

  void _toggleSwitch() {
    throttler.throttle(
      onThrottle: () {
        setState(() {
          _isToggled = !_isToggled;
          widget.onChange(_isToggled);
        });
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    bool isApplySwitchOffColor = widget.applySwitchOffColor && !_isToggled;
    Color switchBgColor = isApplySwitchOffColor ? Colors.transparent : context.appColors.primary.shade300;

    return GestureDetector(
      onTap: () => _toggleSwitch(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 30,
        width: 50,
        alignment: _isToggled ? Alignment.centerRight : Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: switchBgColor,
          border: _isToggled ? null : Border.all(color: context.appColors.primary.shade500 ,width: 2)
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 4),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 22, // Thumb width
          height: 22, // Thumb height
          decoration: BoxDecoration(
            color: _isToggled ? context.appColors.primary.shade100 : context.appColors.primary.shade500,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 3,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
