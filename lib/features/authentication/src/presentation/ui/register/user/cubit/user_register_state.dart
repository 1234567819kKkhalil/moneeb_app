part of auth;

class UserRegisterState extends Equatable {
  final StateBox<AppUserModel> registerState;

  const UserRegisterState(
      this.registerState,
      );

  const UserRegisterState.initial()
      : this(
    const StateBox.initial(),
  );

  UserRegisterState reduce({
    StateBox<AppUserModel>? registerState,
  }) {
    return UserRegisterState(
      registerState ?? this.registerState,
    );
  }

  @override
  List<Object?> get props => [
    registerState,
  ];
}
