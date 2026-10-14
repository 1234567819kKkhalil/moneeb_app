part of provider_profile;

abstract class ProviderProfileRepository {
  Future<ProviderProfileEntity> getProfile(String providerId);
  Future<List<ProviderReviewEntity>> getReviews(String providerId);
}
