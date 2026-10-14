part of app_material;

class NumberTooLongException implements Exception {}

class NumberTooShortException implements Exception {}

class InvalidCharactersException implements Exception {}

class PhoneNumber extends Equatable {
  final String countryISOCode;
  final String countryCode;
  final String number;
  final String numberWithCode;
  final int numberMaxLength;

  PhoneNumber({
    required this.countryISOCode,
    required this.countryCode,
    required this.number,
    required this.numberMaxLength,
  }): numberWithCode = number.isEmptyOrNull
      ? ''
      : '${countryCode.replaceAll("+", "")}$number';

  PhoneNumber modify({
    String? countryISOCode,
    String? countryCode,
    String? number,
    int? numberMaxLength,
  }) {
    return PhoneNumber(
      countryISOCode: countryISOCode ?? this.countryISOCode,
      countryCode: countryCode ?? this.countryCode,
      number: number ?? this.number,
      numberMaxLength: numberMaxLength ?? this.numberMaxLength,
    );
  }

  factory PhoneNumber.fromCompleteNumber({required String completeNumber}) {
    if (completeNumber == "") {
      return PhoneNumber(countryISOCode: "", countryCode: "", numberMaxLength: 40, number: "");
    }

    try {
      IntelPhoneCountry country = getCountry(completeNumber);
      String number;
      if (completeNumber.startsWith('+')) {
        number = completeNumber.substring(1 + country.dialCode.length + country.regionCode.length);
      } else {
        number = completeNumber.substring(country.dialCode.length + country.regionCode.length);
      }
      return PhoneNumber(
          countryISOCode: country.code,
          countryCode: country.dialCode + country.regionCode,
          numberMaxLength: country.maxLength,
          number: number,
      );
    } on InvalidCharactersException {
      rethrow;
    } on Exception {
      return PhoneNumber(countryISOCode: "", countryCode: "", numberMaxLength: 40, number: "");
    }
  }

  //
  // bool isValidNumber() {
  //   IntelPhoneCountry country = getCountry(completeNumber);
  //   if (number.length < country.minLength) {
  //     throw NumberTooShortException();
  //   }
  //
  //   if (number.length > country.maxLength) {
  //     throw NumberTooLongException();
  //   }
  //   return true;
  // }

  String get completeNumber {
    return countryCode + number;
  }

  /// Dial code carrying the leading `+` (e.g. `+966`), the format the API expects.
  String get dialCodeWithPlus =>
      countryCode.startsWith('+') ? countryCode : '+$countryCode';

  /// The subscriber number without the national trunk prefix: users often type
  /// `01028762009`, while the API expects `1028762009`.
  String get nationalNumber =>
      number.trim().replaceFirst(RegExp(r'^0+'), '');

  /// Full international number, e.g. `+201028762009`. Empty when no number was
  /// entered.
  String get internationalNumber =>
      nationalNumber.isEmpty ? '' : '$dialCodeWithPlus$nationalNumber';

  static IntelPhoneCountry getCountry(String phoneNumber) {
    if (phoneNumber == "") {
      throw NumberTooShortException();
    }

    final validPhoneNumber = RegExp(r'^[+0-9]*[0-9]*$');

    if (!validPhoneNumber.hasMatch(phoneNumber)) {
      throw InvalidCharactersException();
    }

    if (phoneNumber.startsWith('+')) {
      return countries.firstWhere((country) => phoneNumber
          .substring(1)
          .startsWith(country.dialCode + country.regionCode));
    }
    return countries.firstWhere((country) =>
        phoneNumber.startsWith(country.dialCode + country.regionCode));
  }

  @override
  String toString() =>
      'PhoneNumber(countryISOCode: $countryISOCode, countryCode: $countryCode, number: $number)';

  @override
  List<Object?> get props =>
      [countryISOCode, countryCode, number, numberMaxLength];
}

