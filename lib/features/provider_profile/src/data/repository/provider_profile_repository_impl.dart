part of provider_profile;

@LazySingleton(as: ProviderProfileRepository)
class ProviderProfileRepositoryImpl extends ProviderProfileRepository {
  final DioHelper _dioHelper = injector<DioHelper>();

  @override
  Future<ProviderProfileEntity> getProfile(String providerId) async {
    final response = await _dioHelper.get('${ProviderProfileEndpoint.publicProviders}/$providerId');

    return ProviderProfileModel.fromJson(response.data['data']);
  }

  @override
  Future<List<ProviderReviewEntity>> getReviews(String providerId) async {
    final response = await _dioHelper.get(ProviderProfileEndpoint.providerReviews(providerId));

    if (response.data['data'] != null && response.data['data'] is List) {
      return (response.data['data'] as List)
          .map((item) => ProviderReviewModel.fromJson(item))
          .toList();
    }
    return [];
  }
}
