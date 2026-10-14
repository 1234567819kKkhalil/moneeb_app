part of custom_pagination;

class PaginationController<K, T>{
  final K initialPageKey;
  final bool autoFetch;
  bool Function(ScrollNotification scrollNotification)? customTriggerThreshold;

  PaginationController({
    required this.initialPageKey,
    this.customTriggerThreshold,
    this.autoFetch = true,
  }) {
    _paginatedStateNotifier = ValueNotifier(PaginationState<K,T>.initial(initialKey: initialPageKey,autoFetch: autoFetch));
  }

  void setCustomTriggerThreshold(bool Function(ScrollNotification scrollNotification) threshold){
    customTriggerThreshold = threshold;
  }

  void removeCustomTriggerThreshold(){
    customTriggerThreshold = null;
  }

  double _screenHeight = 0;
  double _triggerExtent = 0;
  double get getTriggerExtent => _triggerExtent;

  //List of page request listeners
  final ObserverList<void Function(K pageKey)> _listeners = ObserverList();

  //State that contains data, loading, failure. pageInfo ..etc
  late final ValueNotifier<PaginationState<K, T>> _paginatedStateNotifier;
  ValueNotifier<PaginationState<K, T>> get paginatedStateNotifier => _paginatedStateNotifier;
  PaginationState<K, T> get state => _paginatedStateNotifier.value;

  //stop listening to the scroll controller or the request listeners when this condition comes true
  bool get _shouldStopListening => state.isLoading || state.isLastPage || state.failure != null;


  Completer? requestCompleter;

  void _requestCompleted(){
    if(!(requestCompleter?.isCompleted ?? true)){
      requestCompleter?.complete();
    }

    requestCompleter = null;
  }

  void _setRequestCompleter(){
    _requestCompleted();
    requestCompleter = Completer();
  }

  void addPageRequestListener(void Function(K pageKey) callback){
    if(!_listeners.contains(callback)){
      _listeners.add(callback);
    }

    _requestCompleted();
  }

  void removePageRequestListener(void Function(K pageKey) callback){
    _listeners.remove(callback);
  }

  void triggerFetchListeners({K? newPageKey}){
    if (state.isLastPage) {
      return;
    }

    _paginatedStateNotifier.value = _paginatedStateNotifier.value.copyWith(
      isLoading: true,
      pageKey: newPageKey,
      failure: null,
    );

    for(var listener in _listeners){
      listener(state.pageKey);
    }

    _setRequestCompleter();
  }

  void setError(Failure? failure){
    _paginatedStateNotifier.value = _paginatedStateNotifier.value.copyWith(
      isLoading: false,
      failure: failure,
    );

    _requestCompleted();
  }

  void retryLastFailedRequest(){
    _paginatedStateNotifier.value = _paginatedStateNotifier.value.copyWith(
        failure: null,
        isLoading: true,
    );

    triggerFetchListeners();
  }

  void refresh(){
    _setRequestCompleter();

    _paginatedStateNotifier.value = _paginatedStateNotifier.value.copyWith(
      failure: null,
      isLoading: true,
      pageKey: initialPageKey,
      items: [],
      isLastPage: false,
    );

    for(var listener in _listeners){
      listener(state.pageKey);
    }
  }


  void appendPage({required List<T> newItems, required K newKey,required bool isLastPage}){
    _paginatedStateNotifier.value = _paginatedStateNotifier.value.copyWith(
      isLoading: false,
      isLastPage: isLastPage,
      pageKey: newKey,
      items: <T>[...state.items, ...newItems],
      failure: state.failure,
    );

    _paginatedStateNotifier.notifyListeners();
    _requestCompleted();
  }

  void insertPage({required List<T> newItems, required K newKey,required bool isLastPage, int insertAt = 0}){
    _paginatedStateNotifier.value = _paginatedStateNotifier.value.copyWith(
      isLoading: false,
      isLastPage: isLastPage,
      pageKey: newKey,
      items: state.items.isEmpty ? <T>[...newItems] : <T>[...state.items..insertAll(insertAt, newItems)], //when using [insertAll], The list must not be empty so we did this check
      failure: state.failure,
    );

    _paginatedStateNotifier.notifyListeners();
    _requestCompleted();
  }

  bool initCalled = false;
  void init({
    required double screenHeight,
    double? triggerExtent,
  }){
    //Set screen height and trigger extent
    _screenHeight = screenHeight;
    _triggerExtent = triggerExtent ?? _screenHeight * 0.8;

    if (!initCalled && autoFetch) {
      //Trigger initial request
      triggerFetchListeners();
    }

    initCalled = true;
  }

  void onReceiveNotification(ScrollNotification scrollNotification) {
    if(_shouldStopListening) return;

    if(customTriggerThreshold?.call(scrollNotification) ?? (scrollNotification.metrics.pixels >= scrollNotification.metrics.maxScrollExtent - _triggerExtent)){
      triggerFetchListeners();
    }
  }

  //List operations helpers
  void updateItemsList(List<T> newItems){
    _paginatedStateNotifier.value = _paginatedStateNotifier.value.copyWith(
      items: newItems,
      failure: state.failure,
    );
  }

  List<T> get itemList => state.items;
  set itemList(List<T> newList) {
    _paginatedStateNotifier.value = _paginatedStateNotifier.value.copyWith(
      items: newList,
      failure: state.failure,
    );

    _paginatedStateNotifier.notifyListeners();
  }

  void updateItem({
    required bool Function(T e) updateWhere,
    required T Function(T oldItem) newItem,
  }) {
    final itemList = _paginatedStateNotifier.value.items;

    if (itemList.isEmpty) return;

    final index = itemList.firstIndexWhere(updateWhere);

    if (index == null) {
      logDebug("item Not found in List ");
    } else {
      List<T> newList = List.from(itemList);
      newList[index] = newItem(newList[index]);

      _paginatedStateNotifier.value = _paginatedStateNotifier.value.copyWith(
        items: newList,
        failure: state.failure,
      );
    }
  }

  void removeAll() {
    _paginatedStateNotifier.value =
        _paginatedStateNotifier.value.copyWith(items: []);
  }

  void removeItem(
      bool Function(T e) removeWhere,
      ) {
    final itemList = _paginatedStateNotifier.value.items;

    if (itemList.isEmpty) {
      return;
    }

    List<T> newList = List.from(itemList);
    newList.removeWhere(removeWhere);
    _paginatedStateNotifier.value = _paginatedStateNotifier.value.copyWith(
      items: newList,
      failure: state.failure,
    );

    //if the user kept removing items and the list gets empty, there is no request will be triggered because the user did not scroll, so we add this to make sure that the request will be triggered if it pass the triggerExtent
    //_triggerRequestIfNeeded();
  }

  void addItem(T item, {int? atIndex, bool appendIfListIsEmpty = false}) {
    final itemList = _paginatedStateNotifier.value.items;

    if (itemList.isEmpty) {
      if(appendIfListIsEmpty){
        _paginatedStateNotifier.value = _paginatedStateNotifier.value.copyWith(
          items: [item],
          failure: state.failure,
        );
      }
      return;
    }

    List<T> newList = List.from(itemList);

    if (atIndex != null) {
      if (newList.isEmpty) {
        newList.add(item);
      } else {
        newList.insert(atIndex, item);
      }
    } else {
      newList.add(item);
    }

    _paginatedStateNotifier.value = _paginatedStateNotifier.value.copyWith(
      items: newList,
      failure: state.failure,
    );
  }

  void dispose(){
    _listeners.clear();
    _paginatedStateNotifier.dispose();
  }
}