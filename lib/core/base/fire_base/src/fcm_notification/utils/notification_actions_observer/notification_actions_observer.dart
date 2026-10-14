
import 'package:moneeb/core/base/di/data_injector.dart';
import 'package:moneeb/core/base/fire_base/src/fcm_notification/utils/notification_actions_observer/notification_actions_updater.dart';
import 'package:moneeb/features/omrah/provider/domain/models/enums/omrah_steps_enum.dart';
import 'package:moneeb/features/orders/user_orders/user_orders_imports.dart';

class NotificationActionsObserver {
  final void Function(String orderId)? refreshOmrahPage;
  final void Function(String orderId,UserOrderStatus status)? orderUpdated;

  /// Returns whether this observer showed the rejected step to the provider.
  final bool Function(String orderId, OmrahStepsEnum? step)? providerStepRejected;

  NotificationActionsObserver({
    required this.refreshOmrahPage,
    required this.orderUpdated,
    this.providerStepRejected,
  }) {
    injector<NotificationActionsUpdater>().attachObserver(this);
  }

  void dispose() {
    injector<NotificationActionsUpdater>().deAttachObserver(this);
  }
}
