part of auth;

class UserRegisterCubit extends BaseCubit<UserRegisterState> {
  late final UserRegisterUseCase _userRegisterUseCase;
  late final OtpRegisterUseCase _otpRegisterUseCase;

  UserRegisterCubit() : super(const UserRegisterState.initial()) {
    _userRegisterUseCase = injector();
    _otpRegisterUseCase = injector();
  }

  Future<void> userRegister({required RegisterInput input}) async {
    emit(state.reduce(registerState: const StateBox.loading()));
    await collect(
      task: () async {
        await _userRegisterUseCase.execute(input);
        emit(state.reduce(registerState: StateBox.successWithoutData()));
      },
      onError: (failure) {
        emit(state.reduce(registerState: StateBox.failure(failure)));
        emit(state.reduce(registerState: const StateBox.initial()));
      },
    );
  }

  /// Completes registration through the verified OTP session
  /// (`POST /auth/otp/register`).
  Future<void> registerViaOtp({required OtpRegisterInput input}) async {
    emit(state.reduce(registerState: const StateBox.loading()));
    await collect(
      task: () async {
        await _otpRegisterUseCase.execute(input);
        emit(state.reduce(registerState: StateBox.successWithoutData()));
      },
      onError: (failure) {
        emit(state.reduce(registerState: StateBox.failure(failure)));
        emit(state.reduce(registerState: const StateBox.initial()));
      },
    );
  }
}
