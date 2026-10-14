part of timer;

class TimerCubit extends BaseCubit<TimerState> {
  TimerCubit() : super(const TimerState.initial()) {
    _loadUseCases();
  }

  void onCubitStart() {
    getRealTime();
  }

  void _loadUseCases() {}

  static TimerCubit of(BuildContext context) => BlocProvider.of(context);

  void getRealTime() async {
    await collect(
      task: () async {
        emit(state.reduce(realTimeTimer: const StateBox.loading()));
        final timer = RealTimeService.instance.getCurrentDateTime();
        emit(state.reduce(realTimeTimer: StateBox.success(timer)));
      },
      onError: (errorMessage) {
        emit(state.reduce(realTimeTimer: StateBox.failure(errorMessage)));
      },
    );
  }
}
