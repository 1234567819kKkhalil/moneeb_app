part of auth;

@injectable
class ForgotPasswordUseCase {
  final AuthRepository _repository;

  ForgotPasswordUseCase(this._repository);

  Future<String> execute(String emailOrPhone) async {
    return await _repository.forgotPassword(emailOrPhone);
  }
}
