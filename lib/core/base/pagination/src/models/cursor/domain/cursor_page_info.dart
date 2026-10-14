part of custom_pagination;

class CursorPageInfo<PageKeyType> extends Equatable {
  final PageKeyType? nextCursor;
  final PageKeyType? beforeCursor;
  final bool hasNext;
  final bool hasBefore;
  final PaginationDirectionEnum direction;
  final int limit;
  final int? totalCount;

  const CursorPageInfo({
    required this.direction,
    this.nextCursor,
    this.beforeCursor,
    this.hasNext = false,
    this.hasBefore = false,
    required this.limit,
    this.totalCount
  });

  static const CursorPageInfo empty = CursorPageInfo(
    nextCursor: null,
    beforeCursor: null,
    hasNext: true,
    hasBefore: false,
    direction: PaginationDirectionEnum.after,
    limit: 15,
    totalCount: 15,
  );

  const CursorPageInfo.initial():this (
    nextCursor: null,
    beforeCursor: null,
    hasNext: false,
    hasBefore: false,
    direction: PaginationDirectionEnum.before,
    limit: 15,
    totalCount: 15,
  );

  @override
  List<Object?> get props =>
      [nextCursor, beforeCursor, hasNext, hasBefore, direction,];

  @override
  String toString() {
    return 'CursorPageInfo{nextCursor: $nextCursor, beforeCursor: $beforeCursor, hasNext: $hasNext, hasBefore: $hasBefore, direction: $direction}';
  }
}

enum PaginationDirectionEnum {
  after,
  before;

  factory PaginationDirectionEnum.fromApi(ApiPaginationDirectionEnum? direction) {
    switch (direction) {
      case ApiPaginationDirectionEnum.BEFORE:
        return PaginationDirectionEnum.before;

        default:
          return PaginationDirectionEnum.after;
    }
  }
}