part of notifications;

@injectable
class NotificationsCubit extends BaseCubit<NotificationsCubitState> {
  late final NotificationsRepository _repository;

  NotificationsCubit() : super(NotificationsCubitState.initial()) {
    _repository = injector();
  }

  Future<void> fetchNotifications({bool unreadOnly = false}) async {
    emit(state.reduce(notifications: const StateBox.loading()));
    await collect(
      task: () async {
        final responseData = await _repository.getNotifications(unreadOnly: unreadOnly);
        emit(state.reduce(
          notifications: StateBox.success(responseData.items),
          notificationCount: responseData.meta.totalItems,
        ));
      },
      onError: (failure) {
        emit(state.reduce(notifications: StateBox.failure(failure)));
      },
    );
  }

  Future<void> fetchNotificationCount() async {
    await collect(
      task: () async {
        final responseData = await _repository.getNotifications(
          unreadOnly: true,
          page: 1,
          limit: 1,
        );
        emit(state.reduce(notificationCount: responseData.meta.totalItems));
      },
      onError: (failure) {
        // Silent error for background count fetch
      },
    );
  }

  Future<void> markAsRead(String id) async {
    emit(state.reduce(markReadStatus: const StateBox.loading()));
    await collect(
      task: () async {
        await _repository.markAsRead(id);
        emit(state.reduce(markReadStatus: const StateBox.success(null)));
        
        // Update local state without fetching again
        final currentData = state.notifications.data;
        if (currentData != null) {
          final updatedList = currentData.map((item) {
            if (item.id == id) {
              return item.copyWith(isRead: true);
            }
            return item;
          }).toList();
          emit(state.reduce(
            notifications: StateBox.success(updatedList),
            notificationCount: (state.notificationCount - 1).clamp(0, 99999),
          ));
        } else {
          emit(state.reduce(
            notificationCount: (state.notificationCount - 1).clamp(0, 99999),
          ));
        }
      },
      onError: (failure) {
        emit(state.reduce(markReadStatus: StateBox.failure(failure)));
      },
    );
  }

  Future<void> markAllAsRead() async {
    emit(state.reduce(markReadStatus: const StateBox.loading()));
    await collect(
      task: () async {
        await _repository.markAllAsRead();
        emit(state.reduce(markReadStatus: const StateBox.success(null)));
        
        // Update local state without fetching again
        final currentData = state.notifications.data;
        if (currentData != null) {
          final updatedList = currentData.map((item) {
            return item.copyWith(isRead: true);
          }).toList();
          emit(state.reduce(
            notifications: StateBox.success(updatedList),
            notificationCount: 0,
          ));
        } else {
          emit(state.reduce(notificationCount: 0));
        }
      },
      onError: (failure) {
        emit(state.reduce(markReadStatus: StateBox.failure(failure)));
      },
    );
  }
}
