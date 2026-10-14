part of notifications;

abstract class NotificationsRepository {
  Future<NotificationsResponse> getNotifications({bool unreadOnly = false, int? page, int? limit});
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
}
