part of auth;

class ResetPasswordPage extends StatelessWidget {
  static const String routeName = '/ResetPasswordPage';
  final String token;

  const ResetPasswordPage({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordCubit(),
      child: _ResetPasswordBody(token: token),
    );
  }
}

class _ResetPasswordBody extends StatefulWidget {
  final String token;
  const _ResetPasswordBody({required this.token});

  @override
  State<_ResetPasswordBody> createState() => _ResetPasswordBodyState();
}

class _ResetPasswordBodyState extends State<_ResetPasswordBody> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final Validator validator = Validator();

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ResetPasswordCubit>().resetPassword(
            widget.token,
            _passwordController.text,
          );
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordCubit, ResetPasswordState>(
      listenWhen: (previous, current) =>
          previous.resetPasswordState != current.resetPasswordState,
      listener: (context, state) {
        state.resetPasswordState.when(
          success: (data) {
            AppToasts.success(context,
                message: context.translate.password_updated_successfully);
            AppRouteNavigator.pushAndRemoveUntil(
                context, LoginPage.routeName, const LoginPage());
          },
          error: (error) {
            AppToasts.error(context, message: error.errorMessage);
          },
        );
      },
      child: Scaffold(
        appBar: AppBars.defaultBar(
          context,
          text: context.translate.reset_password,
          useCloseButton: true,
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    context.translate.set_new_password,
                    style: context.extraBold.copyWith(
                      color: context.appColors.secondary.shade500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.translate.reset_password_instruction,
                    style: context.regular,
                  ),
                  const SizedBox(height: 32),
                  AppTextFormField(
                    controller: _passwordController,
                    hint: context.translate.new_password,
                    obscureText: true,
                    prefixIconType: PrefixIconType.password,
                    validator: (value) {
                      return validator.passwordValidation(value);
                    },
                  ),
                  const SizedBox(height: 16),
                  AppTextFormField(
                    controller: _confirmPasswordController,
                    hint: context.translate.confirm_password,
                    obscureText: true,
                    prefixIconType: PrefixIconType.password,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return context.translate.passwords_do_not_match;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
                    builder: (context, state) {
                      return AppPrimaryButton(
                        onPressed:
                            state.resetPasswordState.isLoading ? null : _onSubmit,
                        isExpanded: true,
                        isLoading: state.resetPasswordState.isLoading,
                        text: context.translate.update_password,
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
