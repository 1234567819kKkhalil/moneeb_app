part of 'add_omrah_review_cubit.dart';

class AddOmrahReviewState extends Equatable {
  final StateBox<void> reviewState;

  const AddOmrahReviewState({
    required this.reviewState,
  });

  const AddOmrahReviewState.initial()
      : reviewState = const StateBox.initial();

  AddOmrahReviewState copyWith({
    StateBox<void>? reviewState,
  }) {
    return AddOmrahReviewState(
      reviewState: reviewState ?? this.reviewState,
    );
  }

  @override
  List<Object?> get props => [
        reviewState,
      ];
}
