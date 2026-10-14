part of provider_profile;

class ProviderReviewModel extends ProviderReviewEntity {
  const ProviderReviewModel({
    required super.id,
    required super.orderId,
    required super.providerId,
    required super.requesterId,
    required super.score,
    required super.comment,
    required super.isHidden,
    required super.createdAt,
    required super.requesterName,
    required super.requesterImage,
  });

  factory ProviderReviewModel.fromJson(Map<String, dynamic> json) {
    return ProviderReviewModel(
      id: json['id'] ?? '',
      orderId: json['orderId'] ?? '',
      providerId: json['providerId'] ?? '',
      requesterId: json['requesterId'] ?? '',
      score: json['score'] ?? 0,
      comment: json['comment'] ?? '',
      isHidden: json['isHidden'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      /*     "counterparty": {
        "name": "شلايعممشا",
        "avatarUrl": "/uploads/avatars/845bb691-66b0-45d2-a95c-c1180ed4cb55.jpg"
      } */
      requesterName: json['counterparty'] != null
          ? json['counterparty']['name'] ?? ''
          : '',
      requesterImage: json['counterparty'] != null
          ? json['counterparty']['avatarUrl'] ?? ''
          : '',
    );
  }

  factory ProviderReviewModel.initial() => ProviderReviewModel(
    id: '',
    orderId: '',
    providerId: '',
    requesterId: '',
    score: 5,
    comment: 'جاري تحميل التقييم...',
    isHidden: false,
    createdAt: DateTime.now(),
    requesterName: '',
    requesterImage: '',
  );
}
