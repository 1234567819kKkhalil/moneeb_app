part of custom_pagination;

class PaginatorInput extends Equatable {
  final int page;
  final int limit;

  const PaginatorInput({this.page = 1, this.limit = 15});

  @override
  List<Object?> get props => [page, limit];
}