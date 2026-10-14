part of auth;

enum QuranMemorizeEnum {
  yes,
  no,
  someParts;

  String get localizedName {
    switch (this) {
      case QuranMemorizeEnum.yes:
        return appLocalizer.yesAuth;
      case QuranMemorizeEnum.no:
        return appLocalizer.noAuth;
      case QuranMemorizeEnum.someParts:
        return appLocalizer.someParts;
    }
  }
}
