part of home;

class LiveSection extends StatelessWidget {
  const LiveSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /* Text(
              appLocalizer.liveFromHaram,
              style: context.bold.copyWith(
                color: context.appColors.neutral.shade900,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(16), */
            Skeletonizer(
              enabled: state.listLives.isEmpty,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: List.generate(
                    state.listLives.isEmpty ? 3 : state.listLives.length,
                    (index) {
                      if (state.listLives.isEmpty) {
                        return LiveHomeItem(
                          live: UserTest(
                            imageUrl: '',
                            name: 'Loading...',
                            rate: '',
                          ),
                        );
                      }
                      UserTest live = state.listLives[index];
                      return LiveHomeItem(live: live);
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
