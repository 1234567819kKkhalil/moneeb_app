part of app_utils;

extension PrettyDateExtensions on DateTime {
  static const int oneSecond = 1000;
  static const int oneMinute = 60 * oneSecond;
  static const int oneHour = 60 * oneMinute;
  static const int oneDay = 24 * oneHour;
  static const int oneWeek = 7 * oneDay;
  static const int oneMonth = 30 * oneDay;

  String get prettySinceDate {
    final Locale locale = Locale(injector<LocalizationContainer>().langCode.name);

    final now = RealTimeService.instance.getCurrentDateTime();

    final passed = now.millisecondsSinceEpoch - millisecondsSinceEpoch;
    if (passed < (2 * oneMinute)) {
      return appLocalizer.justNow;
    } else if (passed < oneHour) {
      return appLocalizer.sinceMinute(passed ~/ oneMinute);
    } else if (passed < oneDay) {
      return appLocalizer.sinceHour(passed ~/ oneHour);
    } else if (passed < oneWeek) {
      int time = passed ~/ oneDay;
      return appLocalizer.sinceDay(time);
    } else if (passed < oneMonth) {
      return appLocalizer.sinceWeek(passed ~/ oneWeek);
    } else {
      return DateFormat.yMd(locale.languageCode).format(this);
    }
  }

  String formatToSinceData() {
    // final Locale locale =
    //  Locale(injector<LocalizationContainer>().langCode.name);

    final now = RealTimeService.instance.getCurrentDateTime();
    final passed = now.millisecondsSinceEpoch - millisecondsSinceEpoch;

    if (passed < oneMinute) {
      return appLocalizer.justNow;
    } else if (passed < oneHour) {
      return appLocalizer.minute(passed ~/ oneMinute);
    } else if (passed < oneDay) {
      return appLocalizer.hour(passed ~/ oneHour);
    } else if (passed < oneWeek) {
      return appLocalizer.day(passed ~/ oneDay);
    } else if (passed < oneMonth) {
      return appLocalizer.week(passed ~/ oneWeek);
    } else {
      return DateFormat('dd/MM/yyyy').format(this);
    }
  }
}

extension DateTimeFormatExtention on DateTime {
  String get langCode => injector<LocalizationContainer>().langCode.name;

  /// Formats the date part with [pattern], digits always Latin.
  /// Time-of-day never goes through here — it comes from [AppTimeFormat] so
  /// the 12/24-hour switch stays in one place.
  String _date(String pattern) =>
      intel.DateFormat(pattern, langCode).format(this).convertNumberToEnglish;

  /// [toHHmma] Output: 14:30 (or 02:30 PM in 12-hour mode)
  String get toHHmma => AppTimeFormat.time(this);

  /// [toMMMddy] Output: Feb 03,2023
  String get toMMMddy {
    return intel.DateFormat('MMM dd,y', langCode)
        .format(this)
        .convertNumberToEnglish;
  }

  /// [toEEEEdMMMMy] Output: sunday 3 september 2023
  String get toEEEEdMMMMy {
    return intel.DateFormat('EEEE d MMMM y', langCode)
        .format(this)
        .convertNumberToEnglish;
  }

  /// [toMMMMy] Output: september 2023
  String get toMMMMy {
    return intel.DateFormat('MMMM y', langCode)
        .format(this)
        .convertNumberToEnglish;
  }

  /// [toMMMYYYY] Output: Feb 2023
  String get toMMMYYYY {
    return intel.DateFormat('MMM yyyy', langCode)
        .format(this)
        .convertNumberToEnglish;
  }

  /// [toE] Output: Mon
  String get toE {
    return intel.DateFormat('E', langCode).format(this);
  }

  /// [toDDMMMyyyy] Output: 03 May, 2023
  String get toDDMMMyyyy {
    return intel.DateFormat('dd MMM , yyyy', langCode)
        .format(this)
        .convertNumberToEnglish;
  }

  /// [toMMMyyyy] Output: May, 2023
  String get toMMMyyyy {
    return intel.DateFormat('MMM${(langCode == "ar") ? ' ' : ', '}yyyy', langCode)
        .format(this)
        .convertNumberToEnglish;
  }

  /// [toDDMMM] Output: 03 May
  String get toDDMMM {
    return intel.DateFormat('dd MMM', langCode)
        .format(this)
        .convertNumberToEnglish;
  }

  /// [toMMMdd] Output: Feb 03
  String get toMMMdd {
    return intel.DateFormat('MMM dd', langCode)
        .format(this)
        .convertNumberToEnglish;
  }

  /// [toEdMMMhmma] Output: Mon 12 Feb 21:00 (or 9:00 PM in 12-hour mode)
  String get toEdMMMhmma =>
      '${_date('E d MMM')} ${AppTimeFormat.time(this, padHour: false)}';

  /// [toMMMDhmma] Output: Aug 15, 18:00 (or 6:00 PM in 12-hour mode)
  String get toMMMDhmma {
    final time = AppTimeFormat.time(this, padHour: false);
    if (langCode == "ar") return '${_date('d MMM،')} $time';
    return '${_date('MMM d,')} $time';
  }

  /// [toMMMDyyyhmma] Output: Aug 15,2024 - 18:00 (or 6:00 PM in 12-hour mode)
  String get toMMMDyyyhmma {
    final time = AppTimeFormat.time(this, padHour: false);
    if (langCode == "ar") return '${_date('d MMM yyy')} - $time';
    return '${_date('MMM d, yyy')} - $time';
  }

  /// [toEDMMM] Output: Mon 12 Feb
  String get toEDMMM {
    return intel.DateFormat('E d MMM', langCode)
        .format(this)
        .convertNumberToEnglish;
  }

  /// [toEhmma] Output: Mon 21:00 (or 9:00 PM in 12-hour mode)
  String get toEhmma =>
      '${_date('E')} ${AppTimeFormat.time(this, padHour: false)}';

  /// [toYYYMMDDHHmmss] Output: 2024-02-28 04:59:42
  ///
  /// A machine/serialization format — intentionally always 24-hour and
  /// independent of [AppTimeFormat.use24Hour].
  String get toYYYMMDDHHmmss {
    return intel.DateFormat('yyyy-MM-dd HH:mm:ss', langCode)
        .format(this)
        .convertNumberToEnglish;
  }

  /// [toEDMMMy] Output: Mon, 12 Feb 2023
  String get toEDMMMy {
    var result = intel.DateFormat('E , d MMM y', langCode).format(this);
    return result.convertNumberToEnglish;
  }

  /// [toEdMMMyhhmma] Output: Wed 28 Feb 2024 - 05:40 (or 05:40 AM in 12-hour mode)
  String get toEdMMMyhhmma =>
      '${_date('E d MMM y')} - ${AppTimeFormat.time(this)}';

  /// [toHmmdMMMyyyy] Output: 22:00, 20 May, 2024 (or 10:00 PM in 12-hour mode)
  String get toHmmdMMMyyyy =>
      '${AppTimeFormat.time(this, padHour: false)} , ${_date('d MMM, yyyy')}';

  String toUmrahDate(DateTime date) {
    final h = HijriCalendar.fromDate(date);
    final dayName = DateFormat('EEEE', langCode).format(date);

    return '$dayName، ${h.hDay} ${h.longMonthName} ${h.hYear}${langCode == "ar" ? ' هـ' : ' AH'}';
  }
}

extension LocaleExtensions on Locale {
  String get toLanguageCountry {
    final country = countryCode ?? "EG";
    return "$languageCode-$country";
  }
}
