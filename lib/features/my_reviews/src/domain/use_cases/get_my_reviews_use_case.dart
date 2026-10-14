part of my_reviews;

@injectable
class GetMyReviewsUseCase {
  final MyReviewsRepository _repository;

  GetMyReviewsUseCase(this._repository);

  Future<List<MyReviewEntity>> call() async {
    return await _repository.getMyReviews();
  }
}
