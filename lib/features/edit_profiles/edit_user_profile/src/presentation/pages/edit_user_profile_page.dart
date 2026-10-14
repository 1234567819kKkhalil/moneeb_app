part of edit_user_profile;

class EditUserProfilePage extends StatelessWidget {
  static const String routeName = '/edit-profile';

  const EditUserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<EditUserProfileCubit>(),
      child: const _EditUserProfilePageBody(),
    );
  }
}

class _EditUserProfilePageBody extends StatelessWidget {
  const _EditUserProfilePageBody();

  @override
  Widget build(BuildContext context) {
    // final currentUser = context.read<AuthenticationCubit>().currentUser;

    return Scaffold(
      backgroundColor: context.appColors.appBackgroundColor,
      appBar: AppBars.defaultBar(
        context,
        text: appLocalizer.editProfile, // TODO: Localize using appLocalizer
        useCloseButton: true,
        closeIconColor: context.appColors.neutral.shade900,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PaddingDimensions.normal,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(PaddingDimensions.xLarge),
              EditUserProfileAvatarSection(),
              const Gap(PaddingDimensions.xLarge),
              BlocBuilder<AuthenticationBloc, AuthState>(
                builder: (context, state) {
                  return EditUserProfileForm(
                    currentUser: state.userData.data ?? AppUserModel.initial(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
