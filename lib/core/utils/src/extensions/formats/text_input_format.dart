part of app_utils;

class UsernameInputFormatter extends TextInputFormatter {
  // Pattern to allow English letters, underscore, hyphen, and numbers
  static final RegExp _pattern = RegExp(r'^[a-zA-Z0-9_-]*$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Check if the new value matches the allowed pattern
    if (_pattern.hasMatch(newValue.text)) {
      return newValue;
    } else {
      // If the new value doesn't match the pattern, revert to the old value
      return oldValue;
    }
  }
}

///[NameInputFormatter] Remove leading spaces and allow only one space between words,
///If the new value contains non-English or Arabic characters, ignore them.
class NameInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String filteredText =
    newValue.text.replaceAll(RegExp(r'[^a-zA-Z\u0600-\u06FF\s]'), '');

    // If the new value contains more than one space, ignore the extra spaces.
    filteredText = filteredText.replaceAll(RegExp(r'\s+'), ' ');

    final String trimmedText = filteredText.trimLeft();

    // Ensure the new selection doesn't go out of bounds after formatting.
    int selectionIndex = newValue.selection.baseOffset -
        newValue.text.length +
        trimmedText.length;
    if (selectionIndex < 0) {
      selectionIndex = 0;
    } else if (selectionIndex > trimmedText.length) {
      selectionIndex = trimmedText.length;
    }

    return TextEditingValue(
      text: trimmedText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

///[UpperCaseTextFormatter] capitalize first char in word.
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String capitalizeText = _capitalize(newValue.text);

    // Ensure the new selection doesn't go out of bounds after formatting.
    int selectionIndex = newValue.selection.baseOffset -
        newValue.text.length +
        capitalizeText.length;
    if (selectionIndex < 0) {
      selectionIndex = 0;
    } else if (selectionIndex > capitalizeText.length) {
      selectionIndex = capitalizeText.length;
    }

    return TextEditingValue(
      text: capitalizeText,
      selection: newValue.selection,
    );
  }

  String _capitalize(String value) {
    if (value.trim().isEmpty) return "";
    return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
  }
}

///[LowerCaseTextFormatter] minimize first char in word.
class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
        text: newValue.text.toLowerCase(), selection: newValue.selection);
  }
}

///[CapitalizeEachWordInputFormatter] capitalize first char in each word.
class CapitalizeEachWordInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String formattedText = _capitalizeEachWord(newValue.text);

    return TextEditingValue(
      text: formattedText,
      selection: newValue.selection,
    );
  }

  String _capitalizeEachWord(String text) {
    List<String> words = text.split(' ');
    List<String> capitalizedWords = words.map((word) {
      if (word.isNotEmpty) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      } else {
        return word;
      }
    }).toList();

    return capitalizedWords.join(' ');
  }
}

///[EnglishNumbersFormatter] convert arabic numbers to english in realtime.
class EnglishNumbersFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.convertNumberToEnglish,
      composing: newValue.composing,
      selection: newValue.selection,
    );
  }
}

///[NoLeadingSpaceFormatter] prevent leading space in Text Fields.
class NoLeadingSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isNotEmpty && newValue.text.startsWith(' ')) {
      final String trimmedText = newValue.text.trimLeft();
      final int selectionIndex = newValue.selection.baseOffset -
          (newValue.text.length - trimmedText.length);

      return TextEditingValue(
        text: trimmedText,
        composing: newValue.composing,
        selection: TextSelection.collapsed(offset: selectionIndex),
      );
    }

    return newValue;
  }
}

///[NoContainSpaceFormatter] allow only single space between each word.
class NoContainSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.startsWith(' ') || newValue.text.endsWith(' ')) {
      final String trimmedText = newValue.text.trim();

      return TextEditingValue(
        text: trimmedText,
        selection: newValue.selection,
      );
    }
    return newValue;
  }
}

