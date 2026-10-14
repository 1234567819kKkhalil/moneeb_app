part of auth;

/// OTP verification screen for the unified passwordless flow. Receives the
/// live [OtpAuthCubit] (carrying the identifier, otpToken and channel) and
/// routes on verify: existing account → app, new account → registration.
class OtpAuthVerificationPage extends StatelessWidget {
  static const String routeName = '/otpAuthVerificationPage';

  final OtpAuthCubit cubit;

  const OtpAuthVerificationPage({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: const _OtpAuthBody(),
    );
  }
}

class _OtpAuthBody extends StatefulWidget {
  const _OtpAuthBody();

  @override
  State<_OtpAuthBody> createState() => _OtpAuthBodyState();
}

class _OtpAuthBodyState extends State<_OtpAuthBody> {
  final TextEditingController _codeController = TextEditingController();

  static const int _cooldownSeconds = 120; // 2 minutes
  int _secondsLeft = _cooldownSeconds;
  Timer? _timer;

  OtpAuthCubit get _cubit => context.read<OtpAuthCubit>();

  String get _formattedCountdown {
    final minutes = _secondsLeft ~/ 60;
    final seconds = _secondsLeft % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    _startCooldown();
  }

  void _startCooldown() {
    _timer?.cancel();
    setState(() => _secondsLeft = _cooldownSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  void _verify() {
    if (_codeController.text.length == 6) {
      _cubit.verify(_codeController.text);
    }
  }

  void _resend() {
    if (_secondsLeft == 0) _cubit.resend();
  }


  void _onVerified(BuildContext context, OtpVerifyResult result) {
    switch (result) {
      case OtpAuthenticated():
        // Token already persisted by the use case — hand off to the decider.
        AuthenticationBloc.of(context).startDecider();
        AppRouteNavigator.popUntil(context);
      case OtpRegistrationRequired(:final signupToken):
        final identifier = _cubit.identifier!;
        if (_cubit.role == UserRoleEnum.provider) {
          AppRouteNavigator.pushReplacement(
            context,
            ProviderRegisterPage.routeName,
            ProviderRegisterPage(
              signupToken: signupToken,
              verifiedIdentifier: identifier,
            ),
          );
        } else {
          AppRouteNavigator.pushReplacement(
            context,
            UserRegisterPage.routeName,
            UserRegisterPage(
              signupToken: signupToken,
              verifiedIdentifier: identifier,
            ),
          );
        }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        // Verify → route
        BlocListener<OtpAuthCubit, OtpAuthState>(
          listenWhen: (p, c) => p.verify != c.verify,
          listener: (context, state) {
            state.verify.when(
              success: (result) {
                if (result != null) _onVerified(context, result);
              },
              error: (failure) {
                AppToasts.error(context, message: failure.errorMessage);
              },
            );
          },
        ),
        // Resend → toast + restart cooldown
        BlocListener<OtpAuthCubit, OtpAuthState>(
          listenWhen: (p, c) => p.resend != c.resend,
          listener: (context, state) {
            state.resend.when(
              success: (_) {
                AppToasts.success(
                  context,
                  message: appLocalizer.code_resent_successfully,
                );
                _startCooldown();
              },
              error: (failure) {
                AppToasts.error(context, message: failure.errorMessage);
              },
            );
          },
        ),
        // Code re-sent via "change method" → clear field + restart cooldown
        BlocListener<OtpAuthCubit, OtpAuthState>(
          listenWhen: (p, c) => p.start != c.start,
          listener: (context, state) {
            state.start.when(
              success: (_) {
                _codeController.clear();
                _startCooldown();
              },
            );
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBars.defaultBar(
          context,
          text: appLocalizer.verificationTitle,
          useCloseButton: true,
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text(
                  appLocalizer.enter_verification_code,
                  style: context.extraBold.copyWith(
                    color: context.appColors.secondary.shade500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(appLocalizer.codeSentTo, style: context.regular),
                const SizedBox(height: 2),
                Text(
                  _cubit.identifier?.display ?? '',
                  style: context.semiBold,
                  textDirection: direction.TextDirection.ltr,
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 32),

                OtpPinCodeWidget(
                  controller: _codeController,
                  length: 6,
                  onCompleted: (_) => _verify(),
                  validator: (value) => null,
                ),
                const SizedBox(height: 32),

                BlocBuilder<OtpAuthCubit, OtpAuthState>(
                  buildWhen: (p, c) => p.verify != c.verify,
                  builder: (context, state) {
                    return AppPrimaryButton(
                      isExpanded: true,
                      isLoading: state.verify.isLoading,
                      text: appLocalizer.verify,
                      onPressed: _verify,
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Resend row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      appLocalizer.didnt_receive_code,
                      style: context.regular,
                    ),
                    const SizedBox(width: 4),
                    BlocBuilder<OtpAuthCubit, OtpAuthState>(
                      buildWhen: (p, c) => p.resend != c.resend,
                      builder: (context, state) {
                        // Show a spinner while the resend request is in-flight.
                        if (state.resend.isLoading) {
                          return const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        }

                        final bool canResend = _secondsLeft == 0;
                        return AppTextButton(
                          onPressed: canResend ? _resend : null,
                          text: _secondsLeft > 0
                              ? '${appLocalizer.resend} ($_formattedCountdown)'
                              : appLocalizer.resend,
                          textStyle: context.medium.copyWith(
                            color: canResend
                                ? context.appColors.secondary.shade500
                                : context.appColors.neutral.shade500,
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.dashed,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
