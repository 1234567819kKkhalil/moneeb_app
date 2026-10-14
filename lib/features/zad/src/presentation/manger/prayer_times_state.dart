part of zad;

class PrayerTimesState extends Equatable {
  final StateBox<PrayerTimesModel> prayerData;
  final PrayerResult result;

  const PrayerTimesState({
    required this.prayerData,
    required this.result,
  });

  factory PrayerTimesState.initial() => PrayerTimesState(
        prayerData: const StateBox.initial(),
        result: PrayerResult.initial(),
      );

  PrayerTimesState reduce({
    StateBox<PrayerTimesModel>? prayerData,
    PrayerResult? result,
  }) {
    return PrayerTimesState(
      prayerData: prayerData ?? this.prayerData,
      result: result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [prayerData, result];
}
