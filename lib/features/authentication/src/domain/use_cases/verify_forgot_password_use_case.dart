part of auth;

@injectable
class VerifyForgotPasswordUseCase {
  final AuthRepository _repository;

  VerifyForgotPasswordUseCase(this._repository);

  Future<String> execute(String sessionToken, String code) async {
    return await _repository.verifyForgotPassword(sessionToken, code);
  }
}
