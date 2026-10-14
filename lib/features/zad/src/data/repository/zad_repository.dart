part of zad;

abstract class ZadRepository {
  Future<List<AzkarSectionModel>> getAzkarSections();
  Future<AzkarContentModel> getAzkarContent(String slug);
  Future<List<DuaModel>> getDua();
  Future<List<TasbeehPresetModel>> getTasbeehPresets();
  Future<PrayerTimesModel> getPrayerTimes({required String lat, required String lng, required String date});
  Future<HomeFeedModel> getHomeFeed({required String lat, required String lng});
  Future<List<EventModel>> getIslamicEvents();
}
