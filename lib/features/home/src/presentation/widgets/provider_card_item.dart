part of home;

class ProviderCardItem extends StatelessWidget {
  final ProviderEntity provider;

  const ProviderCardItem({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppRouteNavigator.push(
          context,
          ProviderProfilePage.routeName,
          BlocProvider(
            create: (context) => injector<ProviderProfileCubit>(),
            child: ProviderProfilePage(providerId: provider.userId),
          ),
        );
      },
      child: SizedBox(
        // margin: const EdgeInsets.only(left: 12),
        width: 80,
        height: 104,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    // clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: context.appColors.backgroundColorForProviderCard,
                    ),
                    child: AppImage(
                      path: Constants.baseUrl + "${provider.avatarUrl ?? ''}",
                      errorPlaceHolder: () => Padding(
                        padding: const EdgeInsets.all(12),
                        child: Image.asset(
                          AssetPaths.moneebLogo,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    bottom: 6,
                    end: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      decoration: BoxDecoration(
                        color: context.appColors.neutral.shade400.withOpacity(
                          0.6,
                        ),
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
                          const SizedBox(width: 2),
                          Text(
                            provider.totalRating.toStringAsFixed(1),
                            style: context.medium.copyWith(
                              color: Colors.white,
                              fontSize: 6,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            Iconsax.star1,
                            size: 12,
                            color: context.appColors.secondary.shade500,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (provider.isVerified)
                    PositionedDirectional(
                      top: 6,
                      end: 6,
                      child: AppSvg(
                        svgPath: AssetPaths.iconVerify,
                        width: 14,
                        height: 14,
                      ),
                    ),
                ],
              ),
            ),
            // const SizedBox(height: 8),
            Spacer(),
            Text(
              provider.fullName,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.bold.copyWith(
                fontSize: 10,
                color: context.appColors.neutral.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
