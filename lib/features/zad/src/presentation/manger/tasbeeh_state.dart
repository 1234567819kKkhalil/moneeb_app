part of zad;

class TasbeehState extends Equatable {
  final StateBox<List<TasbeehPresetModel>> presets;
  final int selectedIndex;
  final int count;
  final double progress;
  final String customDhikr;

  const TasbeehState({
    required this.presets,
    required this.selectedIndex,
    required this.count,
    required this.progress,
    required this.customDhikr,
  });

  factory TasbeehState.initial() => const TasbeehState(
        presets: StateBox.initial(),
        selectedIndex: 0,
        count: 0,
        progress: 0,
        customDhikr: '',
      );

  TasbeehState reduce({
    StateBox<List<TasbeehPresetModel>>? presets,
    int? selectedIndex,
    int? count,
    double? progress,
    String? customDhikr,
  }) {
    return TasbeehState(
      presets: presets ?? this.presets,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      count: count ?? this.count,
      progress: progress ?? this.progress,
      customDhikr: customDhikr ?? this.customDhikr,
    );
  }

  @override
  List<Object?> get props => [presets, selectedIndex, count, progress, customDhikr];
}
