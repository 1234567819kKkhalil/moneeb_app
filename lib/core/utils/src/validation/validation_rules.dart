part of app_utils;

typedef ValidationPredicate = String? Function(Validator validatable);

class Validator {
  String? validateAgainst(String text, List<ValidationPredicate> validations) {
    final errors = validations
        .map((e) => e(this))
        .where((element) => element != null && element.isNotEmpty);
    if (errors.isEmpty) {
      return null;
    } else {
      return errors.join(',\n');
    }
  }

  String? hasValidUrl(String value) {
    if (value.isEmpty) {
      return appLocalizer.invalidLinkError;
    }

    if (!RegExp(AppRegex.urlRegex).hasMatch(value)) {
      return appLocalizer.invalidLinkError;
    }
    return null;
  }

  String? validateButNotRequired(String text, List<ValidationPredicate> validations) {
    if (text.isEmpty) return appLocalizer.emptyEmailError;
    return validateAgainst(text, validations);
  }

  //Email should not contain space
  bool isEmailHaveCapitalCharacters(String text) {
    final x = RegExp(AppRegex.capitalCharacterRegex).hasMatch(text);
    return x;
  }

  bool isEmailInValidType(String text, ) {
    final isValid = RegExp(AppRegex.emailRegex).hasMatch(text);
    return !isValid;
  }

  String? emailValidation(String text, {bool? canEmpty}) {
    if (text.isEmpty) {
      if(canEmpty==true){
        return null;
      }
      return appLocalizer.emptyEmailError;
    } else if (text.contains(' ')) {
      return appLocalizer.emailHasSpaceError;
    } else if (isEmailHaveCapitalCharacters(text)) {
      return appLocalizer.emailCapitalCharactersError;
    } else if (RegExp(AppRegex.arabicRegex).hasMatch(text)) {
      return appLocalizer.emailContainArabicError;
    } else if (isEmailInValidType(text)) {
      return appLocalizer.emailFormatError;
    }
    return null;
  }


  String? passwordValidation(String? password) {
    if (password == null || password.isEmpty) {
      return appLocalizer.emptyPasswordError;
    } else if (password.length < 8) {
      return appLocalizer.lengthPasswordError;
    } else if (!hasLowercaseLetter(password)) {
      return appLocalizer.lowercaseLetterPasswordError;
    } else if (!hasUppercaseLetter(password)) {
      return appLocalizer.uppercaseLetterPasswordError;
    } else if (!hasDigit(password)) {
      return appLocalizer.digitPasswordError;
    } else if (!hasSpecialCharacter(password)) {
      return appLocalizer.specialCharPasswordError;
    }
    return null;
  }

  bool hasLowercaseLetter(String password) {
    RegExp lowercaseRegExp = RegExp(AppRegex.lowerCharacterRegex);
    return lowercaseRegExp.hasMatch(password);
  }

  bool hasOnlyLowercaseLetter(String password) {
    RegExp lowercaseRegExp = RegExp(AppRegex.onlyLowerCharacterRegex);
    return lowercaseRegExp.hasMatch(password);
  }

  bool hasUppercaseLetter(String password) {
    RegExp uppercaseRegExp = RegExp(AppRegex.capitalCharacterRegex);
    return uppercaseRegExp.hasMatch(password);
  }

  bool hasOnlyUppercaseLetter(String password) {
    RegExp uppercaseRegExp = RegExp(AppRegex.onlyCapitalCharacterRegex);
    return uppercaseRegExp.hasMatch(password);
  }

  bool hasDigit(String password) {
    RegExp digitRegExp = RegExp(AppRegex.digitRegex);
    return digitRegExp.hasMatch(password);
  }

  bool hasOnlyDigit(String password) {
    RegExp digitRegExp = RegExp(AppRegex.onlyDigitRegex);
    return digitRegExp.hasMatch(password);
  }

  bool hasSpecialCharacter(String password) {
    RegExp specialCharRegExp = RegExp(AppRegex.specialCharacters);
    return specialCharRegExp.hasMatch(password);
  }

  bool hasOnlySpecialCharacter(String password) {
    RegExp specialCharRegExp = RegExp(AppRegex.onlySpecialCharacters);
    return specialCharRegExp.hasMatch(password);
  }

