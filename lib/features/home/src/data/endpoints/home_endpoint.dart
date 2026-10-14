part of home;

class HomeEndpoint {
  HomeEndpoint._();

  static const String homeFeed = "feed/home";
  static const String stories = "stories";
  static const String storyProviders = "stories/home/providers";
  static String providerStories(String providerId) => "stories/provider/$providerId";
  static const String publicProviders = "providers/public";
  static const String banners = "banners";
  static const String streams = "streams";
  static String viewStory(String storyId) => "stories/$storyId/view";
}
