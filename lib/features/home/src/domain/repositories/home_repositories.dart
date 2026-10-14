part of home;

abstract class HomeRepositories {
  Future<FeedData> getHomeFeed({required String lat, required String lng});
  Future<List<StoryProviderModel>> getStoryProviders();
  Future<List<StoryModel>> getProviderStories(String providerId);
  Future<List<ProviderModel>> getPublicProviders({
    int page = 1,
    int limit = 20,
    bool? verified,
    String? sortBy,
  });
  Future<List<BannerModel>> getBanners();
  Future<List<StreamModel>> getStreams();
  Future<void> viewStory(String storyId);
}
