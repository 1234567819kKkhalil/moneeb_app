part of auth;


@injectable
class UserRegisterUseCase {
  final AuthRepository _authenticationRepository;
  final SetFcmTokenUseCase _setFcmTokenUseCase;
  final TokenManager _tokenManager;

  UserRegisterUseCase(this._authenticationRepository, this._setFcmTokenUseCase, this._tokenManager);

  Future<void> execute(RegisterInput input,) async {
    final tokenModel = await _authenticationRepository.register(input);

    _tokenManager.setTokenToLocalStorage(tokenModel);

    try{
      await _setFcmTokenUseCase.execute();
    } catch(e){
      log("FCM TOKEN SET ERROR: $e");
    }
  }
}