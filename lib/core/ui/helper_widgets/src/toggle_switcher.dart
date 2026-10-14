part of helper_widgets;

class ToggleSwitch<T> extends StatelessWidget {
  final List<T> values;
  final T selectedValue;
  final ValueChanged<T> onValueChanged;
  final String Function(T) labelBuilder;

  const ToggleSwitch({
    super.key,
    required this.values,
    required this.selectedValue,
    required this.onValueChanged,
    required this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = context.read<AppLanguageCubit>().state.langCode.isArabic;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: context.colorDecider(onLight: (appColors) => appColors.primary.shade900 , onDark: (appColors) => appColors.primary.shade600)),
        borderRadius: const BorderRadius.all(Radius.circular(100)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Row(
        children: values.map((value) {
          bool isSelected = value == selectedValue;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                onValueChanged(value);
              },
              child:Container(
                decoration: BoxDecoration(
                  color: isSelected ? context.appColors.primary.shade500 : Colors.transparent,
                  borderRadius: _getBorderRadius(value,isArabic),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                child: Center(
                  child: Text(
                    labelBuilder(value),
                    style: TextStyle(
                      color: isSelected ? context.appColors.primary.shade50 : context.appColors.primary.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ),
          );
        }).toList(),
      ),
    );
  }

  BorderRadius? _getBorderRadius(T value,isArabic) {
    if (values.first == value) {
      return BorderRadius.only(
        topLeft: isArabic ? Radius.zero : const Radius.circular(30),
        bottomLeft: isArabic ? Radius.zero :  const Radius.circular(30),
        topRight: isArabic ?  const Radius.circular(30):Radius.zero,
        bottomRight: isArabic ?  const Radius.circular(30):Radius.zero,
      );
    } else if (values.last == value) {
      return BorderRadius.only(
        topRight: isArabic ? Radius.zero :  const Radius.circular(30),
        bottomRight: isArabic ? Radius.zero :  const Radius.circular(30),
        topLeft: isArabic ? const Radius.circular(30):  Radius.zero ,
        bottomLeft: isArabic ? const Radius.circular(30) : Radius.zero ,
      );
    } else {
      return null;
    }
  }
}