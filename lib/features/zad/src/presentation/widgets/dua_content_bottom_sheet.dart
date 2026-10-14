part of zad;

class DuaContentBottomSheet extends StatelessWidget {
  final DuaModel dua;

  const DuaContentBottomSheet({super.key, required this.dua});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 24),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
          Text(
            dua.localizedTitle,
            style: context.semiBold.copyWith(
              fontSize: Dimensions.xxLarge,
              color: context.appColors.secondary.shade500,
            ),
          ),
          const SizedBox(height: PaddingDimensions.small),
          Text(
            dua.localizedSubtitle?.isNotEmpty ?? false
                ? dua.localizedSubtitle!
                : appLocalizer.repeatTheseAzkarWithHumilityAndSincerityToGod,
            style: context.regular.copyWith(
              fontSize: Dimensions.normal,
              color: context.appColors.neutral.shade500,
            ),
          ),
          Gap(16),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.appColors.primary.shade500.withValues(
                  alpha: 0.5,
                ),
                borderRadius: BorderRadius.circular(Dimensions.largeRadius),
              ),
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: PaddingDimensions.normal,
                  vertical: PaddingDimensions.large,
                ),
                child: Text(
                  dua.localizedContent,
                  style: context.regular.copyWith(
                    fontSize: Dimensions.large,
                    color: context.appColors.neutral.shade900,
                    height: 1.6,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
