part of home;

class ProviderEntity extends Equatable {
  final String userId;
  final String fullName;
  final String? avatarUrl;
  final double totalRating;
  final int executedCount;
  final int umrahCount;
  final bool isVerified;
  final bool isOnline;
  final bool isHafiz;

  const ProviderEntity({
    required this.userId,
    required this.fullName,
    this.avatarUrl,
    required this.totalRating,
    required this.executedCount,
    this.umrahCount = 0,
    required this.isVerified,
    required this.isOnline,
    required this.isHafiz,
  });

  ProviderEntity copyWith({
    String? userId,
    String? fullName,
    String? avatarUrl,
    double? totalRating,
    int? executedCount,
    int? umrahCount,
    bool? isVerified,
    bool? isOnline,
    bool? isHafiz,
  }) {
    return ProviderEntity(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      totalRating: totalRating ?? this.totalRating,
      executedCount: executedCount ?? this.executedCount,
      umrahCount: umrahCount ?? this.umrahCount,
      isVerified: isVerified ?? this.isVerified,
      isOnline: isOnline ?? this.isOnline,
      isHafiz: isHafiz ?? this.isHafiz,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        fullName,
        avatarUrl,
        totalRating,
        executedCount,
        umrahCount,
        isVerified,
        isOnline,
        isHafiz,
      ];
}
