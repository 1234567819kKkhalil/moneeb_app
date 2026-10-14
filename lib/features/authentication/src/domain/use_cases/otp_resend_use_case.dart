part of auth;

@injectable
class OtpResendUseCase {
  final AuthRepository _repository;
  OtpResendUseCase(this._repository);

  Future<OtpChannel?> execute(String otpToken) =>
      _repository.otpResend(otpToken);
}