///[SingleSpaceFormatter] English and arabic char with single space.
class SingleSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // If the new value contains spaces characters, ignore them.
    String filteredText = newValue.text.replaceAll(RegExp(r'\s+'), ' ');

    // Ensure the new selection doesn't go out of bounds after formatting.
    int selectionIndex = newValue.selection.baseOffset -
        newValue.text.length +
        filteredText.length;
    if (selectionIndex < 0) {
      selectionIndex = 0;
    } else if (selectionIndex > filteredText.length) {
      selectionIndex = filteredText.length;
    }

    return TextEditingValue(
      text: filteredText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

///[ArabicWithSingleSpaceFormatter] Arabic char only with single space.
class ArabicWithSingleSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // If the new value contains non-Arabic characters, ignore them.
    String filteredText =
    newValue.text.replaceAll(RegExp(r'[^\u0600-\u06FF\s]'), '');

    // If the new value contains more than one space, ignore the extra spaces.
    filteredText = filteredText.replaceAll(RegExp(r'\s+'), ' ');

    // Ensure the new selection doesn't go out of bounds after formatting.
    int selectionIndex = newValue.selection.baseOffset -
        newValue.text.length +
        filteredText.length;
    if (selectionIndex < 0) {
      selectionIndex = 0;
    } else if (selectionIndex > filteredText.length) {
      selectionIndex = filteredText.length;
    }

    return TextEditingValue(
      text: filteredText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

///[EnglishWithSingleSpaceFormatter] English char only with single space.
class EnglishWithSingleSpaceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // If the new value contains non-English characters, ignore them.
    String filteredText = newValue.text.replaceAll(RegExp(r'[^\x00-\x7F]'), '');

    // If the new value contains more than one space, ignore the extra spaces.
    filteredText = filteredText.replaceAll(RegExp(r'\s+'), ' ');

    // Ensure the new selection doesn't go out of bounds after formatting.
    int selectionIndex = newValue.selection.baseOffset -
        newValue.text.length +
        filteredText.length;
    if (selectionIndex < 0) {
      selectionIndex = 0;
    } else if (selectionIndex > filteredText.length) {
      selectionIndex = filteredText.length;
    }

    return TextEditingValue(
      text: filteredText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

///[NoNumbersAllowedFormatter] prevent numbers in Text Fields.
class NoNumbersAllowedFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final filteredValue = newValue.text.replaceAll(RegExp(r'[0-9٠-٩]'), '');

    return TextEditingValue(
      text: filteredValue,
      selection: TextSelection.collapsed(offset: filteredValue.length),
    );
  }
}

///[NoArabicAllowedFormatter] prevent arabic char.
class NoArabicAllowedFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final filteredValue = newValue.text.replaceAll(
        RegExp(
            r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]'),
        '');

    final selectionIndex = newValue.selection.baseOffset +
        (filteredValue.length - newValue.text.length);

    return TextEditingValue(
      text: filteredValue,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}

/// [SecureInputFormatter] prevent special characters from input to avoid injection
class SecureInputFormatter extends TextInputFormatter {
  static final RegExp _unsafeCharsRegex = RegExp('[<>"\'%;()&+/?~\\\\]');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final sanitized = newValue.text.replaceAll(_unsafeCharsRegex, '');

    int newOffset = newValue.selection.baseOffset;

    final beforeCursor = newValue.text.substring(0, newValue.selection.baseOffset);
    final removedBeforeCursor = beforeCursor.length - beforeCursor.replaceAll(_unsafeCharsRegex, '').length;
    newOffset = (newValue.selection.baseOffset - removedBeforeCursor).clamp(0, sanitized.length);

    return TextEditingValue(
      text: sanitized,
      selection: newValue.selection.copyWith(baseOffset: newOffset, extentOffset: newOffset),
    );
  }
}

class TwoDecimalsAfterMark extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final regExp = RegExp(r'^\d+\.?\d{0,2}');
    final match = regExp.firstMatch(newValue.text);
    final truncated = match?.group(0) ?? '';
    return TextEditingValue(
      text: truncated,
      selection: TextSelection.collapsed(offset: truncated.length),
    );
  }
}

/// Allow Any Characters Else English [Dont Allow English]
class AllowNewLinesFormatter extends TextInputFormatter {
  AllowNewLinesFormatter({this.allowedCount = 1}) {
    for (int index = 0; index < allowedCount; index++) {
      _linesString = '$_linesString\n';
    }
  }

  final int allowedCount;
  String _linesString = '';

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String filteredText = newValue.text;

    if (filteredText.isNotEmpty && filteredText[0] == ' ') {
      filteredText = filteredText.trimLeft();
    }

    final String newLinesNotAllowed = '$_linesString\n';
    if (filteredText.startsWith('\n')) {
      filteredText = filteredText.replaceFirst('\n', '');
    } else if (filteredText.contains(newLinesNotAllowed)) {
      filteredText = filteredText.replaceAll(newLinesNotAllowed, _linesString);
    }

    final selection = newValue.selection.copyWith(
      baseOffset: newValue.selection.baseOffset.clamp(0, filteredText.length),
      extentOffset:
      newValue.selection.extentOffset.clamp(0, filteredText.length),
    );

    return TextEditingValue(
      text: filteredText,
      selection: selection,
      composing: TextRange.empty,
    );
  }
}

class NoNewlineFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.replaceAll('\n', ''), // Remove newlines
      selection: newValue.selection,
    );
  }
}
