part of auth;

enum OtpVerificationType {
  passwordReset,
  emailUpdate,
}

class ResendOtpInput extends Equatable {
  final String email;
  final OtpVerificationType otpVerificationType;

  const ResendOtpInput({
    required this.email,
    required this.otpVerificationType,
  });

  ResendOtpInput copyWith() {
    return ResendOtpInput(
      email: email,
      otpVerificationType: otpVerificationType,
    );
  }

  @override
  List<Object?> get props => [
    email,
    otpVerificationType,
  ];
}

