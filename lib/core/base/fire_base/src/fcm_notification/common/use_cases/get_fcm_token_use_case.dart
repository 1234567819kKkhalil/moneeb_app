part of fire_base;

@injectable
class GetFcmTokenUseCase {
  Future<String> execute() async {
    try {
      // if (Platform.isIOS) {
      //   final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      //   logDebug("APNS Token: $apnsToken");
      // }

      final token = await FirebaseMessaging.instance.getToken();

      logDebug("FCM Token: $token");
      return token ?? "";
    } catch (e) {
      logDebug(e);
      return '';
    }
  }
}

