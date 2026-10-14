part of auth;

class ResetPasswordCubit extends BaseCubit<ResetPasswordState> {
  late final ResetPasswordUseCase _resetPasswordUseCase;

  ResetPasswordCubit() : super(const ResetPasswordState.initial()) {
    _resetPasswordUseCase = injector();
  }

  Future<void> resetPassword(String token, String password) async {
    emit(state.reduce(resetPasswordState: const StateBox.loading()));
    await collect(
      task: () async {
        await _resetPasswordUseCase.execute(token, password);
        emit(state.reduce(resetPasswordState: StateBox.successWithoutData()));
      },
      onError: (failure) {
        emit(state.reduce(resetPasswordState: StateBox.failure(failure)));
      },
    );
  }
}
