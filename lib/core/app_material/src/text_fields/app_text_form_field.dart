part of app_material;

enum PrefixIconType{
  email,
  name,
  password,
  phone;

  String getIcon(){
    switch(this){
      case email:
        return SvgPaths.email;
      case name:
        return SvgPaths.user_in_circle;
      case password:
        return SvgPaths.lock;
      case phone:
        return SvgPaths.phone;
    }
  }
}

class AppTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final TextStyle? textStyle;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final TextInputAction? textInputAction;
  final String? labelText;
  final TextDirection? textDirection;
  final String? hint;
  final TextStyle? hintTextStyle;
  final bool obscureText;
  final String? initialValue;
  final TextInputType? keyboardType;
  final Brightness? keyboardAppearance;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final Widget? prefix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final PrefixIconType? prefixIconType;
  final void Function(String text)? onChange;
  final AutovalidateMode? autoValidateMode;
  final FormFieldValidator<String>? validator;
  final VoidCallback? onTap;
  final void Function(PointerDownEvent event)? onTapOutside;
  final void Function(String)? onFieldSubmitted;
  final void Function(String? text)? onSaved;
  final bool? isEnabled;
  final bool readOnly;
  final bool? isDense;
  final bool expands;
  final BoxConstraints? suffixIconConstraints;
  final BoxConstraints? prefixIconConstraints;
  final Color? fillColor;
  final int? maxErrorLines;
  final double? errorTextFontSize;
  final bool disableBorder;
  final InputBorder? border;
  final List<TextInputFormatter>? inputFormatters;
  final bool sanitizeText;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;
  final bool autoFocus;
  final ScrollController? scrollController;
  final ScrollPhysics? scrollPhysics;
  final bool? showDoneButton;
  final double? cursorHeight;
  final Color? cursorColor;

  final bool showEnteredTextLength;

  final bool showErrorOnField;
  final Function(bool hasFocus)? fieldFocus;
  final Iterable<String>? autofillHints;

  const AppTextFormField({
    super.key,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.maxLength = 500,
    this.maxLines,
    this.minLines,
    this.readOnly = false,
    this.keyboardType,
    this.hint,
    this.maxErrorLines = 5,
    this.labelText,
    this.autoFocus = false,
    this.suffixIcon,
    this.isEnabled,
    this.onChange,
    this.onTap,
    this.inputFormatters,
    this.sanitizeText = true,
    this.initialValue,
    this.textDirection,
    this.contentPadding,
    this.focusNode,
    this.autoValidateMode,
    this.errorTextFontSize,
    this.prefixIcon,
    this.prefixIconType,
    this.showEnteredTextLength = false,
    this.cursorHeight,
    this.cursorColor,
    this.border,
    this.suffixIconConstraints,
    this.prefixIconConstraints,
    this.isDense,
    this.prefix,
    this.hintTextStyle,
    this.fillColor,
    this.expands = false,
    this.textStyle,
    this.textAlignVertical = TextAlignVertical.center,
    this.textInputAction,
    this.onFieldSubmitted,
    this.disableBorder = false,
    this.scrollController,
    this.scrollPhysics,
    this.textAlign = TextAlign.start,
    this.keyboardAppearance,
    this.onTapOutside,
    this.onSaved,
    this.showDoneButton,
    this.showErrorOnField = true,
    this.fieldFocus,
    this.autofillHints,
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  bool _isPasswordSecure = false;
  late TextDirection _textDirection;
  late final FocusNode _focusNode;
  String? _enteredText;

  @override
  void initState() {
    _textDirection = widget.textDirection ?? TextDirection.ltr;
    _isPasswordSecure = widget.obscureText;

    _focusNode = widget.focusNode ?? FocusNode();

    // Handle Field Focus
    _focusNode.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {});
      });
    });
    _enteredText = widget.initialValue ?? widget.controller?.text;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: widget.autoFocus,
      canRequestFocus: true,
      child: FormField(
        autovalidateMode: widget.autoValidateMode,
        validator: widget.validator,
        initialValue: _enteredText,
        builder: (field) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.labelText != null) ...[
                Text(
                  '${widget.labelText}',
                  style: context.medium
                ),
                const SizedBox(height: PaddingDimensions.small),
              ],
              Flexible(
                child: AnimatedContainer(
                  alignment: Alignment.center,
                  duration: const Duration(milliseconds: 100),
                  decoration: BoxDecoration(color: widget.fillColor),
                  clipBehavior: Clip.antiAlias,
                  child: TextFormField(
                    autofillHints: widget.autofillHints,
                    textDirection: _textDirection,
                    textAlign: widget.textAlign,
                    textAlignVertical: widget.textAlignVertical,
                    textCapitalization: TextCapitalization.none,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    initialValue: widget.initialValue,
                    readOnly: widget.readOnly,
                    enabled: widget.isEnabled,
                    expands: widget.expands,
                    keyboardType: widget.keyboardType,
                    keyboardAppearance: widget.keyboardAppearance,
                    obscureText: _isPasswordSecure,
                    obscuringCharacter: "*",
                    maxLength: widget.maxLength,
                    maxLines: widget.obscureText ? 1 : widget.maxLines,
                    minLines: widget.minLines,
                    scrollController: widget.scrollController,
                    scrollPhysics: widget.scrollPhysics,
                    cursorColor: widget.cursorColor ?? context.appColors.primary.shade900,
                    cursorHeight: widget.cursorHeight,
                    textInputAction: widget.textInputAction,
                    inputFormatters: [
                      if (widget.sanitizeText) SecureInputFormatter(),
                      ...?widget.inputFormatters
                    ],
                    controller: widget.controller,
                    style: widget.textStyle ??
                        context.regular.copyWith(
                          //height: 1.3,
                          color: context.colorDecider(onLight: (appColors) => appColors.neutral.shade50, onDark: (appColors) => appColors.neutral.shade900,)
                        ),

                    // modify the input decoration for appTheme
                    decoration: InputDecoration(
                      counter: const SizedBox.shrink(),
                      hintText: widget.hint,
                      suffixIcon: _suffixIconWidget(),
                      suffixIconConstraints: widget.suffixIconConstraints ,//?? const BoxConstraints(maxHeight: 20),
                      prefixIcon: widget.prefixIconType != null ? _buildPrefixIcon() : widget.prefixIcon,
                      prefix: widget.prefix,
                      border: widget.disableBorder ? InputBorder.none : null,
                      errorBorder: widget.disableBorder ? InputBorder.none : null,
                      disabledBorder: widget.disableBorder ? InputBorder.none : null,
                      enabledBorder: widget.disableBorder ? InputBorder.none : widget.border,
                      focusedBorder: widget.disableBorder ? InputBorder.none : null,
                      focusedErrorBorder: widget.disableBorder ? InputBorder.none : null,
                      contentPadding: widget.contentPadding,
                      hintStyle: widget.hintTextStyle,
                      isDense: widget.isDense,
                      suffixIconColor: context.appColors.neutral.shade900,
                      errorMaxLines: widget.maxErrorLines ?? 5,
                      prefixIconConstraints: widget.prefixIconConstraints,
                    ),
                    onFieldSubmitted: widget.onFieldSubmitted,
                    onTapOutside: (event) {
                      if (widget.onTapOutside != null) {
                        widget.onTapOutside!(event);
                      } else {
                        _focusNode.unfocus();
                      }
                    },
                    onSaved: widget.onSaved,
                    onChanged: (text) {
                      // if (text.length <= (widget.maxLength ?? 20)) {
                        _enteredText = text;
                        if (widget.onChange != null) widget.onChange!(text);

                        if (widget.textDirection == null) {
                          if (_textDirection != text.getTextDirection) {
                            // setState(() {
                              _textDirection = text.getTextDirection;
                            // });
                          }
                        }
                        field.setValue(text);
                      // } else {
                      //   widget.controller?.text = _enteredText ?? '';
                      // }
                      setState(() {});
                    },
                    onTap: () {
                      if (widget.showDoneButton == true) {
                        if (_focusNode.hasFocus == true ||
                            _focusNode.hasPrimaryFocus == true) {
                          KeyboardDoneOverlay.showOverlay(context);
                        } else {
                          KeyboardDoneOverlay.removeOverlay();
                        }
                      }
                      if (widget.onTap != null) {
                        widget.onTap!();
                      }
                      field.reset();
                    },
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 50),
                child: Builder(
                  key: ValueKey(field.errorText),
                  builder: (context) {
                    if (field.hasError && widget.showErrorOnField) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: PaddingDimensions.small,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Iconsax.info_circle,
                              color: context.appColors.danger.shade600,
                              size: IconDimensions.xSmall,
                            ),
                            const SizedBox(width: PaddingDimensions.small),
                            Expanded(
                              child: Text(
                                '${field.errorText}',
                                style: context.medium.copyWith(
                                  height: 1.2,
                                  color: context.appColors.danger.shade600,
                                  fontSize: widget.errorTextFontSize ??
                                      Dimensions.large,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (widget.showEnteredTextLength) {
                      return Align(
                        alignment: context
                            .read<AppLanguageCubit>()
                            .state
                            .langCode
                            .isArabic
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: PaddingDimensions.normal),
                          child: Text(
                            _charactersLeftLength ?? '',
                            style: context.regular.copyWith(
                              fontSize: Dimensions.normal,
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget? _suffixIconWidget() {
    if (widget.obscureText == true) {
      return _SecureWidget(
        isSecure: _isPasswordSecure,
        onSecureStateChange: (isSecure) {
          setState(() {
            _isPasswordSecure = isSecure;
          });
        },
      );
    } else {
      return widget.suffixIcon;
    }
  }

  Widget? _buildPrefixIcon(){
    return FittedBox(
      alignment: Alignment.center,
      fit: BoxFit.scaleDown,
      child: AppSvg(
        size: 20,
        svgPath: widget.prefixIconType?.getIcon()??'',
        color: AppColors.primary600,
      ),
    );
  }

  String? get _charactersLeftLength {
    final maxLength = widget.maxLength ?? 0;
    final enteredTextLength = _enteredText?.characters.length ?? 0;
    int charactersLeftLength = maxLength - enteredTextLength;
    if (maxLength < enteredTextLength) {
      charactersLeftLength++;
    }
    return '$charactersLeftLength\t/\t$maxLength';
  }
}

class _SecureWidget extends StatelessWidget {
  const _SecureWidget(
      {this.isSecure = false, required this.onSecureStateChange});

  final bool isSecure;
  final Function(bool isSecure) onSecureStateChange;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSecureStateChange(!isSecure);
      },
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(
          PaddingDimensions.xSmall,
          0,
          4,
          0,
        ),
        child: Icon(
          isSecure ? Iconsax.eye_slash : Iconsax.eye,
          color: context.colorDecider(onLight: (appColors) => appColors.neutral.shade50, onDark: (appColors) => appColors.neutral.shade900,),
          size: IconDimensions.xxSmall,
        ),
      ),
    );
  }
}
