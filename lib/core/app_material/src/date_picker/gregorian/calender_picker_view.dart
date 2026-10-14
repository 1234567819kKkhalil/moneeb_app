part of app_material;

/// [CalenderPickerView] is a widget that allows the user to select a date
/// using a calendar picker.
/// Can use as a Dialog or as a Widget.
class CalenderPickerView extends StatefulWidget {
  final void Function(DateTime selectedDate) onAddedPress;
  final DateTime? initialDate;

  /// Used internally to control layout
  final bool _showButtons;
  final bool _wrapInDialog;

  const CalenderPickerView._internal({
    required this.onAddedPress,
    this.initialDate,
    required bool showButtons,
    required bool wrapInDialog,
    super.key,
  })  : _showButtons = showButtons,
        _wrapInDialog = wrapInDialog;

  /// Public factory constructor
  factory CalenderPickerView({
    required void Function(DateTime selectedDate) onAddedPress,
    DateTime? initialDate,
  }) {
    return CalenderPickerView._internal(
      onAddedPress: onAddedPress,
      initialDate: initialDate,
      showButtons: false,
      wrapInDialog: false,
    );
  }

  static void showDialog({
    required BuildContext context,
    required void Function(DateTime selectedDate) onAddedPress,
    DateTime? initialDate,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation animation, Animation secondaryAnimation) {
        return Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: CalenderPickerView._internal(
              onAddedPress: onAddedPress,
              initialDate: initialDate,
              showButtons: true,
              wrapInDialog: true,
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: child,
        );
      },
    );
  }

  static void showBottomSheet({
    required BuildContext context,
    required void Function(DateTime selectedDate) onAddedPress,
    DateTime? initialDate,
  }) {
    AppBottomSheets.showAppBottomSheet(context, builder: (context) {
      return CalenderPickerView._internal(
        onAddedPress: onAddedPress,
        initialDate: initialDate,
        showButtons: true,
        wrapInDialog: false,
      );
    },);
  }

  @override
  State<CalenderPickerView> createState() =>
      _CalenderPickerViewState();
}

class _CalenderPickerViewState extends State<CalenderPickerView> {
  late DateTime _selectedDate;
  late int _maxYear;

  @override
  void initState() {
    _selectedDate = widget.initialDate ?? DateTime.now();
    _maxYear = RealTimeService.instance.getCurrentDateTime().year;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final wdt = _buildWidget;

    if (widget._wrapInDialog) {
      return Dialog(
        insetPadding: const EdgeInsets.all(PaddingDimensions.normal),
        backgroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: PaddingDimensions.xLarge),
          child: wdt,
        ),
      );
    }
    return wdt;
  }

  Widget get _buildWidget {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDatePicker(context),
        if (widget._showButtons) ...[
          const Gap(PaddingDimensions.large),
          _buildActionButtons(context),
          const Gap(PaddingDimensions.xLarge),
        ],
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.37,
      child: CupertinoDatePickerModified(
        use24hFormat: AppTimeFormat.use24Hour,
        onDateTimeChanged: (date) => setState(() => _selectedDate = date),
        initialDateTime: _selectedDate,
        dateOrder: DatePickerDateOrder.dmy,
        mode: CupertinoDatePickerModeModified.date,
        minimumYear: 1940,
        maximumYear: _maxYear,
        validTextStyle: context.medium.copyWith(
          fontSize: 14,
        ),
        notValidTextStyle: context.medium.copyWith(
          fontSize: 14,
          color: context.appColors.neutral.shade400,
        ),
        additionalSpaceString: 4,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.center,
        isEnglishNum: true,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PaddingDimensions.large),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: _onCancelPressed,
            child: Text(
              appLocalizer.cancel,
              style: context.semiBold.copyWith(fontSize: Dimensions.xxLarge),
            ),
          ),
          const Gap(PaddingDimensions.large),
          AppShader(
            child: GestureDetector(
              onTap: _onAddPressed,
              child: Text(
                appLocalizer.add,
                style: context.semiBold.copyWith(fontSize: Dimensions.xxLarge),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onAddPressed() {
    widget.onAddedPress(_selectedDate);
    AppRouteNavigator.pop(context);
  }

  void _onCancelPressed() => AppRouteNavigator.pop(context);
}
