part of paginated_search_view;

class SearchObserver<T> {
  final void Function({
    required bool Function(T e) updateWhere,
    required T Function(T oldItem) newItem,
  })? updateItem;

  SearchObserver({
    this.updateItem,
  }) {
    injector<SearchUpdater>().attachObserver(this);
  }

  void dispose() {
    injector<SearchUpdater>().deAttachObserver(this);
  }
}
