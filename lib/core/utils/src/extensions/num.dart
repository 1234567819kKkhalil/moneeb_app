part of app_utils;

extension RoundNum on num {
  String get approximate {
    if (this is double) {
      double approximateToDouble = (this * pow(10, 2)).round() / pow(10, 2);
      return approximateToDouble._removeZeros.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');
    } else {
      return toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');
    }
  }

  String get _removeZeros => toString().removeZeros;

  String toArabicNumber() {
    const zero = 0x30;
    const arabicZero = 0x0660;

    return toString().runes.map((r) {
      if (r >= zero && r <= zero + 9) {
        return arabicZero + (r - zero);
      }
      return r;
    }).map(String.fromCharCode).join();
  }
}

extension NumberFormats on num {
  String get simplifyLargeNumber{
    String num = toString();
    int len = num.length;

    if (this >= 10000 && this < 1000000) {
      return '${num.substring(0, len - 3)}.${num.substring(len - 3, 1 + (len - 3))}K';
    } else if (this >= 1000000 && this < 1000000000) {
      return '${num.substring(0, len - 6)}.${num.substring(len - 6, 1 + (len - 6))}M';
    } else if (this > 1000000000) {
      return '${num.substring(0, len - 9)}.${num.substring(len - 9, 1 + (len - 9))}B';
    } else {
      return num.toString();
    }
  }

  String formatBytes(int decimalsCountAfterMark) {
    if (this <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(this) / log(1024)).floor();
    return '${(this / pow(1024, i)).toStringAsFixed(decimalsCountAfterMark)} ${suffixes[i]}';
  }

  String get formatMaxTwoNumbers {
    if (this <= 99) {
      return toString();
    } else {
      return '99+';
    }
  }
}

extension DoubleExtension on double {
  String toFixedDecimal(int numbers) {
    return toStringAsFixed(numbers);
  }
}

