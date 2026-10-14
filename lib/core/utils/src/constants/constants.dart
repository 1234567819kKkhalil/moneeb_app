part of app_utils;


class Constants {
  static const String appName = 'Moneeb';

  static String get endpoint => Env().endpoint;
  static String get baseUrl => Env().baseUrl;

  static const String androidStore = "https://play.google.com/store/apps/details?id=[iosIdentifier]";
  static const String iosStore = "https://apps.apple.com/eg/app/[appName]/id[appIdInTheWebPage]";
  static const String shareApp = "https://[YourDomain]/download";

  static const int blocOtpDurationInMinutes = 60;

  // App Social Links
  static const String appFacebookPageLink = "";
  static const String appXPageLink = "";
  static const String appInstagramPageLink = "";
  static const String appLinkedInPageLink = "";
  static const String appWebsiteLink = "https://moneeb.sa";
}
