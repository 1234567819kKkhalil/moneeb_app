part of my_reviews;

class MyReviewItemWidget extends StatelessWidget {
  final MyReviewEntity review;

  const MyReviewItemWidget({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        // color: context.appColors.primary.shade400,
        // borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // "تفاصيل التعليق" button

          // Name

          // Avatar
          _buildAvatar(context),
          const Gap(12),
          Expanded(
            child: Text(
              review.counterpartyName.isNotEmpty
                  ? review.counterpartyName
                  : appLocalizer.userRoleName,
              style: context.bold.copyWith(
                fontSize: 14,
                color: context.appColors.neutral.shade900,
              ),
            ),
          ),
          _buildDetailsButton(context),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return review.counterpartyAvatarUrl.isNotEmpty
        ? AppImage(
            path: review.counterpartyAvatarUrl.addBaseUrl,
            height: 64,
            width: 64,
            borderRadius: BorderRadius.circular(20),
          )
        : CircleAvatar(
            radius: 32,
            backgroundColor: context.appColors.primary.shade100,
            child: Text(
              review.counterpartyName.isNotEmpty
                  ? review.counterpartyName[0]
                  : '?',
              style: context.bold.copyWith(
                color: context.appColors.primary.shade900,
                fontSize: 18,
              ),
            ),
          );
  }

  Widget _buildDetailsButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showReviewDetailsDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: context.appColors.primary.shade400,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          appLocalizer.reviewDetails,
          style: context.bold.copyWith(
            fontSize: 12,
            color: context.appColors.neutral.shade900,
          ),
        ),
      ),
    );
  }

  void _showReviewDetailsDialog(BuildContext context) {
    AppBottomSheets.showAppBottomSheet(
      svgIconColor: context.appColors.neutral.shade50,
      context,
      useCloseButton: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                appLocalizer.mutamerRating,
                style: context.bold.copyWith(
                  fontSize: 14,
                  color: context.appColors.neutral.shade50,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(8),
              Text(
                appLocalizer.rateMutamerDesc,
                style: context.regular.copyWith(
                  fontSize: 12,
                  color: context.appColors.neutral.shade400,
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(20),
              // Stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starIndex = 5 - index;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: SvgPicture.asset(
                      starIndex <= review.score
                          ? AssetPaths.iconStarFill
                          : AssetPaths.iconStarRate,
                      width: 36,
                      height: 36,
                    ),
                  );
                }),
              ),
              const Gap(24),
              // Comment box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.appColors.neutral.shade400.withValues(
                    alpha: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  /*  border: Border.all(
                    color: context.appColors.neutral.shade400,
                    width: 1,
                  ), */
                ),
                child: Text(
                  review.comment.isNotEmpty ? review.comment : appLocalizer.noComment,
                  style: context.regular.copyWith(
                    fontSize: 14,
                    color: context.appColors.neutral.shade50,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
