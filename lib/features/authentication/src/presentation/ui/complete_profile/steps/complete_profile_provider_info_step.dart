part of auth;

class CompleteProfileProviderInfoStep extends StatefulWidget {
  final VoidCallback onNext;

  const CompleteProfileProviderInfoStep({super.key, required this.onNext});

  @override
  State<CompleteProfileProviderInfoStep> createState() =>
      _CompleteProfileProviderInfoStepState();
}

class _CompleteProfileProviderInfoStepState
    extends State<CompleteProfileProviderInfoStep>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController umrahCountController = TextEditingController();
  final TextEditingController nationalIdController = TextEditingController();
  Attachment? profilePicture;
  Attachment? nationalIdPicture;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    final userData = context.read<AuthenticationBloc>().getUserModel;

    bioController.text = userData.providerData?.bio ?? '';

    if (userData.providerData?.umrahCount != 0) {
      umrahCountController.text =
          userData.providerData?.umrahCount.toString() ?? '';
    }

    nationalIdController.text =
        userData.providerData?.identificationNumber ?? '';

    if (userData.avatarUrl.isNotEmpty) {
      profilePicture = Attachment(
        id: RandomId.generate(),
        url: userData.avatarUrl,
        type: AttachmentTypeEnum.photo,
      );
    }

    if (userData.providerData?.identificationDocumentUrl != null) {
      nationalIdPicture = Attachment(
        id: RandomId.generate(),
        url: userData.providerData?.identificationDocumentUrl ?? '',
        type: AttachmentTypeEnum.photo,
      );
    }

    super.initState();
  }

  @override
  void dispose() {
    bioController.dispose();
    umrahCountController.dispose();
    nationalIdController.dispose();
    profilePicture = null;
    nationalIdPicture = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocListener<
      ProviderCompleteProfileCubit,
      ProviderCompleteProfileState
    >(
      listenWhen: (previous, current) =>
          previous.sendProfileInfoState != current.sendProfileInfoState,
      listener: (context, state) {
        if (state.sendProfileInfoState.isLoading) {
          AppBlockerLoader.showLoader(context);
        } else {
          AppBlockerLoader.removeLoader();
        }

        if (state.sendProfileInfoState.isFailure) {
          AppToasts.error(
            context,
            message: state.sendProfileInfoState.failure?.errorMessage ?? '',
          );
        } else if (state.sendProfileInfoState.isSuccess) {
          widget.onNext();
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
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appLocalizer.createMutamerProfile,
                  style: context.extraBold.copyWith(
                    color: context.appColors.secondary.shade500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  appLocalizer.enterDataToCompleteProfile,
                  style: context.regular,
                ),
                const SizedBox(height: 24),

                // Profile Picture
                _buildMediaUploader(
                  context: context,
                  title: appLocalizer.uploadImageTitle,
                  attachment: profilePicture,
                  onMediaPicked: (media) {
                    setState(() {
                      profilePicture = media;
                    });
                  },
                  onRemoved: () {
                    setState(() {
                      profilePicture = null;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Bio
                AppTextFormField(
                  controller: bioController,
                  hint: appLocalizer.yourBioHint,
                  maxLines: 5,
                  maxLength: 600,
                  validator: (value) {
                    final text = value?.trim() ?? '';
                    if (text.isEmpty) return appLocalizer.bioRequired;
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // Umrah Count
                AppTextFormField(
                  controller: umrahCountController,
                  hint: appLocalizer.timesPerformedOmrah,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final raw = value?.trim() ?? '';
                    if (raw.isEmpty) return appLocalizer.umrahCountRequired;
                    final parsed = int.tryParse(raw);
                    if (parsed == null) return appLocalizer.enterValidNumber;
                    if (parsed < 0) return appLocalizer.enterValidNumber;
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // National ID Picture
                _buildMediaUploader(
                  context: context,
                  title: appLocalizer.uploadIdImage,
                  attachment: nationalIdPicture,
                  onMediaPicked: (media) {
                    setState(() {
                      nationalIdPicture = media;
                    });
                  },
                  onRemoved: () {
                    setState(() {
                      nationalIdPicture = null;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // National ID
                AppTextFormField(
                  controller: nationalIdController,
                  hint: appLocalizer.idNumberHint,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final raw = value?.trim() ?? '';
                    if (raw.isEmpty) return appLocalizer.idNumberRequired;
                    if (int.tryParse(raw) == null)
                      return appLocalizer.enterValidNumber;
                    return null;
                  },
                ),

                const SizedBox(height: 32),

                AppPrimaryButton(
                  onPressed: _onSubmit,
                  isExpanded: true,
                  text: appLocalizer.continueAuth,
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    FocusScope.of(context).unfocus();

    setState(() {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    });

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    /* if (profilePicture == null) {
      AppToasts.error(context, message: appLocalizer.pleaseUploadImage);
      return;
    } */

    if (nationalIdPicture == null) {
      AppToasts.error(context, message: appLocalizer.pleaseUploadIdImage);
      return;
    }

    context.read<ProviderCompleteProfileCubit>().sendProviderInfo(
      CompleteProviderProfileInput(
        bio: bioController.text.trim(),
        nationalId: nationalIdController.text.trim(),
        umrahCount: (num.tryParse(umrahCountController.text.trim()) ?? 0)
            .toInt(),
      ),
      nationalIdPicture!,
      profilePicture,
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
