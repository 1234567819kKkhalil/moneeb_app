part of nested_paginated_list;

class NestedPaginatedItemEntity<ItemType> extends Equatable {
  final GlobalKey _itemKey;
  final ItemType item;
  final PaginationDirectionEnum direction;
  final bool isFirstItem;
  final bool isLastItem;
  final int indexInDirectionalList;
  final int indexInWholeList;

  NestedPaginatedItemEntity(
      {
      required this.item,
      required this.direction,
      required this.isLastItem,
      required this.isFirstItem,
      required this.indexInDirectionalList,
      required this.indexInWholeList})
      : _itemKey = GlobalKey();

  GlobalKey get key => _itemKey;

  NestedPaginatedItemEntity<ItemType> copyWith({ItemType? item}) {
    return NestedPaginatedItemEntity<ItemType>(
        isLastItem: isLastItem,
        isFirstItem: isFirstItem,
        indexInDirectionalList: indexInDirectionalList,
        indexInWholeList: indexInDirectionalList,
        direction: direction,
        item: item ?? this.item);
  }

  @override
  List<Object?> get props => [
        item,
        direction,
        isLastItem,
        isFirstItem,
        indexInDirectionalList,
        indexInWholeList,
        _itemKey
      ];
}
