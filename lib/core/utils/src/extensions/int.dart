part of app_utils;

extension IntToPrettyElapsedTime on int {
  /// [convertToPrettyElapsedTime] 01:01:45:43 or 01:45:43 if days are less than 1 or 45:43 if hours are less than 1.
  String convertToPrettyElapsedTime({bool isMilliseconds = false}) {
    int totalSeconds = isMilliseconds ? this ~/ 1000 : this;
    int days = totalSeconds ~/ (24 * 3600);
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds ~/ 60) % 60;
    int seconds = totalSeconds % 60;

    String daysStr = days.toString();
    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return days > 0
        ? "$daysStr:$hoursStr:$minutesStr:$secondsStr"
        : hours > 0
        ? "$hoursStr:$minutesStr:$secondsStr"
        : "$minutesStr:$secondsStr";
  }
}

extension ConvertMilliSeconds on int {
  /// [toSeconds] Output: 56
  int get toSeconds {
    int hundreds = (this / 10).truncate();
    int seconds = (hundreds / 100).truncate();
    int minutes = (seconds / 60).truncate();
    int hours = (minutes / 60).truncate();

    int s = seconds % 60;
    int h = hours % 60;
    int m = minutes % 60;

    if (h > 0) {
      h = h * 60 * 60;
    }

    if (m > 0) {
      m = m * 60;
    }
    return s + h + m;
  }
}

extension PrettifySecondsAndMilliSeconds on int {
  /// [prettify] a given number of seconds or milliseconds into a human-readable format.
  /// If [isMilliseconds] is set to true, the input is treated as milliseconds; otherwise, it's treated as seconds.
  /// resOutput: 3 Hours 1 Mins 3 Seconds
  String prettify({bool isMilliseconds = false}) {
    int seconds = isMilliseconds ? this ~/ 1000 : this;
    Duration durationSecond = Duration(seconds: seconds);

    if (durationSecond.inSeconds <= 59) {
      return appLocalizer.second(durationSecond.inSeconds);
    } else if (durationSecond.inSeconds > 59 &&
        durationSecond.inSeconds <= 3599) {
      int remainingSeconds = seconds % 60;

      return '${appLocalizer.minute(durationSecond.inMinutes)} ${remainingSeconds != 0 ? appLocalizer.second(remainingSeconds) : ''}';
    } else if (durationSecond.inSeconds > 3599 &&
        durationSecond.inSeconds <= 86399) {
      int minutes = (seconds % 3600) ~/ 60;
      int remainingSeconds = seconds % 60;

      return '${appLocalizer.hour(durationSecond.inHours)} ${minutes != 0 ? appLocalizer.minute(minutes) : ''} ${remainingSeconds != 0 ? appLocalizer.second(remainingSeconds) : ''}';
    } else if (durationSecond.inSeconds > 86399 &&
        durationSecond.inSeconds <= 604799) {
      int hours = seconds ~/ 3600;
      int minutes = (seconds % 3600) ~/ 60;
      int remainingSeconds = seconds % 60;

      return '${appLocalizer.day(durationSecond.inDays)} ${hours != 0 ? appLocalizer.hour(hours) : ''} ${minutes != 0 ? appLocalizer.minute(minutes) : ''} ${remainingSeconds != 0 ? appLocalizer.second(remainingSeconds) : ''}';
    } else {
      return '';
    }
  }
}
