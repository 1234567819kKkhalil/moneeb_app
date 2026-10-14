part of my_reviews;

abstract class MyReviewsRepository {
  Future<List<MyReviewEntity>> getMyReviews();
}
