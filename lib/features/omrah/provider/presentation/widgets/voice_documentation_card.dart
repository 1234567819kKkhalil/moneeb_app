import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/features/omrah/provider/domain/models/enums/omrah_steps_enum.dart';

/// Shows the provider the exact phrase he has to say out loud while
/// documenting [stepType], with the beneficiary name already filled in.
class VoiceDocumentationCard extends StatelessWidget {
  final OmrahStepsEnum stepType;
  final String beneficiaryName;

  const VoiceDocumentationCard({
    super.key,
    required this.stepType,
    required this.beneficiaryName,
  });

  @override
  Widget build(BuildContext context) {
    final phrase = stepType.voiceDocumentationPhrase(beneficiaryName);
    if (phrase.isEmpty) return const SizedBox.shrink();

    final note = stepType.voiceDocumentationNote();
    final goldColor = context.appColors.secondary.shade500;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF0E2A22), Color(0xFF0B3D2E)],
        ),
        border: Border.all(color: goldColor.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Iconsax.microphone_2, color: goldColor, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  appLocalizer.voiceDocumentationTitle,
                  style: context.bold.copyWith(fontSize: 12, color: goldColor),
                ),
              ),
            ],
          ),

          const Gap(6),

          Text(
            stepType.voiceDocumentationHint(),
            style: context.regular.copyWith(
              fontSize: 11,
              color: Colors.white70,
            ),
          ),

          const Gap(10),

          Text(
            stepType.voiceDocumentationAction(),
            style: context.semiBold.copyWith(fontSize: 11, color: Colors.white),
          ),

          const Gap(6),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '«$phrase»',
              style: context.semiBold.copyWith(
                fontSize: 13,
                color: Colors.white,
                height: 1.6,
              ),
            ),
          ),

          /* if (note != null) ...[
            const Gap(8),
            Text(
              note,
              style: context.regular.copyWith(
            ه    fontSize: 11,
                color: Colors.white70,
              ),
            ),
          ], */
        ],
      ),
    );
  }
}
