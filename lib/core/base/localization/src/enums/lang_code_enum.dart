part of localization;

enum AppLangCodeEnum {
  ar,
  en;

  factory AppLangCodeEnum.fromName(String name) {
    return EnumUtils.enumFromString(name, AppLangCodeEnum.values) ?? AppLangCodeEnum.ar;
  }

  bool get isArabic => this == AppLangCodeEnum.ar;

  bool get isEnglish => this == AppLangCodeEnum.en;

  String get getLangCode {
    switch (this) {
      case AppLangCodeEnum.ar:
        return 'ar';
      case AppLangCodeEnum.en:
        return "en";
    }
  }

  String get getName {
    switch (this) {
      case AppLangCodeEnum.ar:
        return 'العربية';
      case AppLangCodeEnum.en:
        return "English";
    }
  }

  Locale get getLocal => Locale(getLangCode);
}

