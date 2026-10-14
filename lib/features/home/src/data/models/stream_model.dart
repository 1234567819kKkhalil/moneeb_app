part of home;

class StreamModel extends StreamEntity {
  const StreamModel({
    required super.id,
    required super.title,
    super.description,
    required super.imageUrl,
    required super.linkUrl,
    required super.isActive,
    required super.sortOrder,
    required super.createdAt,
    required super.updatedAt,
  });

  factory StreamModel.fromJson(Map<String, dynamic> json) {
    return StreamModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      imageUrl: (json['imageUrl'] as String?)?.addBaseUrl ?? '',
      linkUrl: json['linkUrl'] ?? '',
      isActive: json['isActive'] ?? false,
      sortOrder: json['sortOrder'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  factory StreamModel.initial() => const StreamModel(
        id: '',
        title: '',
        imageUrl: '',
        linkUrl: '',
        isActive: true,
        sortOrder: 0,
        createdAt: '',
        updatedAt: '',
      );
}
