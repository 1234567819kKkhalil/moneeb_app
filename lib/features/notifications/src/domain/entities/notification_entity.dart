part of notifications;

enum NotificationIconType {
  success,
  info,
  warning,
  error;

  String toApi() {
    switch (this) {
      case NotificationIconType.success:
        return "SUCCESS";
      case NotificationIconType.info:
        return "INFO";
      case NotificationIconType.warning:
        return "WARNING";
      case NotificationIconType.error:
        return "ERROR";
    }
  }

  static NotificationIconType fromApi(String? val) {
    if (val == "SUCCESS") return NotificationIconType.success;
    if (val == "WARNING") return NotificationIconType.warning;
    if (val == "ERROR") return NotificationIconType.error;
    return NotificationIconType.info;
  }
}

// ─── NotificationEventType ────────────────────────────────────────────────────

enum NotificationEventType {
  orderCreated,
  orderProviderAssigned,
  orderAccepted,
  orderRejected,
  orderCancelled,
  orderCancelledByAdmin,
  orderCompleted,
  orderAcceptDeadlineWarn,
  orderReassignedAfterTimeout,
  orderRitualDeadlineWarn,
  orderRitualDeadlineRequesterWarn,
  orderReassignedAfterRitualDeadline,
  orderAssignmentDelayed,
  ritualProofUploaded,
  ritualGpsVerified,
  ritualGpsFailed,
  ritualStepValidated,
  ritualProofRejectedProvider,
  ritualProofRejectedRequester,
  ritualAdminNote,
  ritualForceValidated,
  ritualVideoBrandingReady,
  paymentConfirmed,
  paymentAdminReceived,
  walletCredit,
  walletTransferOut,
  walletWithdrawalRejected,
  tasbeehWeeklyReport,
  tasbeehStreak,
  providerRegistrationApproved,
  providerRegistrationRejected,
  adminBroadcast,
  unknown;

  static NotificationEventType fromApi(String? val) {
    switch (val) {
      case 'ORDER_CREATED':
        return NotificationEventType.orderCreated;
      case 'ORDER_PROVIDER_ASSIGNED':
        return NotificationEventType.orderProviderAssigned;
      case 'ORDER_ACCEPTED':
        return NotificationEventType.orderAccepted;
      case 'ORDER_REJECTED':
        return NotificationEventType.orderRejected;
      case 'ORDER_CANCELLED':
        return NotificationEventType.orderCancelled;
      case 'ORDER_CANCELLED_BY_ADMIN':
        return NotificationEventType.orderCancelledByAdmin;
      case 'ORDER_COMPLETED':
        return NotificationEventType.orderCompleted;
      case 'ORDER_ACCEPT_DEADLINE_WARN':
        return NotificationEventType.orderAcceptDeadlineWarn;
      case 'ORDER_REASSIGNED_AFTER_TIMEOUT':
        return NotificationEventType.orderReassignedAfterTimeout;
      case 'ORDER_RITUAL_DEADLINE_WARN':
        return NotificationEventType.orderRitualDeadlineWarn;
      case 'ORDER_RITUAL_DEADLINE_REQUESTER_WARN':
        return NotificationEventType.orderRitualDeadlineRequesterWarn;
      case 'ORDER_REASSIGNED_AFTER_RITUAL_DEADLINE':
        return NotificationEventType.orderReassignedAfterRitualDeadline;
      case 'ORDER_ASSIGNMENT_DELAYED':
        return NotificationEventType.orderAssignmentDelayed;
      case 'RITUAL_PROOF_UPLOADED':
        return NotificationEventType.ritualProofUploaded;
      case 'RITUAL_GPS_VERIFIED':
        return NotificationEventType.ritualGpsVerified;
      case 'RITUAL_GPS_FAILED':
        return NotificationEventType.ritualGpsFailed;
      case 'RITUAL_STEP_VALIDATED':
        return NotificationEventType.ritualStepValidated;
      case 'RITUAL_PROOF_REJECTED_PROVIDER':
        return NotificationEventType.ritualProofRejectedProvider;
      case 'RITUAL_PROOF_REJECTED_REQUESTER':
        return NotificationEventType.ritualProofRejectedRequester;
      case 'RITUAL_ADMIN_NOTE':
        return NotificationEventType.ritualAdminNote;
      case 'RITUAL_FORCE_VALIDATED':
        return NotificationEventType.ritualForceValidated;
      case 'RITUAL_VIDEO_BRANDING_READY':
        return NotificationEventType.ritualVideoBrandingReady;
      case 'PAYMENT_CONFIRMED':
        return NotificationEventType.paymentConfirmed;
      case 'PAYMENT_ADMIN_RECEIVED':
        return NotificationEventType.paymentAdminReceived;
      case 'WALLET_CREDIT':
        return NotificationEventType.walletCredit;
      case 'WALLET_TRANSFER_OUT':
        return NotificationEventType.walletTransferOut;
      case 'WALLET_WITHDRAWAL_REJECTED':
        return NotificationEventType.walletWithdrawalRejected;
      case 'TASBEEH_WEEKLY_REPORT':
        return NotificationEventType.tasbeehWeeklyReport;
      case 'TASBEEH_STREAK':
        return NotificationEventType.tasbeehStreak;
      case 'PROVIDER_REGISTRATION_APPROVED':
        return NotificationEventType.providerRegistrationApproved;
      case 'PROVIDER_REGISTRATION_REJECTED':
        return NotificationEventType.providerRegistrationRejected;
      case 'ADMIN_BROADCAST':
        return NotificationEventType.adminBroadcast;
      default:
        return NotificationEventType.unknown;
    }
  }

