part of nested_paginated_list;

typedef PageRequestListener<PageKeyType, CursorPaginationDirection> = void
    Function(PageKeyType? cursor, CursorPaginationDirection direction);

typedef StatusListener<NestedPaginatedListStatus> = void Function(
    NestedPaginatedListStatus status);

typedef ItemScrollListener<NestedPaginatedItem> = void Function(
    NestedPaginatedItem? itemDetails, _NestedPaginatedScrollState scrollState);

typedef _WhereCondition<ItemType> = bool Function(ItemType e);

class NestedPaginatedController<PageKeyType, ItemType> extends ChangeNotifier {
  final ValueNotifier<List<NestedPaginatedItemEntity<ItemType>>> _beforeList =
      ValueNotifier([]);
  final ValueNotifier<List<NestedPaginatedItemEntity<ItemType>>> _afterList =
      ValueNotifier([]);

  ValueNotifier<List<NestedPaginatedItemEntity<ItemType>>>
      get beforeItemsValueNotifier => _beforeList;

  ValueNotifier<List<NestedPaginatedItemEntity<ItemType>>>
      get afterItemsValueNotifier => _afterList;

  List<ItemType> get beforeItems =>
      _beforeList.value.map((e) => e.item).toList();

  List<ItemType> get afterItems => _afterList.value.map((e) => e.item).toList();

  /// [_items] Has All Loaded Items
  final List<NestedPaginatedItemEntity<ItemType>> _items = [];

  List<NestedPaginatedItemEntity<ItemType>> get items => _items;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  PageKeyType? _nextCursor;
  PageKeyType? _beforeCursor;

  PageKeyType? get nextCursor => _nextCursor;

  PageKeyType? get beforeCursor => _beforeCursor;

  _LoadingStatus _firstPageState = _LoadingStatus.initial;

  final ValueNotifier<_LoadingStatus> afterWidgetState =
      ValueNotifier(_LoadingStatus.initial);
  final ValueNotifier<_LoadingStatus> beforeWidgetState =
      ValueNotifier(_LoadingStatus.initial);

  void onDataLoaded(CursorPaginatedData<ItemType> cursorData) {
    final pageInfo = cursorData.pageInfo;
    if (_firstPageState != _LoadingStatus.finish) {
      _firstPageState == _LoadingStatus.loading;
    }

    switch (pageInfo.direction) {
      case PaginationDirectionEnum.after:
        _addToAfterList(cursorData);
        _nextCursor = pageInfo.nextCursor;
        if (pageInfo.hasNext) {
          afterWidgetState.value = _LoadingStatus.initial;
        } else {
          afterWidgetState.value = _LoadingStatus.finish;
        }
      case PaginationDirectionEnum.before:
        _addToBeforeList(cursorData);
        _beforeCursor = pageInfo.beforeCursor;
        if (pageInfo.hasBefore) {
          beforeWidgetState.value = _LoadingStatus.initial;
        } else {
          beforeWidgetState.value = _LoadingStatus.finish;
        }
    }

    if (_firstPageState != _LoadingStatus.finish) {
      if (beforeItems.isEmpty && afterItems.isEmpty) {
        notifyStatusRequestListeners(NestedPaginatedListStatus.noDataFound);
      } else if (afterItems.isNotEmpty || beforeItems.isNotEmpty) {
        notifyStatusRequestListeners(NestedPaginatedListStatus.completed);
      }
    }

    _firstPageState = _LoadingStatus.finish;
  }

  void _addToAfterList(CursorPaginatedData<ItemType> cursorData) {
    final pageInfo = cursorData.pageInfo;
    final newList = cursorData.items;
    final List<NestedPaginatedItemEntity<ItemType>> newItemsEntityList = [];
    final int newListLength = afterItems.length + newList.length;
    for (int index = 0; index < newList.length; index++) {
      final item = newList[index];
      final int directionalIndex = afterItems.length + index;

      final entity = NestedPaginatedItemEntity<ItemType>(
        item: item,
        direction: PaginationDirectionEnum.after,
        indexInDirectionalList: directionalIndex,
        indexInWholeList: directionalIndex + beforeItems.length,
        isFirstItem: false,
        isLastItem: ((directionalIndex + 1) == newListLength),
      );
      newItemsEntityList.add(entity);
    }
    _afterList.value = [..._afterList.value, ...newItemsEntityList];
    _setItems();
  }

