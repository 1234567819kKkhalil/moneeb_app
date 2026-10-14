part of auth;

class OTPCubit extends BaseCubit<OTPState> {
  late final ForgotPasswordUseCase _forgotPasswordUseCase;
  late final VerifyForgotPasswordUseCase _verifyForgotPasswordUseCase;

  String? sessionToken;

  OTPCubit() : super(const OTPState.initial()) {
    _loadUseCases();
  }

  void _loadUseCases() {
    _forgotPasswordUseCase = injector();
    _verifyForgotPasswordUseCase = injector();
  }

  void sendOTP({required String emailOrPhone}) async {
    emit(state.reduce(sendOtp: const StateBox.loading()));
    await collect(
      task: () async {
        sessionToken = await _forgotPasswordUseCase.execute(emailOrPhone);
        emit(state.reduce(sendOtp: StateBox.success(emailOrPhone)));
      },
      onError: (failure) {
        emit(
          state.reduce(
            sendOtp: StateBox.failure(failure),
          ),
        );
      },
    );
  }

  void verifyOtp({required String code, required String emailOrPhone}) async {
    if (sessionToken == null) {
      sendOTP(emailOrPhone: emailOrPhone);
      return;
    }
    emit(state.reduce(verifyOtp: const StateBox.loading()));
    await collect(
      task: () async {
        final resetToken = await _verifyForgotPasswordUseCase.execute(sessionToken!, code);
        emit(state.reduce(verifyOtp: StateBox.success(resetToken)));
      },
      onError: (failure) {
        emit(
          state.reduce(
            verifyOtp: StateBox.failure(failure),
          ),
        );
      },
    );
  }
}
