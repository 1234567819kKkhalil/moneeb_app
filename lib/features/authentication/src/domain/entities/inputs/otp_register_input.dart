part of auth;

/// Body for `POST /auth/otp/register` — completes signup after the identifier
/// was verified. The verified contact comes from the `signupToken`; here we
/// supply the OTHER contact plus profile fields.
class OtpRegisterInput {
  final String signupToken;
  final UserRoleEnum role;
  final String fullName;

  /// The contact NOT used for verification (email when verified via phone,
  /// phone when verified via email). May be null if not collected.
  final OtpIdentifier? otherContact;

  /// Optional — when set (min 8 chars) the account can also sign in with a
  /// password. Omitted entirely for OTP-only accounts.
  final String? password;

  final String? countryCode; // ISO 3166-1 alpha-2, e.g. "SA"
  final String languageCode; // e.g. "ar"
  final GenderEnum? gender; // "MALE" / "FEMALE"
  final bool? isHafiz; // provider only

  const OtpRegisterInput({
    required this.signupToken,
    required this.role,
    required this.fullName,
    required this.languageCode,
    this.otherContact,
    this.password,
    this.countryCode,
    this.gender,
    this.isHafiz,
  });

  Map<String, dynamic> toJson() => {
        'signupToken': signupToken,
        'role': role.toApi(),
        'fullName': fullName,
        'languageCode': languageCode,
        if (otherContact != null) ...otherContact!.toJson(),
        if (password != null && password!.isNotEmpty) 'password': password,
        if (countryCode != null && countryCode!.isNotEmpty)
          'countryCode': countryCode,
        if (gender != null) 'gender': gender!.toApi(),
        if (isHafiz != null) 'isHafiz': isHafiz,
      };
}
