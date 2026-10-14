part of auth;

class LoginState extends Equatable {
  final StateBox<void> loginState;
  const LoginState({required this.loginState,});

  const LoginState.initial() : this(
      loginState:  const StateBox.initial(),
  );

  LoginState reduce({
    StateBox<AppUserModel>? loginState,
  }) {
    return LoginState(
      loginState: loginState ?? this.loginState,
    );
  }

  @override
  List<Object?> get props => [loginState ];
}
