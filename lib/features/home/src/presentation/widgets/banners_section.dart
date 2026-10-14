part of home;

class BannersSection extends StatefulWidget {
  const BannersSection({super.key});

  @override
  State<BannersSection> createState() => _BannersSectionState();
}

class _BannersSectionState extends State<BannersSection> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (previous, current) => previous.banners != current.banners,
      builder: (context, state) {
        if (state.banners.isLoading) {
          return AppSkeletonizer(
            isEnabled: true,
            child: _buildBannerContainer(
              context,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(color: Colors.grey.shade300),
              ),
            ),
          );
        }

        if (state.banners.isFailure) {
          return const SizedBox.shrink(); // Hide silently on error to not ruin home
        }

        final banners = state.banners.data;

        if (banners == null || banners.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              CarouselSlider.builder(
                itemCount: banners.length,
                options: CarouselOptions(
                  height: 191,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 5),
                  autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                  enlargeCenterPage: true,
                  viewportFraction: 0.8,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  final banner = banners[index];
                  final imageUrl = banner.mediaType == 'VIDEO'
                      ? banner.thumbnailUrl ?? ''
                      : banner.mediaUrl;

                  return _buildBannerContainer(
                    context,
                    child: GestureDetector(
                      onTap: () {
                        AppRouteNavigator.push(
                          context,
                          BannerPreviewPage.routeName,
                          BannerPreviewPage(banner: banner),
                        );
                      },
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: AppImage(path: imageUrl, fit: BoxFit.cover),
                          ),
                          if (banner.mediaType == 'VIDEO')
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.play_circle_fill_rounded,
                                  color: Colors.white,
                                  size: 48,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              if (banners.length > 1) ...[
                const Gap(12),
                AnimatedSmoothIndicator(
                  activeIndex: _currentIndex,
                  count: banners.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: context.appColors.secondary.shade500,
                    dotColor: context.appColors.neutral.shade300,
                    dotHeight: 6,
                    dotWidth: 6,
                    expansionFactor: 3,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildBannerContainer(BuildContext context, {required Widget child}) {
    return Container(
      height: 191,
      width: double.infinity,
      // margin: EdgeInsets.symmetric(horizontal: 16),
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
      child: child,
    );
  }
}
