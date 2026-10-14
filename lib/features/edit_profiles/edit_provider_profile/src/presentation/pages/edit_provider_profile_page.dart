part of edit_provider_profile;

class EditProviderProfilePage extends StatelessWidget {
  static const String routeName = '/edit-provider-profile';

  const EditProviderProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<EditProviderProfileCubit>(),
      child: const _EditProviderProfilePageBody(),
    );
  }
}

class _EditProviderProfilePageBody extends StatelessWidget {
  const _EditProviderProfilePageBody();

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
              EditProviderProfileAvatarSection(),
              const Gap(PaddingDimensions.xLarge),
              BlocBuilder<AuthenticationBloc, AuthState>(
                builder: (context, authState) {
                  final initialIsOnline =
                      authState.userData.data?.providerData?.isOnline ?? false;
                  return BlocConsumer<EditProviderProfileCubit, EditProviderProfileState>(
                    listener: (context, profileState) {
                      if (profileState.toggleOnlineState.isSuccess) {
                        context.read<AuthenticationBloc>().modifyUserModel((user) {
                          return user.copyWith(
                            providerData: user.providerData?.copyWith(
                              isOnline: profileState.isOnline,
                            ),
                          );
                        });
                        AppToasts.success(
                          context,
                          message: appLocalizer.updatedSuccessfully,
                        );
                      } else if (profileState.toggleOnlineState.isFailure) {
                        AppToasts.error(
                          context,
                          message:
                              profileState.toggleOnlineState.failure?.errorMessage ?? '',
                        );
                      }
                    },
                    builder: (context, profileState) {
                      final currentIsOnline = profileState.isOnline ?? initialIsOnline;
                      return AvailabilitySwitcher(
                        isOnline: currentIsOnline,
                        onChanged: (value) {
                          context.read<EditProviderProfileCubit>().toggleOnlineStatus(value);
                        },
                      );
                    },
                  );
                },
              ),
              const Gap(PaddingDimensions.xLarge),
              BlocBuilder<AuthenticationBloc, AuthState>(
                builder: (context, state) {
                  return EditProviderProfileForm(
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
