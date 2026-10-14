part of notifications;

class NotificationsPage extends StatelessWidget {
  static const String routeName = "/notificationsPage";
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsCubit()..fetchNotifications(),
      child: const _NotificationsPageBody(),
    );
  }
}

class _NotificationsPageBody extends StatelessWidget {
  const _NotificationsPageBody({super.key});

  Future<void> _onRefresh(BuildContext context) async {
    return context.read<NotificationsCubit>().fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.appBackgroundColor,
      appBar: AppBars.defaultBar(
        context,
        text:
            appLocalizer.notifications, // todo: l10n appLocalizer.notifications
        centerTitle: true,
        useCloseButton: true,
        actions: [
          BlocBuilder<NotificationsCubit, NotificationsCubitState>(
            builder: (context, state) {
              if (state.notifications.isSuccess &&
                  (state.notifications.data ?? []).any(
                    (element) => !element.isRead,
                  )) {
                return IconButton(
                  icon: Icon(
                    Icons.done_all,
                    color: context.appColors.neutral.shade900,
                  ),
                  tooltip: appLocalizer.markAllAsRead, // todo: l10n
                  onPressed: () {
                    context.read<NotificationsCubit>().markAllAsRead();
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocConsumer<NotificationsCubit, NotificationsCubitState>(
        listenWhen: (previous, current) =>
            previous.markReadStatus != current.markReadStatus,
        listener: (context, state) {
          if (state.markReadStatus.isFailure) {
            AppToasts.error(
              context,
              message: state.markReadStatus.failure?.errorMessage ?? '',
            );
          }
        },
        buildWhen: (previous, current) =>
            previous.notifications != current.notifications,
        builder: (context, state) {
          if (state.notifications.isFailure) {
            return FailureWidget(
              failure: state.notifications.failure,
              onRetryPressed: () {
                context.read<NotificationsCubit>().fetchNotifications();
              },
            );
          }

          if (state.notifications.isSuccess) {
            final items = state.notifications.data ?? [];
            if (items.isEmpty) {
              return Center(
                child: NoItemsFoundWidget(
                  enableRefreshSupport: true,
                  text: appLocalizer.noNotifications, // todo: l10n
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => _onRefresh(context),
              child: ListView.separated(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ).copyWith(bottom: context.height * 0.1),
                itemCount: items.length,
                separatorBuilder: (context, index) => const Gap(12),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return NotificationCard(
                    item: item,
                    onTap: () {
                      if (!item.isRead) {
                        context.read<NotificationsCubit>().markAsRead(item.id);
                      }
                      NotificationRouter.route(context, item);
                    },
                  );
                },
              ),
            );
          }

          // Loading state
          return AppSkeletonizer(
            isEnabled: true,
            child: ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: 8,
              separatorBuilder: (context, index) => const Gap(12),
              itemBuilder: (context, index) {
                return NotificationCard(item: NotificationItemEntity.initial());
              },
            ),
          );
        },
      ),
    );
  }
}
