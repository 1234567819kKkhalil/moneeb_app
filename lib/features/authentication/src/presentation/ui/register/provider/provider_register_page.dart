part of auth;

class ProviderRegisterPage extends StatelessWidget {
  static const String routeName = '/ProviderRegisterPage';

  /// Signup session token from the verified OTP step.
  final String signupToken;

  /// The contact already verified via OTP (prefilled + locked).
  final OtpIdentifier verifiedIdentifier;

  const ProviderRegisterPage({
    super.key,
    required this.signupToken,
    required this.verifiedIdentifier,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => ProviderRegisterCubit())],
      child: _ProviderRegisterPageBody(
        signupToken: signupToken,
        verifiedIdentifier: verifiedIdentifier,
      ),
    );
  }
}

class _ProviderRegisterPageBody extends StatefulWidget {
  final String signupToken;
  final OtpIdentifier verifiedIdentifier;

  const _ProviderRegisterPageBody({
    required this.signupToken,
    required this.verifiedIdentifier,
  });

  @override
  State<_ProviderRegisterPageBody> createState() =>
      _ProviderRegisterPageBodyState();
}

class _ProviderRegisterPageBodyState extends State<_ProviderRegisterPageBody> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();
  // final TextEditingController confirmPasswordController =
  //     TextEditingController();

  PhoneNumber? phoneNumber;
  GenderEnum? selectedGender;
  IntelPhoneCountry? selectedCountry;
  QuranMemorizeEnum? quranMemorize;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Validator _validator = Validator();

  bool get _verifiedViaEmail => widget.verifiedIdentifier.isEmail;

  String? get _prefilledPhone => _verifiedViaEmail
      ? null
      : '${widget.verifiedIdentifier.phoneCountryCode ?? ''}${widget.verifiedIdentifier.phoneNumber ?? ''}';

  @override
  void initState() {
    super.initState();
    if (_verifiedViaEmail) {
      emailController.text = widget.verifiedIdentifier.email ?? '';
    }
  }

  static const List<GenderEnum> _genderOptions = [
    GenderEnum.male,
    GenderEnum.female,
  ];

  static const List<QuranMemorizeEnum> _quranOptions = [
    QuranMemorizeEnum.yes,
    QuranMemorizeEnum.no,
    QuranMemorizeEnum.someParts,
  ];

  void _onContinue() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (selectedGender == null) {
      AppToasts.error(context, message: appLocalizer.pleaseChooseGender);
      return;
    }
    if (quranMemorize == null) {
      AppToasts.error(
        context,
        message: appLocalizer.pleaseChooseQuranMemorization,
      );
      return;
    }

    // The contact NOT used for verification is required by the backend.
    OtpIdentifier? otherContact;
    if (_verifiedViaEmail) {
      final phone = phoneNumber;
      if (phone == null || phone.number.trim().isEmpty) {
        AppToasts.error(context, message: appLocalizer.invalidPhoneNumber);
        return;
      }
      otherContact = OtpIdentifier.phone(
        countryCode: phone.countryCode,
        number: phone.number.trim(),
      );
    } else {
      final email = emailController.text.trim();
      otherContact = OtpIdentifier.email(email);
    }

    // final password = passwordController.text;

    context.read<ProviderRegisterCubit>().registerViaOtp(
      input: OtpRegisterInput(
        signupToken: widget.signupToken,
        role: UserRoleEnum.provider,
        fullName: nameController.text.trim(),
        otherContact: otherContact,
        // password: password.isEmpty ? null : password,
        countryCode: selectedCountry?.code,
        languageCode: injector<LocalizationContainer>().langCode.name,
        gender: selectedGender,
        isHafiz: quranMemorize == QuranMemorizeEnum.no ? false : true,
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    // passwordController.dispose();
    // confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProviderRegisterCubit, ProviderRegisterState>(
      listener: (context, state) {
        if (state.registerState.isLoading) {
          AppBlockerLoader.showLoader(context);
        } else {
          AppBlockerLoader.removeLoader();
        }

        if (state.registerState.isSuccess) {
          AuthenticationBloc.of(context).startDecider();

          //backend does not return provider data, so we do not use it
          // AuthenticationBloc.of(context).add(AuthenticatedEvent(
          //   userData: state.registerState.data ?? AppUserModel.initial()
          // ));
          AppRouteNavigator.popUntil(context);
        } else if (state.registerState.isFailure) {
          AppToasts.error(
            context,
            message: state.registerState.failure?.errorMessage ?? '',
          );
        }
      },
      child: Scaffold(
        appBar: AppBars.defaultBar(
          context,
          text: appLocalizer.createAccount,
          useCloseButton: true,
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
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
                  _buildWelcomeHeader(context),
                  const SizedBox(height: 24),

                  // Name Field
                  AppTextFormField(
                    controller: nameController,
                    hint: appLocalizer.mutamerName,
                    keyboardType: TextInputType.name,
                    prefixIconType: PrefixIconType.name,
                    maxLength: 50,
                    validator: (value) =>
                        _validator.nameValidation(value ?? ''),
                  ),

                  const SizedBox(height: 16),

                  // Email Field (locked when it was the verified contact)
                  EmailWidget(
                    controller: emailController,
                    readOnly: _verifiedViaEmail,
                    validator: _verifiedViaEmail
                        ? null
                        : (text) => _validator.emailValidation(text ?? ''),
                  ),
                  const SizedBox(height: 16),

                  // Phone Field (locked when it was the verified contact)
                  PhoneField(
                    hint: appLocalizer.mobileNumberHint,
                    initialValue: _prefilledPhone,
                    readOnly: !_verifiedViaEmail,
                    onChange: (number) {
                      phoneNumber = number;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Country Field
                  AppTextFormField(
                    // textDirection: TextDirection.rtl,
                    key: ObjectKey(selectedCountry),
                    hint: appLocalizer.countryHint,
                    readOnly: true,
                    initialValue:
                        injector<LocalizationContainer>().langCode.isArabic
                        ? selectedCountry?.arabicName
                        : selectedCountry?.name,
                    onTap: () async {
                      await AppBottomSheets.showAppBottomSheet(
                        context,
                        header: BottomSheetHeader(
                          title: appLocalizer.selectYourCountry,
                        ),
                        builder: (context) => CountryPickerSheet(
                          filteredCountries: countries,
                          searchText: appLocalizer.searchHint,
                          countryList: countries,
                          showNumbers: false,
                          selectedCountry: selectedCountry ?? countries.first,
                          onCountryChanged: (IntelPhoneCountry country) {
                            setState(() {
                              selectedCountry = country;
                            });
                          },
                        ),
                      );
                    },
                    // prefixIcon: Text(selectedCountry?.dialCode ?? ''),
                  ),

                  const SizedBox(height: 16),

                  // Gender Selection
                  _buildSectionTitle(context, appLocalizer.chooseGender),
                  const SizedBox(height: 12),
                  _buildGenderSelector(context),
                  const SizedBox(height: 24),

                  // // Password Field (optional — OTP-only accounts can skip it)
                  // AppTextFormField(
                  //   controller: passwordController,
                  //   hint: appLocalizer.passwordOptionalHint,
                  //   obscureText: true,
                  //   prefixIconType: PrefixIconType.password,
                  //   validator: (value) => _validator.passwordValidation(value),
                  // ),
                  // const SizedBox(height: 16),
                  //
                  // // Confirm Password Field (only when a password was entered)
                  // AppTextFormField(
                  //   controller: confirmPasswordController,
                  //   hint: appLocalizer.confirmPasswordHint,
                  //   obscureText: true,
                  //   prefixIconType: PrefixIconType.password,
                  //   validator: (value) {
                  //     // if (passwordController.text.isEmpty) return null;
                  //     if (value == null || value.isEmpty) {
                  //       return appLocalizer.pleaseConfirmPassword;
                  //     }
                  //     if (value != passwordController.text) {
                  //       return appLocalizer.passwordsDoNotMatch;
                  //     }
                  //     return null;
                  //   },
                  // ),
                  // const SizedBox(height: 24),

                  // Quran Memorization Selection
                  _buildSectionTitle(context, appLocalizer.quranHafiz),
                  const SizedBox(height: 12),
                  _buildQuranSelector(context),
                  const SizedBox(height: 32),

                  // Continue Button
                  AppPrimaryButton(
                    onPressed: _onContinue,
                    isExpanded: true,
                    text: appLocalizer.registerBtn,
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
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
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
        Text(appLocalizer.loginToViewOrdersDesc, style: context.regular),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(title, style: context.semiBold);
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
                groupValue: selectedGender,
                onChanged: (value) {
                  setState(() => selectedGender = value);
                },
              ),

              Text(
                option.localizedName,
                style: context.regular.copyWith(fontSize: 12),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuranSelector(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _quranOptions.map((option) {
          return Padding(
            padding: EdgeInsetsDirectional.only(
              end: option != _quranOptions.last ? 12 : 0,
            ),
            child: Row(
              children: [
                Radio<QuranMemorizeEnum>(
                  value: option,
                  // paddingInsets: const EdgeInsets.symmetric(vertical: 12,horizontal: 8),
                  groupValue: quranMemorize,
                  //title: option.localizedName,
                  //titleStyle: context.regular.copyWith(fontSize: 12),
                  onChanged: (value) {
                    setState(() => quranMemorize = value);
                  },
                ),

                Text(
                  option.localizedName,
                  style: context.regular.copyWith(fontSize: 12),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOrDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: context.appColors.neutral.shade500)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(appLocalizer.orAuth, style: context.regular),
        ),
        Expanded(child: Divider(color: context.appColors.neutral.shade500)),
      ],
    );
  }

  Widget _buildAlreadyHaveAccount(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(appLocalizer.haveAccount, style: context.regular),
        AppTextButton(
          onPressed: () {
            AppRouteNavigator.pop(context);
          },
          text: appLocalizer.loginBtn,
          textStyle: context.medium.copyWith(
            color: context.appColors.secondary.shade500,
          ),
        ),
      ],
    );
  }
}
