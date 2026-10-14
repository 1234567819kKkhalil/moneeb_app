part of paginated_search_view;

@lazySingleton
class SearchUpdater {
  SearchUpdater._internal();

  static final SearchUpdater _instance = SearchUpdater._internal();

  factory SearchUpdater() => _instance;

  final List<SearchObserver> _observers = [];

  void attachObserver<T>(SearchObserver observer) {
    _observers.add(observer);
  }

  void deAttachObserver(SearchObserver observer) {
    _observers.remove(observer);
  }

  void updatePagination<T>({
    required bool Function(T e) updateWhere,
    required T Function(T oldItem) newItem,
  }) {
    for (var observer in _observers) {
      if (observer is SearchObserver<T> && observer.updateItem != null) {
        observer.updateItem!(updateWhere: updateWhere, newItem: newItem);
      }
    }
  }
}
