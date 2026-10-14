part of notifications;

class NotificationCard extends StatelessWidget {
  final NotificationItemEntity item;
  final VoidCallback? onTap;

  const NotificationCard({super.key, required this.item, this.onTap});

  /*
  String _getIconPath() {
    switch (item.iconType) {
      case NotificationIconType.success:
        return '${Const.icons}icon_notifications_accept.svg';
      case NotificationIconType.info:
      default:
        // We can reuse the default/info icon or fallback
        // For now, let's use the accept for success and reject for others as fallback from old code
        // or check if there's an info icon. In old code:
        // accepted -> icon_notifications_accept.svg
        // rejected -> icon_notifications_reject.svg
        // We'll use accept for SUCCESS, reject for ERROR, info for INFO if it exists
        return '${Const.icons}icon_notifications_accept.svg'; // Defaulting to one of the known icons or we can just use an Icon widget if it's missing
    }
  }
*/

  IconData _getIconData() {
    switch (item.iconType) {
      case NotificationIconType.success:
        return Icons.check_circle_outline;
      case NotificationIconType.error:
      case NotificationIconType.warning:
        return Icons.cancel_outlined;
      case NotificationIconType.info:
        return Icons.notifications_none_outlined;
    }
  }

  Color _getIconColor(BuildContext context) {
    if (item.isRead) {
      return context.appColors.neutral.shade50;
    }
    switch (item.iconType) {
      case NotificationIconType.success:
        return context.appColors.success.shade500;
      case NotificationIconType.error:
        return context.appColors.danger.shade500;
      case NotificationIconType.warning:
        return context
            .appColors
            .secondary
            .shade500; // Assuming warning is yellowish/gold
      case NotificationIconType.info:
        return context.appColors.primary.shade500;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        decoration: BoxDecoration(
          color: item.isRead
              ? context
                    .appColors
                    .neutral
                    .shade200 // Read background
              : context.appColors.primary.shade400, // Unread background
          borderRadius: BorderRadius.circular(18),
          /* border: Border.all(
            color: item.isRead
                ? context.appColors.neutral.shade200
                : context.appColors.primary.shade200,
            width: 1.5,
          ), */
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Container
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: /* item.isRead
                        ? */
                        context.appColors.neutral.shade900,
                    // : context.appColors.neutral.shade50,
                    // shape: BoxShape.circle,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getIconData(),
                    color: _getIconColor(context),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title ?? '',
                        style: context.medium.copyWith(
                          fontSize: 14,
                          fontWeight: item.isRead
                              ? FontWeight.w500
                              : FontWeight.bold,
                          color: context.appColors.neutral.shade900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.body ?? "",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: context.regular.copyWith(
                          fontSize: 12,
                          color: context.appColors.neutral.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (item.createdAt != null) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    item.createdAt!.prettySinceDate,
                    style: context.light.copyWith(
                      fontSize: 10,
                      color: context.appColors.neutral.shade500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
