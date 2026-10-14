part of zad;

class AzkarSectionModel {
  final String id;
  final Map<String, dynamic> name;
  final Map<String, dynamic>? subtitle;
  final String slug;
  final int sortOrder;
  final bool isActive;
  final String? iconUrl;

  AzkarSectionModel({
    required this.id,
    required this.name,
    this.subtitle,
    required this.slug,
    required this.sortOrder,
    required this.isActive,
    required this.iconUrl,
  });

  factory AzkarSectionModel.fromJson(Map<String, dynamic> json) {
    return AzkarSectionModel(
      id: json['id'] ?? '',
      name: json['name'] ?? {},
      subtitle: json['subtitle'],
      slug: json['slug'] ?? '',
      sortOrder: json['sortOrder'] ?? 0,
      isActive: json['isActive'] ?? false,
      iconUrl: json['iconUrl'] ?? '',
    );
  }

  String get arabicName => name['ar'] ?? '';
  String get englishName => name['en'] ?? '';
  String get localizedName =>
      name[injector<LocalizationContainer>().langCode.name] ??
      name['ar'] ??
      '';
  String? get localizedSubtitle =>
      subtitle?[injector<LocalizationContainer>().langCode.name] ??
      subtitle?['ar'];

  factory AzkarSectionModel.initial() => AzkarSectionModel(
    id: '',
    name: {'ar': 'جاري التحميل...'},
    slug: '',
    sortOrder: 0,
    isActive: true,
    iconUrl: '',
  );
}
