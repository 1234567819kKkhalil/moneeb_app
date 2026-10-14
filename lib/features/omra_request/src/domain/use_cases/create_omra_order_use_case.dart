part of omra_request;

@injectable
class CreateOmraOrderUseCase {
  final OmraRequestRepository _repository;

  CreateOmraOrderUseCase(this._repository);

  Future<CreateOrderResponse> execute({
    required String beneficiaryType,
    required String beneficiaryName,
    required String beneficiaryGender,
    required String customDua,
    required String targetDate,
    String? preferredProviderId,
  }) async {
    return await _repository.createOrder(
      beneficiaryType: beneficiaryType,
      beneficiaryName: beneficiaryName,
      beneficiaryGender: beneficiaryGender,
      customDua: customDua,
      targetDate: targetDate,
      preferredProviderId: preferredProviderId,
    );
  }
}
