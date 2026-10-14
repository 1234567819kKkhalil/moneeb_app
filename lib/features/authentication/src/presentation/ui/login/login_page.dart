part of auth;

class LoginPage extends StatelessWidget {
  static const String routeName = '/LoginPage';

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OtpAuthCubit(role: UserRoleEnum.user),
      child: const _LoginBody(),
    );
  }
}

class _LoginBody extends StatelessWidget {
  const _LoginBody();

  void _startFlow(BuildContext context, OtpIdentifier identifier) {
    final cubit = context.read<OtpAuthCubit>();
    cubit.setIdentifier(identifier);
    // No channel picker: the code always goes out on the fixed channel
    // (whatsapp for phone, email for email).
    cubit.startWithDefaultChannel();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OtpAuthCubit, OtpAuthState>(
      listenWhen: (p, c) => p.start != c.start,
      listener: (context, state) {
        final cubit = context.read<OtpAuthCubit>();
        state.start.when(
          success: (_) {
            AppRouteNavigator.push(
              context,
              OtpAuthVerificationPage.routeName,
              OtpAuthVerificationPage(cubit: cubit),
            );
          },
          error: (failure) {
            AppToasts.error(context, message: failure.errorMessage);
          },
        );
      },
      child: Scaffold(
        appBar: AppBars.defaultBar(
          context,
          text: appLocalizer.loginBtn,
          useCloseButton: true,
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                // Welcome Texts
                Text(
                  appLocalizer.welcomeAuth,
                  style: context.extraBold.copyWith(
                    color: context.appColors.secondary.shade500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(appLocalizer.loginWithOtpDesc, style: context.regular),
                const SizedBox(height: 24),

                // Email / Phone identifier + Send code
                BlocBuilder<OtpAuthCubit, OtpAuthState>(
                  builder: (context, state) {
                    return AuthIdentifierForm(
                      isSubmitting: state.start.isLoading,
                      onSubmit: (identifier) => _startFlow(context, identifier),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Or Divider
                Row(
                  children: [
                    Expanded(
                      child: Divider(color: context.appColors.neutral.shade500),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(appLocalizer.orAuth, style: context.regular),
                    ),
                    Expanded(
                      child: Divider(color: context.appColors.neutral.shade500),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Register as a Service Provider
                AppPrimaryButton.outline(
                  isExpanded: true,
                  text: appLocalizer.registerAsServiceProvider,
                  onPressed: () {
                    AppRouteNavigator.push(
                      context,
                      ProviderIdentityVerificationPage.routeName,
                      const ProviderIdentityVerificationPage(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
