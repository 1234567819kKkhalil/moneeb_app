
import 'package:injectable/injectable.dart';
import 'package:moneeb/core/base/fire_base/src/fcm_notification/utils/notification_actions_observer/notification_actions_observer.dart';
import 'package:moneeb/features/omrah/provider/domain/models/enums/omrah_steps_enum.dart';
import 'package:moneeb/features/orders/user_orders/user_orders_imports.dart';

@lazySingleton
class NotificationActionsUpdater {
  NotificationActionsUpdater();

  final List<NotificationActionsObserver> _observers = [];

  void attachObserver<T>(NotificationActionsObserver observer){
    _observers.add(observer);
  }

  void deAttachObserver(NotificationActionsObserver observer){
    _observers.remove(observer);
  }

  void refreshOmrahPage(String orderId){
    for(var observer in _observers){
      observer.refreshOmrahPage?.call(orderId);
    }
  }

  void orderUpdated(String orderId, UserOrderStatus status){
    for(var observer in _observers){
      observer.orderUpdated?.call(orderId,status);
    }
  }

  /// Returns true when an open page of that order took care of it. A null [step]
  /// only refreshes that page without navigating anywhere.
  bool providerStepRejected(String orderId, OmrahStepsEnum? step){
    bool isHandled = false;
    for(var observer in [..._observers]){
      isHandled = (observer.providerStepRejected?.call(orderId, step) ?? false) || isHandled;
    }
    return isHandled;
  }
}
