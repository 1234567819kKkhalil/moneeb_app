part of auth;

/// Body for `POST /auth/otp/verify`.
class OtpVerifyInput {
  final String otpToken;
  final String code;

  const OtpVerifyInput({
    required this.otpToken,
    required this.code,
  });

  Map<String, dynamic> toJson() => {
        'otpToken': otpToken,
        'code': code,
      };
}
