part of settings;

class SettingsEndpoint {
  SettingsEndpoint._();

  static String appSettings(String slug) => 'app-settings/$slug';
  static const String socialLinks = 'app-settings/social-links';
  static const String deletionRequest = 'users/me/deletion-request';
}
