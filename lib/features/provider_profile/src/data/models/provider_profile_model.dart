part of provider_profile;

class ProviderProfileModel extends ProviderProfileEntity {
  const ProviderProfileModel({
    required super.userId,
    required super.fullName,
    required super.username,
    super.avatarUrl,
    super.isVerified,
    super.isOnline,
    super.isHafiz,
    super.hafizBadgeEnabled,
    super.bio,
    super.totalRating,
    super.executedCount,
    super.umrahCount,
    super.introImageUrl,
    super.introVideoUrl,
  });

  factory ProviderProfileModel.fromJson(Map<String, dynamic> json) {
    return ProviderProfileModel(
      userId: json['userId'] ?? '',
      fullName: json['fullName'] ?? '',
      username: json['username'] ?? '',
      avatarUrl: json['avatarUrl'],
      isVerified: json['isVerified'] ?? false,
      isOnline: json['isOnline'] ?? false,
      isHafiz: json['isHafiz'] ?? false,
      hafizBadgeEnabled: json['hafizBadgeEnabled'] ?? false,
      bio: json['bio'],
      totalRating: (json['totalRating'] ?? 0).toDouble(),
      executedCount: json['executedCount'] ?? 0,
      umrahCount: json['umrahCount'] ?? 0,
      introImageUrl: json['introImageUrl'],
      introVideoUrl: json['introVideoUrl'],
    );
  }

  factory ProviderProfileModel.initial() => const ProviderProfileModel(
        userId: '',
        fullName: 'جاري التحميل...',
        username: '@loading',
      );
}
