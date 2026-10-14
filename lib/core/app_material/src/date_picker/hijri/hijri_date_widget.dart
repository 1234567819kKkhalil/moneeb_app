part of app_material;

///[HijriDateWidget] is a widget that allows the user to select a Hijri date.
///Can Call it as a Widget
///Or as a Dialog [HijriDateWidget.showDialog] / Or as a BottomSheet [HijriDateWidget.showBottomSheet]
class HijriDateWidget extends StatefulWidget {
  final Function(DateTime selectedDate) onSelectToGregorian;
  final Function(HijriCalendar selectedDate) onSelectHijri;
  final Function({required int year, required int day, required String month})? onSelectedWithMonthName;
  final DateTime? initialDate;

  /// Used internally to control layout
  final bool _showButtons;
  final bool _wrapInDialog;

  const HijriDateWidget._initial({
    required this.onSelectToGregorian,
    required this.onSelectHijri,
    this.onSelectedWithMonthName,
    this.initialDate,
    required bool showButtons,
    required bool wrapInDialog,
  })  : _showButtons = showButtons,
        _wrapInDialog = wrapInDialog;

  factory HijriDateWidget({
    required Function(DateTime selectedDate) onSelectToGregorian,
    required Function(HijriCalendar selectedDate) onSelectHijri,
    Function({required int year, required int day, required String month})? onSelectedWrittenMonthDate,
    DateTime? initialDate,
  }) {
    return HijriDateWidget._initial(
      onSelectToGregorian: onSelectToGregorian,
      onSelectHijri: onSelectHijri,
      onSelectedWithMonthName: onSelectedWrittenMonthDate,
      initialDate: initialDate,
      showButtons: false,
      wrapInDialog: false,
    );
  }

  static void showDialog({
    required BuildContext context,
    required Function(DateTime selectedDate) onSelectToGregorian,
    required Function(HijriCalendar selectedDate) onSelectHijri,
    Function({required int year, required int day, required String month})? onSelectedWrittenMonthDate,
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
            child: HijriDateWidget._initial(
              onSelectToGregorian: onSelectToGregorian,
              onSelectHijri: onSelectHijri,
              onSelectedWithMonthName: onSelectedWrittenMonthDate,
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
    required Function(DateTime selectedDate) onSelectToGregorian,
    required Function(HijriCalendar selectedDate) onSelectHijri,
    Function({required int year, required int day, required String month})? onSelectedWrittenMonthDate,
    DateTime? initialDate,
  }) {
    AppBottomSheets.showAppBottomSheet(context, builder: (context) {
      return HijriDateWidget._initial(
        onSelectToGregorian: onSelectToGregorian,
        onSelectHijri: onSelectHijri,
        onSelectedWithMonthName: onSelectedWrittenMonthDate,
        initialDate: initialDate,
        showButtons: true,
        wrapInDialog: false,
      );
    },);
  }

  @override
  State<HijriDateWidget> createState() => _HijriDateWidgetState();
}

class _HijriDateWidgetState extends State<HijriDateWidget> {
  late HijriCalendar _selectedDate;
  late AppLangCodeEnum lang;

  void get _setMonthNames {
    hijriMonthNames = [
      appLocalizer.hijriMonth1,
      appLocalizer.hijriMonth2,
      appLocalizer.hijriMonth3,
      appLocalizer.hijriMonth4,
      appLocalizer.hijriMonth5,
      appLocalizer.hijriMonth6,
      appLocalizer.hijriMonth7,
      appLocalizer.hijriMonth8,
      appLocalizer.hijriMonth9,
      appLocalizer.hijriMonth10,
      appLocalizer.hijriMonth11,
      appLocalizer.hijriMonth12,
    ];
  }

  List hijriMonthNames = [];
  late DateTime _gregorianBirthDate;
  int hijriMinimumYear = 1356;
  BorderRadiusGeometry? highlighterYearRadius;
  BorderRadiusGeometry? highlighterDayRadius;

  late FixedExtentScrollController fixedExtentScrollControllerYear;
  late FixedExtentScrollController fixedExtentScrollControllerMonth;
  late FixedExtentScrollController fixedExtentScrollControllerDay;

  @override
  void initState() {
    super.initState();

    lang = context.read<AppLanguageCubit>().state.langCode;
    _setMonthNames;
    _calculateBorderRadius();

    _setInitialValues(widget.initialDate ?? DateTime.now());
  }

  void _setInitialValues(DateTime initialDate) {
    _selectedDate = HijriCalendar.fromDate(initialDate);
    _gregorianBirthDate = initialDate;

    fixedExtentScrollControllerYear = FixedExtentScrollController(
      initialItem: _selectedDate.hYear - hijriMinimumYear,
    );
    fixedExtentScrollControllerMonth = FixedExtentScrollController(
      initialItem: _selectedDate.hMonth - 1,
    );
    fixedExtentScrollControllerDay = FixedExtentScrollController(
      initialItem: _selectedDate.hDay - 1,
    );
  }

  void _calculateBorderRadius() {
    highlighterYearRadius = _getBorderRadius(lang.isEnglish);
    highlighterDayRadius = _getBorderRadius(lang.isArabic);
  }

