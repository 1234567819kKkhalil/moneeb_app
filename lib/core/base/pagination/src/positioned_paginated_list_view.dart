part of custom_pagination;

class PositionedPaginatedListView<K, T> extends StatefulWidget {
  final PaginationController<K, T> controller;
  final FlutterListViewController? scrollController;

  final ScrollPhysics? physics;
  final Axis scrollDirection;
  final bool reversed;
  final bool paginateFromTop;
  //final double? cacheExtent;

  final String Function(T item) onItemKey;
  final bool Function(String)? onIsPermanent;
  final int Function(PaginationState state)? initIndex;

  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget Function(BuildContext context, Failure failure)
  firstPageErrorBuilder;
  final Widget Function(BuildContext context) firstPageLoadingBuilder;
  final Widget Function(BuildContext context) noItemsFoundBuilder;
  final Widget Function(BuildContext context) newPageLoadingBuilder;
  final Widget Function(BuildContext context, Failure failure)
  newPageErrorBuilder;

  const PositionedPaginatedListView({
    super.key,
    required this.controller,
    this.scrollController,

    required this.itemBuilder,
    required this.firstPageErrorBuilder,
    required this.firstPageLoadingBuilder,
    required this.noItemsFoundBuilder,
    required this.newPageLoadingBuilder,
    required this.newPageErrorBuilder,

    required this.onItemKey,
    this.reversed = false,
    this.paginateFromTop = false,
    this.physics,
    //this.cacheExtent,
    this.scrollDirection = Axis.vertical,
    this.initIndex,
    this.onIsPermanent,
  });

  @override
  State<PositionedPaginatedListView<K, T>> createState() =>
      _PositionedPaginatedListViewState<K, T>();
}

class _PositionedPaginatedListViewState<K, T> extends State<PositionedPaginatedListView<K, T>> {
  bool initIndexCalled = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        widget.controller.init(
          screenHeight: context.height,
        );
      },
    );
    super.initState();
  }

  int _getInitIndex(PaginationState state){
    //because sometimes when this list changes, it call this initIndex again and jumps to it

    if(state.items.isEmpty){
      initIndexCalled = false;
    }

    if(initIndexCalled) {
      return 0;
    }

    initIndexCalled = true;

    return widget.initIndex?.call(state) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        widget.controller.onReceiveNotification(notification);
        return false;
      },
      child: ValueListenableBuilder<PaginationState<K, T>>(
        valueListenable: widget.controller.paginatedStateNotifier,
        builder: (context, state, child) {
          if (state.items.isEmpty) {
            return _firstPageStateBuilder(state);
          }

          return FlutterListView(
            controller: widget.scrollController,
            scrollDirection: widget.scrollDirection,
            physics: widget.physics,
            reverse: widget.reversed,
            //cacheExtent: widget.cacheExtent,

            delegate: FlutterListViewDelegate(
                  (BuildContext context, int index) => _buildItem(state, index),
              // disableCacheItems: true,
              childCount: state.items.length,

              initIndex: _getInitIndex(state),
              keepPosition: true,
              onItemKey: (index) => widget.onItemKey(state.items[index]),
              onIsPermanent: widget.onIsPermanent,

            ),
          );
        },
      ),
    );
  }

  Widget _firstPageStateBuilder(PaginationState state) {
    if (state.isLoading) {
      return widget.firstPageLoadingBuilder(context);
    } else if (state.failure != null) {
      return widget.firstPageErrorBuilder(context, state.failure!);
    } else {
      return widget.noItemsFoundBuilder(context);
    }
  }

  Widget _buildItem(PaginationState state, int index) {
    bool showItemBuilderAtTop = !widget.reversed && !widget.paginateFromTop;

    if (widget.paginateFromTop ? index == 0 : index == state.items.length - 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if(showItemBuilderAtTop)
            widget.itemBuilder(context, state.items[index], index),

          if (state.isLoading)
            widget.newPageLoadingBuilder(context)
          else if (state.failure != null)
            widget.newPageErrorBuilder(context, state.failure!),

          if(!showItemBuilderAtTop)
            widget.itemBuilder(context, state.items[index], index),
        ],
      );
    }

    return widget.itemBuilder(context, state.items[index], index);
  }
}
