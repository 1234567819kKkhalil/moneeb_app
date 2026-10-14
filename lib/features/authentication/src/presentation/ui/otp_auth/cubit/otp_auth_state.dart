part of auth;

class OtpAuthState extends Equatable {
  /// Sending the code (`POST /auth/otp/start`).
  final StateBox<OtpStartResult> start;

  /// Verifying the code (`POST /auth/otp/verify`).
  final StateBox<OtpVerifyResult> verify;

  /// Resending the code (`POST /auth/otp/resend`).
  final StateBox<void> resend;

  const OtpAuthState({
    required this.start,
    required this.verify,
    required this.resend,
  });

  const OtpAuthState.initial()
      : this(
          start: const StateBox.initial(),
          verify: const StateBox.initial(),
          resend: const StateBox.initial(),
        );

  OtpAuthState reduce({
    StateBox<OtpStartResult>? start,
    StateBox<OtpVerifyResult>? verify,
    StateBox<void>? resend,
  }) {
    return OtpAuthState(
      start: start ?? this.start,
      verify: verify ?? this.verify,
      resend: resend ?? this.resend,
    );
  }

  @override
  List<Object?> get props => [start, verify, resend];
}
