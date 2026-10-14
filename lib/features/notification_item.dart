/*
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moneeb/model/notification_event.dart';
import 'package:moneeb/utils/app_color.dart';
import 'package:moneeb/utils/app_text.dart';
import 'package:moneeb/utils/constants.dart';
import 'package:moneeb/utils/date_util.dart';

class NotificationItem extends StatelessWidget {
  final NotificationEvent notification;
  final VoidCallback? onTap;

  const NotificationItem({
    super.key,
    required this.notification,
    this.onTap,
  });

  String _notificationIcon() {
    if (notification.status == 'accepted') {
      return '${Const.icons}icon_notifications_accept.svg';
    } else {
      return '${Const.icons}icon_notifications_reject.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        decoration: BoxDecoration(
          color: notification.status == 'accepted'
              ? AppColors.colorAppMain
              : AppColors.colorNotifications,
          borderRadius: BorderRadius.circular(18),
          border: !notification.isRead
              ? Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5)
              : null,
        ),
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            Row(
              children: [
                SvgPicture.asset(_notificationIcon()),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.medium(
                        text: notification.title,
                        fontSize: 14,
                        fontWeight: notification.isRead
                            ? FontWeight.w500
                            : FontWeight.w700,
                      ),
                      const SizedBox(height: 4),
                      AppText.medium(
                        text: notification.body,
                        maxline: 3,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppText.medium(
              text: DateUtil.getFormattedDateTime(
                time: notification.createdAt.millisecondsSinceEpoch,
                isToday: false,
              ),
              fontSize: 10,
            ),
          ],
        ),
      ),
    );
  }
}
*/
