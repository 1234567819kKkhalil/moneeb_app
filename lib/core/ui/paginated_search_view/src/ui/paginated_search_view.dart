part of paginated_search_view;

class PaginatedSearchView<T> extends StatelessWidget {
  final FutureOr<PaginatedData<T>?> Function(String searchTerm, int pageKey)
  requestData;

  final Widget Function(
    BuildContext context,
    T item,
    int index,
    int itemsLength,
  )
  itemBuilder;
  final T? loadingItem;

  final Widget Function(BuildContext)? noItemsFoundIndicatorBuilder;
  final String? noItemsFoundLabel;

  final bool isLiveSearch;
  final bool showBackIcon;
  final String? searchHintText;

  final EdgeInsetsGeometry? padding;

  final List<T> Function(PaginatedData<T> paginatedData)? processOnItems;

  final bool autoFetch;

  final Widget? bottomWidget;

  const PaginatedSearchView({
    super.key,
    required this.requestData,
    required this.itemBuilder,
    this.loadingItem,
    this.noItemsFoundIndicatorBuilder,
    this.noItemsFoundLabel,
    this.isLiveSearch = false,
    this.showBackIcon = false,
    this.searchHintText,
    this.padding = EdgeInsets.zero,
    this.processOnItems,
    this.autoFetch = true,
    this.bottomWidget,
  }) : assert(
         noItemsFoundLabel == null || noItemsFoundIndicatorBuilder == null,
         'Provide one of this',
       );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaginatedSearchViewBloc<T>(requestData: requestData),
      child: _PaginatedSearchViewBody<T>(
        isLiveSearch: isLiveSearch,
        itemBuilder: itemBuilder,
        searchHintText: searchHintText,
        showBackIcon: showBackIcon,
        noItemsFoundIndicatorBuilder: noItemsFoundIndicatorBuilder,
        noItemsFoundLabel: noItemsFoundLabel,
        padding: padding,
        processOnItems: processOnItems,
        loadingItem: loadingItem,
        autoFetch: autoFetch,
        bottomWidget: bottomWidget,
      ),
    );
  }
}

class _PaginatedSearchViewBody<T> extends StatefulWidget {
  final Widget Function(
    BuildContext context,
    T item,
    int index,
    int itemsLength,
  )
  itemBuilder;
  final T? loadingItem;

  final Widget Function(BuildContext)? noItemsFoundIndicatorBuilder;
  final String? noItemsFoundLabel;

  final bool isLiveSearch;
  final bool showBackIcon;

  final String? searchHintText;

  final EdgeInsetsGeometry? padding;

  final List<T> Function(PaginatedData<T> paginatedData)? processOnItems;

  final bool autoFetch;
  final Widget? bottomWidget;

  const _PaginatedSearchViewBody({
    super.key,
    required this.itemBuilder,
    required this.isLiveSearch,
    required this.showBackIcon,
    this.noItemsFoundIndicatorBuilder,
    this.searchHintText,
    this.noItemsFoundLabel,
    this.padding,
    this.processOnItems,
    this.loadingItem,
    this.bottomWidget,
    required this.autoFetch,
  });

  @override
  State<_PaginatedSearchViewBody<T>> createState() =>
      _PaginatedSearchViewBodyState<T>();
}

