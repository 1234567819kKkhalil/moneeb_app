part of app_material;


/// A SOLID, strongly-typed refactor of the original widget.
///
/// Responsibilities are split:
///  - Text input is handled by [TextFormField].
///  - Popup state is handled by [PopupSelector] & its controller.
///  - Validation is delegated to the given validators (no setState inside validator).
class AppTextFieldWithSuffixPopup<T> extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;

  final List<PopupOption<T>> options;
  final PopupSelectorController<T>? popupController;

  final String? labelText;
  final String popupHint;

  final String? Function(String?)? textValidator;
  final String? Function(T?)? popupValidator;

  final ValueChanged<String>? onTextChanged;
  final ValueChanged<T?>? onPopupChanged;

  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final int? maxLength;
  final Color? unfocusDividerColor;

  const AppTextFieldWithSuffixPopup({
    super.key,
    this.controller,
    required this.options,
    this.popupController,
    this.labelText,
    this.popupHint = 'Hint',
    this.textValidator,
    this.popupValidator,
    this.onTextChanged,
    this.onPopupChanged,
    this.inputFormatters,
    this.keyboardType,
    this.maxLength,
    this.focusNode,
    this.unfocusDividerColor,
  });

  @override
  State<AppTextFieldWithSuffixPopup<T>> createState() => _AppTextFieldWithSuffixPopupState<T>();
}

class _AppTextFieldWithSuffixPopupState<T> extends State<AppTextFieldWithSuffixPopup<T>> {
  late final FocusNode _focusNode;
  late final PopupSelectorController<T> _popupController;

  String? _textError;
  String? _popupError;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _popupController = widget.popupController ?? PopupSelectorController<T>();

    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  Color _dividerColor(BuildContext context) {
    final hasError = (_textError != null && _textError!.isNotEmpty) || (_popupError != null && _popupError!.isNotEmpty);
    if (hasError) {
      return Theme.of(context).colorScheme.error;
    }
    if (_focusNode.hasFocus || widget.controller?.text.isNotEmpty == true) {
      return Theme.of(context).colorScheme.onSurface;
    }
    return widget.unfocusDividerColor ?? Theme.of(context).dividerColor;
  }

  void _validate() {
    setState(() {
      _textError = widget.textValidator?.call(widget.controller?.text);
      _popupError = widget.popupValidator?.call(_popupController.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dividerColor = _dividerColor(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            labelText: widget.labelText,
            errorText: _textError ?? _popupError,
            suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            suffixIcon: PopupSelector<T>(
              options: widget.options,
              hint: widget.popupHint,
              controller: _popupController,
              dividerColor: dividerColor,
              onChanged: (opt) {
                widget.onPopupChanged?.call(opt?.value);
                _validate();
              },
            ),
          ),
          onChanged: (text) {
            widget.onTextChanged?.call(text);
            _validate();
          },
          validator: (_) {
            _validate();
            return _textError ?? _popupError;
          },
        ),
        // If you prefer showing the popup error below the field only, uncomment:
        if (_popupError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(_popupError!,
                style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12)),
          ),
      ],
    );
  }
}

/// A strongly-typed option used by [PopupSelector].
class PopupOption<T> {
  final T value;
  final String label;
  const PopupOption({required this.value, required this.label});
}

/// Controller to read / change the selected popup value programmatically.
class PopupSelectorController<T> extends ChangeNotifier {
  T? _value;
  String? _label;

  T? get value => _value;
  String? get label => _label;

  void set(T? newValue, {String? label}) {
    _value = newValue;
    _label = label;
    notifyListeners();
  }
}

/// A reusable popup selector that can live anywhere (suffixes, standalone, etc.).
class PopupSelector<T> extends StatefulWidget {
  final List<PopupOption<T>> options;
  final String hint;
  final PopupSelectorController<T>? controller;
  final ValueChanged<PopupOption<T>?>? onChanged;
  final double maxMenuHeight;
  final double maxWidthFraction;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final Color? dividerColor;

  const PopupSelector({
    super.key,
    required this.options,
    this.hint = 'Hint',
    this.controller,
    this.onChanged,
    this.maxMenuHeight = 260,
    this.maxWidthFraction = .45,
    this.textStyle,
    this.hintStyle,
    this.dividerColor,
  });

  @override
  State<PopupSelector<T>> createState() => _PopupSelectorState<T>();
}

class _PopupSelectorState<T> extends State<PopupSelector<T>> {
  late final PopupSelectorController<T> _controller;
  late final MenuController _menuController;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? PopupSelectorController<T>();
    _menuController = MenuController();
  }

  @override
  void dispose() {
    _menuController.close();
    // don't dispose external controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final selectedLabel = _controller.label;

    return MenuAnchor(
      controller: _menuController,
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(context.appColors.neutral.shade50),
        alignment: AlignmentDirectional.bottomEnd,
        maximumSize: WidgetStateProperty.all(
          Size(double.infinity, widget.maxMenuHeight),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
            side: BorderSide(color: Theme.of(context).dividerColor, width: 0.5),
          ),
        ),
      ),
      onOpen: () => setState(() {}),
      onClose: () => setState(() {}),
      builder: (context, controller, child) {
        return InkWell(
          onTap: () => controller.isOpen ? controller.close() : controller.open(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 30,
                width: 1,
                color: widget.dividerColor ?? context.appColors.neutral.shade50,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              ),
              Flexible(
                child: Text(
                  selectedLabel ?? widget.hint,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: selectedLabel != null
                      ? (widget.textStyle ?? context.regular)
                      : (widget.hintStyle ?? context.regular),
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                controller.isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                size: 18,
                color: selectedLabel != null
                    ? context.appColors.neutral.shade900
                    : context.appColors.neutral.shade900,
              ),
              const SizedBox(width: 8),
            ],
          ),
        );
      },
      alignmentOffset: const Offset(-170, 7),
      menuChildren: widget.options.map((opt) {
        final isSelected = _controller.value == opt.value;
        return InkWell(
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            _controller.set(opt.value, label: opt.label);
            widget.onChanged?.call(opt);
            _menuController.close();
            setState(() {});
          },
          child: Container(
            width: width * widget.maxWidthFraction,
            constraints: BoxConstraints(
              minWidth: width * widget.maxWidthFraction,
              maxWidth: width * (widget.maxWidthFraction + .05),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: isSelected
                ? context.appColors.neutral.shade200
                : context.appColors.neutral.shade50,
            child: Text(
              opt.label,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: context.regular,
            ),
          ),
        );
      }).toList(),
    );
  }
}


