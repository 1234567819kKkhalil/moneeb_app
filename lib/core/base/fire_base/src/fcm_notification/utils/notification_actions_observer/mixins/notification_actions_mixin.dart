
import 'package:flutter/material.dart';
import 'package:moneeb/core/base/fire_base/src/fcm_notification/utils/notification_actions_observer/notification_actions_observer.dart';
import 'package:moneeb/features/omrah/provider/domain/models/enums/omrah_steps_enum.dart';
import 'package:moneeb/features/orders/user_orders/user_orders_imports.dart';

mixin NotificationActionsObserverMixin<T extends StatefulWidget> on State<T>{
  NotificationActionsObserver? _observer;

  void initNotificationActionsObserver({
    void Function(String orderId)? refreshOmrahPage,
    void Function(String orderId,UserOrderStatus status)? orderUpdated,
    bool Function(String orderId, OmrahStepsEnum? step)? providerStepRejected,
  }){
    _observer = NotificationActionsObserver(
      orderUpdated: orderUpdated,
      refreshOmrahPage: refreshOmrahPage,
      providerStepRejected: providerStepRejected,
    );
  }

  @override
  void dispose() {
    _observer?.dispose();
    _observer = null;
    super.dispose();
  }
}