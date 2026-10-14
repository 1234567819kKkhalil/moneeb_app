part of tazkiyah;

class MyTazkiyahModel extends MyTazkiyahEntity {
  const MyTazkiyahModel({
    required super.id,
    required super.providerId,
    required super.providerName,
    super.providerAvatarUrl,
    required super.reason,
    required super.agreedToOath,
    required super.createdAt,
  });

  factory MyTazkiyahModel.fromJson(Map<String, dynamic> json) {
    return MyTazkiyahModel(
      id: json['id'] ?? '',
      providerId: json['providerId'] ?? '',
      providerName: json['providerName'] ?? '',
      providerAvatarUrl: (json['providerAvatarUrl'] as String?)?.addBaseUrl,
      reason: json['reason'] ?? '',
      agreedToOath: json['agreedToOath'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
