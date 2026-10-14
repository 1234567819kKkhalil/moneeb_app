part of tazkiyah;

@injectable
class SearchProviderUseCase {
  final TazkiyahRepository _repository;

  SearchProviderUseCase(this._repository);

  Future<LookupProviderEntity?> call({String? email, String? phone}) async {
    return await _repository.searchProvider(email: email, phone: phone);
  }
}
