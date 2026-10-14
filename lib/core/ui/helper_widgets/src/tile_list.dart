part of helper_widgets;

class TileList<T> extends StatelessWidget {
  final T item;
  final void Function(T?)? onChanged;
  final T? groupValue;
  final String Function(T) getTitle;

  const TileList({
    super.key,
    required this.item,
    this.onChanged,
    required this.groupValue,
    required this.getTitle,
  });

  @override
  Widget build(BuildContext context) {
    return AppRadioTile(
      value: item,
      groupValue: groupValue,
      onChanged: onChanged,
      title: getTitle(item),
    );
  }
}
