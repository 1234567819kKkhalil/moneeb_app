part of app_utils;

class LaunchUrlUtils {
  static Future<void> openGoogleMapsApp({
    required double latitude,
    required double longitude,
    LaunchMode linkLaunchMode = LaunchMode.inAppBrowserView,
  }) async {
    String googleUrl;

    if(Platform.isIOS){
      googleUrl = 'http://maps.apple.com/?ll=$latitude,$longitude';
    } else {
      googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    }

    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      try {
        await launchUrl(Uri.parse(googleUrl), mode: linkLaunchMode);
      } catch (e) {
        await launchUrl(Uri.parse(googleUrl), mode: LaunchMode.platformDefault);
      }
    } else {
      throw 'Could not open the map.';
    }
  }

  static Future<void> openUrl(
    BuildContext context, {
    required String url,
    LaunchMode linkLaunchMode = LaunchMode.externalApplication,
  }) async {
    String formattedUrl = url.trim();
    if (!formattedUrl.startsWith('http://') && !formattedUrl.startsWith('https://')) {
      formattedUrl = 'https://$formattedUrl';
    }

    final uri = Uri.parse(formattedUrl);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: linkLaunchMode);
      } else {
        // Fallback to direct launch due to Android 11+ visibility queries strictness
        await launchUrl(uri, mode: linkLaunchMode);
      }
    } catch (e) {
      if (context.mounted) {
        AppToasts.error(context, message: appLocalizer.couldNotLaunchError);
      }
      logDebug(e.toString());
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint("Could not launch phone call to $phoneNumber");
    }
  }

  Future<void> openWhatsApp({
    required String phoneNumber, // Add phone number parameter
    String? text,
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    final encodeText = text != null ? Uri.encodeComponent(text) : '';

    final String urlIOS = 'https://wa.me/$phoneNumber?text=$encodeText';
    final String urlAndroid =
        'whatsapp://send?phone=$phoneNumber&text=$encodeText';

    final String effectiveURL = Platform.isIOS ? urlIOS : urlAndroid;

    if (await canLaunchUrl(Uri.parse(effectiveURL))) {
      await launchUrl(Uri.parse(effectiveURL), mode: mode);
    } else {
      throw Exception('Failed to launch WhatsApp: $effectiveURL');
    }
  }

  Future<void> openMessenger({
    String? text,
    LaunchMode mode = LaunchMode.externalNonBrowserApplication,
  }) async {
    final String messengerUri = 'fb-messenger://share?link=$text';

    if (await canLaunchUrl(Uri.parse(messengerUri))) {
      await launchUrl(Uri.parse(messengerUri), mode: mode);
    } else {
      throw 'Could not launch messenger app';
    }
  }

  Future<void> openSMS({
    String? text,
    LaunchMode mode = LaunchMode.externalApplication,
  }) async {
    final String effectiveText =
    Platform.isAndroid ? '?body=$text' : '&body=$text';

    const String url = 'sms:';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse('$url$effectiveText'), mode: mode);
    } else {
      throw Exception('Failed to launch url: $url');
    }
  }

  Future<void> openEmail({
    required String email,
    required String subject ,
    LaunchMode linkLaunchMode = LaunchMode.inAppWebView,
    required  BuildContext context,
  }) async {

    final queryParameters = <String, String>{};
    String? query;
    queryParameters['subject'] = subject;

    if (queryParameters.isNotEmpty) {
      query = _encodeQueryParameters(queryParameters);
    }

    if (await canLaunchUrl(Uri(scheme: 'mailto', path: email))) {
      try {
        if (!context.mounted) return;
        copyText(context: context, text: email);
        await Future.delayed(const Duration(milliseconds: 400));
        await launchUrl(Uri(scheme: 'mailto', query: query, path: email), mode: linkLaunchMode);
      } catch (e) {
        await launchUrl(Uri(scheme: 'mailto', query: query, path: email), mode: LaunchMode.platformDefault);
      }
    } else {
      throw 'Could not url make sure it is valid.';
    }
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Future<void> copyText({
    required BuildContext context,
    required String text,
  }) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    AppToasts.hint(context, message: " Email copied to your clipboard!");
  }
}
