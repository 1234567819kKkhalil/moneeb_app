part of settings;

abstract class SettingsRepository {
  Future<AppSettingsModel> getAppSettings(String slug);
  Future<SocialLinksModel> getSocialLinks();
  Future<void> requestAccountDeletion();
}
