part of zad;

@injectable
class TasbeehCubit extends BaseCubit<TasbeehState> {
  final ZadRepository _zadRepository;

  TasbeehCubit(this._zadRepository) : super(TasbeehState.initial());

  Future<void> fetchPresets() async {
    emit(state.reduce(presets: const StateBox.loading()));
    await collect(
      task: () async {
        final data = await _zadRepository.getTasbeehPresets();
        emit(state.reduce(presets: StateBox.success(data)));
        if (data.isNotEmpty) {
          selectPreset(0);
        }
      },
      onError: (failure) {
        emit(state.reduce(presets: StateBox.failure(failure)));
      },
    );
  }

  void selectPreset(int index) {
      emit(state.reduce(
        selectedIndex: index,
        count: 0,
        progress: 0,
        customDhikr: '',
      ));
  }

  void increment() {
    int target = 0;
    if (state.customDhikr.isNotEmpty) {
       target = 100; // default for custom
    } else if (state.presets.isSuccess && state.presets.data != null && state.selectedIndex != -1) {
      target = state.presets.data![state.selectedIndex].targetCount;
    }

    if (target > 0) {
      final newCount = state.count + 1;
      // If we reach target, maybe we want to keep going?
      // For now let's just increment count and update progress.
      // If count > target, progress would be > 1.0 but CircularProgressIndicator handles it.
      // But typically tasbeeh resets or indicates finish.
      emit(state.reduce(
        count: newCount,
        progress: newCount / target,
      ));
    } else {
       emit(state.reduce(count: state.count + 1, progress: 0));
    }
  }

  void reset() {
    emit(state.reduce(count: 0, progress: 0, customDhikr: ''));
  }

  void setCustomDhikr(String dhikr) {
    if (dhikr.isEmpty) return;
    emit(state.reduce(
      customDhikr: dhikr,
      count: 0,
      progress: 0,
      selectedIndex: -1, // deselect presets
    ));
  }
}
