part of tazkiyah;

@injectable
class GetMyTazkiyahsUseCase {
  final TazkiyahRepository _repository;

  GetMyTazkiyahsUseCase(this._repository);

  Future<List<MyTazkiyahEntity>> call() async {
    return await _repository.getMyTazkiyahs();
  }
}
