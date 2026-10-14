part of provider_orders;

/// A certificate the signed in user is party to, as returned by
/// `/orders/certificates/mine`.
class OrderCertificateEntity extends Equatable {
  final String orderId;
  final String serialNumber;
  final String beneficiaryName;
  final String certificateUrl;

  /// Whether the signed in user was the provider or the requester of the order.
  final String role;

  final String providerName;
  final String requesterName;
  final DateTime? targetDate;
  final DateTime? completedAt;

  const OrderCertificateEntity({
    required this.orderId,
    required this.serialNumber,
    required this.beneficiaryName,
    required this.certificateUrl,
    required this.role,
    required this.providerName,
    required this.requesterName,
    required this.targetDate,
    required this.completedAt,
  });

  factory OrderCertificateEntity.fromJson(Map<String, dynamic> json) {
    return OrderCertificateEntity(
      orderId: json['orderId'] ?? '',
      serialNumber: json['serialNumber'] ?? '',
      beneficiaryName: json['beneficiaryName'] ?? '',
      certificateUrl: json['certificateUrl'] ?? '',
      role: json['role'] ?? '',
      providerName: json['providerName'] ?? '',
      requesterName: json['requesterName'] ?? '',
      targetDate: DateTime.tryParse(json['targetDate'] ?? ''),
      completedAt: DateTime.tryParse(json['completedAt'] ?? ''),
    );
  }

  /// Placeholder used while the list is skeletonized.
  factory OrderCertificateEntity.skeleton() => OrderCertificateEntity(
    orderId: '',
    serialNumber: 'MO-0000-000000',
    beneficiaryName: '——————',
    certificateUrl: '',
    role: '',
    providerName: '',
    requesterName: '',
    targetDate: DateTime.now(),
    completedAt: DateTime.now(),
  );

  @override
  List<Object?> get props => [
    orderId,
    serialNumber,
    beneficiaryName,
    certificateUrl,
    role,
    providerName,
    requesterName,
    targetDate,
    completedAt,
  ];
}
