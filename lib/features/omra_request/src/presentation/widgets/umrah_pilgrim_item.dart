part of omra_request;

class UmrahPilgrimItem extends StatelessWidget {
  final ProviderEntity provider;
  final VoidCallback? onTap;
  final bool changeButtomName;

  const UmrahPilgrimItem({
    super.key,
    required this.provider,
    this.onTap,
    this.changeButtomName = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Stack(
            children: [
              // if (provider.avatarUrl != null)
              AppImage(
                path: provider.avatarUrl?.addBaseUrl ?? '',
                width: 60,
                height: 60,
                borderRadius: BorderRadius.circular(20),
                errorPlaceHolder: () => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: context.appColors.backgroundColorForProviderCard,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    AssetPaths.moneebLogo,
                    fit: BoxFit.contain,
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
              /* else
                Container(
                  width: 60,
                  height: 60,
                  // clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: context.appColors.primary.shade400,
                  ),
                  child: Center(
                    child: Text(
                      provider.fullName.isNotEmpty ? provider.fullName[0] : '?',
                      style: context.semiBold.copyWith(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ) */
              PositionedDirectional(
                bottom: 6,
                end: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  decoration: BoxDecoration(
                    color: context.appColors.neutral.shade400.withOpacity(0.6),
                    borderRadius: const BorderRadiusDirectional.only(
                      topEnd: Radius.circular(6),
                      topStart: Radius.circular(6),
                      bottomStart: Radius.circular(6),
                      // bottomEnd: Radius.circular(0),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(width: 4),
                      Text(
                        provider.totalRating.toStringAsFixed(1),
                        style: context.medium.copyWith(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Iconsax.star1,
                        size: 14,
                        color: context.appColors.secondary.shade500,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 8),
          // Name & username
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.fullName,
                  style: context.medium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.appColors.neutral.shade900,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${provider.executedCount + provider.umrahCount} ${appLocalizer.omra}',
                  style: context.medium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: context.appColors.neutral.shade300,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          // Action button
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: context.appColors.primary.shade400,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                changeButtomName
                    ? appLocalizer.change
                    : appLocalizer.requestOmraNav,
                style: context.medium.copyWith(
                  fontSize: 10,
                  color: context.appColors.neutral.shade900,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
