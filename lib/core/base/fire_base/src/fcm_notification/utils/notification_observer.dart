part of fire_base;

// To Handle Notification Updates counts
class NotificationObserver{
  final Function(int newCount, bool reset)? onNotificationUpdates;

  NotificationObserver({required this.onNotificationUpdates}) {
    LocalNotificationService.instance.attachObserver(this);
  }

  void dispose() {
    LocalNotificationService.instance.deAttachObserver(this);
  }
}