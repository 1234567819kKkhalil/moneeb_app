part of home;

class BestProvidersSection extends StatelessWidget {
  const BestProvidersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Gap(12),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      appLocalizer.theBest,
                      style: context.bold.copyWith(
                        color: context.appColors.neutral.shade900,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                /* TextButton(
                  onPressed: () {},
                  child: Text(
                    'المزيد',
                    style: context.theme.textTheme.bodyMedium?.copyWith(
                      color: context.appColors.neutral.shade900,
                    ),
                  ),
                ), */
              ],
            ),
            const Gap(14),
            AppSkeletonizer(
              isEnabled: state.bestProviders.isLoading,
              child: SizedBox(
                height: 104,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final provider = state.bestProviders.isLoading
                        ? ProviderModel.initial()
                        : state.bestProviders.data![index];
                    return ProviderCardItem(provider: provider);
                  },
                  separatorBuilder: (context, index) {
                    return const Gap(12);
                  },
                  itemCount: state.bestProviders.isLoading
                      ? 5
                      : (state.bestProviders.data?.length ?? 0),
                ),
              ),

              /* SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(
                    state.bestProviders.isLoading
                        ? 5
                        : (state.bestProviders.data?.length ?? 0),
                    (index) {
                      final provider = state.bestProviders.isLoading
                          ? ProviderModel.initial()
                          : state.bestProviders.data![index];
                      return ProviderCardItem(provider: provider);
                    },
                  ),
                ),
              ) */
            ),
          ],
        );
      },
    );
  }
}
