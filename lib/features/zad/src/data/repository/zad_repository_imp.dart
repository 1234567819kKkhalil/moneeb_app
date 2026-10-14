part of zad;

@LazySingleton(as: ZadRepository)
class ZadRepositoryImpl implements ZadRepository {
  final DioHelper _dioHelper;

  ZadRepositoryImpl(this._dioHelper);

  @override
  Future<List<AzkarSectionModel>> getAzkarSections() async {
    final response = await _dioHelper.get(ZadEndpoint.azkarSections);

    if (response.data != null && response.data['data'] is List) {
      return (response.data['data'] as List)
          .map((item) => AzkarSectionModel.fromJson(item))
          .toList();
    }
    return [];
  }

  @override
  Future<AzkarContentModel> getAzkarContent(String slug) async {
    final response = await _dioHelper.get(ZadEndpoint.azkar(slug));

    if (response.data != null && response.data['data'] != null) {
      return AzkarContentModel.fromJson(response.data['data']);
    }

    throw Exception('Failed to load azkar content');
  }

  @override
  Future<List<DuaModel>> getDua() async {
    final response = await _dioHelper.get(ZadEndpoint.dua);

    if (response.data != null && response.data['data'] is List) {
      return (response.data['data'] as List)
          .map((item) => DuaModel.fromJson(item))
          .toList();
    }
    return [];
  }

  @override
  Future<List<TasbeehPresetModel>> getTasbeehPresets() async {
    final response = await _dioHelper.get(ZadEndpoint.tasbeehPresets);

    if (response.data != null && response.data['data'] is List) {
      return (response.data['data'] as List)
          .map((item) => TasbeehPresetModel.fromJson(item))
          .toList();
    }
    return [];
  }

  @override
  Future<PrayerTimesModel> getPrayerTimes({
    required String lat,
    required String lng,
    required String date,
  }) async {
    final response = await _dioHelper.get(
      ZadEndpoint.prayerTimes,
      query: {'lat': lat, 'lng': lng, 'date': date},
    );
    if (response.data != null && response.data['data'] != null) {
      return PrayerTimesModel.fromJson(response.data['data']);
    }
    return PrayerTimesModel.initial();
  }

  @override
  Future<HomeFeedModel> getHomeFeed({
    required String lat,
    required String lng,
  }) async {
    final response = await _dioHelper.get(
      ZadEndpoint.homeFeed,
      query: {'lat': lat, 'lng': lng},
    );

    if (response.data != null && response.data['data'] != null) {
      return HomeFeedModel.fromJson(response.data['data']);
    }
    return HomeFeedModel.initial();
  }

  @override
  Future<List<EventModel>> getIslamicEvents() async {
    final response = await _dioHelper.get(ZadEndpoint.islamicEvents);

    if (response.data != null && response.data['data'] is List) {
      return (response.data['data'] as List)
          .map((item) => EventModel.fromJson(item))
          .toList();
    }
    return [];
  }
}
