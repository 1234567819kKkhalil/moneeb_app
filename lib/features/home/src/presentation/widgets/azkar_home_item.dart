part of home;

class AzkarHomeItem extends StatelessWidget {
  final AppSettings zikr;

  const AzkarHomeItem({super.key, required this.zikr});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12, top: 12, bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: zikr.data is Color ? zikr.data as Color : context.appColors.primary.shade500,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        zikr.title,
        style: context.theme.textTheme.bodyMedium?.copyWith(
          color: AppColors.neutral900,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
