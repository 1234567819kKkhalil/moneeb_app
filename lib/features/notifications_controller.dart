/*
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneeb/model/notification_event.dart';
import 'package:moneeb/services/fcm_service.dart';
import 'package:moneeb/utils/app_color.dart';
import 'package:moneeb/utils/app_log.dart';

class NotificationsController extends GetxController {
  final FCMService _fcmService = Get.find<FCMService>();

  final RxList<NotificationEvent> notifications = <NotificationEvent>[].obs;
  StreamSubscription<NotificationEvent>? _notificationSubscription;

  int get unreadCount =>
      notifications.where((n) => !n.isRead).length;

  @override
  void onInit() {
    super.onInit();
    _initializeFCM();
    _listenToNotifications();
  }

  void _initializeFCM() async {
    await _fcmService.initialize();
  }

  void _listenToNotifications() {
    _notificationSubscription =
        _fcmService.notificationStream.listen((notification) {
      AppLog.info('NotificationsController: New notification: ${notification.title}');

      // Add to beginning of list (newest first)
      notifications.insert(0, notification);

      // Show snackbar
      _showNotificationSnackbar(notification);
    });
  }

  void _showNotificationSnackbar(NotificationEvent notification) {
    if (Get.isSnackbarOpen) return;

    Get.snackbar(
      notification.title,
      notification.body,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.colorAppMain.withValues(alpha: 0.95),
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      icon: Icon(
        notification.status == 'accepted'
            ? Icons.check_circle_outline
            : notification.status == 'rejected'
                ? Icons.cancel_outlined
                : Icons.notifications_outlined,
        color: Colors.white,
      ),
    );
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index].isRead = true;
      notifications.refresh();
      // _socketService.markNotificationAsRead(id); // Removed as notification socket is replaced by FCM
    }
  }

  void markAllAsRead() {
    for (var notification in notifications) {
      notification.isRead = true;
    }
    notifications.refresh();
  }

  @override
  void onClose() {
    _notificationSubscription?.cancel();
    super.onClose();
  }
}
*/
