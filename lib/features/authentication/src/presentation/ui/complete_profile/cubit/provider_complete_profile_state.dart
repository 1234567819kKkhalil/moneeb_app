part of auth;

class ProviderCompleteProfileState extends Equatable {
  final StateBox<void> sendProfileInfoState;
  final StateBox<void> sendCertificationsState;

  const ProviderCompleteProfileState({required this.sendProfileInfoState, required this.sendCertificationsState});

  const ProviderCompleteProfileState.initial() : this(
    sendProfileInfoState: const StateBox.initial(),
    sendCertificationsState: const StateBox.initial(),
  );

  ProviderCompleteProfileState reduce({
    StateBox<void>? sendProfileInfoState,
    StateBox<void>? sendCertificationsState,
  }) {
    return ProviderCompleteProfileState(
      sendProfileInfoState: sendProfileInfoState ?? this.sendProfileInfoState,
      sendCertificationsState: sendCertificationsState ?? this.sendCertificationsState,
    );
  }

  @override
  List<Object?> get props => [sendProfileInfoState, sendCertificationsState];
}
