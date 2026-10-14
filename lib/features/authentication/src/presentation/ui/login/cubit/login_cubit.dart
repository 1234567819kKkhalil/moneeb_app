part of auth;

class LoginCubit extends BaseCubit<LoginState> {
  late LoginUseCase _loginUseCase;

  LoginCubit() : super(const LoginState.initial()) {
    _loginUseCase = injector();
  }

  Future<void> login(LoginInput input) async {
    emit(state.reduce(loginState: const StateBox.loading()));

    await collect(
      task: () async {
        await _loginUseCase.execute(input);
        emit(state.reduce(loginState: StateBox.successWithoutData()));
      },
      onError: (failure) {
        emit(state.reduce(loginState: StateBox.failure(failure)));
      },
    );
  }

}
