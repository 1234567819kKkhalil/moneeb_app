part of auth;

/// Segmented email/phone switch shared by the OTP login form and any other
/// screen that looks a user up by either contact (e.g. tazkiyah search).
class IdentifierTypeToggle extends StatelessWidget {
  final LoginInputType selected;
  final ValueChanged<LoginInputType> onChanged;

  const IdentifierTypeToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.appColors.primary.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _segment(context, LoginInputType.email, appLocalizer.emailTabLabel),
          _segment(context, LoginInputType.phone, appLocalizer.phoneTabLabel),
        ],
      ),
    );
  }

  Widget _segment(BuildContext context, LoginInputType type, String label) {
    final bool isSelected = selected == type;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? context.appColors.primary.shade400
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: context.semiBold.copyWith(
              color: isSelected
                  ? context.appColors.neutral.shade900
                  : context.appColors.neutral.shade400,
            ),
          ),
        ),
      ),
    );
  }
}
