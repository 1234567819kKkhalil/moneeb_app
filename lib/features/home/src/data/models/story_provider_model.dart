part of home;

class StoryProviderModel extends StoryProviderEntity {
  const StoryProviderModel({
    required super.providerId,
    required super.providerName,
    required super.avatarUrl,
    required super.storyId,
    required super.storyPictureUrl,
    super.hasUnviewed,
  });

  factory StoryProviderModel.fromJson(Map<String, dynamic> json) {
    return StoryProviderModel(
      providerId: json['providerId'] ?? '',
      providerName: json['providerName'] ?? '',
      avatarUrl: (json['avatarUrl'] as String?)?.addBaseUrl ?? '',
      storyId: json['storyId'] ?? '',
      storyPictureUrl: (json['storyPictureUrl'] as String?)?.addBaseUrl ?? '',
      // The backend tells us whether the user has already seen this provider's
      // latest story. A refresh after viewing should turn the ring grey, so we
      // derive `hasUnviewed` from `isViewed` instead of hardcoding it.
      hasUnviewed: !((json['isViewed'] as bool?) ?? false),
    );
  }

  /// For Skeletonizer loading placeholders
  factory StoryProviderModel.initial() => const StoryProviderModel(
        providerId: '',
        providerName: 'جاري التحميل...',
        avatarUrl: '',
        storyId: '',
        storyPictureUrl: '',
        hasUnviewed: false,
      );
}
