part of settings;

@injectable
class GetAppSettingsUseCase {
  final SettingsRepository repository;

  GetAppSettingsUseCase(this.repository);

  Future<AppSettingsModel> call(String slug) {
    return repository.getAppSettings(slug);
  }
}
