part of home;

class TrustedPilgrimsSection extends StatelessWidget {
  const TrustedPilgrimsSection({super.key});

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
                    appLocalizer.trustedPilgrims,
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
                    ],
                  ),
                ),
              ],
            ),
            const Gap(8),
            Skeletonizer(
              enabled: state.listLives.isEmpty,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: List.generate(
                    state.listLives.isEmpty ? 5 : state.listLives.length,
                    (index) {
                      if (state.listLives.isEmpty) {
                        return TrustworthyPilgrimItem(
                          user: UserTest(
                            imageUrl: '',
                            name: 'Loading...',
                            rate: '0.0',
                          ),
                        );
                      }
                      UserTest user = state.listLives[index];
                      return TrustworthyPilgrimItem(user: user);
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

