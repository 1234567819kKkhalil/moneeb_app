import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:moneeb/core/app_material/material.dart';
import 'package:moneeb/core/app_material/src/app_alerts/alerts/add_review_alert/add_review_alert.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/features/authentication/authentication_imports.dart';
import 'package:moneeb/features/my_reviews/my_reviews_imports.dart';
import 'package:moneeb/features/omrah/user/presentation/manager/omrah_review_status_cubit.dart';

class OmrahAddReviewPage extends StatelessWidget {
  const OmrahAddReviewPage({
    super.key,
    required this.orderId,
    this.beneficiaryName,
  });

  static const String routeName = "OmrahAddReviewPage";
  final String orderId;

  /// Name of the person the omrah was performed for. Null when the entry point
  /// has no order data at hand, in which case the sentence drops the "عن ..."
  /// part instead of showing an empty name.
  final String? beneficiaryName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OmrahReviewStatusCubit(
        orderId: orderId,
        currentUserId:
            context.read<AuthenticationBloc>().state.userData.data?.id,
      )..loadMyReview(),
      child: _OmrahAddReviewPageBody(
        orderId: orderId,
        beneficiaryName: beneficiaryName,
      ),
    );
  }
}

class _OmrahAddReviewPageBody extends StatelessWidget {
  const _OmrahAddReviewPageBody({
    required this.orderId,
    required this.beneficiaryName,
  });

  final String orderId;
  final String? beneficiaryName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.defaultBar(
        context,
        useCloseButton: true,
        centerTitle: true,
        text: appLocalizer.omrahConclusion,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    AppImage(
                      width: context.width,
                      path: AssetPaths.kaabaBg,
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    Positioned(
                      top: 16,
                      right: 0,
                      left: 0,
                      child: Center(
                        child: AppImage(
                          path: AssetPaths.moneebLogo,
                          width: 100,
                          height: 55,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Gap(20),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: appLocalizer.endOfJourney,
                    style: context.semiBold.copyWith(
                      fontSize: 16
                    ),
                    children: [
                      TextSpan(text: appLocalizer.omrahWord , style: context.semiBold.copyWith(
                          color: context.appColors.secondary.shade500,
                          fontSize: 16
                      )),
                    ]
                ),
              ),
              Gap(20),
              _CompletionSentence(beneficiaryName: beneficiaryName),
              Gap(12),
              Text(
                appLocalizer.omrahAcceptedSupplication,
                style: context.regular,
                textAlign: TextAlign.center,
              ),
              Gap(24),
              Expanded(
                child: SizedBox(),
              ),
              _RatingAction(orderId: orderId),
              Gap(8),
            ],
          ),
        ),
      ),
    );
  }
}

/// The single rating entry point of an omrah: an invitation to rate while the
/// omrah carries no review, and the rating itself once it does.
///
/// A rating is given once per omrah, so the button does not come back after a
/// review lands — not on this visit, and not after the app is reopened.
class _RatingAction extends StatelessWidget {
  const _RatingAction({required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OmrahReviewStatusCubit, OmrahReviewStatusState>(
      builder: (context, state) {
        if (state.isRated) {
          return _SubmittedRating(review: state.review);
        }

        return AppPrimaryButton(
          text: appLocalizer.evaluate,
          isExpanded: true,
          // Hold the button until the rating state is known, so a slow answer
          // cannot be raced into a second review.
          isLoading: state.isChecking,
          onPressed: state.isChecking ? null : () => _openRatingSheet(context),
        );
      },
    );
  }

  void _openRatingSheet(BuildContext context) {
    final statusCubit = context.read<OmrahReviewStatusCubit>();

    AppAlerts.showCustomDialog(
      context,
      widget: AddReviewAlert(
        orderId: orderId,
        onSuccess: (score, comment) {
          statusCubit.onReviewSubmitted(score: score, comment: comment);
        },
      ),
    );
  }
}

/// Read-only view of the rating this omrah already carries.
///
/// [review] is null for an omrah we know was rated on this device but whose
/// review the server has not handed back yet, so the stars are dropped instead
/// of shown at a guessed score.
class _SubmittedRating extends StatelessWidget {
  const _SubmittedRating({required this.review});

  final MyReviewEntity? review;

  @override
  Widget build(BuildContext context) {
    final score = review?.score;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: context.appColors.neutral.shade400.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            appLocalizer.omrahAlreadyRated,
            style: context.semiBold.copyWith(fontSize: 14),
            textAlign: TextAlign.center,
          ),
          if (score != null) ...[
            const Gap(12),
            AppRatingBar(
              initialRating: score.toDouble(),
              ignoreGestures: true,
              itemSize: 28,
            ),
          ],
          const Gap(12),
          Text(
            appLocalizer.omrahRatingOnceOnly,
            style: context.regular.copyWith(
              fontSize: 12,
              color: context.appColors.neutral.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CompletionSentence extends StatelessWidget {
  const _CompletionSentence({required this.beneficiaryName});

  final String? beneficiaryName;

  @override
  Widget build(BuildContext context) {
    final name = beneficiaryName?.trim() ?? '';

    if (name.isEmpty) {
      return Text(
        appLocalizer.omrahCompletionConfirmed,
        style: context.regular,
        textAlign: TextAlign.center,
      );
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: "${appLocalizer.omrahCompletionConfirmedFor} ",
        style: context.regular,
        children: [
          TextSpan(
            text: name,
            style: context.semiBold.copyWith(
              color: context.appColors.secondary.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
