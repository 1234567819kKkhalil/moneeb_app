part of edit_provider_profile;

class EditProviderProfileAvatarSection extends StatelessWidget {
  final AppUserModel? currentUser;

  const EditProviderProfileAvatarSection({super.key, this.currentUser});

  void _onSelectImageTap(BuildContext context) {
    AppBottomSheets.showMediaPickerUtilsBottomSheet(
      context: context,
      pickConfigs: const [
        MediaPickImageConfig.single(isCamera: false, canModifyImage: true),
        MediaPickImageConfig.single(isCamera: true, canModifyImage: true),
      ],
      onPickMedia: (media) {
        // if (media.firstOrNull != null) {
        context.read<EditProviderProfileCubit>().setAvatar(media);
        // }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthState>(
      buildWhen: (previous, current) => previous.userData != current.userData,
      builder: (context, state) {
        final currentUser = state.userData;
        return BlocBuilder<EditProviderProfileCubit, EditProviderProfileState>(
          buildWhen: (previous, current) =>
              previous.selectedAvatar != current.selectedAvatar,
          builder: (context, state) {
            final avatar = state.selectedAvatar;

            String? displayPath = avatar?.url;
            if (displayPath == null || displayPath.isEmpty) {
              displayPath = currentUser.data?.avatarUrl;
            }

            return Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppImage(
                          path: avatar?.url ?? displayPath ?? '',
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          border: Border.all(
                            color: context.appColors.primary.shade400,
                            width: 2,
                          ),
                          errorPlaceHolder: () => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: context.appColors.primary.shade500,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              AssetPaths.moneebLogo,
                              fit: BoxFit.contain,
                              width: 60,
                              height: 60,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentUser.data?.fullName ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: context.semiBold.copyWith(
                                  color: context.appColors.neutral.shade50,
                                  fontSize: Dimensions.large,
                                ),
                              ),
                              Text(
                                currentUser.data?.email ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: context.regular.copyWith(
                                  color: context.appColors.neutral.shade500,
                                  fontSize: Dimensions.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _onSelectImageTap(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: context.appColors.primary.shade500,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        appLocalizer.editImage,
                        style: context.medium.copyWith(
                          fontSize: 12,
                          color: context.appColors.neutral.shade900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
