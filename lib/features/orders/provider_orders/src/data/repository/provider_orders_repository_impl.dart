part of provider_orders;

@LazySingleton(as: ProviderOrdersRepository)
class ProviderOrdersRepositoryImpl implements ProviderOrdersRepository {
  final DioHelper _dioHelper;

  ProviderOrdersRepositoryImpl(this._dioHelper);

  @override
  Future<PaginatedData<ProviderOrderEntity>> getProviderOrders({
    ProviderOrderStatus? status,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dioHelper.get(
      ProviderOrdersEndpoint.orders,
      query: {
        if (status != null) 'status': status.toApi(),
        'as': 'PROVIDER',
        'page': page,
        'limit': limit,
      },
    );

    final data = response.data?['data'];
    final items = ((data?['items'] ?? []) as List)
        .map((item) => ProviderOrderEntity.fromJson(item))
        .toList();

    final meta = data?['meta'];
    final metaPage = meta?['page'] ?? page;
    final totalPages = meta?['totalPages'] ?? 1;

    return PaginatedData(
      items: items,
      pageInfo: PageInfo(
        page: metaPage,
        limit: meta?['limit'] ?? limit,
        hasNext: metaPage < totalPages,
        totalCount: meta?['totalItems'] ?? items.length,
      ),
    );
  }

  @override
  Future<void> acceptOrder(String id) async {
    await _dioHelper.patch(
      ProviderOrdersEndpoint.acceptOrder(id),
      data: null
    );
  }

  @override
  Future<void> cancelOrder(String id) async {
    await _dioHelper.patch(
      ProviderOrdersEndpoint.cancelOrder(id),
      data: null
    );
  }

  @override
  Future<void> rejectOrder(String id, String reason) async {
    await _dioHelper.patch(
      ProviderOrdersEndpoint.rejectOrder(id),
      data: {
        "reason": reason
      }
    );
  }

  @override
  Future<void> completeOrder(String id) async {
    await _dioHelper.patch(
      ProviderOrdersEndpoint.completeOrder(id),
      data: null
    );
  }

  @override
  Future<String> generateCertificate(String id) async {
    final response = await _dioHelper.post(
      ProviderOrdersEndpoint.orderCertificate(id),
      data: null,
    );

    final certificateUrl = response.data?['data']?['certificateUrl'] as String?;

    if (certificateUrl == null || certificateUrl.isEmpty) {
      throw ServerFailure(appLocalizer.unexpectedError);
    }

    return certificateUrl;
  }

  @override
  Future<List<OrderCertificateEntity>> getMyCertificates() async {
    final response = await _dioHelper.get(
      ProviderOrdersEndpoint.myCertificates,
    );

    return ((response.data?['data'] ?? []) as List)
        .map((item) => OrderCertificateEntity.fromJson(item))
        .toList();
  }

  @override
  Future<void> downloadCertificate({
    required String url,
    required String savePath,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    await _dioHelper.downloadFile(
      url: url.isNetwork ? url : url.addBaseUrl,
      path: savePath,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
    );
  }
}
