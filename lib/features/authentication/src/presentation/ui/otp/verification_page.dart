part of auth;

class OtpVerificationPage extends StatelessWidget {
  static const String routeName = '/otpVerificationPage';
  final String emailOrPhone;
  final bool showAppBar;
  final OTPCubit? otpCubit;
  final VoidCallback? onBackPressed;

  const OtpVerificationPage({
    super.key,
    required this.emailOrPhone,
    this.otpCubit,
    this.showAppBar = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: otpCubit ?? OTPCubit(),
      child: OtpVerificationBody(
        emailOrPhone: emailOrPhone,
        onBackPressed: onBackPressed,
        showAppBar: showAppBar,
      ),
    );
  }
}

class OtpVerificationBody extends StatefulWidget {
  final String emailOrPhone;
  final bool showAppBar;
  final VoidCallback? onBackPressed;

  const OtpVerificationBody({
    super.key,
    required this.emailOrPhone,
    this.showAppBar = true,
    this.onBackPressed,
  });

  @override
  State<OtpVerificationBody> createState() => _OtpVerificationBodyState();
}

class _OtpVerificationBodyState extends State<OtpVerificationBody> {
  final _codeController = TextEditingController();

  void _verifyAction() {
    if (_codeController.text.length == 6) {
      BlocProvider.of<OTPCubit>(context).verifyOtp(
        code: _codeController.text,
        emailOrPhone: widget.emailOrPhone,
      );
    }
  }

  void _resendCode() {
    BlocProvider.of<OTPCubit>(
      context,
    ).sendOTP(emailOrPhone: widget.emailOrPhone);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OTPCubit, OTPState>(
          listenWhen: (previous, current) =>
              previous.verifyOtp != current.verifyOtp,
          listener: (context, state) {
            state.verifyOtp.when(
              success: (token) {
                AppToasts.success(
                  context,
                  message: context.translate.verified_successfully,
                );
                AppRouteNavigator.pushReplacement(
                  context,
                  ResetPasswordPage.routeName,
                  ResetPasswordPage(token: token!),
                );
              },
              error: (error) {
                AppToasts.error(context, message: error.errorMessage);
              },
            );
          },
        ),
        BlocListener<OTPCubit, OTPState>(
          listenWhen: (previous, current) => previous.sendOtp != current.sendOtp,
          listener: (context, state) {
            state.sendOtp.when(
              success: (data) {
                AppToasts.success(
                  context,
                  message: context.translate.code_resent_successfully,
                );
              },
              error: (error) {
                AppToasts.error(context, message: error.errorMessage);
              },
            );
          },
        ),
      ],
      child: Scaffold(
        appBar: widget.showAppBar
            ? AppBars.defaultBar(
                onBackPressed: widget.onBackPressed,
                context,
                text: context.translate.forgot_password,
                useCloseButton: true,
                centerTitle: true,
              )
            : null,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                Text(
                  context.translate.enter_verification_code,
                  style: context.extraBold.copyWith(
                    color: context.appColors.secondary.shade500,
                  ),
                ),
                const SizedBox(height: 24),

                OtpPinCodeWidget(
                  controller: _codeController,
                  length: 6,
                  hasError: false,
                  // onCompleted: (value) => _verifyAction(),
                  validator: (value) {
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                BlocBuilder<OTPCubit, OTPState>(
                  builder: (context, state) {
                    return AppPrimaryButton(
                      isExpanded: true,
                      isLoading: state.verifyOtp.isLoading,
                      text: context.translate.verify,
                      onPressed: _verifyAction,
                    );
                  },
                ),
                const SizedBox(height: 24),

                /* Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.translate.didnt_receive_code,
                      style: context.regular,
                    ),
                    BlocBuilder<OTPCubit, OTPState>(
                      builder: (context, state) {
                        return AppTextButton(
                          onPressed: state.sendOtp.isLoading ? null : _resendCode,
                          text: state.sendOtp.isLoading ? '...' : context.translate.resend,
                          textStyle: context.medium.copyWith(
                            color: context.appColors.secondary.shade500,
                            decoration: TextDecoration.underline,
                            decorationStyle: TextDecorationStyle.dashed,
                          ),
                        );
                      },
                    ),
                  ],
                ), */
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }
}
