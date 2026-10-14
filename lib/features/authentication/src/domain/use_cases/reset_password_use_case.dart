part of auth;

@injectable
class ResetPasswordUseCase {
  final AuthRepository _repository;

  ResetPasswordUseCase(this._repository);

  Future<void> execute(String token, String password) async {
    await _repository.resetPassword(token, password);
  }
}
