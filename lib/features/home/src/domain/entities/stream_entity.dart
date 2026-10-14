part of home;

class StreamEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String imageUrl;
  final String linkUrl;
  final bool isActive;
  final int sortOrder;
  final String createdAt;
  final String updatedAt;

  const StreamEntity({
    required this.id,
    required this.title,
    this.description,
    required this.imageUrl,
    required this.linkUrl,
    required this.isActive,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        imageUrl,
        linkUrl,
        isActive,
        sortOrder,
        createdAt,
        updatedAt,
      ];
}
