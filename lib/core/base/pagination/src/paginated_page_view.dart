part of custom_pagination;

class PaginatedPageView<K, T> extends StatefulWidget {
  final PaginationController<K, T> controller;
  final PageController? pageController;
  final ScrollPhysics? physics;
  final void Function(int)? onPageChanged;
  final Axis scrollDirection;

  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget Function(BuildContext context, Failure failure)firstPageErrorBuilder;
  final Widget Function(BuildContext context) firstPageLoadingBuilder;
  final Widget Function(BuildContext context) noItemsFoundBuilder;
  final Widget Function(BuildContext context) noMoreItemsFoundBuilder;
  final Widget Function(BuildContext context) newPageLoadingBuilder;
  final Widget Function(BuildContext context, Failure failure) newPageErrorBuilder;

  const PaginatedPageView({
    super.key,
    required this.controller,
    required this.pageController,
    this.physics,
    this.scrollDirection = Axis.horizontal,
    required this.itemBuilder,
    required this.firstPageErrorBuilder,
    required this.firstPageLoadingBuilder,
    required this.noItemsFoundBuilder,
    required this.noMoreItemsFoundBuilder,
    required this.newPageLoadingBuilder,
    required this.newPageErrorBuilder,
    this.onPageChanged,
  });

  @override
  State<PaginatedPageView<K, T>> createState() =>
      _PaginatedPageViewState<K, T>();
}

class _PaginatedPageViewState<K, T> extends State<PaginatedPageView<K, T>> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.controller.init(
          screenHeight: context.height,
          triggerExtent: context.height * 4
      );
    },
    );

    super.initState();
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
          if(state.items.isEmpty){
            return _firstPageStateBuilder(state);
          }

          return PageView.builder(
            controller: widget.pageController,
            physics: widget.physics,
            itemCount: state.items.length + 1,
            onPageChanged: widget.onPageChanged,
            scrollDirection: widget.scrollDirection,
            itemBuilder: (context, index) {
              return _buildItem(state, index);
            },
          );
        },
      ),
    );
  }

  Widget _firstPageStateBuilder(PaginationState state){
    if (state.isLoading) {
      return widget.firstPageLoadingBuilder(context);
    } else if (state.failure != null){
      return widget.firstPageErrorBuilder(context, state.failure!);
    } else{
      return widget.noItemsFoundBuilder(context);
    }
  }

  Widget _buildItem(PaginationState state, int index) {
    if (index == state.items.length) {
      if (state.isLoading) {
        return widget.newPageLoadingBuilder(context);
      } else if (state.failure != null) {
        return widget.newPageErrorBuilder(context, state.failure!);
      }else{
        return widget.noMoreItemsFoundBuilder(context);
      }
    }

    return widget.itemBuilder(context, state.items[index], index);
  }
}
