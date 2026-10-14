part of home;

class RitualsDocumentationSection extends StatelessWidget {
  const RitualsDocumentationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Text(
                appLocalizer.ritualsDocumentation,
                style: context.bold.copyWith(
                  color: context.appColors.neutral.shade900,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Gap(14),
            Skeletonizer(
              enabled: state.listStage.isEmpty,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (
                      int index = 0;
                      index < state.listStage.length;
                      index++
                    ) ...[
                      if (index > 0)
                        RotatedBox(
                          quarterTurns: AppLanguageCubit.isArabic() ? 2 : 0,
                          child: const AppSvg(
                            svgPath: AssetPaths.iconArrowHomeEn,
                          ),
                        ),
                      Expanded(
                        child: RealTrustItem(
                          stage: state.listStage[index],
                          index: index,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
