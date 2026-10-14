part of zad;

class DuaModel {
  final String id;
  final Map<String, dynamic> title;
  final Map<String, dynamic>? subtitle;
  final Map<String, dynamic> content;
  final String imageUrl;

  DuaModel({
    required this.id,
    required this.title,
    this.subtitle,
    required this.content,
    required this.imageUrl,
  });

  factory DuaModel.fromJson(Map<String, dynamic> json) {
    return DuaModel(
      id: json['id'] ?? '',
      title: _asLocalizedMap(json['title']),
      subtitle: json['subtitle'] == null
          ? null
          : _asLocalizedMap(json['subtitle']),
      content: _asLocalizedMap(json['content']),
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  // The backend currently returns title/content as plain Arabic strings,
  // but is expected to switch to a localized map (like azkar sections' `name`).
  static Map<String, dynamic> _asLocalizedMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is String) return {'ar': value};
    return {};
  }

  String get fullImageUrl => imageUrl.addBaseUrl ?? '';

  String get localizedTitle =>
      title[injector<LocalizationContainer>().langCode.name] ??
      title['ar'] ??
      '';
  String get localizedContent =>
      content[injector<LocalizationContainer>().langCode.name] ??
      content['ar'] ??
      '';
  String? get localizedSubtitle =>
      subtitle?[injector<LocalizationContainer>().langCode.name] ??
      subtitle?['ar'];

  factory DuaModel.initial() => DuaModel(
    id: '1',
    title: {'ar': 'جاري التحميل...'},
    content: {'ar': 'جاري التحميل...'},
    imageUrl: '',
  );
}
