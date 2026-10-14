part of my_reviews;

class MyReviewModel extends MyReviewEntity {
  const MyReviewModel({
    required super.id,
    required super.orderId,
    required super.providerId,
    required super.requesterId,
    required super.score,
    required super.comment,
    required super.isHidden,
    required super.createdAt,
    required super.counterpartyName,
    required super.counterpartyAvatarUrl,
  });

  factory MyReviewModel.fromJson(Map<String, dynamic> json) {
    return MyReviewModel(
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
      counterpartyName: json['counterparty'] != null
          ? json['counterparty']['name'] ?? ''
          : '',
      counterpartyAvatarUrl: json['counterparty'] != null
          ? json['counterparty']['avatarUrl'] ?? ''
          : '',
    );
  }

  factory MyReviewModel.initial() => MyReviewModel(
        id: '',
        orderId: '',
        providerId: '',
        requesterId: '',
        score: 5,
        comment: 'جاري تحميل التقييم...',
        isHidden: false,
        createdAt: DateTime.now(),
        counterpartyName: 'جاري التحميل',
        counterpartyAvatarUrl: '',
      );
}
