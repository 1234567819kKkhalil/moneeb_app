part of app_utils;

double? parseDynamicToDouble(x) {
  if (x is double) {
    return x;
  } else if (x is int) {
    return x.toDouble();
  } else {
    return null;
  }
}

int? parseDynamicToInt(x) {
  if (x is int) {
    return x;
  } else if (x is double) {
    return x.toInt();
  } else {
    return null;
  }
}