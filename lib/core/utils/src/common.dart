part of app_utils;

void logDebug(Object? object) {
  if (kDebugMode) {
    print(object);
  }
}

V nullHandler<T, V>(
  T? value, {
  required V ifNull,
  V Function(T value)? ifNotNull,
}) {
  if (value != null) {
    if (ifNotNull != null) {
      return ifNotNull(value);
    } else {
      return value as V;
    }
  }

  return ifNull;
}

String formatSecondsToTime(int seconds) {
  String twoDigits(int n) => n.toString().padLeft(2, "0");

  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  final secs = seconds % 60;

  if (hours > 0) {
    return "${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(secs)}";
  } else {
    return "${twoDigits(minutes)}:${twoDigits(secs)}";
  }
}
