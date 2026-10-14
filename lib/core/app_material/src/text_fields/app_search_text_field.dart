part of app_material;

class AppSearchTextField extends StatefulWidget {
  final void Function(String)? onChange;
  final void Function()? onClear;

  final void Function(String)? requestNewSearchData;

  final String searchHintText;
  final TextEditingController? controller;

  final bool isLiveSearch;
  final bool showBackIcon;
  final Widget? suffixIcon;

  AppSearchTextField({
    super.key,
    this.onChange,
    this.onClear,
    this.requestNewSearchData,
    searchHintText,
    this.controller,
    this.isLiveSearch = false,
    this.showBackIcon = false,
    this.suffixIcon,
  }) : searchHintText = searchHintText ?? appLocalizer.searchWithDots;

  @override
  State<AppSearchTextField> createState() => _AppSearchTextFieldState();
}

class _AppSearchTextFieldState extends State<AppSearchTextField> {
  // final ValueNotifier<bool> _showClearIcon = ValueNotifier(false);

  final Debouncer _debouncer = Debouncer(milliseconds: 600);

  @override
  void initState() {
    super.initState();
    widget.controller?.text = '';
  }

  @override
  void dispose() {
    super.dispose();
    // _showClearIcon.dispose();
    _debouncer.dispose();
  }

  // void _onClearSearchData() {
  //   widget.controller?.clear();
  //   _showClearIcon.value = false;
  //   widget.onClear?.call();
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.showBackIcon)
          AppIconButton(
            iconData: Icons.arrow_left,
            onPressed: () => AppRouteNavigator.pop(context),
            startPadding: 0,
            endPadding: 8,
          ),

        Flexible(
          child: AppTextFormField(
            inputFormatters: [
              NoLeadingSpaceFormatter(),
              SingleSpaceFormatter(),
              FilteringTextInputFormatter.allow(
                RegExp(r'[a-zA-Z\u0600-\u06FF0-9\s]'),
              ),
              SecureInputFormatter(),
            ],
            prefixIcon: Padding(
              padding: const EdgeInsetsDirectional.only(start: 12, end: 2),
              child:
                  widget.suffixIcon ??
                  Icon(
                    Iconsax.search_normal,
                    size: IconDimensions.normal,
                    color: context.appColors.neutral.shade300,
                  ),
            ),
            prefixIconConstraints: const BoxConstraints(minHeight: 11),
            maxLength: 50,
            maxLines: 1,
            controller: widget.controller,
            hint: widget.searchHintText,
            textInputAction: TextInputAction.search,
            onChange: (text) {
              //Show & Hide clear icon
              // if (text.isEmpty && _showClearIcon.value) {
              //   _showClearIcon.value = false;
              // } else if (text.isNotEmpty && !_showClearIcon.value) {
              //   _showClearIcon.value = true;
              // }

              if (widget.isLiveSearch) {
                _debouncer.run(() {
                  widget.requestNewSearchData?.call(text);
                  widget.onChange?.call(text);
                });
              }
            },
            // suffixIcon: ValueListenableBuilder(
            //   valueListenable: _showClearIcon,
            //   builder: (context, value, child) {
            //     if (!value) return const SizedBox();
            //     return AppIconButton(
            //       iconData: Icons.close,
            //       color: context.appColors.neutral.shade900,
            //       size: IconDimensions.small,
            //       endPadding: PaddingDimensions.medium,
            //       startPadding: 0,
            //       alignment: Alignment.center,
            //       onPressed: _onClearSearchData,
            //     );
            //   },
            // ),
            onFieldSubmitted: (searchTerm) {
              if (!widget.isLiveSearch) {
                widget.requestNewSearchData?.call(searchTerm);
              }
            },
          ),
        ),
      ],
    );
  }
}
