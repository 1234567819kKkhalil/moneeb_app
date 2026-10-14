part of home;

@injectable
class GetProviderStoriesUseCase {
  final HomeRepositories _repository;

  GetProviderStoriesUseCase(this._repository);

  Future<List<StoryEntity>> execute(String providerId) async {
    return await _repository.getProviderStories(providerId);
  }
}
