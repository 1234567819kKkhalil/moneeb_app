part of auth;

class OTPState extends Equatable {
  final StateBox<String> sendOtp;
  final StateBox<String> verifyOtp;

  const OTPState(
      this.sendOtp,
      this.verifyOtp,
      );

  const OTPState.initial()
      : this(
    const StateBox.initial(),
    const StateBox.initial(),
  );

  OTPState reduce({
    StateBox<String>? sendOtp,
    StateBox<String>? verifyOtp,
  }) {
    return OTPState(
      sendOtp ?? this.sendOtp,
      verifyOtp ?? this.verifyOtp,
    );
  }

  @override
  List<Object?> get props => [
    sendOtp,
    verifyOtp,
  ];
}
