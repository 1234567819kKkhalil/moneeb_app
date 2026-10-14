part of custom_pagination;

class PaginatedData<T> extends Equatable {
  final List<T> items;
  final PageInfo pageInfo;

  const PaginatedData({required this.items, required this.pageInfo});

  const PaginatedData.initial()
      : items = const [],
        pageInfo =  const PageInfo.initial();

  @override
  List<Object?> get props => [
    items,
    pageInfo,
  ];
}