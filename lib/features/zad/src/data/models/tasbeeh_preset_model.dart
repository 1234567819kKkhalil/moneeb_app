part of zad;

class TasbeehPresetModel {
  final String id;
  final Map<String, dynamic> name;
  final String arabicText;
  final int targetCount;
  final String category;
  final Map<String, dynamic>? source;
  final Map<String, dynamic>? reward;
  final int sortOrder;
  final bool isActive;

  TasbeehPresetModel({
    required this.id,
    required this.name,
    required this.arabicText,
    required this.targetCount,
    required this.category,
    this.source,
    this.reward,
    required this.sortOrder,
    required this.isActive,
  });

  factory TasbeehPresetModel.fromJson(Map<String, dynamic> json) {
    return TasbeehPresetModel(
      id: json['id'] ?? '',
      name: json['name'] ?? {},
      arabicText: json['arabicText'] ?? '',
      targetCount: json['targetCount'] ?? 0,
      category: json['category'] ?? '',
      source: json['source'] as Map<String, dynamic>?,
      reward: json['reward'] as Map<String, dynamic>?,
      sortOrder: json['sortOrder'] ?? 0,
      isActive: json['isActive'] ?? false,
    );
  }

  String get arabicName => name['ar'] ?? '';
  String get localizedName =>
      name[injector<LocalizationContainer>().langCode.name] ?? name['ar'] ?? '';

  factory TasbeehPresetModel.initial() => TasbeehPresetModel(
        id: '',
        name: {'ar': 'جاري التحميل...'},
        arabicText: '',
        targetCount: 0,
        category: '',
        sortOrder: 0,
        isActive: true,
      );
}
