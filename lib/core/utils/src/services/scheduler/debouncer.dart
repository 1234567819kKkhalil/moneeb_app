part of app_utils;

/// Prevents a function from being called too frequently.
/// Useful for search input or text field debounce.
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  /// Cancels any existing timer and schedules [action] to run
  /// after [milliseconds] of inactivity.
  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  /// Cancels the timer if still active.
  void dispose() {
    _timer?.cancel();
  }
}
