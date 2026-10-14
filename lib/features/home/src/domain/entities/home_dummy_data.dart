part of home;

class UserTest {
  String imageUrl;
  String name;
  String rate;
  bool isSeen;
  List<StoryTest> stories;

  UserTest({
    required this.imageUrl,
    required this.name,
    required this.rate,
    this.isSeen = false,
    this.stories = const [],
  });
}

class Stage {
  String imageUrl;
  String name;
  // String rate;
  // bool isSeen;
  // List<StoryTest> stories;

  Stage({
    required this.imageUrl,
    required this.name,
    // required this.rate,
    // this.isSeen = false,
    // this.stories = const [],
  });
}

class StoryTest {
  String url;
  StoryTest({required this.url});
}

class AppSettings {
  String title;
  dynamic data;
  String? icon;
  bool isSelected;

  AppSettings({
    required this.title,
    this.data,
    this.icon,
    this.isSelected = false,
  });
}

class FeedData {
  final PrayerCountdownData? prayerCountdown;
  final List<EventData> events;

  FeedData({this.prayerCountdown, this.events = const []});

  factory FeedData.fromJson(Map<String, dynamic> json) {
    return FeedData(
      prayerCountdown: json['prayerCountdown'] != null
          ? PrayerCountdownData.fromJson(json['prayerCountdown'])
          : null,
      events: (json['events'] as List? ?? [])
          .map((e) => EventData.fromJson(e))
          .toList(),
    );
  }
}

class PrayerCountdownData {
  final String nextPrayer;
  final Map<String, String> timings;

  /// Countdown seconds provided directly by the API (most accurate initial value).
  final int? _apiCountdownSeconds;

  /// Ordered list of the five daily prayers used to cycle through.
  static const List<String> prayerOrder = [
    'Fajr',
    'Dhuhr',
    'Asr',
    'Maghrib',
    'Isha',
  ];

  PrayerCountdownData({
    required this.nextPrayer,
    this.timings = const {},
    int? apiCountdownSeconds,
  }) : _apiCountdownSeconds = apiCountdownSeconds;

  factory PrayerCountdownData.fromJson(Map<String, dynamic> json) {
    return PrayerCountdownData(
      nextPrayer: json['nextPrayer'] ?? '',
      timings: Map<String, String>.from(json['timings'] ?? {}),
      // Use API value directly — it is calculated server-side and is accurate.
      apiCountdownSeconds: json['countdownSeconds'] as int?,
    );
  }

  /// The initial countdown seconds:
  /// - Uses the API-provided value if available (accurate, no timezone issues).
  /// - Falls back to local calculation if the API didn't provide it.
  int get countdownSeconds => _apiCountdownSeconds ?? countdownSecondsFor(nextPrayer);

  /// Calculate the remaining seconds until [prayerName] locally from the timings map.
  /// Used for auto-switching to subsequent prayers after the initial countdown ends.
  int countdownSecondsFor(String prayerName) {
    final timeStr = timings[prayerName];
    if (timeStr == null) return 0;

    final parts = timeStr.split(':');
    if (parts.length != 2) return 0;

    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;

    final now = DateTime.now();
    var prayerTime = DateTime(now.year, now.month, now.day, hour, minute);

    // If the prayer time already passed today, it must be tomorrow's occurrence.
    if (prayerTime.isBefore(now)) {
      prayerTime = prayerTime.add(const Duration(days: 1));
    }

    return prayerTime.difference(now).inSeconds;
  }

  /// Returns the prayer name that comes after [currentPrayer] in the cycle.
  String getNextPrayerAfter(String currentPrayer) {
    final index = prayerOrder.indexOf(currentPrayer);
    if (index == -1) return prayerOrder.first;
    return prayerOrder[(index + 1) % prayerOrder.length];
  }
}

class EventData {
  final String id;
  final String name;
  final String date;
  final int daysRemaining;

  EventData({
    required this.id,
    required this.name,
    required this.date,
    required this.daysRemaining,
  });

  factory EventData.fromJson(Map<String, dynamic> json) {
    return EventData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      date: json['date'] ?? '',
      daysRemaining: json['daysRemaining'] ?? 0,
    );
  }
}

class UmraTimeLine {
  String title;
  String content;
  String type;
  String status;
  String iconStatus;
  String icon;

  UmraTimeLine({
    required this.title,
    required this.content,
    required this.type,
    required this.status,
    required this.iconStatus,
    required this.icon,
  });
}
