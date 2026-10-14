part of home;

@LazySingleton(as: HomeRepositories)
class HomeRepositoriesImp extends HomeRepositories {
  final DioHelper _dioHelper = injector<DioHelper>();

  @override
  Future<FeedData> getHomeFeed({
    required String lat,
    required String lng,
  }) async {
    /* // ==================== FAKE TEST DATA ====================
    // Uncomment the block below and comment out the real API call
    // to test countdown auto-switch (sets next prayer 10 seconds from now).
    //
    // final now = DateTime.now();
    // final soon = now.add(const Duration(seconds: 10));
    // final later1 = now.add(const Duration(hours: 2));
    // final later2 = now.add(const Duration(hours: 5));
    // final later3 = now.add(const Duration(hours: 8));
    // final later4 = now.add(const Duration(hours: 11));
    // String _fmt(DateTime d) =>
    //     '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
    // return FeedData(
    //   prayerCountdown: PrayerCountdownData(
    //     nextPrayer: 'Fajr',
    //     timings: {
    //       'Fajr': _fmt(soon),
    //       'Dhuhr': _fmt(later1),
    //       'Asr': _fmt(later2),
    //       'Maghrib': _fmt(later3),
    //       'Isha': _fmt(later4),
    //     },
    //   ),
    //   events: [],
    // );
    // ==================== END FAKE TEST DATA ==================== */

    print('REQUEST URL: ${HomeEndpoint.homeFeed}?lat=$lat&lng=$lng');
    final response = await _dioHelper.get(
      HomeEndpoint.homeFeed,
      query: {'lat': lat, 'lng': lng},
    );

    print('RESPONSE for ${HomeEndpoint.homeFeed}: ${response.data}');

    if (response.data != null && response.data['data'] != null) {
      return FeedData.fromJson(response.data['data']);
    }
    return FeedData();
  }

  @override
  Future<List<StoryProviderModel>> getStoryProviders() async {
    print('REQUEST URL: ${HomeEndpoint.storyProviders}');
    final response = await _dioHelper.get(
      "${HomeEndpoint.storyProviders}?sort=newest",
    );

    print('RESPONSE for ${HomeEndpoint.storyProviders}: ${response.data}');

    if (response.data != null &&
        response.data['data'] != null &&
        response.data['data']['items'] is List) {
      final list = (response.data['data']['items'] as List)
          .map((e) => StoryProviderModel.fromJson(e))
          .toList();
      print('Parsed story providers count: ${list.length}');
      return list;
    }
    return [];
  }

  @override
  Future<List<StoryModel>> getProviderStories(String providerId) async {
    final endpoint = HomeEndpoint.providerStories(providerId);
    print('REQUEST URL: $endpoint');
    final response = await _dioHelper.get(endpoint);

    print('RESPONSE for $endpoint: ${response.data}');

    if (response.data != null &&
        response.data['data'] != null &&
        response.data['data']['items'] is List) {
      final list = (response.data['data']['items'] as List)
          .map((e) => StoryModel.fromJson(e))
          .toList();
      print('Parsed provider stories count: ${list.length}');
      return list;
    }
    return [];
  }

  @override
  Future<List<ProviderModel>> getPublicProviders({
    int page = 1,
    int limit = 20,
    bool? verified,
    String? sortBy,
  }) async {
    final query = <String, dynamic>{'page': page, 'limit': limit};
    if (verified != null) query['verified'] = verified;
    if (sortBy != null) query['sortBy'] = sortBy;

    final response = await _dioHelper.get(
      HomeEndpoint.publicProviders,
      query: query,
    );

    if (response.data != null &&
        response.data['data'] != null &&
        response.data['data']['items'] is List) {
      return (response.data['data']['items'] as List)
          .map((item) => ProviderModel.fromJson(item))
          .toList();
    }
    return [];
  }

  @override
  Future<List<BannerModel>> getBanners() async {
    final response = await _dioHelper.get(
      HomeEndpoint.banners,
      query: {'limit': 20, 'offset': 0},
    );

    if (response.data != null &&
        response.data['data'] != null &&
        response.data['data']['items'] is List) {
      return (response.data['data']['items'] as List)
          .map((item) => BannerModel.fromJson(item))
          .toList();
    }
    return [];
  }

  @override
  Future<List<StreamModel>> getStreams() async {
    final response = await _dioHelper.get(
      HomeEndpoint.streams,
      query: {'limit': 20, 'offset': 0},
    );

    if (response.data != null &&
        response.data['data'] != null &&
        response.data['data']['items'] is List) {
      return (response.data['data']['items'] as List)
          .map((item) => StreamModel.fromJson(item))
          .toList();
    }
    return [];
  }

  @override
  Future<void> viewStory(String storyId) async {
    await _dioHelper.post(HomeEndpoint.viewStory(storyId), data: {});
  }
}
