part of paginated_search_view;

abstract class PaginatedSearchViewEvents extends Equatable {
  const PaginatedSearchViewEvents();
}

class GetPaginatedSearchResultsEvent extends PaginatedSearchViewEvents {
  final String searchTerm;
  final int pageKey;

  const GetPaginatedSearchResultsEvent(this.searchTerm, this.pageKey);

  @override
  List<Object?> get props => [searchTerm, pageKey];
}
