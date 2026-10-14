part of custom_pagination;

class CursorPaginatedData<ItemType> extends Equatable {
  final List<ItemType> items;
  final CursorPageInfo pageInfo;

  const CursorPaginatedData(this.items, this.pageInfo);

  @override
  List<Object?> get props => [items, pageInfo];
}
