part of auth;

class ProviderRegisterCubit extends BaseCubit<ProviderRegisterState> {
  late final UserRegisterUseCase _registerUseCase;
  late final OtpRegisterUseCase _otpRegisterUseCase;

  ProviderRegisterCubit() : super(const ProviderRegisterState.initial()) {
    _loadUseCases();
  }

  void _loadUseCases() {
    _registerUseCase = injector();
    _otpRegisterUseCase = injector();
  }

  Future<void> providerRegister({
    required RegisterInput input,
  }) async {
    emit(state.reduce(registerState: const StateBox.loading()));
    await collect(
      task: () async {
        await _registerUseCase.execute(input);
        emit(state.reduce(registerState: StateBox.successWithoutData()));
      },
      onError: (failure) {
        emit(state.reduce(
            registerState: StateBox.failure(failure)));
        emit(state.reduce(
            registerState: const StateBox.initial()));
      },
    );
  }

  /// Completes provider registration through the verified OTP session
  /// (`POST /auth/otp/register`, role PROVIDER).
  Future<void> registerViaOtp({
    required OtpRegisterInput input,
  }) async {
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
