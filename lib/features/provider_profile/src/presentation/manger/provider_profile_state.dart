part of provider_profile;

class ProviderProfileState extends Equatable {
  final StateBox<ProviderProfileEntity> profile;
  final StateBox<List<ProviderReviewEntity>> reviews;

  const ProviderProfileState({
    required this.profile,
    required this.reviews,
  });

  factory ProviderProfileState.initial() => const ProviderProfileState(
        profile: StateBox.initial(),
        reviews: StateBox.initial(),
      );

  ProviderProfileState reduce({
    StateBox<ProviderProfileEntity>? profile,
    StateBox<List<ProviderReviewEntity>>? reviews,
  }) {
    return ProviderProfileState(
      profile: profile ?? this.profile,
      reviews: reviews ?? this.reviews,
    );
  }

  @override
  List<Object?> get props => [profile, reviews];
}
