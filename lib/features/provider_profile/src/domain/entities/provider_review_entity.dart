part of provider_profile;

class ProviderReviewEntity extends Equatable {
  final String id;
  final String orderId;
  final String providerId;
  final String requesterId;
  final int score;
  final String comment;
  final bool isHidden;
  final DateTime createdAt;
  final String? requesterName;
  final String? requesterImage;

  const ProviderReviewEntity({
    required this.id,
    required this.orderId,
    required this.providerId,
    required this.requesterId,
    required this.score,
    required this.comment,
    required this.isHidden,
    required this.createdAt,
    this.requesterName,
    this.requesterImage,
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
    requesterName,
    requesterImage,
  ];
}
