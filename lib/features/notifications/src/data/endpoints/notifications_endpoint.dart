part of notifications;

class NotificationsEndpoint {
  NotificationsEndpoint._();

  static const String notifications = "/notifications";
  static String markRead(String id) => "/notifications/$id/read";
  static const String markAllRead = "/notifications/read-all";
}
