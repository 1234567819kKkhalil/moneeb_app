part of home;

class StoryModel extends StoryEntity {
  const StoryModel({
    required super.id,
    required super.providerId,
    required super.providerName,
    required super.providerAvatarUrl,
    required super.mediaUrl,
    required super.mediaType,
    super.title,
    super.thumbnailUrl,
    required super.isFeatured,
    required super.createdAt,
    required super.expiresAt,
    super.isViewed,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] ?? '',
      providerId: json['providerId'] ?? '',
      providerName: json['providerName'] ?? '',
      providerAvatarUrl:
          (json['providerAvatarUrl'] as String?)?.addBaseUrl ?? '',
      mediaUrl: (json['mediaUrl'] as String?)?.addBaseUrl ?? '',
      mediaType: json['mediaType'] ?? 'IMAGE',
      title: json['title'],
      thumbnailUrl: (json['thumbnailUrl'] as String?)?.addBaseUrl ?? '',
      isFeatured: json['isFeatured'] ?? false,
      createdAt: json['createdAt'] ?? '',
      expiresAt: json['expiresAt'] ?? '',
      isViewed: json['isViewed'] ?? false,
    );
  }
}