  void _addToBeforeList(CursorPaginatedData<ItemType> cursorData) {
    final pageInfo = cursorData.pageInfo;
    final newList = cursorData.items;
    final List<NestedPaginatedItemEntity<ItemType>> newItemsEntityList = [];
    final int newListLength = beforeItems.length + newList.length;
    for (int index = 0; index < newList.length; index++) {
      final item = newList[index];
      final int directionalIndex = beforeItems.length + index;
      final entity = NestedPaginatedItemEntity<ItemType>(
        item: item,
        direction: PaginationDirectionEnum.before,
        indexInDirectionalList: directionalIndex,
        indexInWholeList: directionalIndex,
        isFirstItem: (directionalIndex + 1) == newListLength &&
            pageInfo.hasBefore == false,
        isLastItem: false,
      );
      newItemsEntityList.add(entity);
    }
    _beforeList.value = [..._beforeList.value, ...newItemsEntityList];
    _setItems();
  }

  void _setItems() {
    _items.clear();
    _items.addAll([..._beforeList.value, ..._afterList.value]);
  }

  void setError(String? errorMessage) {
    _errorMessage = errorMessage;
    if (_firstPageState != _LoadingStatus.finish) {
      _firstPageState == _LoadingStatus.fail;
      notifyStatusRequestListeners(NestedPaginatedListStatus.firstPageError);
    } else {
      if (afterWidgetState.value == _LoadingStatus.loading) {
        afterWidgetState.value = _LoadingStatus.fail;
      }
      if (beforeWidgetState.value == _LoadingStatus.loading) {
        beforeWidgetState.value = _LoadingStatus.fail;
      }
    }
  }

  void removeWhere(_WhereCondition<ItemType> where) {
    final itemInfo = getItemWhere(where);
    if (itemInfo != null) {
      switch (itemInfo.direction) {
        case PaginationDirectionEnum.before:
          _beforeList.value.removeAt(itemInfo.indexInDirectionalList);
          break;
        case PaginationDirectionEnum.after:
          _afterList.value.removeAt(itemInfo.indexInDirectionalList);
          break;
      }
    }
  }

  void updateItem(_WhereCondition<ItemType> where, ItemType newItem) {
    final itemInfo = getItemWhere(where);
    if (itemInfo != null) {
      switch (itemInfo.direction) {
        case PaginationDirectionEnum.after:
          _afterList.value[itemInfo.indexInDirectionalList] =
              itemInfo.copyWith(item: newItem);
          _afterList.notifyListeners();
          break;
        case PaginationDirectionEnum.before:
          _beforeList.value[itemInfo.indexInDirectionalList] =
              itemInfo.copyWith(item: newItem);
          _beforeList.notifyListeners();
          break;
      }
    }
  }

  NestedPaginatedItemEntity<ItemType>? getItemWhere(
      _WhereCondition<ItemType> where) {
    final int? indexInAfter =
        _afterList.value.firstIndexWhere((e) => where(e.item));
    if (indexInAfter != null) {
      return _afterList.value[indexInAfter];
    } else {
      final int? indexInBefore =
          _beforeList.value.firstIndexWhere((e) => where(e.item));
      if (indexInBefore != null) {
        return _afterList.value[indexInBefore];
      } else {
        debugPrint('[Nested Paginated] Item Not Exist in data');
      }
    }
    return null;
  }

  void requestLastAfterFailRequest() {
    afterWidgetState.value = _LoadingStatus.loading;
    notifyPageRequestListeners(_nextCursor, PaginationDirectionEnum.after);
  }

  void requestLastBeforeFailRequest() {
    beforeWidgetState.value = _LoadingStatus.loading;
    notifyPageRequestListeners(_beforeCursor, PaginationDirectionEnum.before);
  }

  void refresh() {
    items.clear();
    _errorMessage = null;

    _firstPageState = _LoadingStatus.initial;
    _errorMessage = null;

    afterWidgetState.value = _LoadingStatus.initial;
    beforeWidgetState.value = _LoadingStatus.initial;

    _beforeList.value.clear();
    beforeItems.clear();
    _beforeCursor = null;

    _afterList.value.clear();
    afterItems.clear();
    _nextCursor = null;

    _items.clear();

    notifyStatusRequestListeners(NestedPaginatedListStatus.firstPageLoading);
    notifyPageRequestListeners(_nextCursor, PaginationDirectionEnum.after);
  }

// Observers -------------------------------------

