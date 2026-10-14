part of paginated_search_view;

class SearchPaginationInput extends Equatable {
  final String? searchKey;
  final PaginatorInput? paginate;

  const SearchPaginationInput({
     this.searchKey,
     this.paginate,
  });

  @override
  List<Object?> get props => [
        searchKey,
        paginate,
      ];
}