  bool get isOrderEvent {
    return [
      NotificationEventType.orderCreated,
      NotificationEventType.orderProviderAssigned,
      NotificationEventType.orderAccepted,
      NotificationEventType.orderRejected,
      NotificationEventType.orderCancelled,
      NotificationEventType.orderCancelledByAdmin,
      NotificationEventType.orderCompleted,
      NotificationEventType.orderAcceptDeadlineWarn,
      NotificationEventType.orderReassignedAfterTimeout,
      NotificationEventType.orderRitualDeadlineWarn,
      NotificationEventType.orderRitualDeadlineRequesterWarn,
      NotificationEventType.orderReassignedAfterRitualDeadline,
      NotificationEventType.orderAssignmentDelayed,
    ].contains(this);
  }

  bool get isRitualEvent {
    return [
      NotificationEventType.ritualProofUploaded,
      NotificationEventType.ritualGpsVerified,
      NotificationEventType.ritualGpsFailed,
      NotificationEventType.ritualStepValidated,
      NotificationEventType.ritualProofRejectedProvider,
      NotificationEventType.ritualProofRejectedRequester,
      NotificationEventType.ritualAdminNote,
      NotificationEventType.ritualForceValidated,
      NotificationEventType.ritualVideoBrandingReady,
    ].contains(this);
  }
}

// ─── NotificationContext ──────────────────────────────────────────────────────

class NotificationContext {
  final NotificationEventType eventType;
  final UserOrderStatus? orderStatus;
  final UserOrderStatus? previousOrderStatus;
  final OmrahStepsEnum? ritualStep;
  final String? ritualStepStatus;
  final String? proofVideoBrandingStatus;
  final bool? hasVideoProof;
  final bool? hasImageProof;
  final String? paymentId;
  final String? walletTransactionId;
  final String? withdrawalRequestId;
  final String? tasbeehSessionId;

  const NotificationContext({
    required this.eventType,
    this.orderStatus,
    this.previousOrderStatus,
    this.ritualStep,
    this.ritualStepStatus,
    this.proofVideoBrandingStatus,
    this.hasVideoProof,
    this.hasImageProof,
    this.paymentId,
    this.walletTransactionId,
    this.withdrawalRequestId,
    this.tasbeehSessionId,
  });

