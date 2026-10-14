part of notifications;

class NotificationsCubitState extends Equatable {
  final StateBox<List<NotificationItemEntity>> notifications;
  final StateBox<void> markReadStatus;
  final int notificationCount;

  const NotificationsCubitState({
    required this.notifications,
    required this.markReadStatus,
    required this.notificationCount,
  });

  factory NotificationsCubitState.initial() => const NotificationsCubitState(
        notifications: StateBox.initial(),
        markReadStatus: StateBox.initial(),
        notificationCount: 0,
      );

  NotificationsCubitState reduce({
    StateBox<List<NotificationItemEntity>>? notifications,
    StateBox<void>? markReadStatus,
    int? notificationCount,
  }) {
    return NotificationsCubitState(
      notifications: notifications ?? this.notifications,
      markReadStatus: markReadStatus ?? this.markReadStatus,
      notificationCount: notificationCount ?? this.notificationCount,
    );
  }

  @override
  List<Object?> get props => [
        notifications,
        markReadStatus,
        notificationCount,
      ];
}
