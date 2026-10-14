import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moneeb/core/app_material/material.dart';
import 'package:moneeb/core/app_material/src/app_loader/ui/custom_loading_widget.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/base/media_utils/media_utils.dart';
import 'package:moneeb/core/ui/helper_widgets/helper_widgets.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:dio/dio.dart';
import 'package:gal/gal.dart';
import 'package:moneeb/features/omrah/provider/domain/models/enums/omrah_steps_enum.dart';
import 'package:moneeb/features/omrah/user/presentation/manager/omrah_inspector_cubit.dart';
import 'package:moneeb/features/omrah/user/presentation/pages/user_omrah_map_inspector_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:moneeb/features/omrah/provider/domain/models/omrah/omrah_step_entity.dart';

class OmrahMediaInspectorPage extends StatelessWidget {
  //already loaded step, passed when coming from the omrah steps view
  final OmrahStepEntity? step;

  //only the step type is known, so the page fetches the step itself [notifications deep linking]
  final OmrahStepsEnum? stepType;

  final String orderId;

  const OmrahMediaInspectorPage({
    super.key,
    required OmrahStepEntity this.step,
    required this.orderId,
  }) : stepType = null;

  const OmrahMediaInspectorPage.byStepType({
    super.key,
    required OmrahStepsEnum this.stepType,
    required this.orderId,
  }) : step = null;

  static const String routeName = "OmrahMediaVerificationPage";

