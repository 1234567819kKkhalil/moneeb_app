part of settings;

class SettingItem {
  final String Function(AppLocalizations) title;
  final String name;
  final String icon;
  final Color? iconColor;
  final Color? trailingColor;

  SettingItem({
    required this.title,
    required this.name,
    required this.icon,
    this.iconColor,
    this.trailingColor,
  });
}
