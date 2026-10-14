part of zad;

class PrayerTimesModel extends Equatable{
  final Timings timings;
  final DateModel date;
  final Meta meta;

  const PrayerTimesModel({
    required this.timings,
    required this.date,
    required this.meta,
  });

  factory PrayerTimesModel.fromJson(Map<String, dynamic> json) {
    return PrayerTimesModel(
      timings: Timings.fromJson(json['timings'] ?? {}),
      date: DateModel.fromJson(json['date'] ?? {}),
      meta: Meta.fromJson(json['meta'] ?? {}),
    );
  }

  factory PrayerTimesModel.initial() => PrayerTimesModel(
        timings: Timings.initial(),
        date: DateModel.initial(),
        meta: Meta.initial(),
      );

  @override
  List<Object?> get props => [
    timings,
    date,
    meta,
  ];
}

class Timings {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String sunset;
  final String maghrib;
  final String isha;
  final String imsak;
  final String midnight;
  final String firstThird;
  final String lastThird;

  Timings({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.sunset,
    required this.maghrib,
    required this.isha,
    required this.imsak,
    required this.midnight,
    required this.firstThird,
    required this.lastThird,
  });

  factory Timings.fromJson(Map<String, dynamic> json) {
    return Timings(
      fajr: json['Fajr'] ?? '',
      sunrise: json['Sunrise'] ?? '',
      dhuhr: json['Dhuhr'] ?? '',
      asr: json['Asr'] ?? '',
      sunset: json['Sunset'] ?? '',
      maghrib: json['Maghrib'] ?? '',
      isha: json['Isha'] ?? '',
      imsak: json['Imsak'] ?? '',
      midnight: json['Midnight'] ?? '',
      firstThird: json['Firstthird'] ?? '',
      lastThird: json['Lastthird'] ?? '',
    );
  }

  factory Timings.initial() => Timings(
        fajr: '00:00',
        sunrise: '00:00',
        dhuhr: '00:00',
        asr: '00:00',
        sunset: '00:00',
        maghrib: '00:00',
        isha: '00:00',
        imsak: '00:00',
        midnight: '00:00',
        firstThird: '00:00',
        lastThird: '00:00',
      );

  List<MapEntry<String, String>> toList() {
    return [
      MapEntry(appLocalizer.fajr, fajr),
      MapEntry(appLocalizer.sunrise, sunrise),
      MapEntry(appLocalizer.dhuhr, dhuhr),
      MapEntry(appLocalizer.asr, asr),
      MapEntry(appLocalizer.maghrib, maghrib),
      MapEntry(appLocalizer.isha, isha),
    ];
  }
}

class DateModel {
  final String readable;
  final String timestamp;
  final HijriDate hijri;
  final GregorianDate gregorian;

  DateModel({
    required this.readable,
    required this.timestamp,
    required this.hijri,
    required this.gregorian,
  });

  factory DateModel.fromJson(Map<String, dynamic> json) {
    return DateModel(
      readable: json['readable'] ?? '',
      timestamp: json['timestamp'] ?? '',
      hijri: HijriDate.fromJson(json['hijri'] ?? {}),
      gregorian: GregorianDate.fromJson(json['gregorian'] ?? {}),
    );
  }

  factory DateModel.initial() => DateModel(
        readable: '',
        timestamp: '',
        hijri: HijriDate.initial(),
        gregorian: GregorianDate.initial(),
      );
}

class HijriDate {
  final String date;
  final String format;
  final String day;
  final Map<String, dynamic> weekday;
  final Map<String, dynamic> month;
  final String year;

  HijriDate({
    required this.date,
    required this.format,
    required this.day,
    required this.weekday,
    required this.month,
    required this.year,
  });

  String get arabicWeekday => weekday['ar'] ?? '';
  String get arabicMonth => month['ar'] ?? '';

  String get localizedWeekday =>
      weekday[injector<LocalizationContainer>().langCode.name] ??
      weekday['en'] ??
      '';

  String get localizedMonth =>
      month[injector<LocalizationContainer>().langCode.name] ??
      month['en'] ??
      '';

  factory HijriDate.fromJson(Map<String, dynamic> json) {
    return HijriDate(
      date: json['date'] ?? '',
      format: json['format'] ?? '',
      day: json['day'] ?? '',
      weekday: json['weekday'] ?? {},
      month: json['month'] ?? {},
      year: json['year'] ?? '',
    );
  }

  factory HijriDate.initial() => HijriDate(
        date: '',
        format: '',
        day: '',
        weekday: {},
        month: {},
        year: '',
      );
}

class GregorianDate {
  final String date;
  final String format;
  final String day;
  final Map<String, dynamic> weekday;
  final Map<String, dynamic> month;
  final String year;

  GregorianDate({
    required this.date,
    required this.format,
    required this.day,
    required this.weekday,
    required this.month,
    required this.year,
  });

  factory GregorianDate.fromJson(Map<String, dynamic> json) {
    return GregorianDate(
      date: json['date'] ?? '',
      format: json['format'] ?? '',
      day: json['day'] ?? '',
      weekday: json['weekday'] ?? {},
      month: json['month'] ?? {},
      year: json['year'] ?? '',
    );
  }

  factory GregorianDate.initial() => GregorianDate(
        date: '',
        format: '',
        day: '',
        weekday: {},
        month: {},
        year: '',
      );
}

class Meta {
  final double latitude;
  final double longitude;
  final String timezone;

  Meta({
    required this.latitude,
    required this.longitude,
    required this.timezone,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      timezone: json['timezone'] ?? '',
    );
  }

  factory Meta.initial() => Meta(
        latitude: 0.0,
        longitude: 0.0,
        timezone: '',
      );
}

class PrayerResult {
  final String current;
  final String previous;
  final String next;
  final Duration remaining;
  final double progress;

  PrayerResult({
    required this.current,
    required this.previous,
    required this.next,
    required this.remaining,
    required this.progress,
  });

  factory PrayerResult.initial() => PrayerResult(
        current: '',
        previous: '',
        next: '',
        remaining: Duration.zero,
        progress: 0.0,
      );
}
