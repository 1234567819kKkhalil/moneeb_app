part of settings;

class AppSettingsLang {
  final String title;
  final String data;
  bool isSelected;

  AppSettingsLang({
    required this.title,
    required this.data,
    this.isSelected = false,
  });
}
