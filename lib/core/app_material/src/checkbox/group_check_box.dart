part of app_material;

class GroupCheckBox<T> extends StatefulWidget {
  final List<T>? values;
  final List<T>? initialValues;
  final List<String> textList;
  final List<String>? subTitle;
  final void Function(List<T>)? onChanged;
  final bool? enabled;

  const GroupCheckBox({
    super.key,
    this.values,
    required this.textList,
    this.onChanged,
    this.subTitle,
    this.initialValues,
    this.enabled,
  });

  @override
  State<GroupCheckBox<T>> createState() => _GroupCheckBoxState<T>();
}

class _GroupCheckBoxState<T> extends State<GroupCheckBox<T>> {
  List<T> _selectedList = <T>[];

  @override
  void initState() {
    super.initState();
    if (widget.initialValues != null) {
      _selectedList = widget.initialValues!;
    }
  }

  @override
  void didUpdateWidget(covariant GroupCheckBox<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValues != null) {
      _selectedList = widget.initialValues!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.textList.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final value = widget.values != null
            ? widget.values![index]
            : widget.textList[index];
        return AppCheckBoxTile(
          enabled: widget.enabled,
          paddingInsets: EdgeInsets.zero,
          subTitle: widget.subTitle != null
              ? Text(
                  widget.subTitle![index],
                  style: context.regular.copyWith(
                      fontSize: Dimensions.normal, color: context.appColors.neutral.shade600),
                )
              : null,
          unselectedColor: context.appColors.primary.shade500,
          title: widget.textList[index],
          value: _selectedList.contains(value),
          onChanged: (_) {
            setState(() {
              if (_selectedList.contains(value)) {
                _selectedList.remove(value);
              } else {
                _selectedList.add(value as T);
              }
              if (widget.onChanged != null) {
                widget.onChanged!(_selectedList);
              }
            });
          },
        );
      },
    );
  }
}
