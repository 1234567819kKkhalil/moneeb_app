part of auth;

@injectable
class LogoutUseCase {
  final AuthRepository _repository;
  LogoutUseCase(this._repository,);

  Future<void> execute() async {
    await _repository.logout();
  }
}
