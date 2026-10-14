part of app_material;

class CountryPickerSheet extends StatefulWidget {
  final List<IntelPhoneCountry> countryList;
  final IntelPhoneCountry selectedCountry;
  final ValueChanged<IntelPhoneCountry> onCountryChanged;
  final String searchText;
  final bool showNumbers;
  final List<IntelPhoneCountry> filteredCountries;

  const CountryPickerSheet({
    super.key,
    required this.searchText,
    required this.countryList,
    required this.onCountryChanged,
    required this.selectedCountry,
    required this.filteredCountries,
    this.showNumbers = true,
  });

  @override
  State<StatefulWidget> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<CountryPickerSheet> {
  late List<IntelPhoneCountry> _filteredCountries;
  late IntelPhoneCountry _selectedCountry;

  @override
  void initState() {
    _selectedCountry = widget.selectedCountry;
    _filteredCountries = widget.filteredCountries;
    super.initState();
  }

  bool isNumeric(String s) => s.isNotEmpty && double.tryParse(s) != null;

  void onTextChange(String value) {
    _filteredCountries = isNumeric(value)
        ? widget.countryList
              .where((country) => country.dialCode.contains(value))
              .toList()
        : widget.countryList
              .where(
                (country) =>
                    country.name.toLowerCase().contains(value.toLowerCase()),
              )
              .toList();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: context.height * 0.8),
      child: Column(
        children: [
          AppSearchTextField(isLiveSearch: true, onChange: onTextChange),
          const Gap(PaddingDimensions.large),
          Expanded(
            child: _filteredCountries.isNotEmpty
                ? _buildList
                : Center(
                    child: Text(
                      appLocalizer.noItemFoundError,
                      textAlign: TextAlign.center,
                      style: context.medium,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget get _buildList {
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        final isSelected =
            _selectedCountry.code == _filteredCountries[index].code;
        return InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            _selectedCountry = _filteredCountries[index];
            widget.onCountryChanged(_selectedCountry);
            AppRouteNavigator.pop(context, data: _filteredCountries[index]);
          },
          child: Container(
            padding: const EdgeInsets.all(PaddingDimensions.normal),
            decoration: BoxDecoration(
              color: isSelected
                  ? context.appColors.primary.shade400
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                width: 0.5,
                color: context.appColors.primary.shade400.withValues(alpha: .5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(PaddingDimensions.normal),
                        child: Text(_filteredCountries[index].flag),
                      ),

                      const Gap(PaddingDimensions.small),
                      Flexible(
                        child: BlocBuilder<AppLanguageCubit, AppLanguageState>(
                          builder: (context, state) {
                            return Text(
                              state.langCode.isArabic
                                  ? _filteredCountries[index].arabicName
                                  : _filteredCountries[index].name,
                              overflow: TextOverflow.ellipsis,
                              style: context.bold.copyWith(
                                color: isSelected
                                    ? context.appColors.neutral.shade900
                                    : context.appColors.neutral.shade50,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(PaddingDimensions.medium),

                if (widget.showNumbers)
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Text(
                      "+${_filteredCountries[index].dialCode}",
                      style: context.regular.copyWith(
                        color: isSelected
                            ? context.appColors.neutral.shade900
                            : context.appColors.neutral.shade50,
                      ),
                    ),
                  ),
                if (isSelected) ...[
                  const Gap(PaddingDimensions.small),
                  SvgPicture.asset(
                    AssetPaths.iconCheck,
                    colorFilter: ColorFilter.mode(
                      context.appColors.primary.shade700,
                      BlendMode.srcIn,
                    ),
                  ),
                  const Gap(PaddingDimensions.small),
                  // Icon(Icons.check, color: context.appColors.primary.shade700),
                ],
              ],
            ),
          ),
        );
      },
      itemCount: _filteredCountries.length,
      separatorBuilder: (context, index) {
        return const Gap(PaddingDimensions.regular);
      },
    );
  }
}
