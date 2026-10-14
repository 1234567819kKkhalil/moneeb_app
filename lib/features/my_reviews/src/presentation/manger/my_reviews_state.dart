part of my_reviews;

class MyReviewsState extends Equatable {
  final StateBox<List<MyReviewEntity>> reviews;

  const MyReviewsState({
    required this.reviews,
  });

  factory MyReviewsState.initial() => const MyReviewsState(
        reviews: StateBox.initial(),
      );

  MyReviewsState reduce({
    StateBox<List<MyReviewEntity>>? reviews,
  }) {
    return MyReviewsState(
      reviews: reviews ?? this.reviews,
    );
  }

  @override
  List<Object?> get props => [reviews];
}
