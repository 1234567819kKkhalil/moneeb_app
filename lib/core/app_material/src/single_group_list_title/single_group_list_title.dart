part of app_material;

class SingleSelectContainer<T> extends StatefulWidget {
  final List<T>? values;
  final List<String> items;
  final String? initialText;
  final void Function(T) onchange;

  const SingleSelectContainer({
    required this.items, required this.onchange, super.key,
    this.values,
    this.initialText,
  });

  @override
  State<SingleSelectContainer<T>> createState() =>
      _SingleSelectContainerState<T>();
}

class _SingleSelectContainerState<T> extends State<SingleSelectContainer<T>> {
  final ValueNotifier<String?> _selectedNotifier = ValueNotifier(null);

  @override
  void initState() {
    _selectedNotifier.value = widget.initialText;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SingleSelectContainer<T> oldWidget) {
    if (widget.initialText != null) {
      _selectedNotifier.value = widget.initialText;
    }
    super.didUpdateWidget(oldWidget);
  }



  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ListView.builder(
        itemCount: widget.items.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final item = widget.items[index];
          return ValueListenableBuilder(
            valueListenable: _selectedNotifier,
            builder: (context, value, child) {
              bool isSelected = _selectedNotifier.value == item;
              return GestureDetector(
                onTap: () {
                  _selectedNotifier.value = item;
                  if (widget.values != null) {
                    widget.onchange(widget.values![index]);
                  } else {
                    widget.onchange(widget.items[index] as T);
                  }
                  setState(() {});
                },
                child: AppSelectTile(
                  isSelected: isSelected,
                  text: item,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
