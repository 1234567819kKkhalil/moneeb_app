part of app_utils;

extension ChangeBoolean on bool? {
  String get pretty {
    switch (this) {
      case true:
        return appLocalizer.on;
      default:
        return appLocalizer.off;
    }
  }

  String get enabledDisabled {
    switch (this) {
      case true:
        return appLocalizer.enabled;
      default:
        return appLocalizer.disabled;
    }
  }
}
