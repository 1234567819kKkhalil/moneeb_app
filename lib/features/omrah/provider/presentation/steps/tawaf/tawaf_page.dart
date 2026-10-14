import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:moneeb/core/app_material/material.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/features/omrah/provider/domain/models/enums/omrah_steps_enum.dart';
import 'package:moneeb/features/omrah/provider/presentation/steps/mekat/data/repo/mekat_data_repository.dart';
import 'package:moneeb/features/omrah/provider/presentation/steps/tawaf/data/repo/tawaf_data_repository.dart';
import 'package:moneeb/features/omrah/provider/presentation/veritifcation_pages/provider_video_verification_upload_page.dart';
import 'package:moneeb/features/omrah/provider/presentation/widgets/for_whom_card.dart';
import 'package:moneeb/features/omrah/provider/presentation/widgets/rejected_proof_card.dart';
import 'package:moneeb/features/omrah/provider/presentation/widgets/instructions_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneeb/features/omrah/provider/presentation/manager/provider_omrah_cubit/provider_omrah_cubit.dart';
import 'package:moneeb/features/omrah/provider/presentation/widgets/omrah_verification_card.dart';

class TawafPage extends StatelessWidget {
  final ProviderOmrahCubit omrahCubitRef;

  const TawafPage({super.key, required this.omrahCubitRef});

  static const String routeName = "TawafPage";

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: omrahCubitRef,
      child: const _TawafBody(),
    );
  }
}

class _TawafBody extends StatefulWidget {
  const _TawafBody({super.key});

  @override
  State<_TawafBody> createState() => _TawafBodyState();
}

class _TawafBodyState extends State<_TawafBody> {
  final TawafDataRepository _repo = TawafDataRepository();

  @override
  Widget build(BuildContext context) {
    final forWhom = context.read<ProviderOmrahCubit>().forWhom;

    return Scaffold(
      appBar: AppBars.defaultBar(
        context,
        useCloseButton: true,
        centerTitle: true,
        text: OmrahStepsEnum.tawaf.getPhaseTitle(),
      ),
      body: BlocBuilder<ProviderOmrahCubit, ProviderOmrahState>(
        builder: (context, state) {
          final tawafStepData = state.getOmrahStepData(OmrahStepsEnum.tawaf);

          return SafeArea(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                ForWhomCard(
                  forWhom: forWhom,
                ),

                RejectedProofCard(step: tawafStepData),

                Gap(12),

                Text(
                  appLocalizer.tawafInstructions,
                  style: context.bold.copyWith(
                    color: context.appColors.secondary.shade500,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  appLocalizer.pleaseReadInstructionsCarefully,
                  style: context.regular.copyWith(fontSize: 12),
                ),

                Gap(24),

                ...List.generate(_repo.getTawafData.length, (index) {
                  final item = _repo.getTawafData[index];
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
                          message: appLocalizer.locationNotValidForTawaf
                        );
                      }
                    }
                  },
                  builder: (context, state) {
                    return OmrahVerificationCard(
                      title: appLocalizer.tawafVerifyInsideHaram,
                      isVerified: tawafStepData.isMapLocationProofed,
                      isLoading : state.validateMapLocation.isLoading,
                      onTap: () {
                        // if(!_repo.isAllItemsSelected){
                        //   AppToasts.error(context, message: appLocalizer.pleaseCompleteInstructions);
                        //   return;
                        // }

                        context.read<ProviderOmrahCubit>().validateTawaf();

                        // AppRouteNavigator.push(
                        //   context,
                        //   MapPage.routeName,
                        //   MapPage(
                        //     omrahCubitRef: context.read<ProviderOmrahCubit>(),
                        //     stepType: OmrahStepsEnum.tawaf,
                        //   ),
                        // );
                      },
                    );
                  },
                ),

                Gap(16),

                OmrahVerificationCard(
                  title: appLocalizer.tawafVerifyDuaa,
                  isVerified: tawafStepData.hasAcceptedVideoProof,
                  onTap: () {
                    // if(!_repo.isAllItemsSelected){
                    //   AppToasts.error(context, message: appLocalizer.pleaseCompleteInstructions);
                    //   return;
                    // }

                    // A rejected step proofs its location again before the new upload.
                    if (tawafStepData.isMapLocationProofed) {
                      AppRouteNavigator.push(
                          context,
                          ProviderVideoVerificationUploadPage.routeName,
                          ProviderVideoVerificationUploadPage(
                            omrahCubitRef: context.read<ProviderOmrahCubit>(),
                            stepType: OmrahStepsEnum.tawaf,
                          )
                      );
                    } else {
                      AppToasts.error(
                          context, message: appLocalizer.pleaseVerifyMapFirst);
                    }
                  },
                ),

                Gap(16),
              ],
            ),
          );
        },
      ),
    );
  }
}
