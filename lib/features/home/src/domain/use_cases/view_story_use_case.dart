part of home;

@injectable
class ViewStoryUseCase {
  final HomeRepositories _repository;

  ViewStoryUseCase(this._repository);

  Future<void> execute(String storyId) async {
    return await _repository.viewStory(storyId);
  }
}
