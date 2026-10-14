part of custom_pagination;

class ApiPaginatedModel<T> {
  final List<T>? items;
  final ApiPageInfo? pageInfo;

  ApiPaginatedModel({
    this.items,
    this.pageInfo,
  });

  factory ApiPaginatedModel.fromJson(Map<String, dynamic> json,{
    required Function(Map<String, dynamic> item) mapper,
  }) {
    List<T> items = [];

    if (json["items"] != null) {
      for (var x in json["items"]) {
        if(x == null) continue;
        items.add(mapper(x));
      }
    }

    return ApiPaginatedModel(
      items: items,
      pageInfo: json["pageInfo"] == null
          ? null
          : ApiPageInfo.fromJson(json["pageInfo"]),
    );
  }
}
