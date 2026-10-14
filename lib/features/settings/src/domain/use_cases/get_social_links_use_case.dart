part of settings;

@injectable
class GetSocialLinksUseCase {
  final SettingsRepository repository;

  GetSocialLinksUseCase(this.repository);

  Future<SocialLinksModel> call() {
    return repository.getSocialLinks();
  }
}
