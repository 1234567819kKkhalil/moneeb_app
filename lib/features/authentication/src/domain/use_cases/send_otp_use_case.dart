part of auth;

@injectable
class SendOTPUseCase {
  final AuthRepository _authRepository;
  SendOTPUseCase(this._authRepository);

  Future<void> execute(String email) async {
    //todo:
    await _authRepository.sendOTP();
  }
}


