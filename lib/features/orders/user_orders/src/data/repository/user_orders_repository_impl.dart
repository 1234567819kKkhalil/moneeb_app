part of user_orders;

@LazySingleton(as: UserOrdersRepository)
class UserOrdersRepositoryImpl implements UserOrdersRepository {
  final DioHelper _dioHelper;

  UserOrdersRepositoryImpl(this._dioHelper);

  @override
  Future<PaginatedData<UserOrderEntity>> getUserOrders({
    UserOrderStatus? status,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dioHelper.get(
      UserOrdersEndpoint.orders,
      query: {
        if (status != null) 'status': status.toApi(),
        'as': 'REQUESTER',
        'page': page,
        'limit': limit,
      },
    );

    final data = response.data?['data'];
    final items = ((data?['items'] ?? []) as List)
        .map((item) => UserOrderEntity.fromJson(item))
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
  Future<void> cancelOrder(String id) async {
    await _dioHelper.patch(UserOrdersEndpoint.cancelOrder(id), data: null);
  }
}
