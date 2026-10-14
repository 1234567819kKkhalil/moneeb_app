part of app_utils;

class AppRegex {
  AppRegex._();

  static const enRegex = r"^[a-zA-Z0-9]+$";
  static const arabicRegex = r'^[\u0600-\u06FF\s]+$';

  static const nameRegex = '^[a-zA-Z\u0621-\u064A ]+\$';
  static const emailRegex = r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";

  static const digitRegex = r"\d";
  static const onlyDigitRegex = r"^\d+$";

  static const specialCharacters = r'[!@#\$%^&*()_+{}\[\]:;<>,.?\/\\~-]';
  static const onlySpecialCharacters = r'^[^a-zA-Z0-9]+$';

  static const lowerCharacterRegex = r"[a-z]";
  static const onlyLowerCharacterRegex = r"^[a-z]+$";

  static const capitalCharacterRegex = r"[A-Z]";
  static const onlyCapitalCharacterRegex = r"^[A-Z]+$";

  static const urlRegex = r"(http|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?";

  static const removeZeroRegex = r'([.]*00)(?!.*\d)';

  static RegExp linkRegExp = RegExp(r'\b(?:https?://|www\.)\S+\b');

  static final RegExp hashtagRegex = RegExp(
      r'#([\p{L}\p{N}_-]+)',
      multiLine: true,
      unicode: true
  );

  // static final RegExp mentionRegex = RegExp(
  //     r'@([\p{L}\p{N}_]+)',
  //     multiLine: true,
  //     unicode: true
  // );

  static final RegExp mentionRegex = RegExp(r'@[\p{L}\p{N}_]+(?: [\p{L}\p{N}_]+)?', unicode: true);
}
