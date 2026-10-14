part of auth;

/// Result of `GET /auth/otp-config`.
/// `{ channels: { whatsapp, sms, call, email }, registration: { allowDirect } }`
class OtpConfig extends Equatable {
  final Set<OtpChannel> enabledChannels;
  final bool allowDirectRegister;

  const OtpConfig({
    required this.enabledChannels,
    required this.allowDirectRegister,
  });

  factory OtpConfig.fromJson(Map<String, dynamic> json) {
    final channels = (json['channels'] as Map?)?.cast<String, dynamic>() ?? {};
    final enabled = <OtpChannel>{};
    channels.forEach((key, value) {
      if (value == true) {
        final channel = OtpChannel.fromApi(key);
        if (channel != null) enabled.add(channel);
      }
    });

    final registration =
        (json['registration'] as Map?)?.cast<String, dynamic>() ?? {};

    return OtpConfig(
      enabledChannels: enabled,
      allowDirectRegister: registration['allowDirect'] == true,
    );
  }

  /// Channels the user may pick for the given identifier type.
  /// - email identifier → only [OtpChannel.email]
  /// - phone identifier → the enabled subset of whatsapp/sms/call
  List<OtpChannel> availableChannels({required bool isEmail}) {
    if (isEmail) {
      return enabledChannels.contains(OtpChannel.email)
          ? [OtpChannel.email]
          : [OtpChannel.email]; // email is always the only option for email
    }
    return OtpChannel.values
        .where((c) => c.isPhoneChannel && enabledChannels.contains(c))
        .toList();
  }

  @override
  List<Object?> get props => [enabledChannels, allowDirectRegister];
}

/// Result of `POST /auth/otp/start`.
class OtpStartResult extends Equatable {
  final String otpToken;
  final OtpChannel? channel;
  final bool accountExists;
  final String message;

  const OtpStartResult({
    required this.otpToken,
    required this.channel,
    required this.accountExists,
    required this.message,
  });

  factory OtpStartResult.fromJson(Map<String, dynamic> json) => OtpStartResult(
        otpToken: json['otpToken'] ?? '',
        channel: OtpChannel.fromApi(json['channel']),
        accountExists: json['accountExists'] == true,
        message: json['message'] ?? '',
      );

  @override
  List<Object?> get props => [otpToken, channel, accountExists, message];
}

/// Result of `POST /auth/otp/verify` — either an authenticated session
/// (existing account) or a signup requirement (new account).
sealed class OtpVerifyResult extends Equatable {
  const OtpVerifyResult();

  factory OtpVerifyResult.fromJson(Map<String, dynamic> json) {
    final status = json['status'];
    if (status == 'registration_required') {
      return OtpRegistrationRequired(
        signupToken: json['signupToken'] ?? '',
        identifier: json['identifier'] ?? '',
        channel: OtpChannel.fromApi(json['channel']),
      );
    }

    // status == 'authenticated' (or default). Tokens may sit at the top level
    // or under a `tokens` object — tolerate both.
    final tokenMap =
        (json['tokens'] as Map?)?.cast<String, dynamic>() ?? json;
    return OtpAuthenticated(ApiTokenModel.fromJson(tokenMap).toEntity());
  }
}

class OtpAuthenticated extends OtpVerifyResult {
  final TokenEntity token;
  const OtpAuthenticated(this.token);

  @override
  List<Object?> get props => [token];
}

class OtpRegistrationRequired extends OtpVerifyResult {
  final String signupToken;
  final String identifier;
  final OtpChannel? channel;

  const OtpRegistrationRequired({
    required this.signupToken,
    required this.identifier,
    required this.channel,
  });

  @override
  List<Object?> get props => [signupToken, identifier, channel];
}
