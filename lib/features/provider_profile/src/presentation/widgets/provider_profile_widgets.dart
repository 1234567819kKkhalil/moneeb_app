part of provider_profile;

class ProfileHeader extends StatelessWidget {
  final ProviderProfileEntity profile;
  final bool isMyProfile;

  const ProfileHeader({
    super.key,
    required this.profile,
    this.isMyProfile = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.appColors.backgroundColorForProviderCard,
                ),
                child: AppImage(
                  path: isMyProfile
                      ? profile.avatarUrl ?? ""
                      : profile.avatarUrl?.addBaseUrl ?? "",
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(75),
                  border: Border.all(
                    color: context.appColors.primary.shade400,
                    width: 3,
                  ),
                  errorPlaceHolder: () =>
                      Image.asset(AssetPaths.moneebLogo, fit: BoxFit.contain),
                ),
              ),
              if (profile.isVerified)
                PositionedDirectional(
                  top: 10,
                  end: 10,
                  child: SizedBox(
                    width: 26,
                    height: 26,
                    child: SvgPicture.asset(AssetPaths.iconVerifyProfile),
                  ),
                ),
              if (profile.isHafiz)
                PositionedDirectional(
                  bottom: 5,
                  start: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.appColors.primary.shade400,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.appColors.neutral.shade900,
                        width: 2,
                      ),
                    ),
                    // clipBehavior: Clip.antiAlias,
                    child: SizedBox(
                      width: 34,
                      height: 34,
                      child: Image.asset(AssetPaths.hafizIcon),
                    ),
                  ),
                ),
              if (profile.isOnline)
                PositionedDirectional(
                  top: 14,
                  start: 14,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: context.appColors.neutral.shade900,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const Gap(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  profile.fullName,
                  style: context.bold.copyWith(
                    fontSize: 16,
                    color: context.appColors.neutral.shade900,
                  ),
                ),
                const Gap(4),
                Text(
                  profile.username,
                  style: context.medium.copyWith(
                    fontSize: 12,
                    color: context.appColors.neutral.shade900,
                  ),
                ),
              ],
            ),
          ],
        ),
        const Gap(24),
        if (!isMyProfile &&
            context.read<AuthenticationBloc>().getUserRole ==
                UserRoleEnum.user) ...[
          AppPrimaryButton(
            isExpanded: false,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            text: appLocalizer.sendRequest,
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
              NavObserver.instance.changeTab(MainHostPageTabsEnum.requestOmra);
            },
          ),
          const Gap(16),
        ],
        if (profile.bio != null) ...[
          Center(
            child: Text(
              appLocalizer.bio,
              style: context.bold.copyWith(
                fontSize: 14,
                color: context.appColors.secondary.shade500,
              ),
            ),
          ),
          const Gap(12),
          AppReadMoreText(
            text: profile.bio!,
            trimLines: 3,
            textAlign: TextAlign.center,
            addSelectionArea: false,
            textStyle: context.regular.copyWith(
              fontSize: 10,
              color: context.appColors.neutral.shade900,
            ),
            moreAndLessStyle: context.semiBold.copyWith(
              fontSize: 10,
              color: context.appColors.secondary.shade500,
            ),
          ),
        ],
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? iconPath;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95,
      height: 95,
      decoration: BoxDecoration(
        border: Border.all(color: context.appColors.secondary.shade500),
        color: context.appColors.primary.shade400,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: context.medium.copyWith(
                  color: context.appColors.neutral.shade900,
                ),
              ),
              if (iconPath != null) ...[
                const Gap(8),
                SvgPicture.asset(
                  iconPath!,
                  height: 12,
                  width: 12,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ],
          ),
          const Gap(12),
          Text(
            label,
            style: context.medium.copyWith(
              fontSize: 10,
              color: context.appColors.neutral.shade900,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ReviewItemWidget extends StatelessWidget {
  final ProviderReviewEntity review;

  const ReviewItemWidget({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    // Format date as "dd MMM yyyy"
    final formattedDate = intel.DateFormat(
      'dd MMM yyyy',
      injector<LocalizationContainer>().langCode.name,
    ).format(review.createdAt);
    print('requesterName: ${review.requesterName}');
    print('requesterImage: ${review.requesterImage}');
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
                  child: review.requesterImage != null
                      ? AppImage(
                          path: review.requesterImage!.addBaseUrl,
                          height: 40,
                          width: 40,
                          borderRadius: BorderRadius.circular(20),
                        )
                      : Text(
                          review.requesterName?.isNotEmpty ?? false
                              ? review.requesterName![0]
                              : '', // First letter of "مستخدم" (user) as placeholder since we don't have requester details in the model yet
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
                            review.requesterName ??
                                '', // Placeholder since we only have requesterId
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
                    /* Text(
                      formattedDate,
                      style: context.regular.copyWith(
                        fontSize: 10,
                        color: context.appColors.neutral.shade500,
                      ),
                    ), */
                    // const Gap(8),
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
