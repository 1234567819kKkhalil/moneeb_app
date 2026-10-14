part of auth;

@injectable
class GetOtpConfigUseCase {
  final AuthRepository _repository;
  GetOtpConfigUseCase(this._repository);

  Future<OtpConfig> execute() => _repository.getOtpConfig();
}
