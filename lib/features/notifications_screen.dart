/*
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:moneeb/controller/notifications_controller.dart';
import 'package:moneeb/model/notification_event.dart';
import 'package:moneeb/utils/app_color.dart';
import 'package:moneeb/utils/app_config.dart';
import 'package:moneeb/utils/app_text.dart';
import 'package:moneeb/utils/date_util.dart';
import 'package:moneeb/widget/screens/notifications/notification_item.dart';

class NotificationsScreen extends StatelessWidget {
  final _controller = Get.find<NotificationsController>();
  NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              transform: const GradientRotation(500),
              tileMode: TileMode.mirror,
              stops: const [2, 5],
              begin: Alignment.topLeft,
              end: Alignment.bottomLeft,
              colors: [
                AppColors.colorBGMain,
                AppColors.colorBGSub,
              ],
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            toolbarHeight: 80,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: SvgPicture.asset(
                AppConfig.arrowBack(),
                fit: BoxFit.scaleDown,
              ),
            ),
            title: AppText.medium(
              text: 'الإشعارات',
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.colorBGMain,
              AppColors.colorBGSub,
            ],
          ),
        ),
        child: Obx(() {
          if (_controller.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 64,
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  AppText.medium(
                    text: 'لا توجد إشعارات',
                    fontSize: 16,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: _controller.notifications.length,
            itemBuilder: (_, index) {
              final NotificationEvent notification =
                  _controller.notifications[index];

              String newDate = '';
              bool isSameDate = false;

              final int currentTime =
                  notification.createdAt.millisecondsSinceEpoch;

              if ((index == 0 && _controller.notifications.length == 1) ||
                  index == _controller.notifications.length - 1) {
                newDate = DateUtil.getFormattedDateTime(
                  isToday: true,
                  time: currentTime,
                );
              } else {
                final DateTime timeMessage = notification.createdAt;
                final DateTime previousTimeMessage =
                    _controller.notifications[index + 1].createdAt;
                isSameDate = timeMessage.year == previousTimeMessage.year &&
                    timeMessage.month == previousTimeMessage.month &&
                    timeMessage.day == previousTimeMessage.day;

                newDate = isSameDate
                    ? ''
                    : DateUtil.getFormattedDateTime(
                        isToday: true,
                        time: currentTime,
                      );
              }

              return Column(
                children: [
                  if (newDate != '')
                    Center(
                      child: Card(
                        color: AppColors.colorAppMain,
                        margin: const EdgeInsets.all(4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 12,
                            left: 12,
                            top: 8,
                            bottom: 8,
                          ),
                          child: AppText.medium(text: newDate),
                        ),
                      ),
                    ),
                  NotificationItem(
                    notification: notification,
                    onTap: () {
                      if (!notification.isRead) {
                        _controller.markAsRead(notification.id);
                      }
                    },
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }
}
*/