  @override
  Widget build(BuildContext context) {
    final loadedStep = step;

    if (loadedStep != null) {
      return _OmrahMediaInspectorBody(step: loadedStep, orderId: orderId);
    }

    return BlocProvider(
      create: (context) => OmrahInspectorCubit(orderId)..getOmrahStepsStatus(),
      child: BlocBuilder<OmrahInspectorCubit, OmrahInspectorState>(
        buildWhen: (previous, current) =>
            previous.omrahStepsData != current.omrahStepsData ||
            previous.currentStep != current.currentStep,
        builder: (context, state) {
          if (state.omrahStepsData.isSuccess) {
            return _OmrahMediaInspectorBody(
              step: state.getOmrahStepData(stepType!),
              orderId: orderId,
            );
          }

          return Scaffold(
            appBar: AppBars.defaultBar(
              context,
              text: appLocalizer.omrahVerifyStep(
                stepType!.getMinimizedLocalizedName(),
              ),
              centerTitle: true,
              useCloseButton: true,
            ),
            body: SafeArea(
              child: Center(
                child: state.currentStep.isFailure
                    ? FailureWidget(
                        failure: state.currentStep.failure,
                        onRetryPressed: () {
                          context
                              .read<OmrahInspectorCubit>()
                              .getOmrahStepsStatus();
                        },
                      )
                    : const CustomAnimationLoading(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OmrahMediaInspectorBody extends StatefulWidget {
  final OmrahStepEntity step;
  final String orderId;
  const _OmrahMediaInspectorBody({required this.step, required this.orderId});

  @override
  State<_OmrahMediaInspectorBody> createState() =>
      _OmrahMediaInspectorBodyState();
}

class _OmrahMediaInspectorBodyState extends State<_OmrahMediaInspectorBody> {
  bool _isDownloading = false;
  bool _isSharing = false;

  Future<String> _downloadVideoOrImage(String path, bool isImage) async {
    final tempDir = await getTemporaryDirectory();
    final String savePath;

    if (isImage) {
      savePath =
          '${tempDir.path}/omrah_image_${DateTime.now().millisecondsSinceEpoch}.png';
    } else {
      savePath =
          '${tempDir.path}/omrah_video_${DateTime.now().millisecondsSinceEpoch}.mp4';
    }

    await Dio().download(path, savePath);

    if (isImage) {
      await Gal.putImage(savePath, album: "Moneeb");
    } else {
      await Gal.putVideo(savePath, album: "Moneeb");
    }

    return savePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.defaultBar(
        context,
        text: appLocalizer.omrahVerifyStep(
          widget.step.stepType.getMinimizedLocalizedName(),
        ),
        centerTitle: true,
        useCloseButton: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // A rejected proof is still "in progress" for the requester,
              // the rejection details are for the provider only.
              if (widget.step.status.needsProof)
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.clock,
                          size: 64,
                          color: context.appColors.primary.shade500,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          appLocalizer.providerStillDoingStep,
                          style: context.bold.copyWith(
                            color: context.appColors.neutral.shade400,
                          ),
                        ),

                        Gap(20),

                        AppPrimaryButton(
                          text: appLocalizer.trackProviderOnMap,
                          isExpanded: true,
                          leadingWidget: Padding(
                            padding: EdgeInsetsDirectional.only(end: 8.0),
                            child: Icon(
                              Icons.share_location_outlined,
                              size: 20,
                            ),
                          ),
                          onPressed: () {
                            AppRouteNavigator.push(
                              context,
                              UserOmrahMapInspectorPage.routeName,
                              UserOmrahMapInspectorPage(
                                orderId: widget.orderId,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildMediaView()),

                        Gap(16),

                        const _ProofAssuranceSection(),

                        Gap(16),

                        AppPrimaryButton(
                          text: appLocalizer.done,
                          isExpanded: true,
                          onPressed: () {
                            AppRouteNavigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              // Expanded(
              //   child: TabBarSwitcher(
              //     tabBarItems: [
              //       appLocalizer.video,
              //     //  "صورة"
              //     ],
              //     tabBarAttributes: TabBarAttributes.centerMode(),
              //     childrens: [
              //       TabBarPage(
              //         page: Padding(
              //           padding: const EdgeInsets.only(top: 16,bottom: 8),
              //           child: _buildVideoView(),
              //         )
              //       ),
              //       // TabBarPage(
              //       //   page: Padding(
              //       //     padding: const EdgeInsets.only(top: 16,bottom: 8),
              //       //     child: _buildPhotoView(),
              //       //   )
              //       // )
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaView() {
    final hasVideo =
        widget.step.proofVideoUrl != null &&
        widget.step.proofVideoUrl!.isNotEmpty;
    final hasImage =
        widget.step.proofImageUrl != null &&
        widget.step.proofImageUrl!.isNotEmpty;

    if (!hasVideo && !hasImage) {
      return Center(
        child: Text(
          appLocalizer.noVideoFound,
          style: context.bold.copyWith(
            color: context.appColors.neutral.shade400,
          ),
        ),
      );
    }

    final bool isImage = !hasVideo;
    final String mediaPath = isImage
        ? widget.step.proofImageUrl!
        : widget.step.proofVideoUrl!;

    return Container(
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: context.appColors.neutral.shade800,
          width: 1.4,
        ),
      ),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          if (hasVideo)
            VideoView(
              item: Attachment(
                id: widget.step.stepType.name,
                url: widget.step.proofVideoUrl!,
                type: AttachmentTypeEnum.video,
                thumbnail: ThumbnailAttachment(
                  id: '',
                  url: AssetPaths.omrah_video_thumbnail,
                ),
              ),
              autoPlay: true,
              isSingleViewPlay: true,
              loadingWidget: AppSkeletonizer(
                containersColor: context.appColors.neutral.shade800,
                child: SizedBox(
                  width: context.width,
                  height: double.infinity,
                  child: const DecoratedBox(
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                ),
              ),
              width: context.width,
              height: double.infinity,
            )
          else
            SizedBox(
              width: context.width,
              height: double.infinity,
              child: AppImage(
                path: widget.step.proofImageUrl!,
                fit: BoxFit.cover,
                width: context.width,
                height: double.infinity,
              ),
            ),

          Positioned(
            top: 16,
            left: 16,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    if (_isDownloading) return;
                    setState(() => _isDownloading = true);
                    try {
                      await _downloadVideoOrImage(mediaPath, isImage);

                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isImage
                                ? appLocalizer.imageSavedToGallerySuccess
                                : appLocalizer.videoSavedToGallerySuccess,
                          ),
                        ),
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isImage
                                ? appLocalizer.failedToSaveImage
                                : appLocalizer.failedToSaveVideo,
                          ),
                        ),
                      );
                    } finally {
                      if (mounted) {
                        setState(() => _isDownloading = false);
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary500,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: _isDownloading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Iconsax.import, size: 20),
                  ),
                ),
                const Gap(12),
                GestureDetector(
                  onTap: () async {
                    if (_isSharing) return;
                    setState(() => _isSharing = true);
                    try {
                      final String path = await _downloadVideoOrImage(
                        mediaPath,
                        isImage,
                      );

                      if (!context.mounted) return;
                      await Share.shareXFiles(
                        [XFile(path)],
                        text: isImage
                            ? appLocalizer.omrahImageUrlShare
                            : appLocalizer.omrahVideoUrlShare,
                      );
                    } catch (e) {
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isImage
                                ? appLocalizer.failedToShareImage
                                : appLocalizer.failedToShareVideo,
                          ),
                        ),
                      );
                    } finally {
                      if (mounted) {
                        setState(() => _isSharing = false);
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary500,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: _isSharing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.share_outlined, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProofAssuranceSection extends StatelessWidget {
  const _ProofAssuranceSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: context.appColors.primary.shade400,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  appLocalizer.proofGeoFenceVerified,
                  textAlign: TextAlign.center,
                  style: context.semiBold.copyWith(color: Colors.white),
                ),
              ),

              const Gap(8),

              const Icon(Icons.verified_rounded, size: 20, color: Colors.white),
            ],
          ),
        ),

        const Gap(10),

        Text(
          appLocalizer.proofCapturedInsideAppOnly,
          textAlign: TextAlign.center,
          style: context.regular.copyWith(
            color: context.appColors.neutral.shade400,
          ),
        ),
      ],
    );
  }
}
