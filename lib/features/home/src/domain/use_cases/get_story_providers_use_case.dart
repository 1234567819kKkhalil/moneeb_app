part of home;

@injectable
class GetStoryProvidersUseCase {
  final HomeRepositories _repository;

  GetStoryProvidersUseCase(this._repository);

  Future<List<StoryProviderEntity>> execute() async {
    return await _repository.getStoryProviders();
  }
}
