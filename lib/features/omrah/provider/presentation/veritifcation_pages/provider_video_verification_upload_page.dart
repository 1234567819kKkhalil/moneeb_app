import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moneeb/core/app_material/material.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/base/media_utils/media_utils.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/features/omrah/provider/domain/models/enums/omrah_steps_enum.dart';
import 'package:moneeb/features/omrah/provider/presentation/manager/provider_omrah_cubit/provider_omrah_cubit.dart';
import 'package:moneeb/features/omrah/provider/presentation/provider_omrah_page.dart';
import 'package:moneeb/features/omrah/provider/presentation/widgets/for_whom_card.dart';
import 'package:moneeb/features/omrah/provider/presentation/widgets/rejected_proof_card.dart';
import 'package:moneeb/features/omrah/provider/presentation/widgets/voice_documentation_card.dart';

class ProviderVideoVerificationUploadPage extends StatelessWidget {
  final ProviderOmrahCubit omrahCubitRef;
  final OmrahStepsEnum stepType;
  const ProviderVideoVerificationUploadPage({super.key, required this.omrahCubitRef, required this.stepType});

  static const String routeName = 'ProviderVideoVerificationUploadPage';

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: omrahCubitRef,
      child: _ProviderVideoVerificationUploadBody(stepType: stepType),
    );
  }
}

class _ProviderVideoVerificationUploadBody extends StatefulWidget {
  final OmrahStepsEnum stepType;
  const _ProviderVideoVerificationUploadBody({super.key, required this.stepType});
  
  @override
  State<_ProviderVideoVerificationUploadBody> createState() => _ProviderVideoVerificationUploadBodyState();
}

class _ProviderVideoVerificationUploadBodyState extends State<_ProviderVideoVerificationUploadBody> {
  Attachment? _video;

  @override
  Widget build(BuildContext context) {
    final forWhom = context.read<ProviderOmrahCubit>().forWhom;

    return BlocListener<ProviderOmrahCubit, ProviderOmrahState>(
      listenWhen: (previous, current) => previous.submitProof != current.submitProof,
      listener: (context, state) {
        if(state.submitProof.isSuccess){
          AppToasts.success(context, message: appLocalizer.videoProofUploadedSuccessfully);

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
          AppToasts.error(context, message: state.submitProof.failure?.errorMessage??'');
        }
      },
      child: Scaffold(
          appBar: AppBars.defaultBar(
            context,
            text: appLocalizer.video,
            useCloseButton: true,
            centerTitle: true,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Scrolls so the recorder keeps a usable height even when the
                  // cards above it (e.g. a rejection reason) take most of the screen.
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                        child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.stepType.videoVerificationText(),
                    style: context.extraBold.copyWith(
                        color: context.appColors.secondary.shade500,
                        fontSize: 12
                    ),
                  ),
              
                  if(widget.stepType == OmrahStepsEnum.tawaf) ...[
                    const SizedBox(height: 8),
                    Text(
                      appLocalizer.prayDuaaTakbeer,
                      style: context.regular.copyWith(
                          fontSize: 12
                      ),
                    ),
                  ],
              
                  Gap(12),
              
                  ForWhomCard(
                    forWhom: forWhom,
                  ),

                  BlocBuilder<ProviderOmrahCubit, ProviderOmrahState>(
                    buildWhen: (previous, current) => previous.omrahStepsData != current.omrahStepsData,
                    builder: (context, state) => RejectedProofCard(
                      step: state.getOmrahStepData(widget.stepType),
                    ),
                  ),

                  const SizedBox(height: 12),

                  VoiceDocumentationCard(
                    stepType: widget.stepType,
                    beneficiaryName: forWhom.beneficiaryName,
                  ),
              
                  const SizedBox(height: 12),

                  SizedBox(
                    height: (constraints.maxHeight * 0.7).clamp(320.0, double.infinity),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Video View
                        Positioned.fill(
                          child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  color: context.appColors.neutral.shade800,
                                  borderRadius: BorderRadius.all(Radius.circular(12))
                              ),
                              child: _video == null
                                  ? Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      MediaPicker.pickVideo(
                                          source: ImageSource.camera,
                                          pickedMediaCallback: (media) {
                                            setState(() {
                                              _video = media;
                                            });
                                          },
                                          pickerVideoProperties: PickerVideoProperties(
                                              ignoreSizeRestrictions: true,
                                              maxRecordDuration: Duration(
                                                  minutes: 10
                                              )
                                          )
                                      );
                                    },
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 20,
                                            color: Colors.black.withOpacity(0.2),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                                 : Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned.fill(
                                      child: VideoView(
                                        item: _video!,
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
                                              _video = null;
                                            });
                                          },
                                          icon: Icon(
                                            Iconsax.trash,
                                            color: context.appColors.danger.shade500,
                                          ),
                                        )
                                    ),

