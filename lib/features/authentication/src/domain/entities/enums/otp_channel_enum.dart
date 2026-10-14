part of auth;

/// Verification channel used by the unified passwordless OTP flow
/// (`/auth/otp/*`). Mirrors the backend `channel` enum.
enum OtpChannel {
  whatsapp,
  sms,
  call,
  email;

  /// Parses the backend channel string. Returns `null` for unknown values.
  static OtpChannel? fromApi(String? value) {
    switch (value) {
      case 'whatsapp':
        return OtpChannel.whatsapp;
      case 'sms':
        return OtpChannel.sms;
      case 'call':
        return OtpChannel.call;
      case 'email':
        return OtpChannel.email;
      default:
        return null;
    }
  }

  /// Value sent to the backend (`whatsapp` | `sms` | `call` | `email`).
  String toApi() => name;

  /// Whether this channel delivers to a phone (everything except email).
  bool get isPhoneChannel => this != OtpChannel.email;

  String get localizedName {
    switch (this) {
      case OtpChannel.whatsapp:
        return appLocalizer.otpChannelWhatsapp;
      case OtpChannel.sms:
        return appLocalizer.otpChannelSms;
      case OtpChannel.call:
        return appLocalizer.otpChannelCall;
      case OtpChannel.email:
        return appLocalizer.otpChannelEmail;
    }
  }
}
