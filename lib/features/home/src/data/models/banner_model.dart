part of home;

class BannerModel extends BannerEntity {
  const BannerModel({
    required super.id,
    required super.title,
    required super.mediaUrl,
    required super.mediaType,
    super.thumbnailUrl,
    required super.sortOrder,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      mediaUrl: (json['mediaUrl'] as String?)?.addBaseUrl ?? '',
      mediaType: json['mediaType'] ?? 'IMAGE',
      thumbnailUrl: (json['thumbnailUrl'] as String?)?.addBaseUrl,
      sortOrder: json['sortOrder'] ?? 0,
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  factory BannerModel.initial() => const BannerModel(
        id: '',
        title: '',
        mediaUrl: '',
        mediaType: 'IMAGE',
        sortOrder: 0,
        isActive: true,
        createdAt: '',
        updatedAt: '',
      );
}
