part of app_material;

class AppMenuAnchor<T> extends StatefulWidget {
  const AppMenuAnchor({
    super.key,
    required this.child,
    this.onTap,
    this.onClose,
    required this.items,
    required this.values,
    this.onPopUpChange,
    this.value,
    this.menuWidth,
    this.dxMenu = 0,
    this.dyMenu = 0,
  });

  final Widget child;
  final void Function()? onTap;
  final void Function()? onClose;
  final List<String> items;
  final List<T> values;
  final void Function(T? value)? onPopUpChange;
  final T? value;
  final double? menuWidth;
  final double dxMenu;
  final double dyMenu;

  @override
  State<AppMenuAnchor<T>> createState() => _AppMenuAnchorState<T>();
}

class _AppMenuAnchorState<T> extends State<AppMenuAnchor<T>> {
  final MenuController _menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      controller: _menuController,
      onClose: () {
        if (widget.onClose != null) widget.onClose!();
        setState(() {});
      },
      onOpen: () {
        setState(() {});
      },
      anchorTapClosesMenu: true,
      alignmentOffset: Offset(widget.dxMenu, widget.dyMenu),
      style: MenuStyle(
        // alignment: AlignmentDirectional.bottomEnd,
        // maximumSize: MaterialStateProperty.all<Size?>(
        //   Size(double.infinity, context.height * .35),
        // ),
        // minimumSize: MaterialStateProperty.all<Size?>(
        //   Size(100, 10),
        // ),
        shape: MaterialStateProperty.all<OutlinedBorder?>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
              side: BorderSide(color: context.appColors.neutral.shade50, width: 1)),
        ),
      ),
      // alignmentOffset: const Offset(-150, 7),
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return InkWell(
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            if (widget.onTap != null) widget.onTap!();
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: widget.child,
        );
      },

      menuChildren: widget.items.indexedMap((element, index) {
        final currentValue = widget.values[index];
        return InkWell(
          focusColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            if (widget.onPopUpChange != null) {
              widget.onPopUpChange!(currentValue);
            }
            _menuController.close();
          },
          child: Container(
            width: widget.menuWidth ?? context.width * .4,
            constraints: widget.menuWidth == null
                ? BoxConstraints(
                    minWidth: context.width * .4, maxWidth: context.width * .5)
                : null,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: widget.value == currentValue
                    ? context.appColors.neutral.shade50
                    : context.appColors.neutral.shade50),
            padding: const EdgeInsets.symmetric(
                horizontal: PaddingDimensions.large,
                vertical: PaddingDimensions.medium),
            child: Text(
              element,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: context.medium.copyWith(fontSize: Dimensions.normal),
            ),
          ),
        );
      }).toList(),
    );
  }
}
