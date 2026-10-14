part of provider_profile;

@injectable
class GetProviderProfileUseCase {
  final ProviderProfileRepository _repository;

  GetProviderProfileUseCase(this._repository);

  Future<ProviderProfileEntity> call(String providerId) async {
    return await _repository.getProfile(providerId);
  }
}
