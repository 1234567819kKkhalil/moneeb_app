part of home;

@injectable
class GetVerifiedProvidersUseCase {
  final HomeRepositories _repository;

  GetVerifiedProvidersUseCase(this._repository);

  Future<List<ProviderModel>> execute() async {
    return await _repository.getPublicProviders(verified: true);
  }
}
