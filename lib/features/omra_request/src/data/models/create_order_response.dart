part of omra_request;

class CreateOrderResponse {
  final String? id;
  final String? serialNumber;
  final String? status;
  final String beneficiaryType;
  final String beneficiaryName;
  final String customDua;
  final String beneficiaryImageFileId;
  final String targetDate;

  CreateOrderResponse({
    this.id,
    this.serialNumber,
    this.status,
    required this.beneficiaryType,
    required this.beneficiaryName,
    required this.customDua,
    required this.beneficiaryImageFileId,
    required this.targetDate,
  });

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    return CreateOrderResponse(
      id: data['id'],
      serialNumber: data['serialNumber'],
      status: data['status'],
      beneficiaryType: data['beneficiaryType'] ?? '',
      beneficiaryName: data['beneficiaryName'] ?? '',
      customDua: data['customDua'] ?? '',
      beneficiaryImageFileId: data['beneficiaryImageFileId'] ?? '',
      targetDate: data['targetDate'] ?? '',
    );
  }
}
