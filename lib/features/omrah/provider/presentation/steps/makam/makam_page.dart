// TODO(User): makam step is disabled for now, uncomment when needed.
/*
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moneeb/core/app_material/material.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/features/omrah/provider/domain/models/enums/omrah_steps_enum.dart';
import 'package:moneeb/features/omrah/provider/presentation/veritifcation_pages/provider_image_verification_upload_page.dart';
import 'package:moneeb/features/omrah/provider/presentation/veritifcation_pages/provider_video_verification_upload_page.dart';
import 'package:moneeb/features/omrah/provider/presentation/steps/makam/data/repo/makam_data_repository.dart';
import 'package:moneeb/features/omrah/provider/presentation/steps/mekat/data/repo/mekat_data_repository.dart';
import 'package:moneeb/features/omrah/provider/presentation/steps/tawaf/data/repo/tawaf_data_repository.dart';
import 'package:moneeb/features/omrah/provider/presentation/widgets/for_whom_card.dart';
import 'package:moneeb/features/omrah/provider/presentation/widgets/instructions_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneeb/features/omrah/provider/presentation/manager/provider_omrah_cubit/provider_omrah_cubit.dart';
import 'package:moneeb/features/omrah/provider/presentation/widgets/omrah_verification_card.dart';

class MakamPage extends StatelessWidget {
  final ProviderOmrahCubit omrahCubitRef;
  const MakamPage({super.key, required this.omrahCubitRef});

  static const String routeName = "MakamPage";

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: omrahCubitRef,
      child: const _MakamBody(),
    );
  }
}

class _MakamBody extends StatefulWidget {
  const _MakamBody({super.key});

  @override
  State<_MakamBody> createState() => _MakamBodyState();
}

class _MakamBodyState extends State<_MakamBody> {
  final MakamDataRepository _repo = MakamDataRepository();

  @override
  Widget build(BuildContext context) {
    final forWhom = context.read<ProviderOmrahCubit>().forWhom;

    return BlocBuilder<ProviderOmrahCubit, ProviderOmrahState>(
      buildWhen: (previous, current) => previous.omrahStepsData != current.omrahStepsData,
      builder: (context, state) {
        // TODO(User): makam step is disabled for now, uncomment when needed.
        final makamStepData = state.getOmrahStepData(OmrahStepsEnum.makam);
        return Scaffold(
          appBar: AppBars.defaultBar(
            context,
            useCloseButton: true,
            centerTitle: true,
            text: OmrahStepsEnum.makam.getPhaseTitle(),
          ),
          body: SafeArea(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                ForWhomCard(
                  forWhom: forWhom,
                ),

                Gap(12),

                Text(
                  appLocalizer.makamInstructions,
                  style: context.bold.copyWith(
                    color: context.appColors.secondary.shade500,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  appLocalizer.makamInstructionDesc,
                  style: context.regular.copyWith(fontSize: 12),
                ),

                Gap(24),

                ...List.generate(_repo.getMakamData.length, (index) {
                  final item = _repo.getMakamData[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: InstructionsCard(
                      item: item,
                      number: index + 1,
                      // onCompleteTap: () {
                      //   setState(() {
                      //     _repo.selectItem(index);
                      //   });
                      // },
                    ),
                  );
                }),

                Gap(20),

                Text(
                  appLocalizer.documentationTitle,
                  style: context.bold,
                ),

                Gap(16),

                OmrahVerificationCard(
                  title: appLocalizer.makamVerifyFirst,
                  isVerified: makamStepData.proofVideoUrl != null,
                  onTap: () {
                    // if(!_repo.isAllItemsSelected){
                    //   AppToasts.error(context, message: appLocalizer.pleaseCompleteInstructions);
                    //   return;
                    // }

                    AppRouteNavigator.push(
                      context,
                      ProviderVideoVerificationUploadPage.routeName,
                      ProviderVideoVerificationUploadPage(
                        omrahCubitRef: context.read<ProviderOmrahCubit>(),
                        // TODO(User): makam step is disabled for now, uncomment when needed.
                        stepType: OmrahStepsEnum.makam,
                      )
                    );
                  },
                ),

                // Gap(16),
                //
                // OmrahVerificationCard(
                //   title: appLocalizer.makamVerifyImage,
                //   isVerified: makamStepData.proofImageUrl != null,
                //   onTap: () {
                //     AppRouteNavigator.push(
                //       context,
                //       ProviderImageVerificationUploadPage.routeName,
                //       ProviderImageVerificationUploadPage(
                //         omrahCubitRef: context.read<ProviderOmrahCubit>(),
                //         stepType: OmrahStepsEnum.makam,
                //       )
                //     );
                //   },
                // ),

                Gap(16),
              ],
            ),
          ),
        );
      },
    );
  }
}
*/
