part of auth;

@injectable
class DeleteUserAccountUseCase {
  final AuthRepository _repository;

  DeleteUserAccountUseCase(this._repository);

  Future<void> execute() async {
    await _repository.deleteAccount();
  }
}
