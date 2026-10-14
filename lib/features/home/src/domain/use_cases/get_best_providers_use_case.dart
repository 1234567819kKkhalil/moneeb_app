part of home;

@injectable
class GetBestProvidersUseCase {
  final HomeRepositories _repository;

  GetBestProvidersUseCase(this._repository);

  Future<List<ProviderModel>> execute() async {
    return await _repository.getPublicProviders(sortBy: 'best');
  }
}
