part of auth;

/// Body for `POST /auth/otp/start`.
class OtpStartInput {
  final OtpIdentifier identifier;

  /// How to deliver the code for a phone identifier
  /// (`whatsapp` default | `sms` | `call`). Ignored server-side for email.
  final OtpChannel? channel;

  const OtpStartInput({
    required this.identifier,
    this.channel,
  });

  Map<String, dynamic> toJson() => {
        ...identifier.toJson(),
        if (channel != null && identifier.isEmail == false)
          'channel': channel!.toApi(),
      };
}
