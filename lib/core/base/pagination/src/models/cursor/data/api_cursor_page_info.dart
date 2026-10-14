part of custom_pagination;

class ApiCursorPageInfo {
  final bool? hasNext;
  final bool? hasBefore;
  final String? nextCursor;
  final String? beforeCursor;
  final int? page;
  final int? limit;
  final int? totalCount;
  final ApiPaginationDirectionEnum? direction;

  ApiCursorPageInfo({
    this.hasNext,
    this.hasBefore,
    this.nextCursor,
    this.beforeCursor,
    this.page,
    this.limit,
    this.totalCount,
    this.direction
  });

  factory ApiCursorPageInfo.fromJson(Map<String, dynamic> json) =>
      ApiCursorPageInfo(
        hasNext: json["hasNext"],
        hasBefore: json["hasBefore"],
        nextCursor: json["nextCursor"],
        beforeCursor: json["beforeCursor"],
        page: json["page"],
        limit: json["limit"],
        totalCount: json["totalCount"],
        direction: ApiPaginationDirectionEnum.fromJson(json["direction"]),
      );

  Map<String, dynamic> toJson() => {
    "hasNext": hasNext,
    "hasBefore": hasBefore,
    "nextCursor": nextCursor,
    "beforeCursor": beforeCursor,
    "page": page,
    "limit": limit,
    "totalCount": totalCount,
  };

  CursorPageInfo get mapCursorPageInfo {
    return CursorPageInfo(
        direction: PaginationDirectionEnum.fromApi(direction),
        hasBefore: hasBefore ?? false,
        hasNext: hasNext ?? false,
        nextCursor: nextCursor,
        beforeCursor: beforeCursor,
        totalCount: totalCount,
        limit: limit ?? 0
    );
  }
}

enum ApiPaginationDirectionEnum {
  AFTER,
  BEFORE;

  factory ApiPaginationDirectionEnum.fromJson(String? json) {
    return EnumUtils.enumFromString(json, ApiPaginationDirectionEnum.values) ?? ApiPaginationDirectionEnum.BEFORE;
  }

  factory ApiPaginationDirectionEnum.fromDomain(PaginationDirectionEnum? direction) {
    switch (direction) {
      case PaginationDirectionEnum.before:
        return ApiPaginationDirectionEnum.BEFORE;

      default:
        return ApiPaginationDirectionEnum.AFTER;
    }
  }
}