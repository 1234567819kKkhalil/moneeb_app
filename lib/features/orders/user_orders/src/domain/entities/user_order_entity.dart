part of user_orders;

enum UserOrderStatus {
  pending,
  assigned,
  accepted,
  inProgress,
  completed,
  rejected,
  cancelled;

  String toApi() {
    switch (this) {
      case UserOrderStatus.pending:
        return "PENDING";
      case UserOrderStatus.assigned:
        return "ASSIGNED";
      case UserOrderStatus.accepted:
        return "ACCEPTED";
      case UserOrderStatus.rejected:
        return "REJECTED";
      case UserOrderStatus.inProgress:
        return "IN_PROGRESS";
      case UserOrderStatus.completed:
        return "COMPLETED";
      case UserOrderStatus.cancelled:
        return "CANCELLED";
    }
  }

  factory UserOrderStatus.fromApi(String val) {
    switch (val) {
      case "PENDING":
        return pending;
      case "ASSIGNED":
        return UserOrderStatus.assigned;
      case "ACCEPTED":
        return UserOrderStatus.accepted;
      case "REJECTED":
        return UserOrderStatus.rejected;
      case "IN_PROGRESS":
        return UserOrderStatus.inProgress;
      case "COMPLETED":
        return UserOrderStatus.completed;
      case "CANCELLED":
        return UserOrderStatus.cancelled;

      default:
        return pending;
    }
  }

  String toLocalizedName() {
    switch (this) {
      case UserOrderStatus.pending:
        return appLocalizer.orderStatusUnderReview;
      case UserOrderStatus.assigned:
        return appLocalizer.orderStatusAssigned;
      case UserOrderStatus.accepted:
        return appLocalizer.orderStatusAccepted;
      case UserOrderStatus.rejected:
        return appLocalizer.orderStatusRefused;
      case UserOrderStatus.inProgress:
        return appLocalizer.orderStatusExecuting;
      case UserOrderStatus.completed:
        return appLocalizer.orderStatusCompletedFemale;
      case UserOrderStatus.cancelled:
        return appLocalizer.orderStatusCanceledFemale;
    }
  }
}

class UserOrderEntity extends Equatable {
  final String id;
  final String serialNumber;
  final UserOrderStatus status;
  final BeneficiaryType beneficiaryType;
  final String beneficiaryName;

  /// Null for orders created before the API started returning this field.
  final GenderEnum? beneficiaryGender;
  final DateTime? targetDate;
  final String providerId;
  final DateTime? createdAt;

  /// Server relative url of the issued omrah certificate, null until it is
  /// generated.
  final String? certificateUrl;

  const UserOrderEntity({
    required this.id,
    required this.serialNumber,
    required this.status,
    required this.beneficiaryType,
    required this.beneficiaryName,
    this.beneficiaryGender,
    this.targetDate,
    required this.providerId,
    this.createdAt,
    this.certificateUrl,
  });

  factory UserOrderEntity.initial() => const UserOrderEntity(
    id: '',
    serialNumber: '',
    status: UserOrderStatus.pending,
    beneficiaryType: BeneficiaryType.other,
    beneficiaryName: '',
    beneficiaryGender: null,
    targetDate: null,
    providerId: '',
    createdAt: null,
    certificateUrl: null,
  );

  factory UserOrderEntity.fromJson(Map<String, dynamic> json) {
    return UserOrderEntity(
      id: json['id'] ?? '',
      serialNumber: json['serialNumber'] ?? '',
      status: UserOrderStatus.values.firstWhere(
        (e) => e.toApi() == json['status'],
        orElse: () => UserOrderStatus.pending,
      ),
      beneficiaryType: BeneficiaryType.fromJson(json['beneficiaryType'] ?? ''),
      beneficiaryName: json['beneficiaryName'] ?? '',
      beneficiaryGender: json['beneficiaryGender'] == null
          ? null
          : GenderEnum.fromApi(json['beneficiaryGender']),
      targetDate: DateTime.tryParse(json['targetDate'] ?? ''),
      providerId: json['providerId'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      certificateUrl: json['certificateUrl'],
    );
  }

  @override
  List<Object?> get props => [
    id,
    serialNumber,
    status,
    beneficiaryType,
    beneficiaryName,
    beneficiaryGender,
    targetDate,
    providerId,
    createdAt,
    certificateUrl,
  ];
}
