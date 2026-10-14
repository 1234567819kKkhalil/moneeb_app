part of timer;

class TimerWidget extends StatelessWidget {
  final DateTime? createdAt;
  final int? durationInSec;
  final TextStyle? timerTextStyle;
  final VoidCallback onTimerEnded;
  final bool _isCountdown;

  const TimerWidget.countdown({
    super.key,
    required this.createdAt,
    required this.durationInSec,
    this.timerTextStyle,
    required this.onTimerEnded,
  }) : _isCountdown = true;

  const TimerWidget.stopwatch({
    super.key,
    this.timerTextStyle,
    required this.onTimerEnded,
  })  : _isCountdown = false,
        createdAt = null,
        durationInSec = null;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TimerCubit()..onCubitStart(),
      child: _TimerWidgetBody(
        createdAt: createdAt ??  DateTime.now(),
        durationInSec: durationInSec ?? 0,
        onTimerEnded: onTimerEnded,
        timerTextStyle: timerTextStyle,
        isCountdown: _isCountdown,
      ),
    );
  }
}

class _TimerWidgetBody extends StatefulWidget {
  final DateTime createdAt;
  final int durationInSec;
  final TextStyle? timerTextStyle;
  final VoidCallback onTimerEnded;
  final bool isCountdown;

  const _TimerWidgetBody({
    super.key,
    required this.createdAt,
    required this.durationInSec,
    this.timerTextStyle,
    required this.onTimerEnded,
    required this.isCountdown,
  });

  @override
  State<_TimerWidgetBody> createState() => _TimerWidgetBodyState();
}

class _TimerWidgetBodyState extends State<_TimerWidgetBody>
    with WidgetsBindingObserver, ConnectivityMonitorMixin {

  Timer? _requestTimer;
  Duration _remaining = Duration.zero;
  AppLifecycleState? appState;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _disposeTimer();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    if (widget.isCountdown) {
      switch (state) {
        case AppLifecycleState.paused:
          _disposeTimer();
          break;

        case AppLifecycleState.resumed:
          if (appState == AppLifecycleState.paused && mounted) {
            context.read<TimerCubit>().getRealTime();
          }
          break;

        default:
          break;
      }
    }

    if (appState != AppLifecycleState.paused) {
      appState = state;
    }
  }

  void _disposeTimer() {
    _remaining = Duration.zero;
    _requestTimer?.cancel();
  }

  void _setRequestDuration(DateTime time) {
    DateTime endTime = widget.createdAt.add(Duration(seconds: widget.durationInSec));

    final secondsLeft = endTime.difference((time)).inSeconds;

    if (secondsLeft > widget.durationInSec) {
      _remaining = Duration(seconds: widget.durationInSec);
    } else if (secondsLeft.isNegative) {
      _remaining = Duration.zero;
      _disposeTimer();
    } else {
      _remaining = Duration(seconds: secondsLeft);
    }
  }

  void _startRequestTimer(DateTime time) {
    const oneSec = Duration(seconds: 1);
    _requestTimer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (!mounted) return;

          setState(() {
            if (_remaining.inSeconds < 2) {
              timer.cancel();
              widget.onTimerEnded();
              _remaining = Duration.zero;
            } else {
              _remaining -= const Duration(seconds: 1);
            }
          });

      },
    );
  }

  void _handleTimer(TimerState state) {
    _disposeTimer();

    if (widget.isCountdown) {
      _setRequestDuration(state.realTimeTimer.data ?? DateTime.now());
      _startRequestTimer(state.realTimeTimer.data ?? DateTime.now());
    } else {
      _startManualTimer();
    }
  }

  // Stop Watch timer
  void _startManualTimer() {
    _requestTimer?.cancel();
    _requestTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() => _remaining += const Duration(seconds: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TimerCubit, TimerState>(
      listenWhen: (previous, current) => previous.realTimeTimer.data != current.realTimeTimer.data,
      listener: (context, state) {
        if (state.realTimeTimer.isSuccess) {
          _handleTimer(state);
        }
      },
      builder: (context, state) {
        final text = state.realTimeTimer.isSuccess
            ? _remaining.inSeconds.convertToPrettyElapsedTime()
            : '--:--';

        return Text(
          text,
          textAlign: TextAlign.center,
          style: widget.timerTextStyle ??
              context.medium.copyWith(
                fontFamily: 'Arial',
              ),
        );
      },
    );
  }

  @override
  void onConnectivityChanges(bool isHasInternet) {
    if (isHasInternet) {
      context.read<TimerCubit>().getRealTime();
    }
  }
}