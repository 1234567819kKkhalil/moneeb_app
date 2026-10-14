part of auth;

class CompleteProfileCertificationsStep extends StatefulWidget {
  final VoidCallback onBack;

  const CompleteProfileCertificationsStep({super.key, required this.onBack});

  @override
  State<CompleteProfileCertificationsStep> createState() =>
      _CompleteProfileCertificationsStepState();
}

class _CompleteProfileCertificationsStepState
    extends State<CompleteProfileCertificationsStep> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController certificateNameController =
      TextEditingController();
  Attachment? certificatePicture;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  void initState() {
    final userCertificate = AuthenticationBloc.of(
      context,
    ).getUserModel.providerData?.certificates?.firstOrNull;
    final certUrl = userCertificate?.url;

    if (certUrl != null) {
      certificatePicture = Attachment(
        id: RandomId.generate(),
        url: certUrl,
        type: AttachmentTypeEnum.photo,
      );
    }

    if (userCertificate != null) {
      certificateNameController.text = userCertificate.title;
    }

    super.initState();
  }

  @override
  void dispose() {
    certificateNameController.dispose();
    certificatePicture = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<
      ProviderCompleteProfileCubit,
      ProviderCompleteProfileState
    >(
      listenWhen: (previous, current) =>
          previous.sendCertificationsState != current.sendCertificationsState,
      listener: (context, state) {
        if (state.sendCertificationsState.isLoading) {
          AppBlockerLoader.showLoader(context);
        } else {
          AppBlockerLoader.removeLoader();
        }

        if (state.sendCertificationsState.isFailure) {
          AppToasts.error(
            context,
            message: state.sendCertificationsState.failure?.errorMessage ?? '',
          );
        } else if (state.sendCertificationsState.isSuccess) {
          AuthenticationBloc.of(context).startDecider();
          AppRouteNavigator.popUntil(context);

          AppRouteNavigator.push(
            context,
            ProviderKasamPage.routeName,
            ProviderKasamPage(),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: PaddingDimensions.pageHorizontalPadding,
          vertical: PaddingDimensions.large,
        ),
        child: Form(
          key: _formKey,
          autovalidateMode: _autovalidateMode,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appLocalizer.oneStepLeft,
                        style: context.extraBold.copyWith(
                          color: context.appColors.secondary.shade500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        appLocalizer.uploadTrustedCertificates,
                        style: context.regular,
                      ),
                      const SizedBox(height: 24),

                      AppTextFormField(
                        controller: certificateNameController,
                        hint: appLocalizer.certificateName,
                        // Optional — validated conditionally in _onSubmit
                      ),

                      const SizedBox(height: 24),

                      _buildMediaUploader(
                        context: context,
                        title: appLocalizer.uploadCertificateImage,
                        attachment: certificatePicture,
                        onMediaPicked: (media) {
                          setState(() {
                            certificatePicture = media;
                          });
                        },
                        onRemoved: () {
                          setState(() {
                            certificatePicture = null;
                          });
                        },
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  Expanded(
                    child: AppPrimaryButton.outline(
                      onPressed: () {
                        widget.onBack();
                      },
                      isExpanded: false,
                      buttonStyle: (currentStyle) => currentStyle?.copyWith(
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.transparent,
                        ),
                      ),
                      text: appLocalizer.backBtn,
                    ),
                  ),
                  Expanded(
                    child: AppPrimaryButton(
                      onPressed: _onSubmit,
                      isExpanded: false,
                      text: appLocalizer.continueBtn,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    FocusScope.of(context).unfocus();

    final name = certificateNameController.text.trim();
    final hasName = name.isNotEmpty;
    final hasPicture = certificatePicture != null;

    // Both empty → skip the step entirely (certifications are optional)
    if (!hasName && !hasPicture) {
      context.read<ProviderCompleteProfileCubit>().skipCertifications();
      return;
    }

    // Partially filled → guide the user to complete or clear the section
    if (hasName && !hasPicture) {
      AppToasts.error(context, message: appLocalizer.uploadCertificateImage);
      return;
    }
    if (!hasName && hasPicture) {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
      AppToasts.error(context, message: appLocalizer.certificateNameRequired);
      return;
    }

    // Both filled → upload as usual
    context.read<ProviderCompleteProfileCubit>().uploadCertificate(
      certificatePicture!,
      name,
    );
  }

  Widget _buildMediaUploader({
    required BuildContext context,
    required String title,
    required Attachment? attachment,
    required Function(Attachment?) onMediaPicked,
    required VoidCallback onRemoved,
  }) {
    return Column(
      children: [
        Center(
          child: GestureDetector(
            onTap: () {
              Feedback.forTap(context);
              AppBottomSheets.showMediaPickerUtilsBottomSheet(
                context: context,
                pickConfigs: [
                  MediaPickImageConfig.single(canModifyImage: true),
                  MediaPickImageConfig.single(
                    canModifyImage: true,
                    isCamera: true,
                  ),
                ],
                onPickMedia: onMediaPicked,
              );
            },
            child: Container(
              width: 200,
              height: 200,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.neutral100,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: attachment == null
                  ? Column(
                      spacing: 10,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.export,
                          color: AppColors.neutral700,
                          size: 24,
                        ),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: context.bold.copyWith(
                            color: AppColors.neutral700,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  : AppImage(
                      path: attachment.url,
                      fit: BoxFit.cover,
                      width: 200,
                      height: 200,
                    ),
            ),
          ),
        ),
        if (attachment != null)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: AppPrimaryButton(
                text: appLocalizer.removeImage,
                textStyle: context.bold.copyWith(fontSize: 12),
                buttonStyle: (currentStyle) {
                  return currentStyle?.copyWith(
                    backgroundColor: WidgetStatePropertyAll(
                      AppColors.danger700,
                    ),
                  );
                },
                onPressed: onRemoved,
              ),
            ),
          ),
      ],
    );
  }
}
