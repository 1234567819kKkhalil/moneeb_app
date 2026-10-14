part of edit_provider_profile;

class AvailabilitySwitcher extends StatelessWidget {
  const AvailabilitySwitcher({
    super.key,
    required this.isOnline,
    required this.onChanged,
  });
  final bool isOnline;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: context.appColors.primary.shade400,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Text(
                isOnline
                    ? appLocalizer.isAvailable
                    : appLocalizer.isNotAvailable,
                style: context.medium.copyWith(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              Switch(
                value: isOnline,
                activeColor: context.appColors.secondary.shade500,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
        if (!isOnline) ...[
          const Gap(8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: context.appColors.danger.shade500,
                  size: 16,
                ),
                const Gap(6),
                Expanded(
                  child: Text(
                    appLocalizer.offlineVisibilityWarning,
                    style: context.regular.copyWith(
                      fontSize: 12,
                      color: context.appColors.danger.shade500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
