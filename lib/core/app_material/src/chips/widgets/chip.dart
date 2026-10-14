part of app_material;

class Chip<T> extends StatelessWidget {
  final List<T> values;
  final List<String> textList;
  final bool inWholeLine;
  final bool withHorizontalScroll;
  final bool Function(T item,int index) isSelected;
  final Function(bool isSelected, T item, int index) onSelect;

  const Chip({
    super.key,
    required this.values,
    required this.textList,
    required this.onSelect,
    required this.inWholeLine,
    required this.isSelected,
    required this.withHorizontalScroll,
  });

  @override
  Widget build(BuildContext context) {
    return withHorizontalScroll
        ? SingleChildScrollView(scrollDirection: Axis.horizontal, child: _buildChips(context))
        : _buildChips(context);
  }

  Widget _buildChips(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: PaddingDimensions.normal),
        child: Wrap(
          direction: Axis.horizontal,
          spacing: Dimensions.small,
          runSpacing: Dimensions.small,
          children: values.indexedMap((item, index) {
            // bool isSelected = _selectedList.contains(item);
            return AnimatedContainer(    duration: const Duration(milliseconds: 150),
                margin: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 0),
                padding: const EdgeInsets.symmetric(vertical: PaddingDimensions.normal, horizontal: PaddingDimensions.medium),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: isSelected(item,index) ? context.theme.chipTheme.selectedColor : context.theme.chipTheme.disabledColor,
                ),
                child: inWholeLine
                    ? _fullLineWidget(context, isSelected(item,index), item, index)
                    : _chipWidget(context, isSelected(item,index), item, index));
          }
          ),
        ));
  }

  Widget _fullLineWidget(BuildContext context,bool isSelected, T item, int index) {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: Text(
              textList[index],
              softWrap: true,
              style: isSelected ? context.theme.chipTheme.labelStyle : context.theme.chipTheme.secondaryLabelStyle,
            ),
          ),
        ),
      ],
    ).onTap(() => onSelect(isSelected, item, index));
  }

  Widget _chipWidget(BuildContext context, bool isSelected, T item, int index) {
    return Text(
      textList[index],
      softWrap: true,
      style: isSelected ? context.theme.chipTheme.labelStyle : context.theme.chipTheme.secondaryLabelStyle,
    ).onTap(() => onSelect(isSelected, item, index));
  }

}
