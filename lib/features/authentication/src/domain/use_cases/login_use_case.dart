part of auth;

@injectable
class LoginUseCase {
  final AuthRepository _repository;
  final SetFcmTokenUseCase _setFcmTokenUseCase;
  final TokenManager tokenManager;

  LoginUseCase(this._repository, this._setFcmTokenUseCase, this.tokenManager);

  Future<void> execute(LoginInput loginInput) async {
    final TokenEntity token = await _repository.login(
      loginInput
    );

    tokenManager.setTokenToLocalStorage(token);

    try{
      await _setFcmTokenUseCase.execute();
    } catch(e){
      log("FCM TOKEN SET ERROR: $e");
    }
  }
}
