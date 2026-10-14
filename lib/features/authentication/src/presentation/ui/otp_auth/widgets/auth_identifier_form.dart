part of auth;

class AuthIdentifierForm extends StatefulWidget {
  final void Function(OtpIdentifier identifier) onSubmit;
  final bool isSubmitting;
  final String? submitText;

  const AuthIdentifierForm({
    super.key,
    required this.onSubmit,
    this.isSubmitting = false,
    this.submitText,
  });

  @override
  State<AuthIdentifierForm> createState() => _AuthIdentifierFormState();
}

class _AuthIdentifierFormState extends State<AuthIdentifierForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final Validator _validator = Validator();

  LoginInputType _type = LoginInputType.email;
  PhoneNumber? _phoneNumber;

  bool get _isPhone => _type == LoginInputType.phone;

  void _onSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final OtpIdentifier identifier;
    if (_isPhone) {
      final phone = _phoneNumber;
      if (phone == null || phone.number.trim().isEmpty) {
        AppToasts.error(context, message: appLocalizer.invalidPhoneNumber);
        return;
      }
      identifier = OtpIdentifier.phone(
        countryCode: phone.countryCode,
        number: phone.number.trim(),
      );
    } else {
      identifier = OtpIdentifier.email(_emailController.text.trim());
    }

    widget.onSubmit(identifier);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IdentifierTypeToggle(
            selected: _type,
            onChanged: (type) {
              if (type != _type) setState(() => _type = type);
            },
          ),
          const SizedBox(height: 24),

          _FieldLabel(_isPhone ? appLocalizer.phone : appLocalizer.emailHint),
          const SizedBox(height: 8),

          if (_isPhone)
            PhoneField(
              hint: appLocalizer.enterPhone,
              onChange: (number) => _phoneNumber = number,
            )
          else
            EmailWidget(
              controller: _emailController,
              validator: (text) => _validator.emailValidation(text ?? ''),
            ),

          const SizedBox(height: 24),

          AppPrimaryButton(
            isExpanded: true,
            isLoading: widget.isSubmitting,
            onPressed: widget.isSubmitting ? null : _onSubmit,
            text: widget.submitText ?? appLocalizer.sendCode,
          ),
        ],
      ),
    );
  }
}

/// Small required-field label with a red asterisk.
class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: text,
        style: context.semiBold,
        children: [
          TextSpan(
            text: ' *',
            style: context.semiBold.copyWith(
              color: context.appColors.danger.shade500,
            ),
          ),
        ],
      ),
    );
  }
}
