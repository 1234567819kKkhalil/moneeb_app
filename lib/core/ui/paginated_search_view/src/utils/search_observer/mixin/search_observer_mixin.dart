part of paginated_search_view;

mixin SearchObserverMixin<V extends StatefulWidget> on State<V>{
  SearchObserver? _searchObserver;

  void initSearchObserver<T>({
    void Function({
    required bool Function(T e) updateWhere,
    required T Function(T oldItem) newItem,
    })? updateItem,
  }) {
    _searchObserver = SearchObserver<T>(updateItem: updateItem);
  }

  @override
  void dispose() {
    _searchObserver?.dispose();
    _searchObserver = null;
    super.dispose();
  }
}