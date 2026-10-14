part of app_utils;

/// ───────────────────────────────────────────────────────────────────────────
///  THE SINGLE SOURCE OF TRUTH FOR THE APP'S CLOCK FORMAT
/// ───────────────────────────────────────────────────────────────────────────
///
/// Every user-facing time-of-day in the app goes through [AppTimeFormat].
/// Flip [use24Hour] and the whole app switches: the date/time extensions,
/// prayer times, the cupertino pickers, `TimeOfDay.format(context)` and
/// `showTimePicker` (through the `MediaQuery.alwaysUse24HourFormat` override
/// in [MediaQueryScaleOverrider]).
///
/// When the app settings screen gets a "24-hour clock" toggle, this is the
/// only place that changes: turn [use24Hour] into a read from that setting
/// (and drop the `const`). No call site needs to be touched.
///
/// Note: this covers *clock times* only. Durations and countdowns
/// (`HH:mm:ss` remaining, media players, OTP timers) are unaffected by
/// 12/24-hour and stay as they are.
class AppTimeFormat {
  const AppTimeFormat._();

  // ╔═════════════════════════════════════════════════════════════════════╗
  // ║  👇 THE ONE SWITCH: true = 24-hour (14:05) · false = 12-hour (2:05 PM)
  // ╚═════════════════════════════════════════════════════════════════════╝
  static const bool use24Hour = false;

  /// The clock pattern without the meridiem — the meridiem is appended by
  /// [time] using the app's own wording instead of intl's `ص`/`م`.
  ///
  /// 24h: `14:05` · 12h: `02:05`
  static String get _clockPattern => use24Hour ? 'HH' : 'hh';

  /// Same as [_clockPattern] but with no leading zero on the hour.
  ///
  /// 24h: `14:05` · 12h: `2:05`
  static String get _shortClockPattern => use24Hour ? 'H' : 'h';

  static String get _langCode =>
      injector<LocalizationContainer>().langCode.name;

  /// `AM` / `PM` — or ` صباحاً` / ` مساءً` in Arabic. Empty in 24-hour mode.
  static String meridiemOf(DateTime dateTime) {
    if (use24Hour) return '';
    return dateTime.hour < 12
        ? appLocalizer.morningAM.trim()
        : appLocalizer.eveningPM.trim();
  }

  /// The localized time-of-day of [dateTime], digits always Latin.
  ///
  /// 24h: `14:05` · 12h: `02:05 PM`
  /// With [padHour] false: 24h `14:05` · 12h `2:05 PM`
  static String time(DateTime dateTime, {bool padHour = true}) {
    final pattern = padHour ? _clockPattern : _shortClockPattern;
    final clock = intel.DateFormat(
      '$pattern:mm',
      _langCode,
    ).format(dateTime).convertNumberToEnglish;

    final meridiem = meridiemOf(dateTime);
    return meridiem.isEmpty ? clock : '$clock $meridiem';
  }

  /// The localized time-of-day of [dateTime] including seconds.
  ///
  /// 24h: `14:05:09` · 12h: `02:05:09 PM`
  static String timeWithSeconds(DateTime dateTime) {
    final clock = intel.DateFormat(
      '$_clockPattern:mm:ss',
      _langCode,
    ).format(dateTime).convertNumberToEnglish;

    final meridiem = meridiemOf(dateTime);
    return meridiem.isEmpty ? clock : '$clock $meridiem';
  }

  /// Formats a raw clock string coming from the backend (prayer times,
  /// schedules…). The backend always sends 24-hour `HH:mm`, optionally with a
  /// seconds part or a timezone suffix like `05:12 (EET)`.
  ///
  /// Returns [raw] untouched when it holds no recognizable clock time, so a
  /// backend change can never blank out the UI.
  static String apiTime(String raw) {
    final parsed = parseClockString(raw);
    return parsed == null ? raw : time(parsed);
  }

  /// Parses the `H:mm` at the start of [raw] onto [onDate] (today by default).
  /// Accepts Arabic-Indic digits and ignores anything after the minutes.
  static DateTime? parseClockString(String raw, {DateTime? onDate}) {
    final match = RegExp(
      r'(\d{1,2})\s*:\s*(\d{1,2})',
    ).firstMatch(raw.convertNumberToEnglish);
    if (match == null) return null;

    final hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    if (hour > 23 || minute > 59) return null;

    final base = onDate ?? DateTime.now();
    return DateTime(base.year, base.month, base.day, hour, minute);
  }

  /// A locale-free variant of [time] for code that runs outside the UI
  /// isolate (background services, isolate entry points) where the DI
  /// container and the localizer are not available.
  ///
  /// 24h: `14:05` · 12h: `02:05 PM`
  static String timeWithoutLocale(DateTime dateTime) {
    final hour = use24Hour ? dateTime.hour : (dateTime.hour + 11) % 12 + 1;
    final clock =
        '${hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';

    if (use24Hour) return clock;
    return '$clock ${dateTime.hour < 12 ? 'AM' : 'PM'}';
  }
}