class _PaginatedSearchViewBodyState<T>
    extends State<_PaginatedSearchViewBody<T>>
    with ConnectivityMonitorMixin, SearchObserverMixin {
  final TextEditingController _searchTextController = TextEditingController();
  late final PaginationController<int, T> _pagingController;

  @override
  void initState() {
    super.initState();
    _searchTextController.text = '';

    _pagingController = PaginationController<int, T>(
      initialPageKey: 1,
      autoFetch: widget.autoFetch,
    );

    _pagingController.addPageRequestListener((pageKey) {
      context.read<PaginatedSearchViewBloc<T>>().add(
        GetPaginatedSearchResultsEvent(_searchTextController.text, pageKey),
      );
    });

    initSearchObserver<T>(
      updateItem: ({required newItem, required updateWhere}) {
        _pagingController.refresh();
        // print('${newItem}, ${updateWhere}');
        // print('${_pagingController.state.items}');
        // _pagingController.updateItem(updateWhere: updateWhere, newItem: newItem);
        // print('${_pagingController.state.items}');
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pagingController.dispose();
    _searchTextController.dispose();
  }

  void _requestNewSearchData(String query) {
    if (query.isEmpty) {
      _onClear();
    } else {
      context.read<PaginatedSearchViewBloc<T>>().add(
        GetPaginatedSearchResultsEvent(_searchTextController.text, 1),
      );
      _pagingController.refresh();
    }
  }

  void _onClear() {
    if (widget.autoFetch) {
      _pagingController.refresh();
    } else {
      _pagingController.removeAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSearchTextField(
          controller: _searchTextController,
          isLiveSearch: widget.isLiveSearch,
          onClear: _onClear,
          requestNewSearchData: _requestNewSearchData,
          searchHintText: widget.searchHintText,
          showBackIcon: widget.showBackIcon,
        ),
        const Gap(PaddingDimensions.medium),
        Expanded(
          child:
              BlocListener<
                PaginatedSearchViewBloc<T>,
                PaginatedSearchViewState<T>
              >(
                listener: (context, state) {
                  if (state.searchResults.isSuccess) {
                    final paginatedData = state.searchResults.data!;
                    final processedItems =
                        widget.processOnItems?.call(paginatedData) ??
                        paginatedData.items;

                    _pagingController.appendPage(
                      newItems: processedItems,
                      newKey: paginatedData.pageInfo.page + 1,
                      isLastPage: !paginatedData.pageInfo.hasNext,
                    );
                  } else if (state.searchResults.isFailure) {
                    _pagingController.setError(state.searchResults.failure);
                  }
                },
                child: PaginatedListView<int, T>(
                  padding: EdgeInsets.zero,
                  withInitialTrigger: false,
                  controller: _pagingController,
                  firstPageErrorBuilder: (context, failure) {
                    return FailureWidget(
                      failure: failure,
                      onRetryPressed: () => _pagingController.refresh(),
                    );
                  },
                  firstPageLoadingBuilder: (context) {
                    return widget.loadingItem != null
                        ? ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return AppSkeletonizer(
                                isEnabled: true,
                                child: widget.itemBuilder(
                                  context,
                                  widget.loadingItem as T,
                                  index,
                                  4,
                                ),
                              );
                            },
                          )
                        : const Center(child: AppProgressIndicator());
                  },
                  newPageErrorBuilder: (context, failure) {
                    return NewPageErrorWidget(
                      failure: failure,
                      onReloadTap: () => _pagingController.refresh(),
                    );
                  },
                  newPageLoadingBuilder: (context) {
                    return const Center(child: AppProgressIndicator());
                  },
                  noItemsFoundBuilder: (context) {
                    if (widget.noItemsFoundIndicatorBuilder != null) {
                      return widget.noItemsFoundIndicatorBuilder!(context);
                    }
                    return NoItemsFoundWidget(
                      enableRefreshSupport: false,
                      // svgImagePath: SvgPaths.postsIllustration,
                      text: widget.noItemsFoundLabel,
                    );
                  },
                  itemBuilder: (context, item, index) {
                    return widget.itemBuilder(
                      context,
                      item,
                      index,
                      _pagingController.state.items.length,
                    );
                  },
                ),
              ),
        ),
        if (widget.bottomWidget != null) widget.bottomWidget!,
      ],
    );
  }

  @override
  void onConnectivityChanges(bool isHasInternet) {
    if (isHasInternet) {
      if (widget.autoFetch && _searchTextController.text.isEmpty) {
        _pagingController.removeAll();
      } else {
        _pagingController.refresh();
      }
    }
  }
}
