// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

part of nested_paginated_list;

class NestedPaginatedList<PageKeyType, ItemType> extends StatefulWidget {
  const NestedPaginatedList({
    super.key,
    required this.delegate,
    required this.controller,
  });

  final NestedPaginatedListDelegate<ItemType> delegate;
  final NestedPaginatedController<PageKeyType, ItemType> controller;

  @override
  State<NestedPaginatedList<PageKeyType, ItemType>> createState() =>
      _NestedPaginatedListState<PageKeyType, ItemType>();
}

class _NestedPaginatedListState<PageKeyType, ItemType>
    extends State<NestedPaginatedList<PageKeyType, ItemType>>
    with TickerProviderStateMixin {
  final _scrollController = ScrollController(
    keepScrollOffset: true,
  );

  NestedPaginatedController<PageKeyType, ItemType> get _pagingController =>
      widget.controller;

  ValueNotifier<List<NestedPaginatedItemEntity<ItemType>>>
      get _afterItemsValueNotifier => _pagingController.afterItemsValueNotifier;

  ValueNotifier<List<NestedPaginatedItemEntity<ItemType>>>
      get _beforeItemsValueNotifier =>
          _pagingController.beforeItemsValueNotifier;

  NestedPaginatedListDelegate<ItemType> get _builderDelegate => widget.delegate;

  ValueNotifier<_LoadingStatus> get _topLoadingNotifier =>
      _pagingController.beforeWidgetState;

  ValueNotifier<_LoadingStatus> get _bottomLoadingNotifier =>
      _pagingController.afterWidgetState;

  final ValueNotifier<NestedPaginatedListStatus> _nestedListStatus =
      ValueNotifier(NestedPaginatedListStatus.firstPageLoading);

  bool get _isTopScrollPagination {
    if (_scrollController.position.pixels <=
        _scrollController.position.minScrollExtent +
            MediaQuery.of(context).size.height * .2) {
      return true;
    }
    return false;
  }

  bool get _isScrollBottomPagination {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent -
            MediaQuery.of(context).size.height * .2) {
      return true;
    }
    return false;
  }

  void _scrollerListener() {
    _scrollController.addListener(() async {
      if (_isTopScrollPagination) {
        if (_topLoadingNotifier.value != _LoadingStatus.fail &&
            _topLoadingNotifier.value != _LoadingStatus.finish) {
          if (_topLoadingNotifier.value != _LoadingStatus.loading) {
            _topLoadingNotifier.value = _LoadingStatus.loading;
            _fetchItems(
                _pagingController.beforeCursor, PaginationDirectionEnum.before);
          }
        }
      } else if (_isScrollBottomPagination) {
        if (_bottomLoadingNotifier.value != _LoadingStatus.fail &&
            _bottomLoadingNotifier.value != _LoadingStatus.finish) {
          if (_bottomLoadingNotifier.value != _LoadingStatus.loading) {
            _bottomLoadingNotifier.value = _LoadingStatus.loading;
            _fetchItems(
                _pagingController.nextCursor, PaginationDirectionEnum.after);
          }
        }
      }
    });
  }

  Future<void> _fetchItems(
      PageKeyType? cursor, PaginationDirectionEnum direction) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pagingController.notifyPageRequestListeners(cursor, direction);
    });
  }

  void _statusListener() {
    _pagingController.addStatusListener((status) {
      _nestedListStatus.value = status;
      if (status == NestedPaginatedListStatus.completed) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (_scrollController.hasClients) {
            _scrollController.position.isScrollingNotifier.addListener(() {
              _scrollController.notifyListeners();
              // if(_scrollController.offset < MediaQuery.of(context).size.height * .4){}
            });
          }
        });
      }
    });
  }

  void _addItemScrollListener() {
    _pagingController.addScrollListener(
      (itemDetails, scrollState) {
        switch (scrollState) {
          case _NestedPaginatedScrollState.scrollToItem:
            if (itemDetails != null) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                  // final cacheExtent = _scrollController.position.extentTotal;
                  // _scrollController.position.copyWith(viewportDimension: cacheExtent);
                  // _scrollController.position.forcePixels(cacheExtent);

                final RenderBox? itemRenderBox = itemDetails.key.currentContext
                    ?.findRenderObject() as RenderBox?;
                if (itemRenderBox != null) {
                  _scrollController.position.ensureVisible(itemRenderBox,
                      duration: const Duration(milliseconds: 200));
                }
              });
            }
          case _NestedPaginatedScrollState.scrollToEnd:
            _scrollToEnd();
            break;
          case _NestedPaginatedScrollState.scrollToStart:
            _scrollToStart();
            break;
        }
      },
    );
  }

  void _scrollToStart() {
    _scrollController.jumpTo(_scrollController.position.minScrollExtent);
  }

  void _scrollToEnd() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }


  @override
  void initState() {
    _statusListener();
    _fetchItems(_pagingController.nextCursor, PaginationDirectionEnum.after);
    _scrollerListener();
    _addItemScrollListener();
    super.initState();
  }

  final Key _centerKey = const ValueKey('nested-sliver-package-list');

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<NestedPaginatedListStatus>(
      valueListenable: _nestedListStatus,
      builder: (context, value, child) {
        Widget child;
        switch (value) {
          case NestedPaginatedListStatus.firstPageLoading:
            child = _firstPageLoadingWidget;
          case NestedPaginatedListStatus.firstPageError:
            child = _firstPageErrorWidget;
          case NestedPaginatedListStatus.noDataFound:
            child = _noDataFoundWidget;
          case NestedPaginatedListStatus.completed:
            child = Stack(
              children: [
                CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  center: _centerKey,
                  scrollBehavior: DisableOverscrollBehavior(),
                  slivers: [
                    ValueListenableBuilder<_LoadingStatus>(
                      valueListenable: _topLoadingNotifier,
                      key: GlobalKey(),
                      builder: (context, value, child) {
                        Widget child;
                        switch (value) {
                          case _LoadingStatus.initial:
                          case _LoadingStatus.finish:
                            child = const SizedBox();
                          case _LoadingStatus.loading:
                            child = _loadMoreLoaderWidget(
                                PaginationDirectionEnum.before);
                          case _LoadingStatus.fail:
                            child = _loadMoreErrorWidget(
                                PaginationDirectionEnum.before);
                        }
                        // child = _loadMoreLoaderWidget;
                        return SliverToBoxAdapter(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 350),
                            child: child,
                          ),
                        );
                      },
                    ),
                    ValueListenableBuilder<
                        List<NestedPaginatedItemEntity<ItemType>>>(
                      valueListenable: _beforeItemsValueNotifier,
                      builder: (context, value, child) {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            addAutomaticKeepAlives: true,
                            (BuildContext context, int index) {
                              final itemDetails = value[index];
                              return SizedBox(
                                key: itemDetails.key,
                                child: _builderDelegate.itemBuilder(
                                  context,
                                  index,
                                  itemDetails.item,
                                  itemDetails,
                                ),
                              );
                            },
                            childCount: value.length,
                          ),
                        );
                      },
                    ),
                    ValueListenableBuilder<
                        List<NestedPaginatedItemEntity<ItemType>>>(
                      key: _centerKey,
                      valueListenable: _afterItemsValueNotifier,
                      builder: (context, value, child) {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            addAutomaticKeepAlives: true,
                            (BuildContext context, int index) {
                              final itemDetails = value[index];
                              return SizedBox(
                                key: itemDetails.key,
                                child: _builderDelegate.itemBuilder(
                                  context,
                                  index,
                                  itemDetails.item,
                                  itemDetails,
                                ),
                              );
                            },
                            childCount: value.length,
                          ),
                        );
                      },
                    ),
                    ValueListenableBuilder<_LoadingStatus>(
                      valueListenable: _bottomLoadingNotifier,
                      key: GlobalKey(),
                      builder: (context, value, child) {
                        Widget child;
                        switch (value) {
                          case _LoadingStatus.initial:
                          case _LoadingStatus.finish:
                            child = const SizedBox();
                          case _LoadingStatus.loading:
                            child = _loadMoreLoaderWidget(
                                PaginationDirectionEnum.after);
                          case _LoadingStatus.fail:
                            child =
                                _loadMoreErrorWidget(PaginationDirectionEnum.after);
                        }
                        return SliverToBoxAdapter(
                          child: child,
                        );
                      },
                    ),
                  ],
                ),
                Positioned(
                    left: 0,
                    right: 0,
                    bottom: MediaQuery.of(context).size.height * .04,
                    child: _refreshInductorWidget),
              ],
            );
        }
        return child;
      },
    );
  }

  Widget get _firstPageLoadingWidget {
    if (_builderDelegate.firstPageLoaderBuilder != null) {
      return _builderDelegate.firstPageLoaderBuilder!(context);
    }
    return const DefaultFirstPageLoaderBuilder();
  }

  Widget get _firstPageErrorWidget {
    if (_builderDelegate.firstPageErrorBuilder != null) {
      return _builderDelegate.firstPageErrorBuilder!(context);
    }
    return _DefaultFirstPageErrorBuilder(
      onTap: () {
        _pagingController.refresh();
      },
    );
  }

  Widget _loadMoreErrorWidget(PaginationDirectionEnum direction) {
    retryFunction() {
      if (direction == PaginationDirectionEnum.after) {
        _pagingController.requestLastAfterFailRequest();
      } else {
        _pagingController.requestLastBeforeFailRequest();
      }
    }

    if (_builderDelegate.failLoadMoreBuilder != null) {
      return _builderDelegate.failLoadMoreBuilder!(
          context, direction, retryFunction);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: PaddingDimensions.normal),
      child: AnimatedLoadingButton(
        onTap: (animation) {
          retryFunction();
        },
        text: 'CommonLocalizer.loadMore',
        isLoading: false,
      ),
    );
  }

  Widget _loadMoreLoaderWidget(PaginationDirectionEnum direction) {
    if (_builderDelegate.loadMoreBuilder != null) {
      return _builderDelegate.loadMoreBuilder!(context, direction);
    }
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: PaddingDimensions.normal),
      child: AnimatedLoadingButton(
        isLoading: true,
      ),
    );
  }

  Widget get _noDataFoundWidget {
    if (_builderDelegate.noDataFoundBuilder != null) {
      return _builderDelegate.noDataFoundBuilder!(context);
    }
    return const _DefaultNoDataFoundBuilder();
  }

  Widget get _refreshInductorWidget {
    if (_builderDelegate.refreshInductorWidget != null) {
      return _builderDelegate.refreshInductorWidget!(context);
    }
    return const SizedBox();
  }

  @override
  void dispose() {
    _nestedListStatus.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
