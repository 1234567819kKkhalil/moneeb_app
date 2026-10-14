part of tab_bar_imports;

typedef TabBarItemBuilder = Widget Function(String text, bool isSelected, double dividerWidth,);// EdgeInsets paddingBetweenItems

class TabBarWidget extends StatefulWidget {
  final PageController pageController;
  final int selectedIndex;
  final List<String> items;
  final TabBarAttributes tabBarAttributes;
  final TabBarItemBuilder? tabItemBuilder;

  const TabBarWidget({
    super.key,
    required this.pageController,
    required this.selectedIndex,
    required this.items,
    required this.tabBarAttributes,
    required this.tabItemBuilder,
  });

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  late List<GlobalKey> keys;
  double dividerWidth = 0;
  double lineWidth = 0;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    _calculateLineWidth();

    WidgetsBinding.instance.addPostFrameCallback(
          (_) {
        if (scrollController.hasClients) {
          _handleOnTapClick(widget.selectedIndex, jumpToPage: true);
        }
      },
    );
    super.initState();
  }

  void _calculateLineWidth() {
    keys = List.generate(widget.items.length, (index) => GlobalKey());

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.tabBarAttributes.centerItems) {
        if(widget.tabBarAttributes.expandItemWidth){
          lineWidth = widget.tabBarAttributes.lineWidth ?? context.width;
        } else {
          for (GlobalKey key in keys) {
            lineWidth += key.getSize().width;
          }
        }

      } else {
        lineWidth = widget.tabBarAttributes.lineWidth ?? context.width;
      }

      _setItemDividerWidth(0);

      setState(() {});
    });
  }

  double? itemWidth;

  void _setItemDividerWidth(int index){
    if(widget.tabBarAttributes.expandItemWidth){
      itemWidth = (lineWidth / widget.items.length) - widget.tabBarAttributes.paddingBetweenItems * 2;
      dividerWidth = itemWidth!;
    } else {
      dividerWidth = widget.items[index].textPainterSize().width;
    }
  }

  @override
  void didUpdateWidget(covariant TabBarWidget oldWidget) {
    if (oldWidget.selectedIndex != widget.selectedIndex ||
        widget.items != oldWidget.items) {
      _handleOnTapClick(widget.selectedIndex, jumpToPage: false);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Align(
        alignment: widget.tabBarAttributes.centerItems
            ? Alignment.center
            : AlignmentDirectional.centerStart,
        child: ScrollConfiguration(
          behavior: _NoPhysics(),
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.antiAliasWithSaveLayer,
           padding: widget.tabBarAttributes.tabBarPadding,
            child: IntrinsicHeight(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(widget.items.length, (index) {
                    return Padding(
                      padding: EdgeInsetsDirectional.only(end: index == widget.items.length-1?0: widget.tabBarAttributes.paddingBetweenItems),
                      child: SizedBox(
                        width: itemWidth,
                        key: keys[index],
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            _handleOnTapClick(index, jumpToPage: true);
                          },
                          child: widget.tabItemBuilder?.call(
                            widget.items[index],
                            widget.selectedIndex == index,
                            dividerWidth,
                          ) ?? _TabItem(
                            item: widget.items[index],
                            isSelected: widget.selectedIndex == index,
                            dividerWidth: dividerWidth,
                            fontSize: widget.tabBarAttributes.fontSize,
                            disableColor: widget.tabBarAttributes.disableColor ?? AppColors.neutral900,
                            focusColor: widget.tabBarAttributes.focusColor ?? AppColors.neutral50,
                          ),
                        ),
                      ),
                    );
                  }).toList()),
            ),
          ),
        ),
      ),
    );
  }

  void _handleOnTapClick(int index, {bool jumpToPage = false}) {
    _setItemDividerWidth(index);

    if (jumpToPage) {
      widget.pageController.jumpToPage(index);
    } else {
      /*widget.pageController.animateToPage(index,
          duration: const Duration(milliseconds: 350),
          curve: Curves.decelerate);*/
    }

    //calculate item position
    double widthOfItems = 0;

    for (int i = 0; i <= index; i++) {
      final currentRenderBox =
      keys[i].currentContext?.findRenderObject() as RenderBox;
      double currentItemWidth = currentRenderBox.size.width;

      if (i == index && (currentItemWidth > (context.width * 0.5))) {
        currentItemWidth = context.width * 0.45;
      }

      widthOfItems += currentItemWidth;
    }

    final double tabPosition = (widthOfItems + widget.tabBarAttributes.paddingBetweenItems) - (context.width * 0.55);

    scrollController.animateTo(tabPosition,
        duration: const Duration(milliseconds: 530), curve: Curves.decelerate);
  }
}

class _TabItem extends StatelessWidget {
  final String item;
  final bool isSelected;
  final double? dividerWidth;
  final Color disableColor;
  final Color focusColor;
  final double? fontSize;
  // final EdgeInsetsGeometry padding;

  const _TabItem({
    required this.item,
    required this.isSelected,
    required this.dividerWidth,
    this.fontSize,
    required this.disableColor,
    required this.focusColor,
    // required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isSelected ? BoxDecoration(
        color: AppColors.primary500,
        borderRadius: BorderRadius.all(Radius.circular(10))
      ) : null,
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 12),
      child: Center(
        child: Text(
          item,
          style: isSelected
              ? context.semiBold.copyWith(
              fontSize: fontSize ?? Dimensions.xLarge, color: focusColor)
              : context.semiBold.copyWith(
            fontSize: fontSize ?? Dimensions.xLarge,
            color: disableColor,
          ),
        ),
      )
    );
  }
}

class _NoPhysics extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
