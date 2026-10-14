part of auth;

@injectable
class CompleteProviderProfileUseCase {
  final AuthRepository _repository;

  CompleteProviderProfileUseCase(this._repository);

  Future<void> execute(CompleteProviderProfileInput input) async {
    await _repository.completeProviderProfile(input);
  }
}

