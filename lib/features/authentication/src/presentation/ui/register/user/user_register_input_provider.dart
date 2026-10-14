part of auth;

class RegisterInputProvider {
  /// Signup session token from `POST /auth/otp/verify` (registration_required).
  final String signupToken;

  /// The contact already verified via OTP (prefilled + locked in the form).
  final OtpIdentifier verifiedIdentifier;

  RegisterInputProvider({
    required this.signupToken,
    required this.verifiedIdentifier,
  }) {
    // Prefill the verified contact so it can be shown (and locked) in the form.
    if (verifiedIdentifier.isEmail) {
      emailController.text = verifiedIdentifier.email ?? '';
    }
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  // final TextEditingController passwordController = TextEditingController();
  // final TextEditingController confirmPasswordController = TextEditingController();

  PhoneNumber? phoneNumber;
  GenderEnum? selectedGender;
  Attachment? profilePicture;

  bool get verifiedViaEmail => verifiedIdentifier.isEmail;

  /// The pre-filled complete phone string when the phone was the verified
  /// contact (used as `PhoneField.initialValue`), otherwise null.
  String? get prefilledPhone => verifiedViaEmail
      ? null
      : '${verifiedIdentifier.phoneCountryCode ?? ''}${verifiedIdentifier.phoneNumber ?? ''}';

  /// Builds the `POST /auth/otp/register` body. The OTHER contact (the one not
  /// verified) is required by the backend; password is optional.
  OtpRegisterInput collectOtp(
    BuildContext context, {
    required UserRoleEnum role,
    bool? isHafiz,
  }) {
    OtpIdentifier? other;
    if (verifiedViaEmail) {
      final p = phoneNumber;
      if (p != null && p.number.trim().isNotEmpty) {
        other = OtpIdentifier.phone(
          countryCode: p.countryCode,
          number: p.number.trim(),
        );
      }
    } else {
      final email = emailController.text.trim();
      if (email.isNotEmpty) other = OtpIdentifier.email(email);
    }

    // final password = passwordController.text;

    return OtpRegisterInput(
      signupToken: signupToken,
      role: role,
      fullName: nameController.text.trim(),
      otherContact: other,
      // password: password.isEmpty ? null : password,
      countryCode: phoneNumber?.countryISOCode,
      languageCode: injector<LocalizationContainer>().langCode.name,
      gender: selectedGender,
      isHafiz: isHafiz,
    );
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    // passwordController.dispose();
    // confirmPasswordController.dispose();
    phoneNumber = null;
    selectedGender = null;
    profilePicture = null;
  }
}
