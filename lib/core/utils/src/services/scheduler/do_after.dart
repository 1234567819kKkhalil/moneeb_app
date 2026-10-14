part of app_utils;

/// Schedules an action to run once after a delay.
class DoAfter {
  DoAfter._(); // Prevent instantiation

  /// Runs the provided [action] after a specified [milliseconds] delay.
  /// Returns a Future that completes after the action is executed.
  static Future<void> run({
    required int milliseconds,
    required VoidCallback action,
  }) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
    action();
  }
}