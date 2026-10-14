part of app_utils;

extension ConvertEnumToString<T> on Enum {
  T convert(List<T> toListEnums) {
    return toListEnums[index];
  }
}
