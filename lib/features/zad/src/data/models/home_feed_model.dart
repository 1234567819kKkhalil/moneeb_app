part of zad;

class HomeFeedModel {
  final PrayerCountdown prayerCountdown;
  final List<EventModel> events;

  HomeFeedModel({
    required this.prayerCountdown,
    required this.events,
  });

  factory HomeFeedModel.fromJson(Map<String, dynamic> json) {
    return HomeFeedModel(
      prayerCountdown: PrayerCountdown.fromJson(json['prayerCountdown'] ?? {}),
      events: (json['events'] as List? ?? [])
          .map((e) => EventModel.fromJson(e))
          .toList(),
    );
  }

  factory HomeFeedModel.initial() => HomeFeedModel(
        prayerCountdown: PrayerCountdown.initial(),
        events: [],
      );
}

class PrayerCountdown {
  final String nextPrayer;
  final Map<String, String> timings;
  final int? _apiCountdownSeconds;

  static const List<String> prayerOrder = [
    'Fajr',
    'Dhuhr',
    'Asr',
    'Maghrib',
    'Isha',
  ];

  PrayerCountdown({
    required this.nextPrayer,
    required this.timings,
    int? apiCountdownSeconds,
  }) : _apiCountdownSeconds = apiCountdownSeconds;

  factory PrayerCountdown.fromJson(Map<String, dynamic> json) {
    return PrayerCountdown(
      nextPrayer: json['nextPrayer'] ?? '',
      timings: Map<String, String>.from(json['timings'] ?? {}),
      apiCountdownSeconds: json['countdownSeconds'] as int?,
    );
  }

  factory PrayerCountdown.initial() => PrayerCountdown(
        nextPrayer: '',
        timings: {},
      );

  int get countdownSeconds => _apiCountdownSeconds ?? countdownSecondsFor(nextPrayer);

  int countdownSecondsFor(String prayerName) {
    final timeStr = timings[prayerName];
    if (timeStr == null) return 0;

    final parts = timeStr.split(':');
    if (parts.length != 2) return 0;

    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;

    final now = DateTime.now();
    var prayerTime = DateTime(now.year, now.month, now.day, hour, minute);

    if (prayerTime.isBefore(now)) {
      prayerTime = prayerTime.add(const Duration(days: 1));
    }

    return prayerTime.difference(now).inSeconds;
  }
}

class EventModel {
  final String id;
  final String name;
  final String date;
  final int daysRemaining;
  final String? imageUrl;

  EventModel({
    required this.id,
    required this.name,
    required this.date,
    required this.daysRemaining,
    this.imageUrl,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      date: json['date'] ?? '',
      daysRemaining: json['daysRemaining'] ?? 0,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  factory EventModel.initial() => EventModel(
        id: '',
        name: '',
        date: '',
        daysRemaining: 0,
      );
}
