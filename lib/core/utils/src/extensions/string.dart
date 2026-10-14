part of app_utils;

extension StringExtensions on String {
  String get addBaseUrl {
    if(isEmpty) return '';

    String refinedUrl = !startsWith('/') ? "/$this" : this;
    return '${Constants.baseUrl}$refinedUrl';
  }

  String get convertNumberToEnglish {
    final number = this;
    return number
        .replaceAll("٠", "0")
        .replaceAll("١", "1")
        .replaceAll("٢", "2")
        .replaceAll("٣", "3")
        .replaceAll("٤", "4")
        .replaceAll("٥", "5")
        .replaceAll("٦", "6")
        .replaceAll("٧", "7")
        .replaceAll("٨", "8")
        .replaceAll("٩", "9");
  }

  String get capitalizeFirst {
    if (trim().isNotEmpty) {
      return replaceAllMapped(
        RegExp(r"(^\w)"),
        (match) => match.group(0)!.toUpperCase(),
      );
    }
    return this;
  }

  String get minimizeFirst {
    if (trim().isNotEmpty) {
      return replaceAllMapped(
        RegExp(r"(^\w)"),
        (match) => match.group(0)!.toLowerCase(),
      );
    }
    return this;
  }
}

extension TextPainterSize on String {
  Size textPainterSize([TextStyle? style]) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: this, style: style),
      maxLines: 1,
      textDirection: td.TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}

extension NullableStringExtenstion<T> on String? {
  bool get isEmptyOrNull {
    if (this == null || this == '') return true;
    return false;
  }
}

extension FileSize on String {
  Future<double> get getFileSizeInMb async {
    return await File.fromUri(Uri.parse(this)).sizeInMB;
  }

  Future<double> get getFileSizeInKB async {
    return await File.fromUri(Uri.parse(this)).sizeInKB;
  }

  Future<int> get getFileSizeInByte async {
    return await File.fromUri(Uri.parse(this)).sizeInByte;
  }
}

extension MediaString on String {
  bool get isNetwork => startsWith('http') || startsWith('https');

  bool get isAssetFile => startsWith("assets/");

  bool get isFile => startsWith("/");

  String get getExtension {
    String fileExt = '';
    if (contains('.')) {
      final splittedExt = split('.').lastOrNull;
      if (splittedExt != null) {
        fileExt = splittedExt;
      }
    } else {
      fileExt = this;
    }
    return fileExt;
  }

  bool get isImage {
    final List<String> imageExtensions = [
      'jpg',
      'jpeg',
      'png',
      'gif',
      'webp',
      'bmp',
      'wbmp',
    ];
    final String extension = split('.').last;
    return imageExtensions.contains(extension.toLowerCase());
  }

  bool get isVideo {
    final List<String> videoExtensions = ['mov', 'mp4', 'avi'];
    final String extension = split('.').last;
    return videoExtensions.contains(extension.toLowerCase());
  }

  MediaType get getMimeType {
    final mime = lookupMimeType(this);
    if (mime != null) {
      final splits = mime.split("/");
      final type = splits.firstOrNull ?? "";
      final subtype = splits.lastOrNull ?? "";
      return MediaType(type, subtype);
    } else {
      return MediaType("", "");
    }
  }
}

extension RemoveSpecificString on String {
  String? removeAt(String specificString) {
    int index = indexOf(specificString);
    if (index != -1) {
      return substring(index + specificString.length);
    } else {
      return null;
    }
  }
}

extension RemoveWhiteSpaces on String {
  String get removeSpaces => replaceAll(' ', '');

  String get removeZeros => replaceAll(RegExp(AppRegex.removeZeroRegex), '');
}

extension StringEncryption on String {
  String get encrypt => injector.get<Encryption>().encrypt(this) ?? '';

  String get decrypt => injector.get<Encryption>().decrypt(this) ?? '';
}

extension ConvertStringToMap on String {
  /// [toMap] convert string to map
  Map<String, dynamic> get toMap {
    return json.decode(this);
  }
}

extension Direction on String {
  td.TextDirection get getTextDirection {
    if (isNotEmpty) {
      final specialCharRegex = RegExp(r'[^\p{L}]', unicode: true);

      for (int i = 0; i < characters.length; i++) {
        if (specialCharRegex.hasMatch(this[i])) {
          continue;
        }

        bool isEnglish = RegExp(r'[a-zA-Z]').hasMatch(this[i]);

        if (isEnglish) {
          return td.TextDirection.ltr;
        } else {
          return td.TextDirection.rtl;
        }
      }
    }
    return td.TextDirection.ltr;
  }

  bool get isRtl => intel.Bidi.detectRtlDirectionality(this);
}

extension HighlightTextExtension on String {
  /// [highlightMatches] highlight matches in text when typing on Search results
  List<TextSpan> highlightMatches(
    String searchText, {
    required TextStyle matchedStyle,
    required TextStyle normalStyle,
  }) {
    if (searchText.isEmpty) {
      return [TextSpan(text: this, style: normalStyle)];
    }

    final matches = RegExp(searchText, caseSensitive: false).allMatches(this);
    if (matches.isEmpty) {
      return [TextSpan(text: this, style: normalStyle)];
    }

    final spans = <TextSpan>[];
    int lastMatchEnd = 0;

    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: substring(lastMatchEnd, match.start),
            style: normalStyle,
          ),
        );
      }
      spans.add(
        TextSpan(text: substring(match.start, match.end), style: matchedStyle),
      );
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < length) {
      spans.add(TextSpan(text: substring(lastMatchEnd), style: normalStyle));
    }

    return spans;
  }
}
