import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moneeb/common/domain/models/enums/user_role_enum.dart';
import 'package:moneeb/core/app_material/material.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/features/authentication/authentication_imports.dart';
import 'package:moneeb/features/omrah/provider/domain/models/enums/omrah_steps_enum.dart';

class OmrahStepsView extends StatelessWidget {
  final OmrahStepsEnum currentStep;
  final void Function(OmrahStepsEnum step) onTap;

  /// Steps whose proof the admin rejected, labeled as such (provider only).
  final Set<OmrahStepsEnum> rejectedSteps;

  /// Steps already proofed. Needed once a rejected step pulls [currentStep]
  /// back, so the steps after it that were done don't read as "not reached".
  final Set<OmrahStepsEnum> proofedSteps;

  const OmrahStepsView({
    super.key,
    required this.currentStep,
    required this.onTap,
    this.rejectedSteps = const {},
    this.proofedSteps = const {},
  });

  @override
  Widget build(BuildContext context) {
    bool isUser =
        AuthenticationBloc.of(context).getUserRole == UserRoleEnum.user;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: OmrahStepsEnum.values.map((step) {
          bool isRejected = rejectedSteps.contains(step);
          bool isNotDone =
              step.index < currentStep.index && !proofedSteps.contains(step);

          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                onTap(step);
              },
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 8,
                      children: [
                        AppSvg(
                          svgPath: step.getSvgIcon(),
                          width: 18,
                          height: 18,
                          color: context.appColors.neutral.shade900,
                        ),

                        Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 2,
                            children: [
                              Text(
                                step.getLocalizedName(),
                                style: context.regular,
                              ),

                              Text(
                                isRejected
                                    ? appLocalizer.proofRejectedStatus
                                    : isNotDone
                                    ? appLocalizer.notReachedYet
                                    : step != currentStep ||
                                          currentStep == OmrahStepsEnum.finished
                                    ? appLocalizer.executedSuccessfully
                                    : appLocalizer.inProgress,
                                style: context.medium.copyWith(
                                  fontSize: 12,
                                  color: isRejected
                                      ? context.appColors.danger.shade400
                                      : isNotDone
                                      ? context.appColors.neutral.shade500
                                      : context.appColors.secondary.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: Center(
                      child: Stack(
                        alignment: currentStep == OmrahStepsEnum.finished
                            ? Alignment.topCenter
                            : Alignment.bottomCenter,
                        clipBehavior: Clip.none,

                        children: [
                          Container(
                            clipBehavior: Clip.none,

                            width: 30,
                            decoration: BoxDecoration(
                              color:
                                  currentStep.index >= step.index &&
                                      currentStep != OmrahStepsEnum.finished
                                  ? AppColors.oliveGreen
                                  : context.appColors.primary.shade400,
                              borderRadius: step.index == 0
                                  ? BorderRadius.only(
                                      topLeft: Radius.circular(99),
                                      topRight: Radius.circular(99),
                                    )
                                  : step.index == 0
                                  ? BorderRadius.only(
                                      bottomRight: Radius.circular(99),
                                      bottomLeft: Radius.circular(99),
                                    )
                                  : null,
                            ),
                          ),

                          if (step == currentStep)
                            DottedBorder(
                              options: CircularDottedBorderOptions(
                                strokeWidth: 4,
                                color: context.appColors.secondary.shade500,
                                dashPattern: [8, 10],
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: context.appColors.primary.shade400,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(14.0),
                                child: AppImage(
                                  width: 38,
                                  height: 38,
                                  path: AssetPaths.kaaba,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 4,
                        children: [
                          if (step.index >= currentStep.index && isUser)
                            AppPrimaryButton(
                              buttonHeight: 32,
                              textStyle: context.semiBold.copyWith(
                                fontSize: 10,
                                color: context.appColors.neutral.shade900,
                              ),
                              trailingWidget: Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  start: 6,
                                ),

                                child: Icon(
                                  Iconsax.eye,
                                  size: 16,
                                  color: context.appColors.neutral.shade900,
                                ),
                              ),
                              text: appLocalizer.verification,

                              // iconData:,
                              onPressed: () {
                                onTap(step);
                              },
                            ),
                          /* Container(
                              decoration: BoxDecoration(
                                color: AppColors.primary500,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(8),
                              child: Icon(
                                Iconsax.eye,
                                size: 14,
                                color: AppColors.neutral100,
                              ),
                            ), */

                          /*  Icon(
                            Icons.arrow_forward,
                            size: 18,
                          ), */
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
