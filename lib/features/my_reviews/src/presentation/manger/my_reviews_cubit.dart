part of my_reviews;

@injectable
class MyReviewsCubit extends BaseCubit<MyReviewsState> {
  final GetMyReviewsUseCase _getMyReviewsUseCase;

  MyReviewsCubit(this._getMyReviewsUseCase) : super(MyReviewsState.initial());

  Future<void> fetchReviews() async {
    emit(state.reduce(reviews: const StateBox.loading()));

    await collect(
      task: () async {
        final data = await _getMyReviewsUseCase.call();
        emit(state.reduce(reviews: StateBox.success(data)));
      },
      onError: (failure) {
        emit(state.reduce(reviews: StateBox.failure(failure)));
      },
    );
  }
}