  BorderRadius _getBorderRadius(bool condition) {
    double radius =  6;
    return condition
        ? BorderRadius.only(topRight: Radius.circular(radius), bottomRight: Radius.circular(radius))
        : BorderRadius.only(topLeft: Radius.circular(radius), bottomLeft: Radius.circular(radius));
  }

  void _handleDaysController() {
    final itemIndex = HijriCalendar().getDaysInMonth(_selectedDate.hYear, _selectedDate.hMonth);
    if (_selectedDate.hDay == 31 || _selectedDate.hDay == 30) {
      Future.delayed(const Duration(milliseconds: 30)).then((_) {
        setState(() {
          fixedExtentScrollControllerDay.animateToItem(
            itemIndex - 1,
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
          );
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollEndNotification) {
          _handleDaysController();
        }
        return true;
      },
      child: widget._wrapInDialog
          ? Dialog(
              insetPadding: const EdgeInsets.all(PaddingDimensions.normal),
              backgroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: PaddingDimensions.medium),
                child: _buildWidget,
              ),
            )
          : _buildWidget,
    );
  }

  Widget get _buildWidget {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.37,
      child: Column(
        children: [
          Expanded(
            child: Directionality(
              textDirection: lang.isEnglish ? TextDirection.rtl : TextDirection.ltr,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  _buildDatePicker(
                    scrollController: fixedExtentScrollControllerYear,
                    borderRadius: highlighterYearRadius,
                    children: List.generate(
                      HijriCalendar.fromDate(RealTimeService.instance.getCurrentDateTime()).hYear - hijriMinimumYear,
                      (int index) {
                        final year = hijriMinimumYear + index;
                        return Center(
                          child: Text(
                            '$year',
                            style: context.medium,
                          ),
                        );
                      },
                    ),
                    onSelectedItemChanged: (int index) {
                      final selectedYear = index + hijriMinimumYear;
                      _selectedDate = HijriCalendar()
                        ..hYear = selectedYear
                        ..hMonth = _selectedDate.hMonth
                        ..hDay = _selectedDate.hDay;
                    },
                    looping: false,
                  ),

                  _buildDatePicker(
                    scrollController: fixedExtentScrollControllerMonth,
                    children: List.generate(
                      12,
                      (int index) {
                        final monthName = hijriMonthNames[index];
                        return Center(
                          child: Text(
                            monthName,
                            style: context.regular.copyWith(
                              fontSize: Dimensions.large,
                            ),
                          ),
                        );
                      },
                    ),
                    onSelectedItemChanged: (int index) {
                      final selectedMonth = index + 1;
                      _selectedDate = HijriCalendar()
                        ..hYear = _selectedDate.hYear
                        ..hMonth = selectedMonth
                        ..hDay = _selectedDate.hDay;
                    },
                  ),

                  _buildDatePicker(
                    scrollController: fixedExtentScrollControllerDay,
                    borderRadius: highlighterDayRadius,
                    children: List.generate(
                      31,
                      (int index) {
                        final day = index + 1;
                        return Center(
                          child: Text(
                            '$day',
                            style: context.medium
                          ),
                        );
                      },
                    ),
                    onSelectedItemChanged: (int index) {
                      final selectedDay = index + 1;
                      _selectedDate = HijriCalendar()
                        ..hYear = _selectedDate.hYear
                        ..hMonth = _selectedDate.hMonth
                        ..hDay = selectedDay;
                    },
                  ),
                ],
              ),
            ),
          ),
          if (widget._showButtons) ...[
            const Gap(PaddingDimensions.large),
            _buildActionButtons(context),
            const Gap(PaddingDimensions.xLarge),
          ],
        ],
      ),
    );
  }

  Widget _buildDatePicker({
    BorderRadiusGeometry? borderRadius = BorderRadius.zero,
    FixedExtentScrollController? scrollController,
    void Function(int index)? onSelectedItemChanged,
    required List<Widget> children,
    bool looping = true
  }) {
    return Flexible(
      child: CupertinoPicker(
        selectionOverlay: Container(
          decoration: BoxDecoration(
            color: context.appColors.neutral.shade200.withValues(alpha: 0.4),
            borderRadius: borderRadius,
          ),
        ),
        magnification: 1,
        offAxisFraction: 0,
        scrollController: scrollController,
        itemExtent: 28,
        looping: looping,
        onSelectedItemChanged: (int index) {
          onSelectedItemChanged?.call(index);
          if (!widget._showButtons) _onSelectDate();
        },
        children: children,
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
    _onSelectDate();
    AppRouteNavigator.pop(context);
  }

  void _onCancelPressed() => AppRouteNavigator.pop(context);

  void _onSelectDate() {
    DateTime gregorianDate = HijriCalendar().hijriToGregorian(_selectedDate.hYear, _selectedDate.hMonth, _selectedDate.hDay);
    _gregorianBirthDate = gregorianDate;
    widget.onSelectToGregorian(_gregorianBirthDate);
    widget.onSelectHijri(_selectedDate);

    widget.onSelectedWithMonthName?.call(
      day: _selectedDate.hDay,
      year: _selectedDate.hYear,
      month: hijriMonthNames[_selectedDate.hMonth - 1],
    );
  }
}
