part of home;

class StoryEntity extends Equatable {
  final String id;
  final String providerId;
  final String providerName;
  final String providerAvatarUrl;
  final String mediaUrl;
  final String mediaType;
  final String? title;
  final String? thumbnailUrl;
  final bool isFeatured;
  final String createdAt;
  final String expiresAt;
  final bool isViewed;

  const StoryEntity({
    required this.id,
    required this.providerId,
    required this.providerName,
    required this.providerAvatarUrl,
    required this.mediaUrl,
    required this.mediaType,
    this.title,
    this.thumbnailUrl,
    required this.isFeatured,
    required this.createdAt,
    required this.expiresAt,
    this.isViewed = false,
  });

  StoryEntity copyWith({
    String? id,
    String? providerId,
    String? providerName,
    String? providerAvatarUrl,
    String? mediaUrl,
    String? mediaType,
    String? title,
    String? thumbnailUrl,
    bool? isFeatured,
    String? createdAt,
    String? expiresAt,
    bool? isViewed,
    bool? isSeen,
  }) {
    return StoryEntity(
      id: id ?? this.id,
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      providerAvatarUrl: providerAvatarUrl ?? this.providerAvatarUrl,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      mediaType: mediaType ?? this.mediaType,
      title: title ?? this.title,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      isFeatured: isFeatured ?? this.isFeatured,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isViewed: isViewed ?? this.isViewed,
    );
  }

  @override
  List<Object?> get props => [
    id,
    providerId,
    providerName,
    providerAvatarUrl,
    mediaUrl,
    mediaType,
    title,
    thumbnailUrl,
    isFeatured,
    createdAt,
    expiresAt,
    isViewed,
  ];
}
