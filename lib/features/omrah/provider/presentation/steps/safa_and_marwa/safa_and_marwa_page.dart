import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moneeb/core/app_material/material.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/features/omrah/provider/domain/models/enums/omrah_steps_enum.dart';
import 'package:moneeb/features/omrah/provider/presentation/veritifcation_pages/provider_image_verification_upload_page.dart';
import 'package:moneeb/features/omrah/provider/presentation/veritifcation_pages/provider_video_verification_upload_page.dart';
// import 'package:moneeb/features/omrah/provider/presentation/steps/makam/data/repo/makam_data_repository.dart';
import 'package:moneeb/features/omrah/provider/presentation/steps/mekat/data/repo/mekat_data_repository.dart';
import 'package:moneeb/features/omrah/provider/presentation/steps/safa_and_marwa/data/repo/safa_and_marwa_data_repository.dart';
import 'package:moneeb/features/omrah/provider/presentation/steps/tawaf/data/repo/tawaf_data_repository.dart';
import 'package:moneeb/features/omrah/provider/presentation/widgets/for_whom_card.dart';
import 'package:moneeb/features/omrah/provider/presentation/widgets/rejected_proof_card.dart';
import 'package:moneeb/features/omrah/provider/presentation/widgets/instructions_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneeb/features/omrah/provider/presentation/manager/provider_omrah_cubit/provider_omrah_cubit.dart';
import 'package:moneeb/features/omrah/provider/presentation/widgets/omrah_verification_card.dart';

class SafaAndMarwaPage extends StatelessWidget {
  final ProviderOmrahCubit omrahCubitRef;
  const SafaAndMarwaPage({super.key, required this.omrahCubitRef});

  static const String routeName = "SafaAndMarwaPage";

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: omrahCubitRef,
      child: const _SafaAndMarwaPageBody(),
    );
  }
}

class _SafaAndMarwaPageBody extends StatefulWidget {
  const _SafaAndMarwaPageBody({super.key});

  @override
  State<_SafaAndMarwaPageBody> createState() => __SafaAndMarwaPageBodyState();
}

class __SafaAndMarwaPageBodyState extends State<_SafaAndMarwaPageBody> {
  final SafaAndMarwaDataRepository _repo = SafaAndMarwaDataRepository();

  @override
  Widget build(BuildContext context) {
    final forWhom = context.read<ProviderOmrahCubit>().forWhom;

    return Scaffold(
      appBar: AppBars.defaultBar(
        context,
        useCloseButton: true,
        centerTitle: true,
        text: OmrahStepsEnum.safa_and_marwa.getPhaseTitle(),
      ),
      body: SafeArea(
        child: BlocBuilder<ProviderOmrahCubit, ProviderOmrahState>(
          builder: (context, state) {
            final saiStepData = state.getOmrahStepData(OmrahStepsEnum.safa_and_marwa);

            return ListView(
              padding: EdgeInsets.all(16),
              children: [
                ForWhomCard(
                  forWhom: forWhom,
                ),

                RejectedProofCard(step: saiStepData),

                Gap(12),

                Text(
                  appLocalizer.safaMarwaInstructions,
                  style: context.bold.copyWith(
                    color: context.appColors.secondary.shade500,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  appLocalizer.safaMarwaInstructionDesc,
                  style: context.regular.copyWith(fontSize: 12),
                ),

                Gap(24),

                ...List.generate(_repo.getSafaAndMarwaData.length, (index) {
                  final item = _repo.getSafaAndMarwaData[index];
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

                BlocConsumer<ProviderOmrahCubit, ProviderOmrahState>(
                  listenWhen: (previous, current) => current.validateMapLocation != previous.validateMapLocation,
                  listener: (context, state) {
                    if(state.validateMapLocation.isFailure){
                      AppToasts.error(context, message: state.validateMapLocation.failure?.errorMessage??'');
                    } else if(state.validateMapLocation.isSuccess){
                      final bool isValid = state.validateMapLocation.data ?? false;
                      if(isValid){
                        AppToasts.success(
                          context,
                          message: appLocalizer.locationProofed
                        );
                      } else {
                        AppToasts.error(
                          context,
                          message: appLocalizer.locationNotValidForSai
                        );
                      }
                    }
                  },
                  builder: (context, state) {
                    return OmrahVerificationCard(
                      title: appLocalizer.safaMarwaVerifyInsideMasaa,
                      isVerified: saiStepData.isMapLocationProofed,
                      isLoading : state.validateMapLocation.isLoading,
                      onTap: () {
                        context.read<ProviderOmrahCubit>().validateSai();
                      },
                    );
                  },
                ),

                Gap(16),

                OmrahVerificationCard(
                  title: appLocalizer.safaMarwaVerifyFirst,
                  isVerified: saiStepData.hasAcceptedVideoProof,
                  onTap: () {
                    // if(!_repo.isAllItemsSelected){
                    //   AppToasts.error(context, message: appLocalizer.pleaseCompleteInstructions);
                    //   return;
                    // }

                    // A rejected step proofs its location again before the new upload.
                    if (saiStepData.isMapLocationProofed) {
                      AppRouteNavigator.push(
                        context,
                        ProviderVideoVerificationUploadPage.routeName,
                        ProviderVideoVerificationUploadPage(
                          omrahCubitRef: context.read<ProviderOmrahCubit>(),
                          stepType: OmrahStepsEnum.safa_and_marwa,
                        )
                      );
                    } else {
                      AppToasts.error(
                          context, message: appLocalizer.pleaseVerifyMapFirst);
                    }
                  },
                ),

                // Gap(16),
                //
                // OmrahVerificationCard(
                //   title: appLocalizer.safaMarwaVerifyMap,
                //   onTap: () {
                //     //todo:
                //     AppRouteNavigator.push(
                //       context,
                //       MapPage.routeName,
                //       MapPage(
                //         omrahCubitRef: context.read<ProviderOmrahCubit>(),
                //         stepType: OmrahStepsEnum.safa_and_marwa,
                //       )
                //     );
                //   },
                // ),

                Gap(16),
              ],
            );
          },
        ),
      ),
    );
  }
}
