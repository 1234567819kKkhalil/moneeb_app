part of tazkiyah;

class MyTazkiyahEntity extends Equatable {
  final String id;
  final String providerId;
  final String providerName;
  final String? providerAvatarUrl;
  final String reason;
  final bool agreedToOath;
  final DateTime createdAt;

  const MyTazkiyahEntity({
    required this.id,
    required this.providerId,
    required this.providerName,
    this.providerAvatarUrl,
    required this.reason,
    required this.agreedToOath,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, providerId, providerName, providerAvatarUrl, reason, agreedToOath, createdAt];
}
