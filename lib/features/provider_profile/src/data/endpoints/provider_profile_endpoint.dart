part of provider_profile;

class ProviderProfileEndpoint {
  ProviderProfileEndpoint._();

  static const String publicProviders = 'providers/public';
  static String providerReviews(String providerId) => 'reviews/providers/$providerId';
}
