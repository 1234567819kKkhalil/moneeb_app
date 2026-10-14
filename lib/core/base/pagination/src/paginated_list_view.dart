part of custom_pagination;

class PaginatedListView<K, T> extends StatefulWidget {
  final PaginationController<K, T> controller;
  final ScrollController? scrollController;
  final ScrollPhysics? physics;
  final Key? listKey;
  final Axis scrollDirection; // New parameter for scroll direction

  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget Function(BuildContext context, Failure failure) firstPageErrorBuilder;
  final Widget Function(BuildContext context) firstPageLoadingBuilder;
  final Widget Function(BuildContext context) noItemsFoundBuilder;
  final Widget Function(BuildContext context) newPageLoadingBuilder;
  final Widget Function(BuildContext context, Failure failure) newPageErrorBuilder;

  final double? cacheExtent;
  final EdgeInsetsGeometry? padding;

  final bool useSliver;

  /// Note, [SliverHeaders] can not have any kind of scrollable widgets or it will lead to unWanted behaviours
  /// like for example if you have horizontal list in SliverHeaders, and you scrolled to the end of this list, it will trigger the pagination page listener for your main list
  final List<Widget>? sliverHeaders;
  final Widget? sliverHeadersLoader;
  final bool attachLoaders;
  final bool isSliverHeadersLoading;
  final bool itemsIsSliver;

  final bool withInitialTrigger;

  const PaginatedListView({
    super.key,
    required this.controller,
    this.scrollController,
    this.physics,
    this.listKey,
    required this.itemBuilder,
    required this.firstPageErrorBuilder,
    required this.firstPageLoadingBuilder,
    required this.noItemsFoundBuilder,
    required this.newPageLoadingBuilder,
    required this.newPageErrorBuilder,
    this.cacheExtent,
    this.padding,
    this.scrollDirection = Axis.vertical, // Default to vertical
    this.withInitialTrigger = true
  })  : useSliver = false,
        sliverHeaders = null,
        sliverHeadersLoader = null,
        attachLoaders = false,
        isSliverHeadersLoading = false,
        itemsIsSliver = false;

  const PaginatedListView.sliver({
    super.key,
    required this.controller,
    this.scrollController,
    this.physics,
    required this.itemBuilder,
    required this.firstPageErrorBuilder,
    required this.firstPageLoadingBuilder,
    required this.noItemsFoundBuilder,
    required this.newPageLoadingBuilder,
    required this.newPageErrorBuilder,
    this.listKey,
    this.cacheExtent,
    this.padding,
    this.scrollDirection = Axis.vertical, // Default to vertical
    this.sliverHeaders,
    this.sliverHeadersLoader,
    this.attachLoaders = true,
    this.isSliverHeadersLoading = false,
    this.itemsIsSliver = false,
    this.withInitialTrigger = true
  }) : useSliver = true;

  @override
  State<PaginatedListView<K, T>> createState() =>
      _PaginatedListViewState<K, T>();
}

class _PaginatedListViewState<K, T> extends State<PaginatedListView<K, T>> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
          (_) => widget.controller.init(screenHeight: context.height),
    );
    super.initState();
  }

  Widget _buildSliverList(BuildContext context, PaginationState<K, T> state) {
    return CustomScrollView(
      controller: widget.scrollController,
      physics: widget.physics,
      scrollDirection: widget.scrollDirection,
      cacheExtent: widget.cacheExtent,
      slivers: [
        if (widget.attachLoaders && widget.isSliverHeadersLoading && state.isLoading)
          widget.sliverHeadersLoader ?? const SliverToBoxAdapter(child: SizedBox())
        else if (widget.attachLoaders && state.failure == null)
          ...?widget.sliverHeaders,

        if (state.items.isEmpty)
          SliverToBoxAdapter(
            child: _firstPageStateBuilder(state,headerLoading: widget.attachLoaders && widget.isSliverHeadersLoading && state.isLoading),
          )
        else if (widget.itemsIsSliver)
          ...List.generate(
            state.items.length,
                (index) => _buildSliverItem(state, index),
          )
        else
          SliverPadding(
            padding: widget.padding ?? EdgeInsets.zero,
            sliver: SliverList(
              key: widget.listKey,
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildItem(state, index),
                childCount: state.items.length,
              ),
            ),
          ),
      ],
    );
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
          if (widget.useSliver) {
            return _buildSliverList(context, state);
          } else {
            return _buildNormalList(context, state);
          }
        },
      ),
    );
  }

  Widget _buildNormalList(BuildContext context, PaginationState<K, T> state) {
    if (state.items.isEmpty) {
      return _firstPageStateBuilder(state);
    }
    return ListView.builder(
      key: widget.listKey,
      controller: widget.scrollController,
      physics: widget.physics,
      scrollDirection: widget.scrollDirection,
      cacheExtent: widget.cacheExtent,
      padding: widget.padding,
      itemCount: state.items.length,
      itemBuilder: (context, index) => _buildItem(state, index),
    );
  }

  Widget _firstPageStateBuilder(PaginationState state, {bool headerLoading = false}) {
    if (state.isLoading || headerLoading) {
      return widget.firstPageLoadingBuilder(context);
    } else if (state.failure != null) {
      return widget.firstPageErrorBuilder(context, state.failure!);
    } else {
      return widget.noItemsFoundBuilder(context);
    }
  }

  Widget _buildItem(PaginationState state, int index) {
    if (index == state.items.length - 1) {
      final List<Widget> children = [
        widget.itemBuilder(context, state.items[index], index),
        if (state.isLoading)
          widget.newPageLoadingBuilder(context)
        else if (state.failure != null)
          widget.newPageErrorBuilder(context, state.failure!)
      ];

      if (widget.scrollDirection == Axis.horizontal) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: children,
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    }

    return widget.itemBuilder(context, state.items[index], index);
  }

  Widget _buildSliverItem(PaginationState state, int index) {
    if (index == state.items.length - 1) {
      return SliverMainAxisGroup(
        slivers: [
          widget.itemBuilder(context, state.items[index], index),
          if (state.isLoading)
            SliverToBoxAdapter(
                child: widget.newPageLoadingBuilder(context)
            )
          else if (state.failure != null)
            SliverToBoxAdapter(
              child: widget.newPageErrorBuilder(context, state.failure!),
            )
        ],
      );
    }

    return widget.itemBuilder(context, state.items[index], index);
  }
}
