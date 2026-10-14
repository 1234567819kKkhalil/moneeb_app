import 'package:moneeb/core/base/localization/localization.dart';

enum ProviderOrderStatus {
  assigned,
  accepted,
  inProgress,
  pending,
  completed,
  rejected,
  cancelled;

  String toApi(){
    switch(this) {
      case ProviderOrderStatus.pending:
        return "PENDING";
      case ProviderOrderStatus.assigned:
        return "ASSIGNED";
      case ProviderOrderStatus.accepted:
        return "ACCEPTED";
      case ProviderOrderStatus.rejected:
        return "REJECTED";
      case ProviderOrderStatus.inProgress:
        return "IN_PROGRESS";
      case ProviderOrderStatus.completed:
        return "COMPLETED";
      case ProviderOrderStatus.cancelled:
        return "CANCELLED";
    }
  }


  String toLocalizedName(){
    switch(this) {
      case ProviderOrderStatus.pending:
        return appLocalizer.orderStatusWaiting;
      case ProviderOrderStatus.assigned:
        return appLocalizer.orderStatusAcceptReject;
      case ProviderOrderStatus.accepted:
        return appLocalizer.orderStatusApproved;
      case ProviderOrderStatus.rejected:
        return appLocalizer.orderStatusRejected;
      case ProviderOrderStatus.inProgress:
        return appLocalizer.orderStatusExecuting;
      case ProviderOrderStatus.completed:
        return appLocalizer.orderStatusCompleted;
      case ProviderOrderStatus.cancelled:
        return appLocalizer.orderStatusCanceled;
    }

  }
}
