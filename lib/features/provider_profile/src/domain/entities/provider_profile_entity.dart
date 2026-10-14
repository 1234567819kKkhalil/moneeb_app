part of provider_profile;

class ProviderProfileEntity extends Equatable {
  final String userId;
  final String fullName;
  final String username;
  final String? avatarUrl;
  final bool isVerified;
  final bool isOnline;
  final bool isHafiz;
  final bool hafizBadgeEnabled;
  final String? bio;
  final double totalRating;
  final int executedCount;
  final int umrahCount;
  final String? introImageUrl;
  final String? introVideoUrl;

  const ProviderProfileEntity({
    required this.userId,
    required this.fullName,
    required this.username,
    this.avatarUrl,
    this.isVerified = false,
    this.isOnline = false,
    this.isHafiz = false,
    this.hafizBadgeEnabled = false,
    this.bio,
    this.totalRating = 0.0,
    this.executedCount = 0,
    this.umrahCount = 0,
    this.introImageUrl,
    this.introVideoUrl,
  });

  @override
  List<Object?> get props => [
        userId,
        fullName,
        username,
        avatarUrl,
        isVerified,
        isOnline,
        isHafiz,
        hafizBadgeEnabled,
        bio,
        totalRating,
        executedCount,
        umrahCount,
        introImageUrl,
        introVideoUrl,
      ];
}
