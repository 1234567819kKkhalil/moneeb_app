part of auth;

/// Step 1 of service-provider registration: identity verification. Reuses the
/// same passwordless OTP logic as login, but with `role = PROVIDER`, so a
/// verified new user is routed into the provider registration screen.
class ProviderIdentityVerificationPage extends StatelessWidget {
  static const String routeName = '/ProviderIdentityVerificationPage';

  const ProviderIdentityVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OtpAuthCubit(role: UserRoleEnum.provider),
      child: const _ProviderIdentityBody(),
    );
  }
}

class _ProviderIdentityBody extends StatelessWidget {
  const _ProviderIdentityBody();

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
          text: appLocalizer.registerAsServiceProvider,
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
                Text(
                  appLocalizer.welcomeAuth,
                  style: context.extraBold.copyWith(
                    color: context.appColors.secondary.shade500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  appLocalizer.providerIdentityDesc,
                  style: context.regular,
                ),
                const SizedBox(height: 24),
                BlocBuilder<OtpAuthCubit, OtpAuthState>(
                  builder: (context, state) {
                    return AuthIdentifierForm(
                      isSubmitting: state.start.isLoading,
                      onSubmit: (identifier) => _startFlow(context, identifier),
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
