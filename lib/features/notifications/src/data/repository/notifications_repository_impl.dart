part of notifications;

@LazySingleton(as: NotificationsRepository)
class NotificationsRepositoryImpl implements NotificationsRepository {
  final DioHelper _dioHelper;

  NotificationsRepositoryImpl(this._dioHelper);

  @override
  Future<NotificationsResponse> getNotifications({
    bool unreadOnly = false,
    int? page,
    int? limit,
  }) async {
    final query = <String, dynamic>{
      'unreadOnly': unreadOnly,
    };
    if (page != null) query['page'] = page;
    if (limit != null) query['limit'] = limit;

    final response = await _dioHelper.get(
      NotificationsEndpoint.notifications,
      query: query,
    );

    final responseData = response.data?['data'];
    final items = ((responseData?['items'] ?? []) as List)
        .map((item) => NotificationItemEntity.fromJson(item))
        .toList();
    final meta = responseData?['meta'] != null
        ? NotificationMeta.fromJson(responseData['meta'])
        : NotificationMeta.initial();

    return NotificationsResponse(items: items, meta: meta);
  }

  @override
  Future<void> markAsRead(String id) async {
    await _dioHelper.patch(NotificationsEndpoint.markRead(id), data: null);
  }

  @override
  Future<void> markAllAsRead() async {
    await _dioHelper.patch(NotificationsEndpoint.markAllRead, data: null);
  }
}