  factory NotificationContext.fromJson(Map<String, dynamic> json) {
    return NotificationContext(
      eventType: NotificationEventType.fromApi(json['eventType'] as String?),
      orderStatus: json['orderStatus'] == null
          ? null
          : UserOrderStatus.fromApi(json['orderStatus'] as String),
      previousOrderStatus: json['previousOrderStatus'] == null
          ? null
          : UserOrderStatus.fromApi(json['previousOrderStatus'] as String),
      ritualStep: json['ritualStep'] == null
          ? null
          : OmrahStepsEnum.fromApi(json['ritualStep'] as String?),
      ritualStepStatus: json['ritualStepStatus'] as String?,
      proofVideoBrandingStatus:
          json['proofVideoBrandingStatus'] as String?,
      hasVideoProof: json['hasVideoProof'] as bool?,
      hasImageProof: json['hasImageProof'] as bool?,
      paymentId: json['paymentId'] as String?,
      walletTransactionId: json['walletTransactionId'] as String?,
      withdrawalRequestId: json['withdrawalRequestId'] as String?,
      tasbeehSessionId: json['tasbeehSessionId'] as String?,
    );
  }
}

// ─── NotificationItemEntity ───────────────────────────────────────────────────

class NotificationItemEntity extends Equatable {
  final String id;
  final String? title;
  final String? body;
  final NotificationIconType iconType;
  final bool isRead;
  final String? referenceOrderId;
  final DateTime? createdAt;
  final NotificationContext? context;

  const NotificationItemEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.iconType,
    required this.isRead,
    this.referenceOrderId,
    this.createdAt,
    this.context,
  });

  factory NotificationItemEntity.initial() => const NotificationItemEntity(
        id: '',
        title: 'جاري التحميل...',
        body: 'جاري تحميل تفاصيل الإشعار...',
        iconType: NotificationIconType.info,
        isRead: false,
        referenceOrderId: null,
        createdAt: null,
        context: null,
      );

  factory NotificationItemEntity.fromJson(Map<String, dynamic> json) {
    final contextJson = json['context'];
    return NotificationItemEntity(
      id: json['id'] ?? '',
      title: json['title'],
      body: json['body'],
      iconType: NotificationIconType.fromApi(json['iconType']),
      isRead: json['isRead'] ?? false,
      referenceOrderId: json['referenceOrderId'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      context: contextJson is Map<String, dynamic>
          ? NotificationContext.fromJson(contextJson)
          : null,
    );
  }

  NotificationItemEntity copyWith({
    String? id,
    String? title,
    String? body,
    NotificationIconType? iconType,
    bool? isRead,
    String? referenceOrderId,
    DateTime? createdAt,
    NotificationContext? context,
  }) {
    return NotificationItemEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      iconType: iconType ?? this.iconType,
      isRead: isRead ?? this.isRead,
      referenceOrderId: referenceOrderId ?? this.referenceOrderId,
      createdAt: createdAt ?? this.createdAt,
      context: context ?? this.context,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        iconType,
        isRead,
        referenceOrderId,
        createdAt,
        context,
      ];

  @override
  String toString() {
    return 'NotificationItemEntity{id: $id, title: $title, body: $body, iconType: $iconType, isRead: $isRead, referenceOrderId: $referenceOrderId, createdAt: $createdAt, context: $context}';
  }
}

class NotificationMeta {
  final int page;
  final int limit;
  final int totalItems;
  final int totalPages;

  const NotificationMeta({
    required this.page,
    required this.limit,
    required this.totalItems,
    required this.totalPages,
  });

  factory NotificationMeta.initial() => const NotificationMeta(
        page: 1,
        limit: 20,
        totalItems: 0,
        totalPages: 0,
      );

  factory NotificationMeta.fromJson(Map<String, dynamic> json) {
    return NotificationMeta(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 20,
      totalItems: json['totalItems'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
    );
  }
}

class NotificationsResponse {
  final List<NotificationItemEntity> items;
  final NotificationMeta meta;

  const NotificationsResponse({
    required this.items,
    required this.meta,
  });
}

