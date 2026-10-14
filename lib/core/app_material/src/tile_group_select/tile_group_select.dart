part of app_material;

typedef TileGroupSelectItemWidgetBuilderType<ItemType> = Widget Function(
  BuildContext context,
  int index,
  bool isSelected,
  ItemType item,
);

class TileGroupSelect<T> extends StatefulWidget {
  final List<T> values;
  final List<String>? items;
  final TileGroupSelectItemWidgetBuilderType<T>? childBuilder;
  final T? initialValue;
  final void Function(T? value) onchange;

  /// [canUnSelectSelected] Set to true if Want to un select same selected item
  final bool canUnSelectSelected;
  final double? itemsVerticalPadding;

  TileGroupSelect({
    super.key,
    this.items,
    required this.values,
    required this.onchange,
    this.initialValue,
    this.itemsVerticalPadding,
    this.canUnSelectSelected = false,
    this.childBuilder,
  }) {
    // print(runtimeType == GroupTileSelect<Object?>);
    // if(runtimeType == GroupTileSelect<Object?>){
    //   assert(runtimeType == GroupTileSelect<Object?>,
    //     'Please Make Sure That $T not dynamic in GroupTileSelect<T> you must specify the return type for GroupTileSelect');
    // }
    // if (runtimeType == GroupTileSelect<dynamic>) {
    //   assert((values != null && runtimeType != GroupTileSelect<String>),
    //       'GroupTileSelect<$T> Must Be GroupTileSelect<String>');
    // }
  }

  @override
  State<TileGroupSelect<T>> createState() => _TileGroupSelectState<T>();
}

class _TileGroupSelectState<T> extends State<TileGroupSelect<T>> {
  final ValueNotifier<T?> _selectedNotifier = ValueNotifier(null);

  @override
  void initState() {
    _selectedNotifier.value = widget.initialValue;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TileGroupSelect<T> oldWidget) {
    if (widget.initialValue != null) {
      _selectedNotifier.value = widget.initialValue;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.values.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = widget.items?[index];
        final itemValue = widget.values[index];
        return ValueListenableBuilder(
          valueListenable: _selectedNotifier,
          builder: (context, value, child) {
            bool isSelected = _selectedNotifier.value == itemValue;
            return GestureDetector(
                onTap: () {
                  if (isSelected && widget.canUnSelectSelected) {
                    _selectedNotifier.value = null;
                  } else {
                    _selectedNotifier.value = itemValue;
                  }
                  widget.onchange(itemValue);
                  setState(() {});
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: widget.itemsVerticalPadding ?? 0),
                  child: AppSelectTile(
                    isSelected: isSelected,
                    text: item,
                    child: widget.childBuilder != null
                        ? widget.childBuilder!(
                            context, index, isSelected, itemValue)
                        : null,
                  ),
                ));
          },
        );
      },
    );
  }
}

class AppSelectTile extends StatelessWidget {
  const AppSelectTile(
      {super.key, required this.isSelected, this.child, this.text});

  final bool isSelected;
  final Widget? child;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.fastEaseInToSlowEaseOut,
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(vertical: 1.2),
      decoration: BoxDecoration(
          color: isSelected ? context.appColors.primary.shade500 : context.appColors.neutral.shade50),
      child: Container(
          alignment: AlignmentDirectional.centerStart,
          margin: const EdgeInsetsDirectional.only(start: PaddingDimensions.xLarge),
          padding: const EdgeInsets.all(PaddingDimensions.medium),
          decoration: BoxDecoration(color: context.appColors.neutral.shade50),
          child: child ??
              Text(
                text ?? '',
                style: isSelected
                    ? context.bold.copyWith(fontSize: Dimensions.large)
                    : context.medium.copyWith(fontSize: Dimensions.normal),
              )),
    );
  }
}
