part of app_material;

class GroupRadioTile<T> extends StatelessWidget {
  final List? values;
  final List<String> textList;
  final void Function(T? value)? onChanged;
  final T? value;
  final Color? selectedColor;
  final Color? textColor;

  const GroupRadioTile({
    super.key,
    this.values,
    required this.textList,
    this.onChanged,
    this.value,
    this.selectedColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: textList.length,
      itemBuilder: (context, index) {
        final itemValue = values != null ? values![index] : textList[index];
        return AppRadioTile<T>(
          groupValue: value,
          paddingInsets: EdgeInsets.zero,
          title: textList[index],
          value: itemValue,
          selectedColor: selectedColor ?? context.appColors.primary.shade900,
          onChanged: onChanged,
        );
      },
    );
  }
}
