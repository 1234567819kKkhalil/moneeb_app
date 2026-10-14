part of zad;

class ZadEndpoint {
  ZadEndpoint._();

  static const String azkarSections = "azkar-sections/public";

  static const String dua = "dua";

  static const String tasbeehPresets = "tasbeeh/presets";
  static const String prayerTimes = "prayer-times";
  static const String homeFeed = "feed/home";
  static const String islamicEvents = "islamic-events";

  static String azkar(String slug) => "azkar/$slug";
}
