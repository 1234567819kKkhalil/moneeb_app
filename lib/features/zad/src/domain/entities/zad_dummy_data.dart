part of zad;

class ZadSetting {
  String title;
  dynamic data;
  String? icon;
  bool isSelected;

  ZadSetting({
    required this.title,
    this.data,
    this.icon,
    this.isSelected = false,
  });
}

class AzkarData {
  final String? text;

  AzkarData({this.text});
}

class ZadConst {
  // Dummy Images

  // TODO ZAD
  static const String imageZadDoaa =
      'https://i.postimg.cc/26jW7tSF/Whats-App-Image-2026-02-05-at-11-43-10.jpg';
  static const String imageZadSebha =
      'https://i.postimg.cc/GpLtWywf/Whats-App-Image-2026-02-05-at-11-43-22.jpg';
  static const String imageZadSalaa =
      'https://i.postimg.cc/sDPWQSyR/Whats-App-Image-2026-02-05-at-11-45-02.jpg';
  static const String imageZad =
      'https://i.postimg.cc/8cmC5Rvy/Whats-App-Image-2026-02-05-at-11-49-31.jpg';
  static const String imageZadSlider =
      'https://i.postimg.cc/rpHRXNGS/Whats-App-Image-2026-02-05-at-11-44-44.jpg';

  static const String icons = 'assets/icons/';
  static const String arrowMore = 'assets/icons/arrow_more.svg';
}
