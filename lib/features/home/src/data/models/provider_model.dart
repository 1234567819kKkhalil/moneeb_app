part of home;

class ProviderModel extends ProviderEntity {
  const ProviderModel({
    required super.userId,
    required super.fullName,
    super.avatarUrl,
    required super.totalRating,
    required super.executedCount,
    super.umrahCount,
    required super.isVerified,
    required super.isOnline,
    required super.isHafiz,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      userId: json['userId'] ?? '',
      fullName: json['fullName'] ?? '',
      avatarUrl: json['avatarUrl'],
      totalRating: (json['totalRating'] ?? 0).toDouble(),
      executedCount: json['executedCount'] ?? 0,
      umrahCount: json['umrahCount'] ?? 0,
      isVerified: json['isVerified'] ?? false,
      isOnline: json['isOnline'] ?? false,
      isHafiz: json['isHafiz'] ?? false,
    );
  }

  /// For Skeletonizer loading placeholders
  factory ProviderModel.initial() => const ProviderModel(
        userId: '',
        fullName: 'جاري التحميل...',
        avatarUrl: null,
        totalRating: 0,
        executedCount: 0,
        umrahCount: 0,
        isVerified: false,
        isOnline: false,
        isHafiz: false,
      );
}
