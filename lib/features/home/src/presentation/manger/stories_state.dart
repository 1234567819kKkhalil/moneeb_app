part of home;

class StoriesState extends Equatable {
  final List<StoryProviderEntity> providers;
  final int currentProviderIndex;
  final Map<String, StateBox<List<StoryEntity>>> providerStories;
  final Map<String, int> currentStoryIndex;

  const StoriesState({
    this.providers = const [],
    this.currentProviderIndex = 0,
    this.providerStories = const {},
    this.currentStoryIndex = const {},
  });

  StoriesState copyWith({
    List<StoryProviderEntity>? providers,
    int? currentProviderIndex,
    Map<String, StateBox<List<StoryEntity>>>? providerStories,
    Map<String, int>? currentStoryIndex,
  }) {
    return StoriesState(
      providers: providers ?? this.providers,
      currentProviderIndex: currentProviderIndex ?? this.currentProviderIndex,
      providerStories: providerStories ?? this.providerStories,
      currentStoryIndex: currentStoryIndex ?? this.currentStoryIndex,
    );
  }

  @override
  List<Object?> get props => [
        providers,
        currentProviderIndex,
        providerStories,
        currentStoryIndex,
      ];
}
