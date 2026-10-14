part of app_utils;

/// Trusted "now" for flows that are gated by a date (e.g. when an umrah may
/// begin).
///
/// It is anchored to the `timestamp` the backend returns with every response
/// and then advanced by a monotonic [Stopwatch], so changing the device clock
/// after the last response cannot move it. Until the first response arrives
/// it falls back to the device clock.
class ServerClock {
  ServerClock._();
  static final ServerClock instance = ServerClock._();

  DateTime? _serverAtSync;
  final Stopwatch _sinceSync = Stopwatch();

  void sync(DateTime serverTime) {
    _serverAtSync = serverTime;
    _sinceSync
      ..reset()
      ..start();
  }

  /// Reads the `timestamp` field of an API envelope, ignoring anything else.
  void syncFromResponseBody(dynamic body) {
    if (body is! Map) return;

    final raw = body['timestamp'];
    final parsed = raw is String ? DateTime.tryParse(raw) : null;
    if (parsed != null) sync(parsed);
  }

  DateTime get now {
    final anchor = _serverAtSync;
    if (anchor == null) return DateTime.now();
    return anchor.add(_sinceSync.elapsed).toLocal();
  }
}

/// When an umrah order may begin: from the very start of the day the requester
/// picked as the target date.
abstract final class OmrahSchedule {
  /// Local midnight of the target day. The API sends a calendar date, so only
  /// its year/month/day count — never the zone it was serialized in.
  static DateTime? startOf(DateTime? targetDate) {
    if (targetDate == null) return null;
    return DateTime(targetDate.year, targetDate.month, targetDate.day);
  }

  /// Time left until the umrah may begin, or [Duration.zero] once it may.
  /// Null when the order has no target date (nothing to wait for).
  static Duration? remaining(DateTime? targetDate) {
    final start = startOf(targetDate);
    if (start == null) return null;

    final left = start.difference(ServerClock.instance.now);
    return left.isNegative ? Duration.zero : left;
  }

  /// Orders without a target date are never locked.
  static bool hasStarted(DateTime? targetDate) {
    final left = remaining(targetDate);
    return left == null || left == Duration.zero;
  }
}
