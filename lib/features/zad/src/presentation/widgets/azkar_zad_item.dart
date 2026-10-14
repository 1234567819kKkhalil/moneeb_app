part of zad;

class AzkarZadItem extends StatelessWidget {
  final AzkarSectionModel data;

  const AzkarZadItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppBottomSheets.showAppBottomSheet(
          context,
          // showContainerColor: true,
          useCloseButton: false,
          backgroundColor: context.appColors.primary.shade300,

          builder: (context) {
            return AzkarContentBottomSheet(
              slug: data.slug,
              title: data.localizedName,
              subtitle: data.localizedSubtitle,
            );
          },
        );
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: context.appColors.primary.shade400,
          border: Border.all(
            width: 1.5,
            color: context.appColors.secondary.shade500,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(5),
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: context.appColors.secondary.shade500.withAlpha(80),
                shape: BoxShape.circle,
              ),
              child: data.iconUrl?.addBaseUrl.endsWith('.svg') ?? false
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: SvgPicture.network(
                        data.iconUrl?.addBaseUrl ?? '',
                        width: 35,
                        height: 35,
                        fit: BoxFit.cover,
                      ),
                    )
                  : AppImage(
                      path: data.iconUrl?.addBaseUrl ?? '',
                      width: 35,
                      height: 35,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(20),
                    ),
            ),
            const SizedBox(height: 12),
            Text(
              data.localizedName,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: context.appColors.neutral.shade900,
                fontWeight: FontWeight.bold,
                fontSize: 8,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  appLocalizer.details,
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    color: context.appColors.neutral.shade900,
                    fontWeight: FontWeight.bold,
                    fontSize: 6,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 8,
                  color: context.appColors.secondary.shade500,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
