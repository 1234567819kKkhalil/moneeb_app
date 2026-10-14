part of edit_user_profile;

class EditUserProfileForm extends StatefulWidget {
  final AppUserModel? currentUser;

  const EditUserProfileForm({super.key, this.currentUser});

  @override
  State<EditUserProfileForm> createState() => _EditUserProfileFormState();
}

class _EditUserProfileFormState extends State<EditUserProfileForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();

  final List<GenderEnum> _genderOptions = [GenderEnum.male, GenderEnum.female];
  GenderEnum? _selectedGender;

  IntelPhoneCountry? _selectedCountry;
  PhoneNumber? _phoneNumber;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentUser?.fullName);
    _emailController = TextEditingController(text: widget.currentUser?.email);
    _selectedGender = widget.currentUser?.gender;
    if (widget.currentUser?.country != null &&
        widget.currentUser!.country.isNotEmpty) {
      _selectedCountry = countries.firstWhereOrNull(
        (c) => c.code == widget.currentUser!.country,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextFormField(
            controller: _nameController,
            labelText: appLocalizer.name,
            hint: appLocalizer.enterName,
            keyboardType: TextInputType.name,
            prefixIconType: PrefixIconType.name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return appLocalizer.serverError;
              }
              return null;
            },
          ),
          const Gap(PaddingDimensions.large),
          AppTextFormField(
            controller: _emailController,
            labelText: appLocalizer.email,
            hint: appLocalizer.enterEmail,
            keyboardType: TextInputType.emailAddress,
            prefixIconType: PrefixIconType.email,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return appLocalizer.serverError;
              }
              /* if (!AppConfig.emailValidate().hasMatch(value)) {
                return 'البريد الالكتروني غير صالح';
              } */
              return null;
            },
          ),
          const Gap(PaddingDimensions.large),
          Text(appLocalizer.phone, style: context.medium),
          const Gap(PaddingDimensions.small),
          PhoneField(
            hint: appLocalizer.mobileNumberHint,
            initialValue: widget.currentUser?.phone,
            onChange: (number) => _phoneNumber = number,
          ),
          const Gap(PaddingDimensions.large),
          AppTextFormField(
            key: ObjectKey(_selectedCountry),
            hint: appLocalizer.country,
            labelText: appLocalizer.country,
            readOnly: true,
            initialValue: injector<LocalizationContainer>().langCode.isArabic
                ? _selectedCountry?.arabicName
                : _selectedCountry?.name ?? '',
            onTap: () async {
              await AppBottomSheets.showAppBottomSheet(
                context,
                header: BottomSheetHeader(title: appLocalizer.selectCountry),
                builder: (context) => CountryPickerSheet(
                  filteredCountries: countries,
                  searchText: appLocalizer.search,
                  countryList: countries,
                  showNumbers: false,
                  selectedCountry: _selectedCountry ?? countries.first,
                  onCountryChanged: (IntelPhoneCountry country) {
                    setState(() {
                      _selectedCountry = country;
                    });
                  },
                ),
              );
            },
          ),
          const Gap(PaddingDimensions.xxLarge),
          Text(appLocalizer.gender, style: context.medium),
          const Gap(PaddingDimensions.small),
          _buildGenderSelector(context),
          const Gap(PaddingDimensions.xxLarge),
          BlocConsumer<EditUserProfileCubit, EditUserProfileState>(
            listenWhen: (previous, current) =>
                previous.updateProfileState != current.updateProfileState,
            listener: (context, state) {
              if (state.updateProfileState.isSuccess) {
                AppToasts.success(
                  context,
                  message: appLocalizer.updatedSuccessfully,
                ); // TODO: Localize
                // context.read<AuthenticationBloc>().add(FetchUserDataEvent());
                context.read<AuthenticationBloc>().modifyUserModel(
                  (user) => user.copyWith(
                    fullName: _nameController.text,
                    email: _emailController.text,
                    phoneCountryCode: _phoneNumber?.dialCodeWithPlus,
                    phoneNumber: _phoneNumber?.nationalNumber,
                    gender: _selectedGender,
                    country: _selectedCountry?.code,
                    avatarUrl: state.uploadedAvatarUrl,
                  ),
                );
                Navigator.pop(context); // Go back after successful update
              } else if (state.updateProfileState.isFailure) {
                AppToasts.error(
                  context,
                  message: state.updateProfileState.failure?.errorMessage ?? '',
                );
              }
            },
            buildWhen: (previous, current) =>
                previous.updateProfileState != current.updateProfileState,
            builder: (context, state) {
              return AppPrimaryButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;

                  final phone = _phoneNumber;
                  if (phone == null || phone.number.trim().isEmpty) {
                    AppToasts.error(
                      context,
                      message: appLocalizer.invalidPhoneNumber,
                    );
                    return;
                  }

                  context.read<EditUserProfileCubit>().saveProfile(
                    name: _nameController.text,
                    email: _emailController.text,
                    phone: phone,
                    gender: _selectedGender,
                    countryCode: _selectedCountry?.code,
                  );
                },
                text: appLocalizer.saveChanges,
                isLoading: state.updateProfileState.isLoading,
              );
            },
          ),
          const Gap(PaddingDimensions.large),
        ],
      ),
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
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() => _selectedGender = value);
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
}
