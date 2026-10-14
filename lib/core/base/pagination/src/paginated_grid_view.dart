part of custom_pagination;

class PaginatedGridView<K, T> extends StatefulWidget {
  final PaginationController<K, T> controller;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget Function(BuildContext context, Failure failure)
  firstPageErrorBuilder;
  final Widget Function(BuildContext context) firstPageLoadingBuilder;
  final Widget Function(BuildContext context) noItemsFoundBuilder;
  final Widget Function(BuildContext context) newPageLoadingBuilder;
  final Widget Function(BuildContext context, Failure failure)
  newPageErrorBuilder;

  final double? cacheExtent;
  final EdgeInsetsGeometry? padding;
  final bool useSliver;
  final List<Widget>? sliverHeaders;

  // Additional properties for Grid layout
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;

  const PaginatedGridView({
    super.key,
    required this.controller,
    required this.itemBuilder,
    required this.firstPageErrorBuilder,
    required this.firstPageLoadingBuilder,
    required this.noItemsFoundBuilder,
    required this.newPageLoadingBuilder,
    required this.newPageErrorBuilder,
    this.cacheExtent,
    this.padding,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 8.0,
    this.crossAxisSpacing = 8.0,
    required this.childAspectRatio,
  })  : useSliver = false,
        sliverHeaders = null;

  const PaginatedGridView.sliver({
    super.key,
    required this.controller,
    required this.itemBuilder,
    required this.firstPageErrorBuilder,
    required this.firstPageLoadingBuilder,
    required this.noItemsFoundBuilder,
    required this.newPageLoadingBuilder,
    required this.newPageErrorBuilder,
    this.cacheExtent,
    this.padding,
    this.sliverHeaders,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 8.0,
    this.crossAxisSpacing = 8.0,
    this.childAspectRatio = 1.0,
  }) : useSliver = true;

  @override
  State<PaginatedGridView<K, T>> createState() =>
      _PaginatedGridViewState<K, T>();
}

class _PaginatedGridViewState<K, T> extends State<PaginatedGridView<K, T>> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.controller.init(
        screenHeight: context.height,
      );
    });
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
            return CustomScrollView(
              cacheExtent: widget.cacheExtent,
              slivers: [
                if (widget.sliverHeaders != null) ...widget.sliverHeaders!,
                if (state.items.isEmpty)
                  SliverFillRemaining(
                    child: _firstPageStateBuilder(state),
                  )
                else
                  SliverPadding(
                    padding: widget.padding ?? EdgeInsets.zero,
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) => _buildItem(state, index),
                        childCount: state.items.length +
                            ((state.isLoading || state.failure != null)
                                ? 1
                                : 0),
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: widget.crossAxisCount,
                        mainAxisSpacing: widget.mainAxisSpacing,
                        crossAxisSpacing: widget.crossAxisSpacing,
                        childAspectRatio: widget.childAspectRatio,
                      ),
                    ),
                  ),
              ],
            );
          } else {
            if (state.items.isEmpty) {
              return _firstPageStateBuilder(state);
            }

            return GridView.builder(
              padding: widget.padding,
              physics: const ClampingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.crossAxisCount,
                mainAxisSpacing: widget.mainAxisSpacing,
                crossAxisSpacing: widget.crossAxisSpacing,
                childAspectRatio: widget.childAspectRatio,
              ),
              itemCount: state.items.length +
                  ((state.isLoading || state.failure != null) ? 1 : 0),
              cacheExtent: widget.cacheExtent,
              itemBuilder: (context, index) => _buildItem(state, index),
            );
          }
        },
      ),
    );
  }

  Widget _firstPageStateBuilder(PaginationState state) {
    Widget child;

    if (state.isLoading) {
      child = widget.firstPageLoadingBuilder(context);
    } else if (state.failure != null) {
      child = widget.firstPageErrorBuilder(context, state.failure!);
    } else {
      child = widget.noItemsFoundBuilder(context);
    }

    if (widget.padding != null) {
      return Padding(
        padding: widget.padding!,
        child: child,
      );
    } else {
      return child;
    }
  }

  Widget _buildItem(PaginationState<K, T> state, int index) {
    if (index == state.items.length) {
      if (state.isLoading) {
        return widget.newPageLoadingBuilder(context);
      } else if (state.failure != null) {
        return widget.newPageErrorBuilder(context, state.failure!);
      }
    }

    return widget.itemBuilder(context, state.items[index], index);
  }
}
