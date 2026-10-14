part of app_utils;

extension MapWithOutNullValues on Map {
  Map<String, dynamic> get withOutNulls {
    Map<String, dynamic> withOutNull = {};
    forEach((key, value) {
      if (value != null) {
        withOutNull.putIfAbsent(key, () => value);
      }
    });
    return withOutNull;
  }
}
