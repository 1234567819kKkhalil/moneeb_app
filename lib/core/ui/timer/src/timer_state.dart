part of timer;

class TimerState extends Equatable {
  final StateBox<DateTime> realTimeTimer;

  const TimerState(
    this.realTimeTimer,
  );

  const TimerState.initial()
      : this(
          const StateBox.initial(),
        );

  TimerState reduce({
    StateBox<DateTime>? realTimeTimer,
  }) {
    return TimerState(
      realTimeTimer ?? this.realTimeTimer,
    );
  }

  @override
  List<Object?> get props => [
        realTimeTimer,
      ];
}
