part of auth;

class ForgotPasswordPage extends StatelessWidget {
  static const String routeName = '/ForgotPasswordPage';

  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OTPCubit(),
      child: const _ForgotPasswordBody(),
    );
  }
}

class _ForgotPasswordBody extends StatefulWidget {
  const _ForgotPasswordBody();

  @override
  State<_ForgotPasswordBody> createState() => _ForgotPasswordBodyState();
}

class _ForgotPasswordBodyState extends State<_ForgotPasswordBody> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<OTPCubit>().sendOTP(emailOrPhone: _emailController.text);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OTPCubit, OTPState>(
      listenWhen: (previous, current) => previous.sendOtp != current.sendOtp,
      listener: (context, state) {
        state.sendOtp.when(
          success: (data) {
            AppRouteNavigator.push(
              context,
              OtpVerificationPage.routeName,
              OtpVerificationPage(
                emailOrPhone: _emailController.text,
                otpCubit: context.read<OTPCubit>(),
              ),
            );
          },
          error: (error) {
            AppToasts.error(context, message: error.errorMessage);
          },
        );
      },
      child: Scaffold(
        appBar: AppBars.defaultBar(
          context,
          text: appLocalizer.forgot_password,
          useCloseButton: true,
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  Text(
                    appLocalizer.registered_email,
                    style: context.extraBold.copyWith(
                      color: context.appColors.secondary.shade500,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    appLocalizer.forgot_password_description,
                    style: context.regular,
                  ),
                  const SizedBox(height: 32),

                  // Email / Phone Field
                  AppTextFormField(
                    controller: _emailController,
                    hint: context.translate.email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.translate.please_enter_email;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  BlocBuilder<OTPCubit, OTPState>(
                    builder: (context, state) {
                      return AppPrimaryButton(
                        onPressed: state.sendOtp.isLoading ? null : _onSubmit,
                        isExpanded: true,
                        isLoading: state.sendOtp.isLoading,
                        text: context.translate.continue_label,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
