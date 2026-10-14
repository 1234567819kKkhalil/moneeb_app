part of provider_profile;

class ProviderProfilePage extends StatefulWidget {
  static const String routeName = '/provider-profile';

  final String providerId;

  const ProviderProfilePage({super.key, required this.providerId});

  @override
  State<ProviderProfilePage> createState() => _ProviderProfilePageState();
}

class _ProviderProfilePageState extends State<ProviderProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProviderProfileCubit>().fetchProfile(widget.providerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.appBackgroundColor,
      appBar: AppBars.defaultBar(
        context,
        text: appLocalizer.profile,
        centerTitle: true,
        appBarCloseIconType: AppBarCloseIconType.backArrow,
        // closeIconColor: context.appColors.neutral.shade900,
        useCloseButton: true,
        actions: [
          /* IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(AssetPaths.iconEditUserProfile),
          ), */
          IconButton(
            onPressed: () {
              final profile = context
                  .read<ProviderProfileCubit>()
                  .state
                  .profile
                  .data;
              if (profile == null) return;
              final message = appLocalizer.shareProviderProfile(
                profile.fullName,
                profile.username,
              );
              ShareUtils.shareText(
                text: "$message\n\n${Constants.appWebsiteLink}",
                context: context,
              );
            },
            icon: SvgPicture.asset(AssetPaths.iconShareProfile),
          ),
          const Gap(12),
        ],
      ),
      body: BlocBuilder<ProviderProfileCubit, ProviderProfileState>(
        builder: (context, state) {
          final profile = state.profile.data ?? ProviderProfileModel.initial();
          final authUser = context
              .watch<AuthenticationBloc>()
              .state
              .userData
              .data;
          final isOwnProfile = authUser?.id == widget.providerId;
          final executedCount = profile.executedCount + profile.umrahCount;

          return AppSkeletonizer(
            // isEnabled: true,
            isEnabled: state.profile.isLoading,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(20),
                  ProfileHeader(profile: profile),
                  const Gap(24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StatCard(
                        label: isOwnProfile
                            ? appLocalizer.myRating
                            : appLocalizer.hisRating,
                        value: profile.totalRating.toString(),
                      ),
                      StatCard(
                        label: isOwnProfile
                            ? appLocalizer.myUmrahsExecuted
                            : appLocalizer.hisUmrahsExecuted,
                        value: executedCount.toString(),
                      ),
                    ],
                  ),
                  // const Gap(24),
                  /*  if (profile.introImageUrl != null) ...[
                    Text(
                      appLocalizer.providerImage,
                      style: context.bold.copyWith(
                        fontSize: 14,
                        color: context.appColors.neutral.shade50,
                      ),
                    ),
                    const Gap(24),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: AppImage(
                        path: profile.introImageUrl ?? '',
                        width: double.infinity,
                        height: 180,
                      ),
                    ),
                    const Gap(24),
                  ], */
                  if (profile.introVideoUrl != null) ...[
                    Text(
                      appLocalizer.providerVideo,
                      style: context.bold.copyWith(
                        fontSize: 14,
                        color: context.appColors.neutral.shade50,
                      ),
                    ),
                    const Gap(24),
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: AssetImage(
                            AssetPaths.kaaba,
                          ), // Using Kaaba as placeholder for background
                          fit: BoxFit.cover,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: SvgPicture.asset(AssetPaths.iconPlayVideo),
                      ),
                    ),
                    const Gap(24),
                  ],
                  const Gap(40),

                  _buildReviewsSection(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildReviewsSection(BuildContext context) {
    return BlocBuilder<ProviderProfileCubit, ProviderProfileState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: Text(
                appLocalizer.reviews,
                style: context.bold.copyWith(
                  fontSize: 14,
                  color: context.appColors.secondary.shade500,
                ),
              ),
            ),
            const Gap(16),
            if (state.reviews.isFailure)
              FailureWidget(
                failure: state.reviews.failure,
                onRetryPressed: () {
                  context.read<ProviderProfileCubit>().fetchReviews(
                    widget.providerId,
                  );
                },
              )
            else if (state.reviews.isSuccess &&
                (state.reviews.data?.isEmpty ?? true))
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: NoItemsFoundWidget(
                  text: appLocalizer.noReviewsYet,
                  enableRefreshSupport: false,
                ),
              )
            else
              AppSkeletonizer(
                isEnabled: state.reviews.isLoading || state.reviews.isInitial,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: context.appColors.primary.shade400,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: context.appColors.secondary.shade500,
                      width: 1,
                    ),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount:
                        state.reviews.isLoading || state.reviews.isInitial
                        ? 3
                        : (state.reviews.data?.length ?? 0),
                    itemBuilder: (context, index) {
                      final review =
                          state.reviews.isLoading || state.reviews.isInitial
                          ? ProviderReviewModel.initial()
                          : state.reviews.data![index];
                      return ReviewItemWidget(review: review);
                    },
                  ),
                ),
              ),
            const Gap(40),
          ],
        );
      },
    );
  }
}
