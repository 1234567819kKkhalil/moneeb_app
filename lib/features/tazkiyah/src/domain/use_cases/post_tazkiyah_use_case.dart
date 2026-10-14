part of tazkiyah;

@injectable
class PostTazkiyahUseCase {
  final TazkiyahRepository _repository;

  PostTazkiyahUseCase(this._repository);

  Future<void> call({
    required String providerId,
    required String reason,
    required bool agreedToOath,
  }) async {
    return await _repository.postTazkiyah(
      providerId: providerId,
      reason: reason,
      agreedToOath: agreedToOath,
    );
  }
}
