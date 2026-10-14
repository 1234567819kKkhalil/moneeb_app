part of app_utils;

/// Ensures an action runs at most once every [milliseconds].
/// Useful for preventing rapid triggering (e.g. button spam).
class Throttler {
  final int milliseconds;
  Timer? _throttleTimer;

  Throttler({required this.milliseconds});

  /// Executes [onThrottle] only if not throttled in the last [milliseconds].
  void throttle({required VoidCallback onThrottle}) {
    if (_throttleTimer == null) {
      onThrottle();
      _throttleTimer = Timer(Duration(milliseconds: milliseconds), () {
        _throttleTimer = null;
      });
    }
  }

  /// Cancels the current throttle window.
  void cancel() {
    _throttleTimer?.cancel();
    _throttleTimer = null;
  }
}