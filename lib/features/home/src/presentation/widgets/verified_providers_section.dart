part of home;

class VerifiedProvidersSection extends StatelessWidget {
  const VerifiedProvidersSection({super.key});

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
                      appLocalizer.trustedPilgrims,
                      style: context.bold.copyWith(
                        color: context.appColors.neutral.shade900,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                /*  TextButton(
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
              isEnabled: state.verifiedProviders.isLoading,
              child: SizedBox(
                height: 104,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final provider = state.verifiedProviders.isLoading
                        ? ProviderModel.initial()
                        : state.verifiedProviders.data![index];
                    return ProviderCardItem(provider: provider);
                  },
                  separatorBuilder: (context, index) {
                    return const Gap(12);
                  },
                  itemCount: state.verifiedProviders.isLoading
                      ? 5
                      : (state.verifiedProviders.data?.length ?? 0),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
