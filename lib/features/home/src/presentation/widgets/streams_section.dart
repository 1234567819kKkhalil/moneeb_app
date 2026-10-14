part of home;

class StreamsSection extends StatelessWidget {
  const StreamsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) => previous.streams != current.streams,
      builder: (context, state) {
        if (state.streams.isFailure) {
          return const SizedBox.shrink();
        }

        if (state.streams.isSuccess &&
            (state.streams.data == null || state.streams.data!.isEmpty)) {
          return const SizedBox.shrink();
        }

        final itemsCount = state.streams.isLoading
            ? 3
            : (state.streams.data?.length ?? 0);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(12),
            /* Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                appLocalizer.liveFromHaram,
                style: context.bold.copyWith(
                  color: context.appColors.neutral.shade900,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ), */
            /* const Gap(14), */
            AppSkeletonizer(
              isEnabled: state.streams.isLoading,
              child: SizedBox(
                height: 140,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final stream = state.streams.isLoading
                        ? StreamModel.initial()
                        : state.streams.data![index];
                    return _StreamCardItem(stream: stream);
                  },
                  separatorBuilder: (context, index) => const Gap(12),
                  itemCount: itemsCount,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StreamCardItem extends StatelessWidget {
  final StreamEntity stream;

  const _StreamCardItem({required this.stream});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (stream.linkUrl.isNotEmpty) {
          LaunchUrlUtils.openUrl(context, url: stream.linkUrl);
        }
      },
      child: Container(
        width: 240,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              AppImage(
                path: stream.imageUrl,
                fit: BoxFit.cover,
                errorPlaceHolder: () => Container(
                  color: context.appColors.primary.shade500,
                  child: Center(
                    child: Image.asset(
                      AssetPaths.moneebLogo,
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // Gradient Overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.1),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),

              // Live Indicator Badge
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade600,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        appLocalizer.homeLive,
                        style: context.semiBold.copyWith(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Center Play Icon for action affordance
              const Center(
                child: CircleAvatar(
                  backgroundColor: Colors.white24,
                  radius: 20,
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),

              // Text Overlay
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      stream.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.bold.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    if (stream.description != null &&
                        stream.description!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        stream.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.medium.copyWith(
                          color: Colors.white70,
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