  ObserverList<PageRequestListener<PageKeyType?, PaginationDirectionEnum>>?
      _pageRequestListeners =
      ObserverList<PageRequestListener<PageKeyType?, PaginationDirectionEnum>>();

  void addPageRequestListener(
      PageRequestListener<PageKeyType?, PaginationDirectionEnum> listener) {
    _pageRequestListeners!.add(listener);
  }

  void removePageRequestListener(
      PageRequestListener<PageKeyType?, PaginationDirectionEnum> listener) {
    _pageRequestListeners!.remove(listener);
  }

  void notifyPageRequestListeners(
      PageKeyType? cursor, PaginationDirectionEnum direction) {
    if (_pageRequestListeners!.isEmpty) {
      return;
    }

    final localListeners =
        List<PageRequestListener<PageKeyType, PaginationDirectionEnum>>.from(
            _pageRequestListeners!);
    for (var listener in localListeners) {
      if (_pageRequestListeners!.contains(listener)) {
        listener(cursor, direction);
      }
    }
  }

  ObserverList<StatusListener<NestedPaginatedListStatus>>? _statusListeners =
      ObserverList<StatusListener<NestedPaginatedListStatus>>();

  void addStatusListener(StatusListener<NestedPaginatedListStatus> listener) {
    _statusListeners!.add(listener);
  }

  void removeStatusRequestListener(
      StatusListener<NestedPaginatedListStatus> listener) {
    _statusListeners!.remove(listener);
  }

  void notifyStatusRequestListeners(NestedPaginatedListStatus status) {
    if (_statusListeners!.isEmpty) {
      return;
    }

    final localListeners =
        List<StatusListener<NestedPaginatedListStatus>>.from(_statusListeners!);

    for (var listener in localListeners) {
      if (_statusListeners!.contains(listener)) {
        listener(status);
      }
    }
  }

  // Add Item Scroll Listener And Handlers
  ObserverList<ItemScrollListener<NestedPaginatedItemEntity<ItemType>>>?
      _scrollListeners =
      ObserverList<ItemScrollListener<NestedPaginatedItemEntity<ItemType>>>();

  void addScrollListener(
      ItemScrollListener<NestedPaginatedItemEntity<ItemType>> listener) {
    _scrollListeners!.add(listener);
  }

  void removeScrollListener(
      ItemScrollListener<NestedPaginatedItemEntity<ItemType>> listener) {
    if (_scrollListeners != null) {
      _scrollListeners!.remove(listener);
    }
  }

  void notifyScrollListeners(_NestedPaginatedScrollState state,
      [NestedPaginatedItemEntity<ItemType>? itemDetails]) {
    if (_scrollListeners!.isEmpty) {
      return;
    }

    final localListeners =
        List<ItemScrollListener<NestedPaginatedItemEntity<ItemType>>>.from(
            _scrollListeners!);

    for (var listener in localListeners) {
      if (_scrollListeners!.contains(listener)) {
        listener(itemDetails, state);
      }
    }
  }

  void scrollToItemWhere(_WhereCondition<ItemType> where) {
    final itemDetails = getItemWhere(where);
    if (itemDetails != null) {
      notifyScrollListeners(
          _NestedPaginatedScrollState.scrollToItem, itemDetails);
    }
  }

  void scrollToEnd() {
    notifyScrollListeners(_NestedPaginatedScrollState.scrollToEnd);
  }

  void scrollToStart() {
    notifyScrollListeners(_NestedPaginatedScrollState.scrollToStart);
  }

  @override
  void dispose() {
    _pageRequestListeners = null;
    _statusListeners = null;
    _scrollListeners = null;
    _items.clear();
    _beforeList.dispose();
    _afterList.dispose();

    afterWidgetState.dispose();
    beforeWidgetState.dispose();
    super.dispose();
  }
}

enum NestedPaginatedListStatus {
  firstPageLoading,
  firstPageError,
  noDataFound,
  completed
}

enum _LoadingStatus { fail, finish, initial, loading }

enum _NestedPaginatedScrollState { scrollToItem, scrollToStart, scrollToEnd }
