part of tab_bar_imports;

class TabBarPage extends Equatable{
  final Widget page;
  final bool keepAlive;
  //if your page is depending on changeable data in its parameter, put this key like this => ObjectKey(yourData), so when the data changes i can update your page from inside
  final Key? key;
  const TabBarPage({required this.page , this.key, this.keepAlive = true});

  @override
  List<Object?> get props => [page, key];
}

class TabBarSwitcher extends StatefulWidget {
  final PageController? pageController;
  final void Function(int index)? onPageChanged;

  final TabBarPage Function(int index)? pageContent;
  final List<TabBarPage>? childrens;

  final List<String> tabBarItems;
  final TabBarAttributes tabBarAttributes;
  final bool disableSwipe;
  final int? initialIndex;
  final int pagesRefreshKey;
  final ScrollPhysics? physics;
  final bool useDivider;
  final TabBarItemBuilder? tabItemBuilder;
  final bool Function(ScrollNotification)? scrollListener;

  const TabBarSwitcher.builder(
      {super.key,
        required this.tabBarItems,
        this.tabItemBuilder,
        this.onPageChanged,
        required this.pageContent,
        this.tabBarAttributes = const TabBarAttributes(),
        this.pageController,
        this.disableSwipe = false,
        this.initialIndex,
        this.pagesRefreshKey = 0,
        this.physics,
        this.scrollListener,
        this.useDivider = true,
      })
      : childrens = null;

  const TabBarSwitcher({
    super.key,
    required this.childrens,
    this.onPageChanged,
    required this.tabBarItems,
    this.tabItemBuilder,
    this.pageController,
    this.disableSwipe = false,
    this.tabBarAttributes = const TabBarAttributes(),
    this.initialIndex,
    this.pagesRefreshKey = 0,
    this.physics,
    this.scrollListener,
    this.useDivider = true,
  }) : pageContent = null;

  @override
  State<TabBarSwitcher> createState() => _TabBarSwitcherState();
}

class _TabBarSwitcherState extends State<TabBarSwitcher> {
  late final PageController _pageController;
  late final ValueNotifier<int> selectedIndex;
  late List<Widget> pages;

  @override
  void didUpdateWidget(covariant TabBarSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);

    // if we added or removed a page, then we need to rebuild the pages
    if(widget.tabBarItems.length != oldWidget.tabBarItems.length){
      _setPages();
    } else {
      for(int i=0 ; i < widget.tabBarItems.length ; i++){

        if(widget.childrens != null){
          if(widget.childrens![i].key != oldWidget.childrens![i].key){
            _setPages();
            break;
          }
        }

        if(widget.pageContent != null){
          if(widget.pageContent!(i).key != oldWidget.pageContent!(i).key){
            _setPages();
            break;
          }
        }
      }
    }

    if (oldWidget.pagesRefreshKey != widget.pagesRefreshKey) {
      _setPages();
    }
  }

  @override
  void initState() {
    _setPages();

    _pageController = widget.pageController ??
        PageController(initialPage: widget.initialIndex ?? 0);

    selectedIndex = ValueNotifier(_pageController.initialPage);
    _pageController.addListener(_pageControllerListener);

    super.initState();
  }

  @override
  void dispose() {
    if (widget.pageController == null) {
      _pageController.dispose();
    }

    _pageController.removeListener(_pageControllerListener);

    selectedIndex.dispose();
    super.dispose();
  }

  void _setPages() {
    if (widget.childrens == null) {
      pages = List.generate(
        widget.tabBarItems.length,
            (index) => _buildPage(index, widget.pageContent!(index),),
      );
    } else {
      pages = List.generate(
          widget.childrens!.length,
              (index) => _buildPage(index , widget.childrens![index]));
    }
  }

  void _pageControllerListener() {
    final int currentPage = _pageController.page!.round();
    if (currentPage != selectedIndex.value) {
      selectedIndex.value = currentPage;

      if (widget.onPageChanged != null) {
        widget.onPageChanged!(currentPage);
      }
    }
  }

  Widget _buildPage(int index , TabBarPage pageData){
    if(pageData.keepAlive){
      return KeepAliveWidget(
        key: ValueKey(widget.pagesRefreshKey + index),
        child: pageData.page,
      );
    }

    return KeyedSubtree(
      key: ValueKey(widget.pagesRefreshKey + index),
      child: pageData.page,
    );

  }

  @override
  Widget build(BuildContext context) {
    if (widget.tabBarAttributes.showTabsAbovePages) {
      return Stack(
        children: [
          Positioned.fill(
            child: _buildPages(),
          ),
          Positioned(top: 0, child: _buildTabs())
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildTabs(),

        // if (widget.useDivider)
        //   const AppDivider(forceWidthOverflow: true, top: 0),
        Expanded(
          child: _buildPages(),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      width: context.width,
      decoration: widget.tabBarAttributes.barBoxDecoration
        ?? BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.1),
              offset: const Offset(0, 1),
            ),
          ],
          color:context.appColors.appBackgroundColor,
        ),
      child: Row(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: selectedIndex,
              builder: (context, value, child) {
                return TabBarWidget(
                  pageController: _pageController,
                  selectedIndex: value,
                  items: widget.tabBarItems,
                  tabBarAttributes: widget.tabBarAttributes,
                  tabItemBuilder: widget.tabItemBuilder,
                );
              },
            ),
          ),
          if (widget.tabBarAttributes.suffixWidget != null)
            widget.tabBarAttributes.suffixWidget!
        ],
      ),
    );
  }

  Widget _buildPages() {
    final Widget page;
    if (widget.childrens == null) {
      page = PageView.builder(
        physics: widget.disableSwipe
            ? const NeverScrollableScrollPhysics()
            : widget.physics ?? const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        controller: _pageController,
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return pages[index];
        },
      );
    } else {
      page = PageView(
        physics: widget.disableSwipe
            ? const NeverScrollableScrollPhysics()
            : widget.physics ?? const ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        controller: _pageController,
        children: pages,
      );
    }

    if (widget.scrollListener != null) {
      return NotificationListener<ScrollNotification>(
        onNotification: widget.scrollListener,
        child: page,
      );
    } else {
      return page;
    }
  }
}