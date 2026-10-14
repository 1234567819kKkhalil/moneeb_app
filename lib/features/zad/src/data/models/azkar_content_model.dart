part of zad;

class AzkarContentModel {
  final String sectionSlug;
  final List<AzkarItemModel> items;

  AzkarContentModel({
    required this.sectionSlug,
    required this.items,
  });

  factory AzkarContentModel.fromJson(Map<String, dynamic> json) {
    return AzkarContentModel(
      sectionSlug: json['sectionSlug'] ?? '',
      items: (json['items'] as List?)
              ?.map((e) => AzkarItemModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  factory AzkarContentModel.initial() => AzkarContentModel(
        sectionSlug: '',
        items: List.generate(3, (index) => AzkarItemModel.initial()),
      );
}

class AzkarItemModel {
  final String id;
  final String text;
  final int count;
  final String? reference;

  AzkarItemModel({
    required this.id,
    required this.text,
    required this.count,
    this.reference,
  });

  factory AzkarItemModel.fromJson(Map<String, dynamic> json) {
    return AzkarItemModel(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      count: json['count'] ?? 0,
      reference: json['reference'],
    );
  }

  factory AzkarItemModel.initial() => AzkarItemModel(
        id: '',
        text: 'جاري التحميل...',
        count: 1,
        reference: null,
      );
}
