/* import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moneeb/api/api_requestes.dart';
import 'package:moneeb/model/test/prayer_test.dart';
import 'package:moneeb/model/zad/prayer_result.dart';
import 'package:moneeb/model/zad/prayer_times.dart';
import 'package:moneeb/utils/app_log.dart';
import 'package:moneeb/utils/caching.dart';
import 'package:moneeb/utils/constants.dart';

class PrayerTimesController extends GetxController{

  PrayerData prayer = PrayerData();
  late final prayerTimes;
  late final String current;
  late final String previous;
  late final String next;
  late final String remaining ;
  bool isCurrent = false;

  List<PrayerTest> prayers = [
    PrayerTest(name: 'صلاة الفجر', time: '05:10 ص', remain: '', type: 'missed'),
    PrayerTest(name: 'الشروق', time: '06:37 ص', remain: '', type: 'missed'),
    PrayerTest(name: 'صلاة الظهر', time: '11:57 ص', remain: '', type: 'missed'),

    PrayerTest(name: 'صلاة العصر', time: '02:56 م', remain: '', type: 'current'),

    PrayerTest(name: 'صلاة المغرب', time: '05:22 م', remain: '', type: 'coming'),
    PrayerTest(name: 'صلاة العشاء', time: '06:17 م', remain: '', type: 'coming'),
  ];

  String isPrayerDone(String prayerTime) {

    final now = DateTime.now();

    final parts = prayerTime.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    final prayerDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      hour,
      minute,);
    String date = DateFormat('hh:mm').format(prayerDateTime);
    AppLog.info('NOW: $date');
    return date;
  }

  void checkPrayer(String name, String time) {
    final done = isPrayerDone(time) == time;
    if(isPrayerDone(time) == time){
      AppLog.info("PRAYER-NOW: $name:");
    }else if(isPrayerDone(time) != time){

    }

  }

  Future<void> getPrayersTimes() async {
    // TODO 2026-02-28
    // TODO HARAM LOCATION 21.4225, 39.8262
    String lat = CacheManager.getLocation(key: Const.KEY_CURRENT_LATITUDE) ?? '21.4225';
    String lng = CacheManager.getLocation(key: Const.KEY_CURRENT_LONGITUDE) ?? '39.8262';
    String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await APIRequestes.fetchPrayerTimes(lat: lat,lng: lng, date: date)
        .then((data) {
          if(data!.data != null){
            prayer = data.data!;

            final timings = prayer.timings;

            prayerTimes = getCurrentPrayer(timings!);

            current = prayerTimes.current;
            previous = prayerTimes.previous;
            next = prayerTimes.next;
            remaining = formatDuration(prayerTimes.remaining);


          AppLog.info("Current: ${prayerTimes.current}");
          AppLog.info("Previous: ${prayerTimes.previous}");
          AppLog.info("Next: ${prayerTimes.next}");
          AppLog.info("Remaining: ${formatDuration(prayerTimes.remaining)}");
          }
    });
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inHours)}:${twoDigits(d.inMinutes % 60)}:${twoDigits(d.inSeconds % 60)}";
  }

  PrayerResult getCurrentPrayer(Timings t) {
    final now = DateTime.now();

    List<MapEntry<String, String>> prayers = [
      MapEntry("صلاة الفجر", t.fajr!),
      MapEntry("الشروق", t.sunrise!),
      MapEntry("صلاة الظهر", t.dhuhr!),
      MapEntry("صلاة العصر", t.asr!),
      MapEntry("صلاة المغرب", t.maghrib!),
      MapEntry("صلاة العشاء", t.isha!),
    ];

    List<MapEntry<String, DateTime>> prayerTimes = prayers.map((p) {
      final parts = p.value.split(":");
      return MapEntry(
        p.key,
        DateTime(
          now.year,
          now.month,
          now.day,
          int.parse(parts[0]),
          int.parse(parts[1]),
        ),
      );
    }).toList();

    String current = "";
    String previous = "";
    String next = "";
    Duration remaining = Duration.zero;
    double progress = 0.0;

    for (int i = 0; i < prayerTimes.length; i++) {
      if (now.isBefore(prayerTimes[i].value)) {
        next = prayerTimes[i].key;
        current = i == 0 ? prayerTimes.last.key : prayerTimes[i - 1].key;
        previous = i <= 1 ? prayerTimes.last.key : prayerTimes[i - 2].key;

        final startTime = i == 0
            ? prayerTimes.last.value.subtract(const Duration(days: 1))
            : prayerTimes[i - 1].value;

        final endTime = prayerTimes[i].value;

        remaining = endTime.difference(now);
        final total = endTime.difference(startTime);
        final passed = now.difference(startTime);

        progress = passed.inSeconds / total.inSeconds;
        break;
      }
    }

    // after Isha → next is Fajr
    if (next.isEmpty) {
      current = "صلاة العشاء";
      previous = "صلاة المغرب";
      next = "صلاة الفجر";

      final fajrTomorrow =
      prayerTimes.first.value.add(const Duration(days: 1));

      remaining = fajrTomorrow.difference(now);

      final startTime = prayerTimes.last.value;
      final total = fajrTomorrow.difference(startTime);
      final passed = now.difference(startTime);

      progress = passed.inSeconds / total.inSeconds;
    }

    return PrayerResult(
      current: current,
      previous: previous,
      next: next,
      remaining: remaining,
      progress: progress.clamp(0.0, 1.0),
    );
  }
} */
