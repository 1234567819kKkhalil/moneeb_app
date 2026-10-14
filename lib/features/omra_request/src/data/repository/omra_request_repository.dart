part of omra_request;

abstract class OmraRequestRepository {
  Future<CreateOrderResponse> createOrder({
    required String beneficiaryType,
    required String beneficiaryName,
    required String beneficiaryGender,
    required String customDua,
    required String targetDate,
    String? preferredProviderId,
  });

  Future<PaginatedData<ProviderEntity>> getPublicProviders({
    required int page,
    int limit = 20,
    String? search,
    bool? isOnline,
  });
}

@LazySingleton(as: OmraRequestRepository)
class OmraRequestRepositoryImpl implements OmraRequestRepository {
  final DioHelper _dioHelper;

  OmraRequestRepositoryImpl(this._dioHelper);

  @override
  Future<CreateOrderResponse> createOrder({
    required String beneficiaryType,
    required String beneficiaryName,
    required String beneficiaryGender,
    required String customDua,
    required String targetDate,
    String? preferredProviderId,
  }) async {
    final data = <String, dynamic>{
      "beneficiaryType": beneficiaryType,
      "beneficiaryName": beneficiaryName,
      "beneficiaryGender": beneficiaryGender,
      "customDua": customDua,
      "targetDate": targetDate,
    };

    if (preferredProviderId != null && preferredProviderId.isNotEmpty) {
      data["preferredProviderId"] = preferredProviderId;
    }

    final response = await _dioHelper.post(
      OmraRequestEndpoint.createOrder,
      data: data,
    );

    return CreateOrderResponse.fromJson(
      response.data?["data"] ?? response.data ?? {},
    );
  }

  @override
  Future<PaginatedData<ProviderEntity>> getPublicProviders({
    required int page,
    int limit = 20,
    String? search,
    bool? isOnline,
  }) async {
    final query = <String, dynamic>{'page': page, 'limit': limit};
    if (search != null && search.isNotEmpty) query['search'] = search;
    if (isOnline != null) query['online'] = isOnline;

    final response = await _dioHelper.get(
      OmraRequestEndpoint.publicProviders,
      query: query,
    );

    if (response.data != null && response.data['data'] != null) {
      final data = response.data['data'];
      final items = (data['items'] as List)
          .map((item) => ProviderModel.fromJson(item))
          .toList();
      final pageInfo = PageInfo(
        page: data['page'] ?? page,
        limit: limit,
        totalCount: data['total'] ?? 0,
        hasNext: (data['page'] ?? page) < (data['totalPages'] ?? 1),
      );
      return PaginatedData(items: items, pageInfo: pageInfo);
    }

    return const PaginatedData.initial();
  }
}
