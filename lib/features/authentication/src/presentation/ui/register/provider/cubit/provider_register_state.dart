part of auth;

class ProviderRegisterState extends Equatable {
  final StateBox<AppUserModel> registerState;

  const ProviderRegisterState(
      this.registerState,
      );

  const ProviderRegisterState.initial()
      : this(
    const StateBox.initial(),
  );

  ProviderRegisterState reduce({
    StateBox<AppUserModel>? registerState,
  }) {
    return ProviderRegisterState(
      registerState ?? this.registerState,
    );
  }

  @override
  List<Object?> get props => [
    registerState,
  ];
}
