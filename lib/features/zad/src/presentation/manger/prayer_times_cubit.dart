part of zad;

@injectable
class PrayerTimesCubit extends BaseCubit<PrayerTimesState> {
  final ZadRepository _zadRepository;
  Timer? _ticker;

  PrayerTimesCubit(this._zadRepository) : super(PrayerTimesState.initial());

  LocationEntity? _currentLocation;
  Future<void> _setLocation() async {
    try {
      final latLong = await LocationService.instance.getLatLng
          .timeout(const Duration(seconds: 10));

      if (latLong != null) {
        _currentLocation = LocationEntity(
          lat: latLong.latitude.toString(),
          long: latLong.longitude.toString(),
        );
      }
    } catch (_) {
      // timeout or permission conflict — _currentLocation stays null, fallback to Makkah
    }
  }

  Future<void> fetchPrayerTimes({String? lat, String? lng}) async {
    emit(state.reduce(prayerData: const StateBox.loading()));

    // Fallback coordinates for Makkah

    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    await _setLocation();
    await collect(
      task: () async {
        final data = await _zadRepository.getPrayerTimes(
          lat: _currentLocation?.lat ?? "21.4225",
          lng: _currentLocation?.long ?? "39.8262",
          date: date,
        );
        emit(state.reduce(prayerData: StateBox.success(data)));
        _calculateTimes();
        _startTicker();

        try {
          final now = DateTime.now();
          final Map<String, DateTime> prayerTimesMap = {};

          for (var p in data.timings.toList()) {
            final parts = p.value.split(":");
            prayerTimesMap[p.key] = DateTime(
              now.year,
              now.month,
              now.day,
              int.parse(parts[0]),
              int.parse(parts[1]),
            );
          }

          await LocalNotificationService.instance.schedulePrayerNotifications(
            prayerTimes: prayerTimesMap,
            timezone: data.meta.timezone,
            bodyBuilder: (name) => appLocalizer.prayerTimeAlert(name),
          );
        } catch (e) {
          logDebug("Failed to schedule prayer notifications: $e");
        }
      },
      onError: (failure) {
        emit(state.reduce(prayerData: StateBox.failure(failure)));
      },
    );
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.prayerData.isSuccess) {
        _calculateTimes();
      } else {
        timer.cancel();
      }
    });
  }

  void _calculateTimes() {
    if (!state.prayerData.isSuccess || state.prayerData.data == null) return;

    final timings = state.prayerData.data!.timings;
    final result = _getCurrentPrayer(timings);
    emit(state.reduce(result: result));
  }

  PrayerResult _getCurrentPrayer(Timings t) {
    final now = DateTime.now();

    final prayers = t.toList();

    final prayerTimes = prayers.map((p) {
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
        // current = upcoming prayer (highlighted in list)
        current = prayerTimes[i].key;
        // next = prayer after upcoming, wraps to Fajr
        next = (i + 1 < prayerTimes.length)
            ? prayerTimes[i + 1].key
            : prayerTimes.first.key;
        previous = i == 0 ? prayerTimes.last.key : prayerTimes[i - 1].key;

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

    // after Isha -> current = Fajr tomorrow, next = Sunrise
    if (current.isEmpty) {
      current = prayerTimes.first.key;
      previous = prayerTimes.last.key;
      next = prayerTimes.length > 1
          ? prayerTimes[1].key
          : prayerTimes.first.key;

      final fajrTomorrow = prayerTimes.first.value.add(const Duration(days: 1));

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

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(d.inHours);
    final minutes = twoDigits(d.inMinutes % 60);
    final seconds = twoDigits(d.inSeconds % 60);
    return "$hours:$minutes:$seconds";
  }

  @override
  Future<void> close() {
    _ticker?.cancel();
    return super.close();
  }
}
