part of settings;

class AppSettingsModel {
  final String slug;
  final String title;
  final String content;
  final String updatedAt;

  AppSettingsModel({
    required this.slug,
    required this.title,
    required this.content,
    this.updatedAt = '',
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  factory AppSettingsModel.initial() => AppSettingsModel(
    slug: '',
    title: 'جاري التحميل...',
    content:
        'جاري تحميل محتوى الصفحة يرجى الانتظار قليلاً... جاري تحميل محتوى الصفحة يرجى الانتظار قليلاً... جاري تحميل محتوى الصفحة يرجى الانتظار قليلاً...'
        'جاري تحميل محتوى الصفحة يرجى الانتظار قليلاً... جاري تحميل محتوى الصفحة يرجى الانتظار قليلاً... جاري تحميل محتوى الصفحة يرجى الانتظار قليلاً...'
        'جاري تحميل محتوى الصفحة يرجى الانتظار قليلاً... جاري تحميل محتوى الصفحة يرجى الانتظار قليلاً... جاري تحميل محتوى الصفحة يرجى الانتظار قليلاً...'
        'جاري تحميل محتوى الصفحة يرجى الانتظار قليلاً... جاري تحميل محتوى الصفحة يرجى الانتظار قليلاً... جاري تحميل محتوى الصفحة يرجى الانتظار قليلاً...',
  );
}

class SocialLinksModel {
  final String facebook;
  final String instagram;
  final String x;
  final String youtube;
  final String tiktok;
  final String snapchat;
  final String whatsapp;
  final String telegram;
  final String linkedin;
  final String website;

  const SocialLinksModel({
    this.facebook = '',
    this.instagram = '',
    this.x = '',
    this.youtube = '',
    this.tiktok = '',
    this.snapchat = '',
    this.whatsapp = '',
    this.telegram = '',
    this.linkedin = '',
    this.website = '',
  });

  factory SocialLinksModel.fromJson(Map<String, dynamic> json) {
    return SocialLinksModel(
      facebook: json['facebook'] ?? '',
      instagram: json['instagram'] ?? '',
      x: json['x'] ?? '',
      youtube: json['youtube'] ?? '',
      tiktok: json['tiktok'] ?? '',
      snapchat: json['snapchat'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      telegram: json['telegram'] ?? '',
      linkedin: json['linkedin'] ?? '',
      website: json['website'] ?? '',
    );
  }
}
