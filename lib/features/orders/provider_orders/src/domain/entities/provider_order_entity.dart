part of provider_orders;

enum BeneficiaryType {
  martyr,
  sick,
  deceased,
  helpless,
  other;

  String toLocalizedName() {
    switch (this) {
      case martyr:
        return appLocalizer.beneficiaryMartyr;
      case sick:
        return appLocalizer.beneficiarySick;
      case deceased:
        return appLocalizer.beneficiaryDeceased;
      case helpless:
        return appLocalizer.beneficiaryHelpless;
      case other:
        return "--";
    }
  }

  factory BeneficiaryType.fromJson(String val) {
    switch (val) {
      case 'MARTYR':
        return BeneficiaryType.martyr;
      case 'SICK':
        return BeneficiaryType.sick;
      case 'DECEASED':
        return BeneficiaryType.deceased;
      case 'DISABLED':
        return BeneficiaryType.helpless;
      default:
        return other;
    }
  }

  String toApi() {
    switch (this) {
      case martyr:
        return 'MARTYR';
      case sick:
        return 'SICK';
      case deceased:
        return 'DECEASED';
      case helpless:
        return 'DISABLED';
      case other:
        return 'OTHER';
    }
  }
}

class ProviderOrderEntity extends Equatable {
  final String id;
  final String serialNumber;
  final ProviderOrderStatus status;
  final BeneficiaryType beneficiaryType;
  final String beneficiaryName;

  /// Null for orders created before the API started returning this field.
  final GenderEnum? beneficiaryGender;
  final DateTime? targetDate;
  final DateTime? createdAt;
  final UserBaseEntity? requester;

  /// Set once the omrah certificate has been issued for this order.
  final String? certificateUrl;

  const ProviderOrderEntity({
    required this.id,
    required this.serialNumber,
    required this.status,
    required this.beneficiaryType,
    required this.beneficiaryName,
    this.beneficiaryGender,
    required this.targetDate,
    required this.requester,
    this.createdAt,
    this.certificateUrl,
  });

  bool get hasCertificate => !certificateUrl.isEmptyOrNull;

  factory ProviderOrderEntity.initial() => const ProviderOrderEntity(
    id: '',
    serialNumber: '',
    status: ProviderOrderStatus.pending,
    beneficiaryType: BeneficiaryType.other,
    beneficiaryName: '',
    beneficiaryGender: null,
    targetDate: null,
    createdAt: null,
    requester: null,
    certificateUrl: null,
  );

  factory ProviderOrderEntity.fromJson(Map<String, dynamic> json) {
    return ProviderOrderEntity(
      id: json['id'] ?? '',
      serialNumber: json['serialNumber'] ?? '',
      status: ProviderOrderStatus.values.firstWhere(
        (e) => e.toApi() == json['status'],
        orElse: () => ProviderOrderStatus.pending,
      ),
      beneficiaryType: BeneficiaryType.fromJson(json['beneficiaryType'] ?? ''),
      beneficiaryName: json['beneficiaryName'] ?? '',
      beneficiaryGender: json['beneficiaryGender'] == null
          ? null
          : GenderEnum.fromApi(json['beneficiaryGender']),
      targetDate: DateTime.tryParse(json['targetDate'] ?? ''),
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      requester: json["requester"] == null
          ? null
          : ApiUserBaseModel.fromJson(json["requester"]).mapToEntity(),
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
    requester,
    createdAt,
    certificateUrl,
  ];
}
