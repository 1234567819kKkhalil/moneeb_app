part of home;

class VideosSection extends StatelessWidget {
  const VideosSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appLocalizer.videos,
              style: context.bold.copyWith(
                color: context.appColors.neutral.shade900,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap(16),
            Skeletonizer(
              enabled: state.listVideos.isEmpty, // Assuming empty means loading for now or check cubit state if available
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: List.generate(
                        state.listVideos.isEmpty ? 5 : state.listVideos.length,
                        (index) {
                          if (state.listVideos.isEmpty) {
                            return VideoHomeItem(
                              video: AppSettings(
                                title: 'Loading...',
                                icon: '',
                              ),
                            );
                          }
                          AppSettings video = state.listVideos[index];
                          return VideoHomeItem(video: video);
                        },
                      ),
                    ),
                  ),
                  const Gap(24),
                  Align(
                    child: Text(
                      appLocalizer.quranQuoteHome,
                      style: context.theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        color: context.appColors.neutral.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

