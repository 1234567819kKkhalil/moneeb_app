import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moneeb/core/app_material/material.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/base/media_utils/media_utils.dart';
import 'package:moneeb/core/utils/utils_imports.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moneeb/features/omrah/provider/domain/models/enums/omrah_steps_enum.dart';
import 'package:moneeb/features/omrah/provider/domain/models/omrah/omrah_step_entity.dart';
import 'package:moneeb/features/omrah/provider/presentation/manager/provider_omrah_cubit/provider_omrah_cubit.dart';
import 'package:moneeb/features/omrah/provider/presentation/provider_omrah_page.dart';
import 'package:moneeb/features/omrah/provider/presentation/widgets/for_whom_card.dart';
import 'package:moneeb/features/omrah/provider/presentation/widgets/rejected_proof_card.dart';

class ProviderImageVerificationUploadPage extends StatelessWidget {
  final ProviderOmrahCubit omrahCubitRef;
  final OmrahStepsEnum stepType;
  const ProviderImageVerificationUploadPage({super.key, required this.omrahCubitRef, required this.stepType});

  static const String routeName = 'ProviderImageVerificationUploadPage';

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: omrahCubitRef,
      child: _ProviderImageVerificationUploadPageBody(stepType: stepType),
    );
  }
}

class _ProviderImageVerificationUploadPageBody extends StatefulWidget {
  final OmrahStepsEnum stepType;
  const _ProviderImageVerificationUploadPageBody({required this.stepType});

  @override
  State<_ProviderImageVerificationUploadPageBody> createState() => _ProviderImageVerificationUploadPageBodyState();
}

class _ProviderImageVerificationUploadPageBodyState extends State<_ProviderImageVerificationUploadPageBody> {
  Attachment? _image;

  @override
  Widget build(BuildContext context) {
    final forWhom = context.read<ProviderOmrahCubit>().forWhom;

    return BlocListener<ProviderOmrahCubit, ProviderOmrahState>(
      listener: (context, state) {
        if(state.submitProof.isSuccess){
          AppToasts.success(context, message: appLocalizer.imageProofUploadedSuccessfully);

          if(mounted){
            // Not simply the step after this one: re-proofing a rejected step sends the
            // provider back to whichever step still needs a proof.
            final nextStep = state.currentStep.data ?? OmrahStepsEnum.finished;

            AppAlerts.showDecisionDialog(
                context,
                title: appLocalizer.stepDocumentedSuccessfully,
                description: appLocalizer.nextStepIs(nextStep.getLocalizedName()),
                canPop: false,
                svgImagePath: widget.stepType.getSvgIcon(),
                actionButtons: [
                  DecisionButtonModel(
                    title: appLocalizer.nextStep,
                    isPrimary: true,
                    onTap: (_) {
                      AppRouteNavigator.popUntil(context, removeUntil: ProviderOmrahPage.routeName);
                      ProviderOmrahPage.pushToOmrahStep(
                        context: context,
                        step: nextStep,
                      );
                    },
                  ),

                  DecisionButtonModel(
                    title: appLocalizer.back,
                    onTap: (_) {
                      AppRouteNavigator.popUntil(context, removeUntil: ProviderOmrahPage.routeName);
                    },
                  ),
                ]
            );
          }
        } else if(state.submitProof.isFailure){
          AppToasts.error(
              context,
              message: state.submitProof.failure?.errorMessage??'');
        }
      },
      child: Scaffold(
          appBar: AppBars.defaultBar(
            context,
            text: appLocalizer.imageTranslate,
            useCloseButton: true,
            centerTitle: true,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Scrolls so the camera area keeps a usable height even when the
                  // cards above it (e.g. a rejection reason) take most of the screen.
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                        child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ForWhomCard(
                    forWhom: forWhom,
                  ),

                  BlocBuilder<ProviderOmrahCubit, ProviderOmrahState>(
                    buildWhen: (previous, current) => previous.omrahStepsData != current.omrahStepsData,
                    builder: (context, state) => RejectedProofCard(
                      step: state.getOmrahStepData(widget.stepType),
                    ),
                  ),

                  Gap(12),

                  // Welcome Texts
                  Text(
                  appLocalizer.verifyImageTitle,
                    style: context.extraBold.copyWith(
                        color: context.appColors.secondary.shade500
                    ),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    height: (constraints.maxHeight * 0.7).clamp(320.0, double.infinity),
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary200,
                            AppColors.primary300,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary500.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: _image == null
                          ? GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              MediaPicker.pickImage(
                                source: ImageSource.camera,
                                pickedMediaCallback: (media) {
                                  setState(() {
                                    _image = media;
                                  });
                                },
                              );
                            },
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withOpacity(0.15),
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt_rounded,
                                        size: 32,
                                        color: Colors.white,
                                      ),
                                    ),

                                    const SizedBox(height: 16),

                                    // Title
                                    Text(
                                      appLocalizer.takePhoto,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    // Subtitle
                                    Text(
                                      appLocalizer.tapToCaptureImage,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          : Stack(
                            children: [
                              Positioned.fill(
                                child: AppImage(
                                    path: _image!.url,
                                    width: context.width,
                                    height: double.infinity,
                                 ),
                              ),

                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _image = null;
                                    });
                                  },
                                  icon: Icon(
                                    Iconsax.trash,
                                    color: context.appColors.danger.shade500,
                                  ),
                                )
                              )
                            ],
                          )
                    ),
                  ),
                ],
                        ),
                      ),
                    ),
                  ),

                  Gap(16),

                  BlocBuilder<ProviderOmrahCubit, ProviderOmrahState>(
                    buildWhen: (previous, current) => previous.submitProof != current.submitProof,
                    builder: (context, state) {
                      return AppPrimaryButton(
                        isExpanded: true,
                        isLoading: state.submitProof.isLoading,
                        onPressed: _image != null ? () {
                          context.read<ProviderOmrahCubit>().submitStepProof(
                            widget.stepType,
                            _image!
                          );
                        } : null,
                        text:appLocalizer.send
                      );
                    },
                  )

                ],
              ),
            ),
          ),
        ),
    );
  }
}
