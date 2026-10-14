part of edit_provider_profile;

class MyProviderProfilePage extends StatefulWidget {
  static const String routeName = '/my-provider-profile';

  const MyProviderProfilePage({super.key});

  @override
  State<MyProviderProfilePage> createState() => _MyProviderProfilePageState();
}

class _MyProviderProfilePageState extends State<MyProviderProfilePage> {
  late final ProviderProfileCubit _providerProfileCubit =
      injector<ProviderProfileCubit>();

  @override
  void initState() {
    super.initState();
    final userId = context.read<AuthenticationBloc>().state.userData.data?.id;
    if (userId != null && userId.isNotEmpty) {
      _providerProfileCubit.fetchProfile(userId);
    }
  }

  @override
  void dispose() {
    _providerProfileCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<MyReviewsCubit>()..fetchReviews(),
      child: BlocBuilder<AuthenticationBloc, AuthState>(
        builder: (context, state) {
          final AppUserModel userModel =
              state.userData.data ?? AppUserModel.initial();

          final providerData =
              userModel.providerData ??
              ProviderDataEntity(
                isOnline: false,
                isVerified: false,
                totalRating: "0.0",
                executedCount: 0,
                isHafiz: false,
                hafizBadgeEnabled: false,
                umrahCount: 0,
                certificates: [],
              );

          final profile = ProviderProfileEntity(
            userId: userModel.id,
            fullName: userModel.fullName,
            username: userModel.username,
            avatarUrl: userModel.avatarUrl,
            isVerified: providerData.isVerified,
            isOnline: providerData.isOnline,
            isHafiz: providerData.isHafiz,
            hafizBadgeEnabled: providerData.hafizBadgeEnabled,
            bio: providerData.bio,
            totalRating: double.tryParse(providerData.totalRating) ?? 0.0,
            executedCount: providerData.executedCount + providerData.umrahCount,
            introImageUrl: providerData.introImageUrl,
            introVideoUrl: providerData.introVideoUrl,
          );

          return Scaffold(
            backgroundColor: context.appColors.appBackgroundColor,
            appBar: AppBars.defaultBar(
              context,
              text: appLocalizer.profile,
              centerTitle: true,
              useCloseButton: true,
              actions: [
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: context.appColors.neutral.shade900,
                  ),
                  onPressed: () {
                    AppRouteNavigator.push(
                      context,
                      EditProviderProfilePage.routeName,
                      const EditProviderProfilePage(),
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    color: context.appColors.neutral.shade50,
                  ),
                  iconSize: 16,
                ),

                const Gap(12),

                // Spacer(),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(10),
                  AvailabilitySection(isOnline: profile.isOnline),
                  ProfileHeader(profile: profile, isMyProfile: true),

                  const Gap(24),
                  if (profile.introImageUrl != null) ...[
                    Text(
                      appLocalizer.yourProviderImage,
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
                  ],
                  if (profile.introVideoUrl != null) ...[
                    Text(
                      appLocalizer.yourProviderVideo,
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
                          image: AssetImage(AssetPaths.kaaba),
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
                  BlocBuilder<ProviderProfileCubit, ProviderProfileState>(
                    bloc: _providerProfileCubit,
                    builder: (context, profileState) {
                      final executedCount =
                          (profileState.profile.data?.executedCount ?? 0) +
                          (profileState.profile.data?.umrahCount ?? 0);
                      return AppSkeletonizer(
                        isEnabled:
                            profileState.profile.isLoading ||
                            profileState.profile.isInitial,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            StatCard(
                              label: appLocalizer.myRating,
                              value: profile.totalRating.toString(),
                            ),
                            StatCard(
                              label: appLocalizer.myUmrahsExecuted,
                              value: executedCount.toString(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Gap(40),
                  DetailsSection(userModel: userModel),
                  const Gap(40),
                  // الشهادات بقت عند طالب الخدمة / المستخدم بس، مش عند مقدم الخدمة
                  // const MyCertificatesSection(),
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
    return BlocBuilder<MyReviewsCubit, MyReviewsState>(
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
                  context.read<MyReviewsCubit>().fetchReviews();
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
                          ? const MyReviewEntity(
                              id: '',
                              orderId: '',
                              providerId: '',
                              requesterId: '',
                              score: 5,
                              comment: 'appLocalizer.loadingReview',
                              isHidden: false,
                              createdAt: null,
                              counterpartyName: '',
                              counterpartyAvatarUrl: '',
                            )
                          : state.reviews.data![index];
                      return _MyReviewItemWidget(review: review);
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

class _MyReviewItemWidget extends StatelessWidget {
  final MyReviewEntity review;

  const _MyReviewItemWidget({required this.review});

  @override
  Widget build(BuildContext context) {
    // Format date as "dd MMM yyyy"
    // final formattedDate = intel.DateFormat(
    //   'dd MMM yyyy',
    //   'ar',
    // ).format(review.createdAt);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: context.appColors.secondary.shade500,
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: context.appColors.primary.shade100,
                  child: review.counterpartyAvatarUrl.isNotEmpty
                      ? AppImage(
                          path: review.counterpartyAvatarUrl.addBaseUrl,
                          height: 40,
                          width: 40,
                          borderRadius: BorderRadius.circular(20),
                        )
                      : Text(
                          review.counterpartyName.isNotEmpty
                              ? review.counterpartyName[0]
                              : '',
                          style: context.bold.copyWith(
                            color: context.appColors.primary.shade900,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            review.counterpartyName,
                            style: context.bold.copyWith(
                              fontSize: 12,
                              color: context.appColors.neutral.shade900,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '(${review.score.toString()})',
                              style: context.medium.copyWith(
                                fontSize: 12,
                                color: context.appColors.neutral.shade900,
                              ),
                            ),
                            const Gap(4),
                            SvgPicture.asset(
                              AssetPaths.iconStarFill,
                              width: 14,
                              height: 14,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Gap(4),
                    Text(
                      review.comment,
                      style: context.regular.copyWith(
                        fontSize: 10,
                        color: context.appColors.neutral.shade900,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(12),
          Divider(
            color: context.appColors.neutral.shade200,
            thickness: 1,
            height: 1,
          ),
        ],
      ),
    );
  }
}
