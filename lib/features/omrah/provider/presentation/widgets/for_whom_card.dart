import 'package:flutter/material.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/features/home/src/domain/entities/omrah_stepper_entity.dart';

class ForWhomCard extends StatelessWidget {
  final ForWhomEntity forWhom;

  const ForWhomCard({
    super.key,
    required this.forWhom,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            AppColors.primary400,
            AppColors.primary500,
          ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${forWhom.beneficiaryType.toLocalizedName()} : ",
            style: context.bold.copyWith(
              fontSize: 12,
              color: context.appColors.secondary.shade400,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            forWhom.beneficiaryName,
            style: context.semiBold.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}