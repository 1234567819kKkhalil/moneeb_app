part of auth;

abstract class AuthRepository {
  Future<TokenEntity> login(LoginInput input);
  Future<TokenEntity> register(RegisterInput input);
  Future<void> completeProviderProfile(CompleteProviderProfileInput input);

  Future<void> setFcmToken(String fcm);
  Future<void> sendOTP();
  Future<void> updateFcmToken(String fcmToken);
  Future<void> logout();
  Future<void> deleteAccount();
  Future<AppUserModel> getUserData();

  Future<String> forgotPassword(String emailOrPhone);
  Future<String> verifyForgotPassword(String sessionToken, String code);
  Future<void> resetPassword(String token, String password);

  // Unified passwordless OTP auth (/auth/otp/*)
  Future<OtpConfig> getOtpConfig();
  Future<OtpStartResult> otpStart(OtpStartInput input);
  Future<OtpVerifyResult> otpVerify(OtpVerifyInput input);
  Future<TokenEntity> otpRegister(OtpRegisterInput input);
  Future<OtpChannel?> otpResend(String otpToken);
}
