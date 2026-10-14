part of helpers;

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    reverseMap ??= map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}

class EnumUtils {
  //convert enum value to string
  static String enumToString<T>(T value) {
    return value.toString().split('.').last;
  }

  //convert string to enum value
  static T? enumFromString<T>(String? value, List<T> values) {
    final eumValue = values.firstWhereOrNull(
      (e) => enumToString(e) == value,
    );
    if (eumValue == null) {
      return values.first;
    }
    return eumValue;
  }
}