                                    const Positioned(
                                      bottom: 38,
                                      left: 0,
                                      right: 0,
                                      child: _VideoBottomDataOverlay(),
                                    ),

                                    // Moneeb logo
                                    Positioned(
                                      top: 50,
                                      width: 70,
                                      height: 60,
                                      child: Center(
                                        child: AppImage(
                                          path: AssetPaths.moneebLogo,
                                          width: 70,
                                          height: 60,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                          ),
                        ),

                        // The miqat name comes from the backend geofence check, so the
                        // badge only shows once that check has actually passed.
                        if(widget.stepType == OmrahStepsEnum.mekat)
                          BlocBuilder<ProviderOmrahCubit, ProviderOmrahState>(
                            buildWhen: (previous, current) =>
                                previous.miqatName != current.miqatName ||
                                previous.getOmrahStepData(OmrahStepsEnum.mekat).isMapLocationProofed !=
                                    current.getOmrahStepData(OmrahStepsEnum.mekat).isMapLocationProofed,
                            builder: (context, state) {
                              final miqatName = state.miqatName;
                              final isLocationProofed = state
                                  .getOmrahStepData(OmrahStepsEnum.mekat)
                                  .isMapLocationProofed;

                              if (miqatName.isEmpty || !isLocationProofed) {
                                return const SizedBox.shrink();
                              }

                              return Positioned(
                                top: 10,
                                left: 10,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: context.appColors.primary.shade400,
                                    border: Border.all(
                                      color: AppColors.neutral100,
                                      width: 1
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(99))
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xff00A651)
                                        ),
                                        padding: EdgeInsets.all(6),
                                        child: Icon(
                                          Iconsax.location,
                                          color: Colors.white,
                                          size: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        miqatName,
                                        style: context.regular.copyWith(
                                          fontSize: 11,
                                          color: Colors.white,
                                          shadows: [
                                            BoxShadow(
                                              blurRadius: 20,
                                              color: Colors.black.withOpacity(0.4),
                                            ),
                                          ]
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
              
                ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  BlocBuilder<ProviderOmrahCubit, ProviderOmrahState>(
                    buildWhen: (previous, current) => previous.submitProof != current.submitProof,
                    builder: (context, state) {
                      return AppPrimaryButton(
                          isExpanded: true,
                          isLoading: state.submitProof.isLoading,
                          onPressed: _video != null ? () {
                            context.read<ProviderOmrahCubit>().submitStepProof(
                              widget.stepType,
                              _video!,
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

class _VideoBottomDataOverlay extends StatefulWidget {
  const _VideoBottomDataOverlay();

  @override
  State<_VideoBottomDataOverlay> createState() => _VideoBottomDataOverlayState();
}

class _VideoBottomDataOverlayState extends State<_VideoBottomDataOverlay> {
  final currentData = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final forWhom = context.read<ProviderOmrahCubit>().forWhom;

    final goldColor = context.appColors.secondary.shade500;
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 0.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  goldColor.withOpacity(0),
                  goldColor.withOpacity(0.5),
                  goldColor,
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Text(
                appLocalizer.umrahFor(forWhom.beneficiaryName),
                style: context.medium.copyWith(
                  color: AppColors.neutral50,
                  fontSize: 11,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),

              Gap(4),

              Text(
                currentData.toUmrahDate(currentData),
                style: context.regular.copyWith(
                  color: goldColor,
                  fontSize: 10,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 4,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
            height: 0.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  goldColor,
                  goldColor.withOpacity(0.5),
                  goldColor.withOpacity(0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
