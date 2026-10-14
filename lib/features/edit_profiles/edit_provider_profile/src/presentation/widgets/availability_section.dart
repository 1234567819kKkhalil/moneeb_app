part of edit_provider_profile;

class AvailabilitySection extends StatelessWidget {
  const AvailabilitySection({super.key, required this.isOnline});
  final bool isOnline;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        decoration: BoxDecoration(
          color: context.appColors.primary.shade400,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          isOnline ? appLocalizer.isAvailable : appLocalizer.isNotAvailable,
          style: context.medium.copyWith(fontSize: 12, color: Colors.white),
        ),
      ),
    );
  }
}
