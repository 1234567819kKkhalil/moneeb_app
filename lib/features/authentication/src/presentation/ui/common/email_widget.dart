part of auth;

class EmailWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool readOnly;
  const EmailWidget({
    super.key,
    required this.controller,
    this.validator,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: TextInputType.emailAddress,
      // prefixIcon: const Icon(Icons.email_outlined),
      validator: validator,
      maxLines: 1,
      maxLength: 50,
      prefixIconType: PrefixIconType.email,
      hint: appLocalizer.enterEmail,
      inputFormatters: [
        FilteringTextInputFormatter.deny(' '),
        EnglishNumbersFormatter(),
        LowerCaseTextFormatter(),
        NoArabicAllowedFormatter(),
      ],
    );
  }
}

/// Input type enum used by [EmailOrPhoneWidget] to indicate
/// whether the user is entering an email or a phone number.
enum LoginInputType { email, phone }

/// A smart text field that auto-detects whether the user is entering
/// an email address or a Saudi phone number.
///
/// Detection logic:
/// - If the input is purely digits and starts with `05`, `5`, `+966`, or `00966`
///   → **phone mode** (Saudi Arabia).
/// - Otherwise → **email mode**.
///
/// The widget reactively switches:
/// - **Prefix icon** (email ↔ phone) with a smooth animation
/// - **Hint text** (localized email hint ↔ phone hint)
/// - **Keyboard type** (email ↔ phone)
/// - **Input formatters** (email rules ↔ digits-only)
/// - **Validation** (email format ↔ Saudi phone format)
class EmailOrPhoneWidget extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final ValueChanged<LoginInputType>? onInputTypeChanged;

  const EmailOrPhoneWidget({
    super.key,
    required this.controller,
    this.validator,
    this.onInputTypeChanged,
  });

  @override
  State<EmailOrPhoneWidget> createState() => _EmailOrPhoneWidgetState();
}

class _EmailOrPhoneWidgetState extends State<EmailOrPhoneWidget> {
  LoginInputType _inputType = LoginInputType.email;
  final Validator _validator = Validator();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_detectInputType);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_detectInputType);
    super.dispose();
  }

  void _detectInputType() {
    final text = widget.controller.text.trim();
    final LoginInputType detected;

    if (text.isEmpty) {
      detected = LoginInputType.email;
    } else if (_validator.isSaudiPhoneInput(text)) {
      detected = LoginInputType.phone;
    } else {
      detected = LoginInputType.email;
    }

    if (detected != _inputType) {
      setState(() {
        _inputType = detected;
      });
      widget.onInputTypeChanged?.call(_inputType);
    }
  }

  bool get _isPhone => _inputType == LoginInputType.phone;

  @override
  Widget build(BuildContext context) {
    return AppTextFormField(
      controller: widget.controller,
      keyboardType: _isPhone ? TextInputType.phone : TextInputType.emailAddress,
      validator:
          widget.validator ??
          (text) => _validator.emailOrPhoneValidation(text ?? ''),
      maxLines: 1,
      maxLength: _isPhone ? 15 : 50,
      prefixIconType: _isPhone ? PrefixIconType.phone : PrefixIconType.email,
      hint: _isPhone ? appLocalizer.enterPhone : appLocalizer.emailOrPhoneHint,
      inputFormatters: _isPhone
          ? [
              FilteringTextInputFormatter.deny(' '),
              FilteringTextInputFormatter.allow(RegExp(r'[\d+]')),
            ]
          : [
              FilteringTextInputFormatter.deny(' '),
              EnglishNumbersFormatter(),
              LowerCaseTextFormatter(),
              NoArabicAllowedFormatter(),
            ],
    );
  }
}

// class PasswordWidget extends StatefulWidget {
//   final TextEditingController? controller;
//   final void Function(String text)? onChange;
//   final void Function(PasswordMeterEnum meter)? passwordMeterValueNotifierValue;
//   final FormFieldValidator<String>? validator;
//   final bool showPasswordValidator;
//   final bool showPasswordMeter;
//   final String labelText;
//   final String hintText;
//
//   PasswordWidget({
//     super.key,
//     String? labelText,
//     this.controller,
//     this.hintText="PASSWORD",
//     this.onChange,
//     this.showPasswordValidator = true,
//     this.showPasswordMeter = false,
//     this.passwordMeterValueNotifierValue,
//     this.validator,
//   }) : labelText = labelText ?? '';
//
//   @override
//   State<PasswordWidget> createState() => _PasswordWidgetState();
// }
//
// class _PasswordWidgetState extends State<PasswordWidget> {
//   final ValueNotifier<String> _passwordChangeValueNotifier =
//   ValueNotifier<String>('');
//
//   @override
//   void dispose() {
//     _passwordChangeValueNotifier.dispose();
//     super.dispose();
//   }
//
//   void _onChange(String text) {
//     widget.onChange == null ? null : widget.onChange!(text);
//     _passwordChangeValueNotifier.value = text;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(widget.labelText),
//         AppTextFormField(
//           hint: widget.hintText,
//           controller: widget.controller,
//           // labelText: appLocalizer.password,
//           onChange: (text) => _onChange(text),
//           inputFormatters: [
//             EnglishNumbersFormatter(),
//             NoArabicAllowedFormatter()
//           ],
//           obscureText: true,
//           maxLength: 25,
//           validator: widget.showPasswordValidator
//               ? widget.validator ?? _passwordValidator
//               : null,
//           maxErrorLines: 4,
//           textDirection: direction.TextDirection.ltr,
//         ),
//         if (widget.showPasswordMeter)
//           ValueListenableBuilder(
//             valueListenable: _passwordChangeValueNotifier,
//             builder: (context, value, child) => PasswordMeter(
//               password: widget.controller!.text,
//               passwordMeterValueNotifierValue:
//               widget.passwordMeterValueNotifierValue,
//             ),
//           )
//       ],
//     );
//   }
//
//   String? _passwordValidator(String? password) =>
//       Validator().passwordValidation(password);
// }
