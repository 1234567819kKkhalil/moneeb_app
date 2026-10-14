part of app_material;

/// [SingleSelectChips] is custom widget built using [Wrap] and [FilterChip] to built multi chose
class SingleSelectChips<T> extends StatefulWidget {
  /// [values] list of values will return in [onSelect] Function
  final List<T> values;

  /// [textList] list of texts will display
  final List<String> textList;

  /// [initialValues] list of initial selected values to set in [_selectedItem]
  final T? initialValue;

  /// [onSelect] Function to return selected list and last select item index
  /// Note : if you send [initialValues] you don't need to use [onSelect] ,
  /// because [initialValues] make [_selectedItem] by reference to major list
  final void Function(T? selectedValue, int selectedItemIndex)? onSelect;

  /// [withHorizontalScroll] to use Chips as Scrollable
  final bool withHorizontalScroll;

  /// [inWholeLine] to use Chips in whole line
  final bool inWholeLine;

  /// [canDeselect] to determine if i can deselect the selected value or not
  final bool canDeselect;

  const SingleSelectChips({
    super.key,
    required this.values,
    required this.textList,
    this.initialValue,
    this.onSelect,
    this.withHorizontalScroll = false,
    this.inWholeLine = false,
    this.canDeselect = true,
  })  : assert(!withHorizontalScroll || !inWholeLine, 'You can not use [withHorizontalScroll] and [inWholeLine] at the same time');

  @override
  State<SingleSelectChips<T>> createState() => _GroupFilterChipState();
}

class _GroupFilterChipState<T> extends State<SingleSelectChips<T>> {
  /// Note : [_selectedItem] is being By reference because set widget.initialValues in it in initState
  T? _selectedItem;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      _selectedItem = widget.initialValue!;
    }
  }

  @override
  void didUpdateWidget(covariant SingleSelectChips<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != null) {
      _selectedItem = widget.initialValue!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      inWholeLine: widget.inWholeLine,
      withHorizontalScroll: widget.withHorizontalScroll,
      values: widget.values,
      textList: widget.textList,
      isSelected: (item,index) => _selectedItem == widget.values[index],
      onSelect: _onSelect,
    );
  }

  void _onSelect(isSelected, item, index) {
    setState(() {
      if (widget.canDeselect && isSelected) {
        _selectedItem = null;
      } else {
        _selectedItem = widget.values[index];
      }
    });
    if (widget.onSelect != null) {
      widget.onSelect?.call(_selectedItem, index);
    }
  }
}
