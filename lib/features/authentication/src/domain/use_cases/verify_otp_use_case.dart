// part of auth;
//
// @injectable
// class VerifyOtpUseCase {
//   final AuthRepository _authenticationRepository;
//   final TokenManager tokenManager;
//   final GetDeviceDetailsUseCase _getDeviceDetailsUseCase;
//
//   VerifyOtpUseCase(
//     this._authenticationRepository,
//     this.tokenManager,
//     this._getDeviceDetailsUseCase,
//   );
//
//   Future<AppUserModel> execute(VerifyOTP otp, {required OTPType type}) async {
//     final device = await _getDeviceDetailsUseCase.deviceDetails;
//     ApiAuthUserModel loginData;
//     TokenEntity? token;
//     final newOTPInput = VerifyOTP(
//       userId: otp.userId,
//       code: otp.code,
//       deviceDetails: device,
//     );
//
//     loginData = await _authenticationRepository.verifyEmailOTP(newOTPInput);
//     token = loginData.token?.toEntity();
//
//     if (token != null) {
//       tokenManager.setTokenToLocalStorage(token);
//     }
//
//     return loginData.apiAppUserModel.mapToAppUser();
//   }
// }
