part of home;

class AzkarSection extends StatelessWidget {
  const AzkarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    appLocalizer.dailyApps,
                    style: context.bold.copyWith(
                      color: context.appColors.neutral.shade900,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        appLocalizer.more,
                        style: context.theme.textTheme.bodyMedium?.copyWith(
                          color: context.appColors.neutral.shade900,
                        ),
                      ),
                      const SizedBox(width: 6),
                      // AppSvg(svgPath: 'assets/icons/arrow_more.svg'),
                    ],
                  ),
                ),
              ],
            ),
            Skeletonizer(
              enabled: state.azkars.isEmpty,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: List.generate(
                    state.azkars.isEmpty ? 4 : state.azkars.length,
                    (index) {
                      if (state.azkars.isEmpty) {
                        return AzkarHomeItem(
                          zikr: AppSettings(
                            title: 'Loading...',
                          ),
                        );
                      }
                      AppSettings zikr = state.azkars[index];
                      return AzkarHomeItem(zikr: zikr);
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