  bool isEmail(String text) {
    final validEmail = RegExp(AppRegex.emailRegex).hasMatch(text);
    final hasArabicLetters = RegExp(AppRegex.arabicRegex).hasMatch(text);
    return validEmail && !hasArabicLetters;
  }

  String? firstNameValidationName(String? firstName) {
    if (firstName == null || firstName.isEmpty) {
      return null;
    }
    if (firstName.length < 2) {
      return appLocalizer.nameLengthError;
    }
    return null;
  }

  String? lastNameValidationName(String? lastName) {
    if (lastName == null || lastName.isEmpty) {
      return null;
    }
    if (lastName.length < 2) {
      return appLocalizer.nameLengthError;
    }
    return null;
  }

  String? nameValidation(String text, ) {
    if (text.isEmpty) {
      return appLocalizer.emptyNameError;
    }
    return null;
  }

  String? userNameValidation(String text, ) {
    if (text.isEmpty || !text.startsWith('@')) {
      return "Username must start with @ symbol";
    }
    return null;
  }

  bool isNumeric(String text) {
    final x = double.tryParse(text);
    return x != null;
  }

  /// Detects if input looks like a Saudi phone number.
  /// Returns true if the input starts with 05, 5, +966, or 00966
  /// and contains only digits (after prefix stripping).
  bool isSaudiPhoneInput(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return false;

    // Strip +966 or 00966 prefix
    String normalized = trimmed;
    if (normalized.startsWith('+966')) {
      normalized = normalized.substring(4);
    } else if (normalized.startsWith('00966')) {
      normalized = normalized.substring(5);
    }

    // Check if remaining is digits only
    if (!RegExp(r'^\d+$').hasMatch(normalized)) return false;

    // Must start with 05 or 5
    return normalized.startsWith('05') || normalized.startsWith('5');
  }

  /// Validates a Saudi phone number.
  /// Accepted formats: 05XXXXXXXX (10 digits), 5XXXXXXXX (9 digits),
  /// +9665XXXXXXXX, 009665XXXXXXXX
  String? saudiPhoneValidation(String text) {
    if (text.isEmpty) {
      return appLocalizer.emptyEmailOrPhoneError;
    }

    String normalized = text.trim();

    // Strip international prefix
    if (normalized.startsWith('+966')) {
      normalized = normalized.substring(4);
    } else if (normalized.startsWith('00966')) {
      normalized = normalized.substring(5);
    }

    // Must be digits only
    if (!RegExp(r'^\d+$').hasMatch(normalized)) {
      return appLocalizer.invalidSaudiPhonePrefixError;
    }

    if (normalized.startsWith('05')) {
      if (!RegExp(r'^05\d{8}$').hasMatch(normalized)) {
        return appLocalizer.saudiPhoneTenDigitsError;
      }
    } else if (normalized.startsWith('5')) {
      if (!RegExp(r'^5\d{8}$').hasMatch(normalized)) {
        return appLocalizer.saudiPhoneNineDigitsError;
      }
    } else {
      return appLocalizer.invalidSaudiPhonePrefixError;
    }

    return null;
  }

  /// Validates input as either email or Saudi phone number.
  String? emailOrPhoneValidation(String text) {
    if (text.isEmpty) {
      return appLocalizer.emptyEmailOrPhoneError;
    }

    if (isSaudiPhoneInput(text)) {
      return saudiPhoneValidation(text);
    } else {
      return emailValidation(text);
    }
  }

  /// Normalizes phone input to the +966 format expected by the API.
  /// e.g. "0512345678" -> "+966512345678"
  /// e.g. "512345678" -> "+966512345678"
  static String normalizeSaudiPhone(String text) {
    String normalized = text.trim();

    if (normalized.startsWith('+966')) {
      return normalized;
    } else if (normalized.startsWith('00966')) {
      return '+${normalized.substring(2)}';
    } else if (normalized.startsWith('05')) {
      return '+966${normalized.substring(1)}';
    } else if (normalized.startsWith('5')) {
      return '+966$normalized';
    }
    return normalized;
  }
}
