part of custom_pagination;

class ApiPageInfo {
  ApiPageInfo({
    required this.page,
    required this.limit,
    required this.hasNext,
    this.totalCount,
  });

  int page;
  int limit;
  bool hasNext;
  int? totalCount;

  factory ApiPageInfo.fromJson(Map<String, dynamic> json) => ApiPageInfo(
    page: json["page"] ?? 0,
    limit: json["limit"] ?? 0,
    hasNext: json["hasNext"] ?? false,
    totalCount: json["totalCount"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "page": page,
    "limit": limit,
    "hasNext": hasNext,
    "totalCount": totalCount,
  };

  PageInfo get mapToPageInfo {
    return PageInfo(
      page: page,
      limit: limit,
      hasNext: hasNext,
      totalCount: totalCount,
    );
  }
}