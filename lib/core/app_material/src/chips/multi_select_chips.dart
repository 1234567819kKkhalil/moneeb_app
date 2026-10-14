part of app_material;

/// [MultiSelectChips] is custom widget built using [Wrap] and [FilterChip] to built multi chose
class MultiSelectChips<T> extends StatefulWidget {
  /// [values] list of values will return in [onSelect] Function
  final List<T> values;

  /// [textList] list of texts will display
  final List<String> textList;

  /// [initialValues] list of initial selected values to set in [_selectedList]
  final List<T>? initialValues;

  /// [onSelect] Function to return selected list and last select item index
  /// Note : if you send [initialValues] you don't need to use [onSelect] ,
  /// because [initialValues] make [_selectedList] by reference to major list
  final void Function(List<T> selectedList, int lastSelectedItemIndex)? onSelect;

  /// [withHorizontalScroll] to use Chips as Scrollable
  final bool withHorizontalScroll;

  /// [inWholeLine] to use Chips in whole line
  final bool inWholeLine;

  /// [canDeselect] to determine if i can deselect the selected the last selected value or not
  final bool canDeselect;

  const MultiSelectChips({
    super.key,
    required this.values,
    required this.textList,
    this.initialValues,
    this.onSelect,
    this.withHorizontalScroll = false,
    this.inWholeLine = false,
    this.canDeselect = true,
  })  : assert(!withHorizontalScroll || !inWholeLine, 'You can not use [withHorizontalScroll] and [inWholeLine] at the same time');

  @override
  State<MultiSelectChips<T>> createState() => _MultiSelectChipsState();
}

class _MultiSelectChipsState<T> extends State<MultiSelectChips<T>> {
  /// Note : [_selectedList] is being By reference because set widget.initialValues in it in initState
  List<T> _selectedList = <T>[];

  @override
  void initState() {
    super.initState();
    if (widget.initialValues != null) {
      _selectedList = widget.initialValues!;
    }
  }

  @override
  void didUpdateWidget(covariant MultiSelectChips<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValues != null) {
      _selectedList = widget.initialValues!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
        inWholeLine: widget.inWholeLine,
        withHorizontalScroll: widget.withHorizontalScroll,
        values: widget.values,
        textList: widget.textList,
        isSelected: (item,index) => _selectedList.contains(item),
        onSelect: _onSelect,
    );
  }

  void _onSelect(isSelected, item, index) {
    setState(() {
      if (isSelected) {
        if (widget.canDeselect || _selectedList.length != 1) {
          _selectedList.remove(item);
        }
      } else {
        _selectedList.add(item);
      }
    });
    if (widget.onSelect != null) {
      widget.onSelect!(_selectedList, index);
    }
  }
}
