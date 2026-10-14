part of omra_request;

@injectable
class GetProvidersUseCase {
  final OmraRequestRepository _repository;

  GetProvidersUseCase(this._repository);

  Future<PaginatedData<ProviderEntity>> execute({
    required int page,
    int limit = 20,
    String? search,
    bool? isOnline,
  }) async {
    return await _repository.getPublicProviders(
      page: page,
      limit: limit,
      search: search,
      isOnline: isOnline,
    );
  }
}
