part of auth;

@injectable
class OtpStartUseCase {
  final AuthRepository _repository;
  OtpStartUseCase(this._repository);

  Future<OtpStartResult> execute(OtpStartInput input) =>
      _repository.otpStart(input);
}
