part of app_material;

class PhoneField extends StatefulWidget {
  //final TextEditingController? controller;
  final bool obscureText;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final String? hint;
  final Widget? suffix;
  final Widget? prefix;
  final Color? borderColor;
  final void Function(PhoneNumber phoneNumber)? onChange;
  final String? errorText;
  final String? initialValue;
  final Function(bool isValid)? isValidateListener;
  final bool readOnly;
  final void Function(IntelPhoneCountry)? onCountryChanged;
  final String? Function(PhoneNumber? phoneNumber)? validator;

  const PhoneField({
    super.key,
    //this.controller,
    this.obscureText = false,
    this.maxLength,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.hint,
    this.suffix,
    this.prefix,
    this.borderColor,
    this.onChange,
    this.errorText,
    this.initialValue,
    this.readOnly = false,
    this.isValidateListener,
    this.validator,
    this.onCountryChanged,
  });

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  PhoneNumber? initialValue;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _errorText;

  @override
  void initState() {
    setInitialValue(widget.initialValue);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Form(
          key: _formKey,
          child: _IntlPhoneField(
            initialValue: initialValue?.number,
            initialCountryCode: initialValue?.countryISOCode ?? "SAR",
            showCountryFlag: true,
            onChanged: (phoneNumber) {
              if (widget.onChange != null) {
                widget.onChange!(phoneNumber);
              }
              // _validatePhoneNumber(phoneNumber);
            },
            validator: widget.validator,
            autovalidateMode: AutovalidateMode.disabled,
            inputFormatters: [
              EnglishNumbersFormatter(),
              FilteringTextInputFormatter.digitsOnly,
            ],
            invalidNumberMessage: appLocalizer.invalidPhoneNumber,
            readOnly: widget.readOnly,
            onCountryChanged: widget.onCountryChanged,
            hint: widget.hint ?? appLocalizer.mobileNumber,
            // decoration: const AuthTextFieldInputDecoration(),
            showDropdownIcon: true,
            isValidateListener: widget.isValidateListener,
            cursorColor: context.appColors.primary.shade700,
          ),
        ),
        if (_errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            _errorText!,
            style: context.regular.copyWith(
              color: Colors.red,
            ),
          ),
        ],
      ],
    );
  }

  void setInitialValue(String? initialText) {
    if (initialText != null) {
      if(initialText.isNotEmpty && initialText[0] == "+"){
        initialText = initialText.substring(1);
      }

      String number;
      for (var element in countries) {
        final code = element.dialCode;

        if (initialText.startsWith(element.dialCode)) {
          number = initialText.replaceFirst(code, "");
          final phoneNumber = PhoneNumber(
            countryISOCode: element.code,
            countryCode: '+$code',
            number: number,
            numberMaxLength: element.maxLength,
            //numberMinLength: element.minLength,
          );
          initialValue = phoneNumber;

          if (widget.onChange != null) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              widget.onChange!(phoneNumber);
            });
          }
          break;
        }
      }
    }
  }
}

