import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:moneeb/core/app_material/material.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/utils/utils_imports.dart';

import 'cubit/add_review/add_omrah_review_cubit.dart';

class AddReviewAlert extends StatefulWidget {
  final String orderId;

  /// Called with the submitted rating once the server accepted it, so the
  /// caller can move to its rated state without asking the server again.
  final void Function(double score, String comment)? onSuccess;

  const AddReviewAlert({super.key, required this.orderId, this.onSuccess});

  @override
  State<AddReviewAlert> createState() => _AddReviewAlertState();
}

class _AddReviewAlertState extends State<AddReviewAlert> {
  double score = 5.0;
  final commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddOmrahReviewCubit(widget.orderId),
      child: BlocConsumer<AddOmrahReviewCubit, AddOmrahReviewState>(
        listener: (context, state) {
          if (!context.mounted) return;

          if (state.reviewState.isSuccess) {
            AppRouteNavigator.pop(context);
            widget.onSuccess?.call(score, commentController.text);
            AppToasts.success(context, message: appLocalizer.reviewSentSuccessfully);
          } else if (state.reviewState.isFailure) {
            AppToasts.error(context,
                message: state.reviewState.failure?.errorMessage ?? '');
          }
        },
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                appLocalizer.evaluateOmrah,
                style: context.semiBold.copyWith(fontSize: 18),
              ),
              Gap(24),
              AppRatingBar(
                initialRating: score,
                itemSize: 40,
                onRatingUpdate: (rating) {
                  score = rating;
                },
              ),
              Gap(24),
              AppTextFormField(
                controller: commentController,
                hint: appLocalizer.addYourCommentHere,
                maxLines: 4,
              ),
              Gap(24),

              AppPrimaryButton(
                text: appLocalizer.confirmEvaluation,
                isLoading: state.reviewState.isLoading,
                isExpanded: true,
                onPressed: () {
                  context.read<AddOmrahReviewCubit>().addReview(
                    score: score,
                    comment: commentController.text,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
