part of home;

class BannerEntity extends Equatable {
  final String id;
  final String title;
  final String mediaUrl;
  final String mediaType;
  final String? thumbnailUrl;
  final int sortOrder;
  final bool isActive;
  final String createdAt;
  final String updatedAt;

  const BannerEntity({
    required this.id,
    required this.title,
    required this.mediaUrl,
    required this.mediaType,
    this.thumbnailUrl,
    required this.sortOrder,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        mediaUrl,
        mediaType,
        thumbnailUrl,
        sortOrder,
        isActive,
        createdAt,
        updatedAt,
      ];
}
