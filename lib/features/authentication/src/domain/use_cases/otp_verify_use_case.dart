part of auth;

@injectable
class OtpVerifyUseCase {
  final AuthRepository _repository;
  final SetFcmTokenUseCase _setFcmTokenUseCase;
  final TokenManager _tokenManager;

  OtpVerifyUseCase(
    this._repository,
    this._setFcmTokenUseCase,
    this._tokenManager,
  );

  /// Verifies the code. When the account already exists the token pair is
  /// persisted (and FCM registered) before the result is returned so the
  /// caller can route straight to the app.
  Future<OtpVerifyResult> execute(OtpVerifyInput input) async {
    final result = await _repository.otpVerify(input);

    if (result is OtpAuthenticated) {
      _tokenManager.setTokenToLocalStorage(result.token);
      try {
        await _setFcmTokenUseCase.execute();
      } catch (e) {
        log("FCM TOKEN SET ERROR: $e");
      }
    }

    return result;
  }
}
