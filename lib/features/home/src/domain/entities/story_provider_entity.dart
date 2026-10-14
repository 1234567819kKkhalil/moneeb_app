part of home;

class StoryProviderEntity extends Equatable {
  final String providerId;
  final String providerName;
  final String avatarUrl;
  final String storyId;
  final String storyPictureUrl;
  final bool hasUnviewed;

  const StoryProviderEntity({
    required this.providerId,
    required this.providerName,
    required this.avatarUrl,
    required this.storyId,
    required this.storyPictureUrl,
    this.hasUnviewed = true,
  });

  StoryProviderEntity copyWith({
    String? providerId,
    String? providerName,
    String? avatarUrl,
    String? storyId,
    String? storyPictureUrl,
    bool? hasUnviewed,
  }) {
    return StoryProviderEntity(
      providerId: providerId ?? this.providerId,
      providerName: providerName ?? this.providerName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      storyId: storyId ?? this.storyId,
      storyPictureUrl: storyPictureUrl ?? this.storyPictureUrl,
      hasUnviewed: hasUnviewed ?? this.hasUnviewed,
    );
  }

  @override
  List<Object?> get props => [
        providerId,
        providerName,
        avatarUrl,
        storyId,
        storyPictureUrl,
        hasUnviewed,
      ];
}
