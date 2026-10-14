part of home;

@injectable
class StoriesCubit extends BaseCubit<StoriesState> {
  final GetProviderStoriesUseCase _getProviderStoriesUseCase;
  final ViewStoryUseCase _viewStoryUseCase;
  final SharedPreferencesHelper _prefsHelper;

  StoriesCubit(
    this._getProviderStoriesUseCase,
    this._viewStoryUseCase,
    this._prefsHelper,
  ) : super(const StoriesState());

  bool _isGuest = false;

  void init({
    required List<StoryProviderEntity> providers,
    required int initialIndex,
    required bool isGuest,
  }) {
    _isGuest = isGuest;
    emit(state.copyWith(
      providers: providers,
      currentProviderIndex: initialIndex,
    ));

    if (providers.isNotEmpty && initialIndex < providers.length) {
      loadProviderStories(providers[initialIndex].providerId);
      preloadAdjacentProviders(initialIndex);
    }
  }

  Future<void> loadProviderStories(String providerId) async {
    if (state.providerStories.containsKey(providerId) &&
        (state.providerStories[providerId]!.isLoading ||
            state.providerStories[providerId]!.isSuccess)) {
      return;
    }

    final newProviderStories =
        Map<String, StateBox<List<StoryEntity>>>.from(state.providerStories);
    newProviderStories[providerId] = const StateBox.loading();
    emit(state.copyWith(providerStories: newProviderStories));

    await collect(
      task: () async {
        final stories = await _getProviderStoriesUseCase.execute(providerId);

        // Play from oldest to newest: index 0 (first progress bar) is the
        // oldest story, the last is the most recent — the one shown on the
        // home ring. The resume logic below then jumps to the first unviewed.
        stories.sort((a, b) {
          final da = DateTime.tryParse(a.createdAt);
          final db = DateTime.tryParse(b.createdAt);
          if (da == null || db == null) return 0;
          return da.compareTo(db);
        });

        // For guest users the server has no view history, so apply any
        // locally cached viewed IDs (stored in SharedPreferences with expiry).
        // For authenticated users the server is the source of truth — skip.
        List<StoryEntity> resolvedStories = stories;
        if (_isGuest) {
          final guestViewed = _prefsHelper.getGuestViewedStoryIds();
          if (guestViewed.isNotEmpty) {
            resolvedStories = stories
                .map((e) => guestViewed.contains(e.id) ? e.copyWith(isViewed: true) : e)
                .toList();
          }
        }

        final updatedStories =
            Map<String, StateBox<List<StoryEntity>>>.from(state.providerStories);
        updatedStories[providerId] = StateBox.success(resolvedStories);

        final currentStoryIdx = Map<String, int>.from(state.currentStoryIndex);
        int initialStoryIndex = resolvedStories.indexWhere((e) => !e.isViewed);
        if (initialStoryIndex == -1) {
          initialStoryIndex = 0;
        }
        currentStoryIdx[providerId] = initialStoryIndex;

        emit(state.copyWith(
          providerStories: updatedStories,
          currentStoryIndex: currentStoryIdx,
        ));
      },
      onError: (failure) {
        final updatedStories =
            Map<String, StateBox<List<StoryEntity>>>.from(state.providerStories);
        updatedStories[providerId] = StateBox.failure(failure);
        emit(state.copyWith(providerStories: updatedStories));
      },
    );
  }

  void preloadAdjacentProviders(int currentIndex) {
    if (state.providers.isEmpty) return;

    // Load two providers ahead (forward bias — users mostly browse forward)
    // and one behind. loadProviderStories already guards against re-fetching
    // providers that are loading/loaded, so there are no duplicate requests.
    for (int i = 1; i <= 2; i++) {
      final next = currentIndex + i;
      if (next < state.providers.length) {
        loadProviderStories(state.providers[next].providerId);
      }
    }

    if (currentIndex - 1 >= 0) {
      final prevProviderId = state.providers[currentIndex - 1].providerId;
      loadProviderStories(prevProviderId);
    }
  }

  void setCurrentProvider(int index) {
    if (index >= 0 && index < state.providers.length) {
      emit(state.copyWith(currentProviderIndex: index));
      final providerId = state.providers[index].providerId;
      loadProviderStories(providerId);
      preloadAdjacentProviders(index);
    }
  }

  void setCurrentStoryForProvider(String providerId, int index) {
    final currentStoryIdx = Map<String, int>.from(state.currentStoryIndex);
    currentStoryIdx[providerId] = index;
    emit(state.copyWith(currentStoryIndex: currentStoryIdx));
  }

  /// Tracks a viewed story for guest users: persists the story ID locally
  /// (keyed by its `expiresAt`) and updates the in-memory viewed state.
  /// No backend call is made.
  void markGuestStoryViewed(String providerId, String storyId, String expiresAt) {
    _prefsHelper.saveGuestViewedStory(storyId, expiresAt);

    final box = state.providerStories[providerId];
    if (box == null || !box.isSuccess || box.data == null) return;

    final stories = box.data!;
    final index = stories.indexWhere((e) => e.id == storyId);
    if (index == -1 || stories[index].isViewed) return;

    final updatedList = List<StoryEntity>.from(stories);
    updatedList[index] = updatedList[index].copyWith(isViewed: true);

    final updatedStories =
        Map<String, StateBox<List<StoryEntity>>>.from(state.providerStories);
    updatedStories[providerId] = StateBox.success(updatedList);
    emit(state.copyWith(providerStories: updatedStories));
  }

  Future<void> markStoryViewed(String providerId, String storyId) async {
    final box = state.providerStories[providerId];
    if (box == null || !box.isSuccess || box.data == null) return;

    final stories = box.data!;
    final index = stories.indexWhere((e) => e.id == storyId);
    // Already seen → don't fire the `view` request again. The flag comes from
    // the API on load and is flipped optimistically below on first view.
    if (index == -1 || stories[index].isViewed) return;

    final updatedList = List<StoryEntity>.from(stories);
    updatedList[index] = updatedList[index].copyWith(isViewed: true);

    final updatedStories =
        Map<String, StateBox<List<StoryEntity>>>.from(state.providerStories);
    updatedStories[providerId] = StateBox.success(updatedList);
    emit(state.copyWith(providerStories: updatedStories));

    try {
      await _viewStoryUseCase.execute(storyId);
    } catch (e) {
      logDebug('Failed to mark story as viewed in backend: $e');
    }
  }
}
