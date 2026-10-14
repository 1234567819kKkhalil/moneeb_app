part of settings;

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  final DioHelper _dioHelper;
  SettingsRepositoryImpl(this._dioHelper);

  @override
  Future<AppSettingsModel> getAppSettings(String slug) async {
    final response = await _dioHelper.get(SettingsEndpoint.appSettings(slug));
    if (response.data != null && response.data['data'] != null) {
      return AppSettingsModel.fromJson(response.data['data']);
    }
    throw Exception('Failed to load settings');
  }

  @override
  Future<SocialLinksModel> getSocialLinks() async {
    final response = await _dioHelper.get(SettingsEndpoint.socialLinks);
    if (response.data != null && response.data['data'] != null) {
      return SocialLinksModel.fromJson(response.data['data']);
    }
    throw Exception('Failed to load social links');
  }

  @override
  Future<void> requestAccountDeletion() async {
    await _dioHelper.post(SettingsEndpoint.deletionRequest, data: {});
  }
}
