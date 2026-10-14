part of home;

@injectable
class GetHomeFeedUseCase {
  final HomeRepositories _repository;

  GetHomeFeedUseCase(this._repository);

  Future<FeedData> execute({required String lat, required String lng}) async {
    return await _repository.getHomeFeed(lat: lat, lng: lng);
  }
}
