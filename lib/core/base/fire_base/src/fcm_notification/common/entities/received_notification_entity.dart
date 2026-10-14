import 'package:moneeb/features/omrah/provider/domain/models/enums/omrah_steps_enum.dart';
import 'package:moneeb/features/orders/user_orders/user_orders_imports.dart';

class ReceivedNotificationEntity {
  final String referenceOrderId;
  final OmrahStepsEnum? ritualStep;
  final UserOrderStatus? orderStatus;
  final String id;
  final String eventType;

  const ReceivedNotificationEntity({
    required this.referenceOrderId,
    required this.ritualStep,
    required this.orderStatus,
    required this.id,
    this.eventType = '',
  });

  /// The admin rejected the proof the provider uploaded for [ritualStep].
  bool get isProviderProofRejected =>
      eventType == 'RITUAL_PROOF_REJECTED_PROVIDER' &&
      ritualStep != null &&
      referenceOrderId.isNotEmpty;

  factory ReceivedNotificationEntity.fromJson(Map<String, dynamic> json) {
    return ReceivedNotificationEntity(
      referenceOrderId: json['referenceOrderId'] ??'',
      ritualStep: json['ritualStep'] == null
        ? null
        : OmrahStepsEnum.fromApi(json['ritualStep']),
      orderStatus: json['orderStatus'] == null
        ? null
        : UserOrderStatus.fromApi(json['orderStatus']),
      id: json['notificationId'] ??'',
      eventType: json['eventType'] ??'',
    );
  }
}