part of auth;

class AuthEndpoint {
  AuthEndpoint._();

  static const String register = "auth/register";
  static const String login = "auth/login";
  static const String setFcmToken = "users/me/notification-preferences/register-device";
  static const String getProviderData = "providers/me";
  static const String getUserData = "users/me";

  static const String provideCompleteProfile = "providers/me/profile";

  static const String forgotPassword = "auth/forgot-password";
  static const String verifyForgotPassword = "auth/verify-forgot-password";
  static const String resetPassword = "auth/reset-password";

  // Unified passwordless OTP auth
  static const String otpConfig = "auth/otp-config";
  static const String otpStart = "auth/otp/start";
  static const String otpVerify = "auth/otp/verify";
  static const String otpRegister = "auth/otp/register";
  static const String otpResend = "auth/otp/resend";
}