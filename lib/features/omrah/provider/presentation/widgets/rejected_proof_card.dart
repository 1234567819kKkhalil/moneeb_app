import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/features/omrah/provider/domain/models/omrah/omrah_step_entity.dart';

/// Tells the provider the admin rejected the proof of [step] and why, so he
/// knows what to fix before uploading it again. Renders nothing otherwise.
class RejectedProofCard extends StatelessWidget {
  final OmrahStepEntity step;

  const RejectedProofCard({super.key, required this.step});

  @override
  Widget build(BuildContext context) {
    if (!step.isRejected) return const SizedBox.shrink();

    final dangerColor = context.appColors.danger.shade400;
    final reason = step.rejectionReason?.trim() ?? '';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: dangerColor.withOpacity(0.12),
        border: Border.all(color: dangerColor.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.danger, color: dangerColor, size: 20),
              const Gap(8),
              Expanded(
                child: Text(
                  appLocalizer.stepProofRejected,
                  style: context.bold.copyWith(color: dangerColor, fontSize: 14),
                ),
              ),
            ],
          ),

          if (reason.isNotEmpty) ...[
            const Gap(10),
            Text(
              appLocalizer.rejectionReason,
              style: context.medium.copyWith(
                fontSize: 12,
                color: context.appColors.neutral.shade500,
              ),
            ),
            const Gap(4),
            Text(reason, style: context.semiBold.copyWith(fontSize: 13)),
          ],

          const Gap(10),
          Text(
            appLocalizer.reuploadStepProofHint,
            style: context.regular.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
