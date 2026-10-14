part of app_material;

class SingleSelectDropDown<T> extends StatefulWidget {
  final List<T> itemsValues;
  final List<String> showItems;
  final String? selectedText;
  final String hint;
  final T? value;
  final void Function(T? selectedItem) onChanged;
  final String? Function(Object?)? validator;

  const SingleSelectDropDown({
    super.key,
    required this.itemsValues,
    required this.showItems,
    required this.onChanged,
    required this.hint,
    this.value,
    this.selectedText,
    this.validator,
  });

  @override
  State<SingleSelectDropDown<T>> createState() =>
      _SingleSelectDropDownState<T>();
}

class _SingleSelectDropDownState<T> extends State<SingleSelectDropDown<T>> {
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent),
      child: Stack(
        fit: StackFit.loose,
        alignment: AlignmentDirectional.topStart,
        children: [
          FormField<T>(
            validator: widget.validator,
            initialValue: widget.value,
            builder: (field) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    alignment: Alignment.center,
                    duration: const Duration(milliseconds: 100),
                    margin: const EdgeInsets.symmetric(
                        vertical: PaddingDimensions.normal + 3),
                    child: DropdownButtonHideUnderline(
                      child: CustomDropdownButton<T>(
                        isExpanded: true,
                        // focusNode: _focusNode,
                        onMenuStateChange: (isOpen) {
                          setState(() {
                            _isOpen = isOpen;
                          });
                        },
                        hint: Padding(
                          padding: const EdgeInsets.all(PaddingDimensions.normal),
                          child: Text(widget.hint,
                              style: context.regular.copyWith(
                                color: context.appColors.neutral.shade600,
                                fontSize: Dimensions.normal,
                              )),
                        ),
                        items: widget.showItems.indexedMap((item, index) {
                          final itemValue = widget.itemsValues[index];
                          return DropdownMenuItem<T>(
                            value: itemValue,
                            child: Container(
                              width: context.width,
                              height: double.infinity,
                              alignment: AlignmentDirectional.centerStart,
                              // margin: EdgeInsets.all(PaddingDimensions.small),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: PaddingDimensions.large),
                              decoration: BoxDecoration(
                                color: (widget.value != itemValue)
                                    ? context.appColors.neutral.shade50
                                    : context.appColors.primary.shade500,
                              ),
                              child: Text(item,
                                  style: context.regular.copyWith(
                                      fontSize: Dimensions.normal)),
                            ),
                          );
                        }).toList(),
                        value: widget.value,
                        onChanged: widget.onChanged,
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: MediaQuery.of(context).size.height * .35,
                          elevation: 1,
                          useRootNavigator: true,
                          offset: const Offset(0, -10),
                          scrollbarTheme: ScrollbarThemeData(
                            thumbColor: MaterialStateProperty.all<Color>(
                                context.appColors.primary.shade900),
                            thickness: MaterialStateProperty.all<double>(8),
                          ),
                          scrollPadding:
                              const EdgeInsets.all(PaddingDimensions.small),
                          decoration: BoxDecoration(
                            color: context.appColors.neutral.shade50,
                            border: Border.all(
                                width: 1, color: context.appColors.neutral.shade900),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        iconStyleData: IconStyleData(
                          icon: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: PaddingDimensions.normal),
                            child: _isOpen
                                ? Icon(
                                    Icons.keyboard_arrow_up,
                                    size: 18,
                                    color: context.appColors.neutral.shade500,
                                  )
                                : Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    size: 18,
                                    color: context.appColors.neutral.shade500,
                                  ),
                          ),
                        ),
                        buttonStyleData: ButtonStyleData(
                            // height: 56,
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            decoration: BoxDecoration(
                              color: context.appColors.neutral.shade50,
                              border: Border.all(
                                color: _getFieldStateColor(field.hasError),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            overlayColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.white)),
                        selectedItemBuilder: (context) {
                          return widget.showItems.map(
                            (item) {
                              return Container(
                                padding: const EdgeInsets.only(
                                    left: PaddingDimensions.large,
                                    top: PaddingDimensions.large - 2,
                                    right: PaddingDimensions.large),
                                child: Text(
                                  widget.selectedText ?? widget.hint,
                                  style: context.medium.copyWith(fontSize: Dimensions.normal),
                                  maxLines: 1,
                                ),
                              );
                            },
                          ).toList();
                        },
                        menuItemStyleData: const MenuItemStyleData(
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ),
                  if (field.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: PaddingDimensions.normal),
                      child: Text(
                        '${field.errorText}',
                        style: context.medium.copyWith(
                          color: context.appColors.danger.shade300,
                          fontSize: Dimensions.small,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          Visibility(
              visible: widget.selectedText != null,
              replacement: const SizedBox.shrink(),
              child: Container(
                padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: PaddingDimensions.small),
                margin: const EdgeInsetsDirectional.only(
                    top: PaddingDimensions.large + 4,
                    end: PaddingDimensions.small,
                    start: 14),
                decoration: const BoxDecoration(color: Colors.white),
                child: Text(widget.hint,
                    style: context.regular.copyWith(
                      color: context.appColors.neutral.shade500,
                      fontSize: Dimensions.small,
                    )),
              )),
        ],
      ),
    );
  }

  Color _getFieldStateColor(bool hasError) {
    if (hasError) {
      // If Field Has Error
      return context.appColors.danger.shade300;
    } else if (_isOpen) {
      // If Field Filled
      return context.appColors.neutral.shade900;
    } else if (widget.value != null) {
      return context.appColors.neutral.shade900;
    } else {
      // Un Focus Or Un Selected Color
      return context.appColors.neutral.shade50;
    }
  }
}
