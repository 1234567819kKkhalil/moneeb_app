part of custom_pagination;

class CursorPaginatorInput extends Equatable {
  final String? cursor;
  final int limit;
  final PaginationDirectionEnum direction;

  const CursorPaginatorInput({
    this.cursor,
    this.limit = 10,
    this.direction = PaginationDirectionEnum.after,
  });

  @override
  List<Object?> get props => [
    cursor,
    limit,
    direction,
  ];
}