part of custom_pagination;

class PageInfo extends Equatable {
  final int page;
  final int limit;
  final bool hasNext;
  final int? totalCount;

  const PageInfo({
    required this.page,
    required this.limit,
    required this.hasNext,
    this.totalCount,
  });

  const PageInfo.initial() : this(
      page: 0,
      limit:15,
      hasNext: false,
      totalCount: 0
  );

  PageInfo copyWith({
    int? page,
    int? limit,
    bool? hasNext,
    int? totalCount,
  }) {
    return PageInfo(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      hasNext: hasNext ?? this.hasNext,
      totalCount: totalCount ?? this.totalCount,
    );
  }

  @override
  List<Object?> get props => [page, limit, hasNext, totalCount];
}