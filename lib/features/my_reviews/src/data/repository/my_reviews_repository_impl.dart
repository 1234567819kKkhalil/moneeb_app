part of my_reviews;

@LazySingleton(as: MyReviewsRepository)
class MyReviewsRepositoryImpl extends MyReviewsRepository {
  final DioHelper _dioHelper = injector<DioHelper>();

  @override
  Future<List<MyReviewEntity>> getMyReviews() async {
    final response = await _dioHelper.get(MyReviewsEndpoint.myReviews);

    if (response.data['data'] != null && response.data['data'] is List) {
      return (response.data['data'] as List)
          .map((item) => MyReviewModel.fromJson(item))
          .toList();
    }
    return [];
  }
}
