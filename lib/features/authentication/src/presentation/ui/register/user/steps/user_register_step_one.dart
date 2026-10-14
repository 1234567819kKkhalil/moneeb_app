part of auth;

//todo: refactor
class UserRegisterStepOne extends StatefulWidget {
  final VoidCallback onRegisterRequested;

  const UserRegisterStepOne({
    super.key,
    required this.onRegisterRequested,
  });

  @override
  State<UserRegisterStepOne> createState() => _UserRegisterStepOneState();
}

class _UserRegisterStepOneState extends State<UserRegisterStepOne> with AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Validator _validator = Validator();

  static const List<GenderEnum> _genderOptions = [GenderEnum.male, GenderEnum.female];

  @override
  bool get wantKeepAlive => true;

  RegisterInputProvider get inputProvider => context.read<RegisterInputProvider>();

  void _onContinue() {
    if (_formKey.currentState?.validate() ?? false) {
      // When verified via email, the phone becomes the required OTHER contact.
      if (inputProvider.verifiedViaEmail) {
        final phone = inputProvider.phoneNumber;
        if (phone == null || phone.number.trim().isEmpty) {
          AppToasts.error(context, message: appLocalizer.invalidPhoneNumber);
          return;
        }
      }

      if (inputProvider.selectedGender == null) {
        AppToasts.error(context, message: appLocalizer.pleaseChooseGender);
        return;
      }

      widget.onRegisterRequested();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final bool isUser =
        context.read<AuthenticationBloc>().getUserRole == UserRoleEnum.user;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: PaddingDimensions.pageHorizontalPadding,
        vertical: PaddingDimensions.large,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            _buildWelcomeHeader(context, isUser),
            const SizedBox(height: 24),

            // Name Field
            AppTextFormField(
              controller: inputProvider.nameController,
              hint: appLocalizer.nameHint,
              keyboardType: TextInputType.name,
              prefixIconType: PrefixIconType.name,
              maxLength: 50,
              validator: (value) => _validator.nameValidation(value ?? ''),
            ),
            const SizedBox(height: 16),

            // Email Field (locked when it was the verified contact)
            EmailWidget(
              controller: inputProvider.emailController,
              readOnly: inputProvider.verifiedViaEmail,
              validator: inputProvider.verifiedViaEmail
                  ? null
                  : (text) => _validator.emailValidation(text ?? ''),
            ),
            const SizedBox(height: 16),

            // Phone Field (locked when it was the verified contact)
            PhoneField(
              hint: appLocalizer.mobileNumberHint,
              initialValue: inputProvider.prefilledPhone,
              readOnly: !inputProvider.verifiedViaEmail,
              onChange: (phoneNumber) {
                inputProvider.phoneNumber = phoneNumber;
              },
            ),
            const SizedBox(height: 16),

            // Gender Selection
            _buildSectionTitle(context, appLocalizer.selectGender), 

            const SizedBox(height: 12),

            _buildGenderSelector(context),

            // const SizedBox(height: 24),
            //
            // // Password Field (optional — OTP-only accounts can skip it)
            // AppTextFormField(
            //   controller: inputProvider.passwordController,
            //   hint: appLocalizer.passwordOptionalHint,
            //   obscureText: true,
            //   prefixIconType: PrefixIconType.password,
            //   validator: (value) => (value == null || value.isEmpty)
            //       ? null
            //       : _validator.passwordValidation(value),
            // ),
            // const SizedBox(height: 16),
            //
            // // Confirm Password Field (only when a password was entered)
            // AppTextFormField(
            //   controller: inputProvider.confirmPasswordController,
            //   hint: appLocalizer.confirmPasswordHint,
            //   obscureText: true,
            //   prefixIconType: PrefixIconType.password,
            //   validator: (value) {
            //     if (inputProvider.passwordController.text.isEmpty) return null;
            //     if (value == null || value.isEmpty) {
            //       return appLocalizer.pleaseConfirmPassword;
            //     }
            //     if (value != inputProvider.passwordController.text) {
            //       return appLocalizer.passwordsDoNotMatch;
            //     }
            //     return null;
            //   },
            // ),
            const SizedBox(height: 24),

            // Continue Button
            AppPrimaryButton(
              onPressed: _onContinue,
              isExpanded: true,
              text: appLocalizer.nextAuth,
            ),
            const SizedBox(height: 24),

            // Or Divider
            _buildOrDivider(context),
            const SizedBox(height: 20),

            // Already have account
            _buildAlreadyHaveAccount(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
  
  Widget _buildWelcomeHeader(BuildContext context, bool isUser) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appLocalizer.welcomeAuth,
          style: context.extraBold.copyWith(
            color: context.appColors.secondary.shade500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isUser
              ? appLocalizer.loginToViewMutamersDesc
              : appLocalizer.loginToViewOrdersDesc,
          style: context.regular,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: context.semiBold,
    );
  }

  Widget _buildGenderSelector(BuildContext context) {
    return Row(
      children: _genderOptions.map((option) {
        return Padding(
          padding: EdgeInsetsDirectional.only(
            end: option != _genderOptions.last ? 16 : 0,
          ),
          child: Row(
            children: [
              Radio<GenderEnum>(
                value: option,
                groupValue: inputProvider.selectedGender,
                onChanged: (value) {
                  setState(() => inputProvider.selectedGender = value);
                },
              ),

              Text(
                option.localizedName,
                style: context.regular.copyWith(fontSize: 12),
              )
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOrDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(color: context.appColors.neutral.shade500),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            appLocalizer.orAuth,
            style: context.regular,
          ),
        ),
        Expanded(
          child: Divider(color: context.appColors.neutral.shade500),
        ),
      ],
    );
  }

  Widget _buildAlreadyHaveAccount(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          appLocalizer.haveAccount,
          style: context.regular,
        ),
        AppTextButton(
          onPressed: () {
            AppRouteNavigator.pop(context);
          },
          text: appLocalizer.loginBtn,
          textStyle: context.medium.copyWith(
            color: context.appColors.secondary.shade500,
            decoration: TextDecoration.underline,
            decorationStyle: TextDecorationStyle.dashed,
          ),
        ),
      ],
    );
  }
}
