part of app_utils;

//https://medium.flutterdevs.com/explore-encrypt-decrypt-data-in-flutter-576425347439
abstract class Encryption {
  final String ENCRYPTION_KEY = Env().ENCRYPTION_KEY;
  final String ENCRYPTION_IV = Env().ENCRYPTION_IV;

  String? encrypt(String? plainText);

  String? decrypt(String? plainText);
}

@LazySingleton(as: Encryption)
class AESEncryption extends Encryption {
  @override
  String? encrypt(String? plainText) {
    try {
      final key = Key.fromBase64(ENCRYPTION_KEY);
      final iv = IV.fromBase64(ENCRYPTION_IV);

      final encrypter = Encrypter(AES(
        key,
        mode: AESMode.cbc,
      ));
      if (plainText != null && (plainText != "" && plainText.isNotEmpty)) {
        final encrypted = encrypter.encrypt(plainText.trim(), iv: iv);
        return encrypted.base64;
      }
      return plainText;
    } catch (_) {
      return plainText;
    }
  }

  @override
  String? decrypt(String? plainText) {
    try {
      final key = Key.fromBase64(ENCRYPTION_KEY);
      final iv = IV.fromBase64(ENCRYPTION_IV);

      final encrypter = Encrypter(AES(
        key,
        mode: AESMode.cbc,
      ));
      if (plainText != null && (plainText != "" && plainText.isNotEmpty)) {
        final decrypted =
        encrypter.decrypt(Encrypted.from64(plainText.trim()), iv: iv);
        return decrypted;
      }
      return plainText;
    } catch (_) {
      return plainText;
    }
  }
}
