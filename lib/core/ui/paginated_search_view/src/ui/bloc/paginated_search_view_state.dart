part of paginated_search_view;

class PaginatedSearchViewState<T> extends Equatable {
  final StateBox<PaginatedData<T>?> searchResults;

  const PaginatedSearchViewState({
    required this.searchResults,
  });

  PaginatedSearchViewState.initial()
      : this(
          searchResults: StateBox<PaginatedData<T>>.initial(),
        );

  PaginatedSearchViewState<T> reduce({StateBox<PaginatedData<T>>? searchResults}) {
    return PaginatedSearchViewState(
      searchResults: searchResults ?? this.searchResults,
    );
  }

  @override
  List<Object> get props => [searchResults];
}
