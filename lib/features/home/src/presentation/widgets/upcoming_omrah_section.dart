part of home;

/// Home card counting down to the nearest accepted umrah, for the requester
/// (how long until it begins) and the provider (when they may start). Tapping
/// it opens the orders tab.
class UpcomingOmrahSection extends StatelessWidget {
  const UpcomingOmrahSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isProvider =
        context.read<AuthenticationBloc>().getUserRole == UserRoleEnum.provider;

    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) =>
          previous.upcomingOmrah != current.upcomingOmrah,
      builder: (context, state) {
        final upcoming = state.upcomingOmrah.data ?? const [];
        if (!state.upcomingOmrah.isSuccess || upcoming.isEmpty) {
          return const SizedBox.shrink();
        }

        final next = upcoming.first;

        return Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    appLocalizer.upcomingOmrah,
                    style: context.bold.copyWith(
                      fontSize: 13,
                      color: context.appColors.secondary.shade500,
                    ),
                  ),
                  if (upcoming.length > 1) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: context.appColors.secondary.shade500,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '+${upcoming.length - 1}',
                        style: context.bold.copyWith(
                          fontSize: 10,
                          color: context.appColors.neutral.shade50,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              OmrahStartCountdownCard(
                targetDate: next.targetDate,
                isProvider: isProvider,
                subtitle: next.beneficiaryName,
                onTap: () =>
                    NavObserver.instance.changeTab(MainHostPageTabsEnum.orders),
              ),
            ],
          ),
        );
      },
    );
  }
}
