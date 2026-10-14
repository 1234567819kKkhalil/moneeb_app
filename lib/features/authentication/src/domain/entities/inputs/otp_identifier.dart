part of auth;

/// A single login/registration identifier: either an email OR a phone
/// (`phoneCountryCode` + `phoneNumber`), as accepted by the `/auth/otp/*`
/// endpoints.
class OtpIdentifier extends Equatable {
  final String? email;
  final String? phoneCountryCode; // e.g. "+20"
  final String? phoneNumber; // national number, e.g. "500000000"

  const OtpIdentifier._({
    this.email,
    this.phoneCountryCode,
    this.phoneNumber,
  });

  const OtpIdentifier.email(String email)
      : this._(email: email);

  const OtpIdentifier.phone({
    required String countryCode,
    required String number,
  }) : this._(phoneCountryCode: countryCode, phoneNumber: number);

  bool get isEmail => email != null && email!.isNotEmpty;

  /// Human-readable representation shown on the OTP screen.
  String get display =>
      isEmail ? email! : '${phoneCountryCode ?? ''}${phoneNumber ?? ''}';

  /// The identifier fields for a request body (email OR phone pair).
  Map<String, dynamic> toJson() => isEmail
      ? {'email': email}
      : {
          'phoneCountryCode': phoneCountryCode,
          'phoneNumber': phoneNumber,
        };

  @override
  List<Object?> get props => [email, phoneCountryCode, phoneNumber];
}
