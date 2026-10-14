part of auth;

class ResetPasswordState extends Equatable {
  final StateBox<void> resetPasswordState;

  const ResetPasswordState({required this.resetPasswordState});

  const ResetPasswordState.initial()
      : this(resetPasswordState: const StateBox.initial());

  ResetPasswordState reduce({StateBox<void>? resetPasswordState}) {
    return ResetPasswordState(
      resetPasswordState: resetPasswordState ?? this.resetPasswordState,
    );
  }

  @override
  List<Object?> get props => [resetPasswordState];
}
