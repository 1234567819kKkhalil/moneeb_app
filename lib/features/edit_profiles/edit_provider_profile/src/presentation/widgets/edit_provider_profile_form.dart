part of edit_provider_profile;

class EditProviderProfileForm extends StatefulWidget {
  final AppUserModel? currentUser;

  const EditProviderProfileForm({super.key, this.currentUser});

  @override
  State<EditProviderProfileForm> createState() =>
      _EditProviderProfileFormState();
}

class _EditProviderProfileFormState extends State<EditProviderProfileForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  late final TextEditingController _bioController;
  late final TextEditingController _umrahCountController;
  late final TextEditingController _identificationNumberController;

  final _formKey = GlobalKey<FormState>();

  final List<GenderEnum> _genderOptions = [GenderEnum.male, GenderEnum.female];
  GenderEnum? _selectedGender;
  bool _isHafiz = false;

  IntelPhoneCountry? _selectedCountry;
  PhoneNumber? _phoneNumber;
  bool _hasProviderApprovalChanges = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentUser?.fullName);
    _emailController = TextEditingController(text: widget.currentUser?.email);

    _bioController = TextEditingController(
      text: widget.currentUser?.providerData?.bio,
    );
    _umrahCountController = TextEditingController(
      text: widget.currentUser?.providerData?.umrahCount.toString(),
    );
    _identificationNumberController = TextEditingController(
      text: widget.currentUser?.providerData?.identificationNumber,
    );
    _isHafiz = widget.currentUser?.providerData?.isHafiz ?? false;

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
    _bioController.dispose();
    _umrahCountController.dispose();
    _identificationNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            appLocalizer.accountInfo,
            style: context.bold.copyWith(
              color: context.appColors.primary.shade900,
            ),
          ),
          const Gap(PaddingDimensions.large),
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
          Text(
            appLocalizer.providerInfo,
            style: context.bold.copyWith(
              color: context.appColors.primary.shade900,
            ),
          ),
          const Gap(PaddingDimensions.large),

          AppTextFormField(
            controller: _identificationNumberController,
            labelText: appLocalizer.idNumber,
            hint: appLocalizer.enterIdNumber,
            keyboardType: TextInputType.number,
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
            controller: _umrahCountController,
            labelText: appLocalizer.previousUmrahCount,
            hint: appLocalizer.enterPreviousUmrahCount,
            keyboardType: TextInputType.number,
            prefixIconType: null,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return appLocalizer.serverError;
              }
              return null;
            },
          ),
          const Gap(PaddingDimensions.large),

          AppTextFormField(
            controller: _bioController,
            labelText: appLocalizer.bio,
            hint: appLocalizer.bioHint,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            prefixIconType: null,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return appLocalizer.serverError;
              }
              return null;
            },
          ),
          const Gap(PaddingDimensions.large),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(appLocalizer.isQuranHafiz, style: context.medium),
              Switch(
                value: _isHafiz,
                // activeColor: context.appColors.secondary.shade500,
                onChanged: (value) {
                  setState(() {
                    _isHafiz = value;
                  });
                  context.read<EditProviderProfileCubit>().setIsHafiz(value);
                },
              ),
            ],
          ),

          const Gap(PaddingDimensions.xxLarge),
          BlocConsumer<EditProviderProfileCubit, EditProviderProfileState>(
            listener: (context, state) {
              if (state.updateProfileState.isSuccess) {
                context.read<AuthenticationBloc>().modifyUserModel((user) {
                  final isOnlineUpdate = state.isOnline ?? user.providerData?.isOnline;
                  return user.copyWith(
                    fullName: _nameController.text,
                    email: _emailController.text,
                    phoneCountryCode: _phoneNumber?.dialCodeWithPlus,
                    phoneNumber: _phoneNumber?.nationalNumber,
                    gender: _selectedGender,
                    country: _selectedCountry?.code,
                    providerData: user.providerData?.copyWith(isOnline: isOnlineUpdate),
                  );
                });

                final needsPendingDialog = _hasProviderApprovalChanges || state.uploadedAvatarUrl != null;
                if (needsPendingDialog) {
                  _showPendingReviewDialog(context);
                } else {
                  AppToasts.success(context, message: appLocalizer.updatedSuccessfully);
                  Navigator.pop(context);
                }
              } else if (state.updateProfileState.isFailure) {
                AppToasts.error(
                  context,
                  message: state.updateProfileState.failure?.errorMessage ?? '',
                );
              }
            },
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

                  final currentIsOnline =
                      state.isOnline ??
                      widget.currentUser?.providerData?.isOnline;

                  final providerData = widget.currentUser?.providerData;
                  final changedBio = _bioController.text != (providerData?.bio ?? '')
                      ? _bioController.text : null;
                  final changedUmrahCount = _umrahCountController.text != (providerData?.umrahCount.toString() ?? '')
                      ? int.tryParse(_umrahCountController.text) : null;
                  final changedIdentification = _identificationNumberController.text != (providerData?.identificationNumber ?? '')
                      ? _identificationNumberController.text : null;
                  final changedIsHafiz = _isHafiz != (providerData?.isHafiz ?? false)
                      ? _isHafiz : null;

                  _hasProviderApprovalChanges = changedBio != null ||
                      changedUmrahCount != null ||
                      changedIdentification != null ||
                      changedIsHafiz != null;

                  context.read<EditProviderProfileCubit>().saveProfile(
                    name: _nameController.text,
                    email: _emailController.text,
                    phone: phone,
                    gender: _selectedGender,
                    countryCode: _selectedCountry?.code,
                    bio: changedBio,
                    umrahCount: changedUmrahCount,
                    identificationNumber: changedIdentification,
                    isHafiz: changedIsHafiz,
                    isOnline: currentIsOnline,
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

  void _showPendingReviewDialog(BuildContext context) {
    AppAlerts.showCustomDialog(
      context,
      canPop: false,
      showCloseButton: false,
      widget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primary100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_clock_rounded,
              size: 36,
              color: AppColors.primary600,
            ),
          ),
          const Gap(PaddingDimensions.large),
          Text(
            appLocalizer.profileChangesUnderReview,
            textAlign: TextAlign.center,
            style: context.bold.copyWith(
              fontSize: Dimensions.xxLarge,
              color: context.appColors.neutral.shade900,
            ),
          ),
          const Gap(PaddingDimensions.medium),
          Text(
            appLocalizer.profileChangesUnderReviewDescription,
            textAlign: TextAlign.center,
            style: context.regular.copyWith(
              color: context.appColors.neutral.shade500,
              height: 1.6,
            ),
          ),
          const Gap(PaddingDimensions.xLarge),
          AppPrimaryButton(
            text: appLocalizer.ok,
            onPressed: () {
              AppRouteNavigator.pop(context);
              Navigator.pop(context);
            },
          ),
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
