part of tazkiyah;

class LookupProviderEntity extends Equatable {
  final String providerId;
  final String fullName;
  final String? avatarUrl;

  const LookupProviderEntity({
    required this.providerId,
    required this.fullName,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [providerId, fullName, avatarUrl];
}
