import 'package:flutter_test/flutter_test.dart';
import 'package:moneeb/core/utils/utils_imports.dart';

void main() {
  // The server clock is what gates the umrah, not the device clock.
  void serverNowIs(DateTime local) =>
      ServerClock.instance.sync(local.toUtc());

  test('locked before the target day, with the exact time left', () {
    serverNowIs(DateTime(2026, 9, 24, 12));

    final target = DateTime.utc(2026, 9, 30);
    expect(OmrahSchedule.hasStarted(target), isFalse);
    expect(
      OmrahSchedule.remaining(target)!.inHours,
      greaterThanOrEqualTo(5 * 24 + 11),
    );
  });

  test('unlocks from the very start of the target day', () {
    serverNowIs(DateTime(2026, 9, 30, 0, 0, 1));
    expect(OmrahSchedule.hasStarted(DateTime.utc(2026, 9, 30)), isTrue);
    expect(OmrahSchedule.remaining(DateTime.utc(2026, 9, 30)), Duration.zero);
  });

  test('date-only and UTC-midnight payloads mean the same calendar day', () {
    serverNowIs(DateTime(2026, 9, 29, 23, 59));
    expect(OmrahSchedule.hasStarted(DateTime.parse('2026-09-30')), isFalse);
    expect(
      OmrahSchedule.hasStarted(DateTime.parse('2026-09-30T00:00:00.000Z')),
      isFalse,
    );
  });

  test('orders without a target date are never locked', () {
    expect(OmrahSchedule.hasStarted(null), isTrue);
    expect(OmrahSchedule.remaining(null), isNull);
  });

  test('server clock ignores malformed envelopes', () {
    serverNowIs(DateTime(2026, 9, 24, 12));
    ServerClock.instance.syncFromResponseBody({'timestamp': 'nonsense'});
    ServerClock.instance.syncFromResponseBody('not a map');

    expect(ServerClock.instance.now.year, 2026);
  });
}
