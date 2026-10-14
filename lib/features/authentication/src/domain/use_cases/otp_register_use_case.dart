part of auth;

@injectable
class OtpRegisterUseCase {
  final AuthRepository _repository;
  final SetFcmTokenUseCase _setFcmTokenUseCase;
  final TokenManager _tokenManager;

  OtpRegisterUseCase(
    this._repository,
    this._setFcmTokenUseCase,
    this._tokenManager,
  );

  Future<void> execute(OtpRegisterInput input) async {
    final token = await _repository.otpRegister(input);

    _tokenManager.setTokenToLocalStorage(token);

    try {
      await _setFcmTokenUseCase.execute();
    } catch (e) {
      log("FCM TOKEN SET ERROR: $e");
    }
  }
}
