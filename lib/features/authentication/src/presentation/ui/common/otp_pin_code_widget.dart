part of auth;

const int appOtpFieldsLength = 4;
const Color _fieldColor = Colors.white;
Color _unFilledBorderColor = AppColors.light().neutral.shade700;
Color _filledBorderColor = AppColors.light().primary.shade500;
Color _focusBorderColor = AppColors.light().primary.shade500;
Color _errorBorderColor = AppColors.light().primary.shade500;
final _fieldRadius = BorderRadius.circular(16);
final _textStyle = AppRouteNavigator.navigatorKey.currentContext?.medium    .copyWith(color: AppColors.light().neutral.shade900);
const double _unFocusBorderWidth = 1;
const double _focusBorderWidth = 1.2;

class OtpPinCodeWidget extends StatelessWidget {
  final bool hasError;
  final TextEditingController controller;
  final int length;
  final void Function(String value)? onChange;
  final void Function(String value)? onCompleted;
  final String? Function(String? value)? validator;

  const OtpPinCodeWidget({
    super.key,
    required this.controller,
    this.length = appOtpFieldsLength,
    this.hasError = false,
    this.onChange,
    this.validator,
    this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    double fieldSize =
        ((MediaQuery.of(context).size.width / length) - (length + 10));
    if (fieldSize > 50) {
      fieldSize = 50;
    }
    return Directionality(
      textDirection: direction.TextDirection.ltr,
      child: Pinput(
        controller: controller,
        length: length,
        showCursor: true,
        cursor: Container(
          width: fieldSize * .2,
          margin: EdgeInsets.only(top: fieldSize * .3),
          height: _focusBorderWidth,
          alignment: Alignment.bottomCenter,
          color: AppColors.light().neutral.shade900,
        ),
        inputFormatters: <TextInputFormatter>[
          EnglishNumbersFormatter(),
          FilteringTextInputFormatter.digitsOnly,
        ],
        keyboardType: TextInputType.phone,
        enableSuggestions: true,
        autofocus: true,
        // androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsRetrieverApi,
        // preFilledWidget: Container(
        //   width: fieldSize * .2,
        //   margin: EdgeInsets.only(top: fieldSize * .3),
        //   height: _unFocusBorderWidth,
        //   alignment: Alignment.bottomCenter,
        //   color: _unFilledBorderColor,
        // ),
        // defaultPinTheme: PinTheme(
        //   width: fieldSize * 2,
        //   height: fieldSize,
        //   textStyle: _textStyle,
        //   decoration: BoxDecoration(
        //     color: _fieldColor,
        //     borderRadius: _fieldRadius,
        //     border: Border.all(
        //         width: _unFocusBorderWidth, color: _unFilledBorderColor),
        //   ),
        // ),
        submittedPinTheme: PinTheme(
          width: fieldSize * 2,
          height: fieldSize,
          textStyle: _textStyle,
          decoration: BoxDecoration(
            color: _fieldColor,
            borderRadius: _fieldRadius,
            border: Border.all(
              width: _unFocusBorderWidth,
              color: _filledBorderColor,
            ),
          ),
        ),
        followingPinTheme: PinTheme(
          width: fieldSize * 2,
          height: fieldSize,
          textStyle: _textStyle,
          decoration: BoxDecoration(
            color: _fieldColor,
            borderRadius: _fieldRadius,
            border: Border.all(
              width: _unFocusBorderWidth,
              color: _unFilledBorderColor,
            ),
          ),
        ),
        focusedPinTheme: PinTheme(
          width: fieldSize * 2,
          height: fieldSize,
          textStyle: _textStyle,
          decoration: BoxDecoration(
            color: _fieldColor,
            borderRadius: _fieldRadius,
            border: Border.all(
              width: _focusBorderWidth,
              color: _focusBorderColor,
            ),
          ),
        ),
        errorPinTheme: PinTheme(
          width: fieldSize * 2,
          height: fieldSize,
          textStyle: _textStyle,
          decoration: BoxDecoration(
            color: _fieldColor,
            borderRadius: _fieldRadius,
            border: Border.all(width: 1, color: _errorBorderColor),
          ),
        ),

        forceErrorState: hasError,
        onChanged: onChange,
        onCompleted: onCompleted,
        validator: validator,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}
