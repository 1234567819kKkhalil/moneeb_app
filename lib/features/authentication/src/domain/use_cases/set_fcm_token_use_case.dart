part of auth;

@injectable
class SetFcmTokenUseCase {
  final AuthRepository _authRepository;
  final GetFcmTokenUseCase _fcmTokenUseCase;
  SetFcmTokenUseCase(this._authRepository, this._fcmTokenUseCase);

  Future<void> execute() async {
    final fcm = await _fcmTokenUseCase.execute();
    await _authRepository.setFcmToken(fcm);
  }
}


