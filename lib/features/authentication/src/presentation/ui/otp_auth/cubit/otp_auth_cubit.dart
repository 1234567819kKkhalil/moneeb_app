part of auth;

/// Orchestrates the unified passwordless OTP flow across the login /
/// provider-identity screen and the OTP verification screen. A single instance
/// is created where the flow starts and passed down via `BlocProvider.value`,
/// so the [identifier], [otpToken] and [selectedChannel] survive across those
/// pages.
class OtpAuthCubit extends BaseCubit<OtpAuthState> {
  /// The one channel the phone flow uses. There is no picker anymore, and
  /// `GET /auth/otp-config` reports whatsapp as the only enabled phone channel
  /// (`sms` and `call` are off), so it is fixed here.
  static const OtpChannel defaultPhoneChannel = OtpChannel.whatsapp;

  /// Role this flow is for: [UserRoleEnum.user] (REQUESTER) for a regular
  /// login/registration, [UserRoleEnum.provider] for the service-provider flow.
  final UserRoleEnum role;

  late final OtpStartUseCase _otpStartUseCase;
  late final OtpVerifyUseCase _otpVerifyUseCase;
  late final OtpResendUseCase _otpResendUseCase;

  OtpIdentifier? identifier;
  OtpChannel? selectedChannel;
  String? otpToken;
  bool accountExists = false;

  OtpAuthCubit({this.role = UserRoleEnum.user})
      : super(const OtpAuthState.initial()) {
    _otpStartUseCase = injector();
    _otpVerifyUseCase = injector();
    _otpResendUseCase = injector();
  }

  bool get isEmailIdentifier => identifier?.isEmail ?? false;

  /// Records the identifier the user entered and clears any previous
  /// start/verify state (e.g. when they edit the field and resubmit).
  void setIdentifier(OtpIdentifier value) {
    identifier = value;
    otpToken = null;
    accountExists = false;
    emit(state.reduce(
      start: const StateBox.initial(),
      verify: const StateBox.initial(),
      resend: const StateBox.initial(),
    ));
  }

  /// Sends the code on the fixed channel for the current identifier type —
  /// there is no channel picker, so the phone flow always uses
  /// [defaultPhoneChannel].
  Future<void> startWithDefaultChannel() =>
      sendCode(isEmailIdentifier ? OtpChannel.email : defaultPhoneChannel);

  /// Sends the code to the identifier via [channel] (`/auth/otp/start`).
  Future<void> sendCode(OtpChannel channel) async {
    final id = identifier;
    if (id == null) return;

    selectedChannel = channel;
    emit(state.reduce(start: const StateBox.loading()));
    await collect(
      task: () async {
        final result = await _otpStartUseCase.execute(
          OtpStartInput(identifier: id, channel: channel),
        );
        otpToken = result.otpToken;
        accountExists = result.accountExists;
        if (result.channel != null) selectedChannel = result.channel;
        emit(state.reduce(start: StateBox.success(result)));
      },
      onError: (failure) {
        emit(state.reduce(start: StateBox.failure(failure)));
      },
    );
  }

  /// Verifies the entered [code] (`/auth/otp/verify`).
  Future<void> verify(String code) async {
    final token = otpToken;
    if (token == null) return;

    emit(state.reduce(verify: const StateBox.loading()));
    await collect(
      task: () async {
        final result = await _otpVerifyUseCase.execute(
          OtpVerifyInput(otpToken: token, code: code),
        );
        emit(state.reduce(verify: StateBox.success(result)));
      },
      onError: (failure) {
        emit(state.reduce(verify: StateBox.failure(failure)));
      },
    );
  }

  /// Resends the code on the same channel (`/auth/otp/resend`).
  Future<void> resend() async {
    final token = otpToken;
    if (token == null) return;

    emit(state.reduce(resend: const StateBox.loading()));
    await collect(
      task: () async {
        final channel = await _otpResendUseCase.execute(token);
        if (channel != null) selectedChannel = channel;
        emit(state.reduce(resend: StateBox.successWithoutData()));
      },
      onError: (failure) {
        emit(state.reduce(resend: StateBox.failure(failure)));
      },
    );
  }
}
