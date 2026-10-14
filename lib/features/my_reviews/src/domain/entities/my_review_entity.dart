part of my_reviews;

class MyReviewEntity extends Equatable {
  final String id;
  final String orderId;
  final String providerId;
  final String requesterId;
  final int score;
  final String comment;
  final bool isHidden;
  final DateTime? createdAt;
  final String counterpartyName;
  final String counterpartyAvatarUrl;

  const MyReviewEntity({
    required this.id,
    required this.orderId,
    required this.providerId,
    required this.requesterId,
    required this.score,
    required this.comment,
    required this.isHidden,
    required this.createdAt,
    required this.counterpartyName,
    required this.counterpartyAvatarUrl,
  });

  @override
  List<Object?> get props => [
    id,
    orderId,
    providerId,
    requesterId,
    score,
    comment,
    isHidden,
    createdAt,
    counterpartyName,
    counterpartyAvatarUrl,
  ];
}
