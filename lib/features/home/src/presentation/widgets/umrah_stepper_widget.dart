part of home;

/// Enum representing the status of each Umrah step
enum UmrahStepStatus {
  /// Step completed successfully
  completed,

  /// Step currently in progress
  inProgress,

  /// Step not yet reached
  notReached,

  /// Umrah finished
  finished,
}

/// Custom horizontal stepper widget for Umrah stages
/// Displays steps in RTL order with icons, arrows, and status indicators
class UmrahStepperWidget extends StatelessWidget {
  final OmrahStepsEnum currentStep;
  final ForWhomEntity forWhom;

  const UmrahStepperWidget({
    super.key,
    required this.currentStep,
    required this.forWhom,
  });

  UmrahStepStatus _getStepStatus(OmrahStepsEnum step) {
    if (currentStep == OmrahStepsEnum.finished) {
      return UmrahStepStatus.finished;
    }

    // Remember: enum order is finished(0), tahalol(1), safa_and_marwa(2), makam(3), tawaf(4), mekat(5)
    // Higher index = earlier step. So completed means step.index > currentStep.index
    if (step.index > currentStep.index) {
      return UmrahStepStatus.completed;
    } else if (step.index == currentStep.index) {
      return UmrahStepStatus.inProgress;
    } else {
      return UmrahStepStatus.notReached;
    }
  }

  String _getStatusText(UmrahStepStatus status) {
    switch (status) {
      case UmrahStepStatus.completed:
      case UmrahStepStatus.finished:
        return appLocalizer.completedStatus;
      case UmrahStepStatus.inProgress:
        return appLocalizer.inProgressStatus;
      case UmrahStepStatus.notReached:
        return appLocalizer.notReachedStatus;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Steps in display order (RTL: right to left)
    // mekat -> tawaf -> makam -> safa_and_marwa -> tahalol -> finished
    final steps = [
      OmrahStepsEnum.mekat,
      OmrahStepsEnum.tawaf,
      // TODO(User): makam step is disabled for now, uncomment when needed.
      // OmrahStepsEnum.makam,
      OmrahStepsEnum.safa_and_marwa,
      OmrahStepsEnum.tahalol,
      OmrahStepsEnum.finished,
    ];

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsetsDirectional.only(
        start: 10,
        end: 0,
        top: 10,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: context.appColors.primary.shade400.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.appColors.secondary.shade500.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Title with icon
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const AppSvg(
                svgPath: AssetPaths.iconUmrah,
                width: 28,
                height: 28,
              ),
              const SizedBox(width: 8),
              Text(
                appLocalizer.umrahTracking,
                style: context.bold.copyWith(
                  color: context.appColors.neutral.shade900,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${forWhom.beneficiaryName})',
                style: context.bold.copyWith(
                  color: context.appColors.neutral.shade900,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Horizontal stepper — fills the card's full width, each step
          // getting an equal share so there's breathing room between them.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (
                int stepIndex = 0;
                stepIndex < steps.length;
                stepIndex++
              ) ...[
                if (stepIndex > 0) _buildArrow(context),
                Expanded(
                  child: _UmrahStepItem(
                    step: steps[stepIndex],
                    status: _getStepStatus(steps[stepIndex]),
                    statusText: _getStatusText(
                      _getStepStatus(steps[stepIndex]),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildArrow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: RotatedBox(
        quarterTurns: AppLanguageCubit.isArabic() ? 2 : 0,
        child: AppSvg(
          svgPath: AssetPaths.iconArrowUmarhEn,
          // width: 14,
          // height: 14,
        ),
      ),
    );
  }
}

class _UmrahStepItem extends StatelessWidget {
  final OmrahStepsEnum step;
  final UmrahStepStatus status;
  final String statusText;

  const _UmrahStepItem({
    required this.step,
    required this.status,
    required this.statusText,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = status == UmrahStepStatus.inProgress;
    final isCompleted =
        status == UmrahStepStatus.completed ||
        status == UmrahStepStatus.finished;

    final double circleSize = isActive ? 36 : 32;
    final double iconSize = 15;

    // Border color based on status
    Color borderColor;
    if (isActive) {
      borderColor = context.appColors.secondary.shade500;
    } else if (isCompleted) {
      borderColor = context.appColors.secondary.shade500.withValues(alpha: 0.4);
    } else {
      borderColor = context.appColors.neutral.shade50.withValues(alpha: 0.15);
    }

    // Circle background
    Color circleBg;
    if (isActive) {
      circleBg = context.appColors.secondary.shade500.withValues(alpha: 0.15);
    } else {
      if (isCompleted) {
        circleBg = context.appColors.secondary.shade500;
      } else {
        circleBg = context.appColors.neutral.shade50.withValues(alpha: 0.08);
      }
    }

    // Icon color
    Color iconColor;
    if (isActive) {
      iconColor = context.appColors.secondary.shade500;
    } else if (isCompleted) {
      iconColor = context.appColors.neutral.shade900;
    } else {
      iconColor = context.appColors.neutral.shade900.withValues(alpha: 0.5);
    }

    // Status text color
    Color statusColor;
    if (isActive) {
      statusColor = context.appColors.secondary.shade500;
    } else if (isCompleted) {
      statusColor = context.appColors.success.shade500;
    } else {
      statusColor = context.appColors.neutral.shade900.withValues(alpha: 0.4);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Circle with icon
        AnimatedContainer(
          margin: EdgeInsets.only(top: isActive ? 0 : 4),
          duration: const Duration(milliseconds: 300),
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: circleBg,
            border: Border.all(color: borderColor, width: isActive ? 2.5 : 1.5),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: context.appColors.secondary.shade500.withValues(
                        alpha: 0.3,
                      ),
                      blurRadius: 2,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: AppSvg(
              svgPath: step.getSvgIcon(),
              width: iconSize,
              height: iconSize,
              color: iconColor,
            ),
          ),
        ),
        const SizedBox(height: 6),

        // Step name — the "finished" step uses a shorter label here only;
        // getLocalizedName()'s full "أنتهاء العمرة" is used elsewhere
        // (e.g. verification upload pages' "next step is ..." phrasing).
        Text(
          step == OmrahStepsEnum.finished
              ? appLocalizer.umrahTrackingFinishedStep
              : step.getLocalizedName(),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: context.theme.textTheme.bodyMedium?.copyWith(
            fontSize: 9,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive
                ? context.appColors.neutral.shade900
                : context.appColors.neutral.shade900.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 1),

        // Status text
        Text(
          statusText,
          textAlign: TextAlign.center,
          style: context.theme.textTheme.bodySmall?.copyWith(
            fontSize: 8,
            fontWeight: FontWeight.w500,
            color: statusColor,
          ),
        ),
      ],
    );
  }
}
