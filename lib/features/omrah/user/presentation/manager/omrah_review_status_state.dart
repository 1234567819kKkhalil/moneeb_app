part of 'omrah_review_status_cubit.dart';

class OmrahReviewStatusState extends Equatable {
  /// The user's review of this omrah as the server knows it. Success with
  /// `null` data means the omrah carries no review; a failure means we could
  /// not ask.
  final StateBox<MyReviewEntity?> myReview;

  /// Whether this device recorded a submitted rating for the omrah. Set when
  /// the rating was accepted and read back on every later visit, including
  /// after the app is closed and reopened.
  final bool isRatedLocally;

  const OmrahReviewStatusState({
    required this.myReview,
    required this.isRatedLocally,
  });

  const OmrahReviewStatusState.initial()
      : myReview = const StateBox.initial(),
        isRatedLocally = false;

  /// True once either source says the omrah is rated, so a failed or pending
  /// server check can never reopen a rating that was already given.
  bool get isRated => isRatedLocally || myReview.data != null;

  /// The rating to show back, when we have it. Null for an omrah rated on this
  /// device whose review the server has not handed back yet.
  MyReviewEntity? get review => myReview.data;

  /// True while neither source has an answer yet, so the rating entry point
  /// waits instead of inviting a second review.
  bool get isChecking =>
      !isRated && (myReview.isInitial || myReview.isLoading);

  OmrahReviewStatusState copyWith({
    StateBox<MyReviewEntity?>? myReview,
    bool? isRatedLocally,
  }) {
    return OmrahReviewStatusState(
      myReview: myReview ?? this.myReview,
      isRatedLocally: isRatedLocally ?? this.isRatedLocally,
    );
  }

  @override
  List<Object?> get props => [
        myReview,
        isRatedLocally,
      ];
}
