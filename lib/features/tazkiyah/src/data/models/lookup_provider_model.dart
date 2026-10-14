part of tazkiyah;

class LookupProviderModel extends LookupProviderEntity {
  const LookupProviderModel({
    required super.providerId,
    required super.fullName,
    super.avatarUrl,
  });

  factory LookupProviderModel.fromJson(Map<String, dynamic> json) {
    return LookupProviderModel(
      providerId: json['providerId'] ?? '',
      fullName: json['fullName'] ?? '',
      avatarUrl: (json['avatarUrl'] as String?)?.addBaseUrl,
    );
  }
}
