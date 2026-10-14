part of home;

class StoryViewerScreen extends StatefulWidget {
  static const String routeName = '/story_viewer';

  const StoryViewerScreen({super.key});

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen>
    with SingleTickerProviderStateMixin {
  late PageController _outerPageController;

  // Swipe-down-to-dismiss state
  double _dragOffset = 0.0;
  bool _isDragging = false;
  late AnimationController _snapBackController;
  late Animation<double> _snapBackAnimation;
  static const double _dismissThreshold = 150.0;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<StoriesCubit>();
    _outerPageController = PageController(
      initialPage: cubit.state.currentProviderIndex,
    );

    _snapBackController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _snapBackAnimation =
        Tween<double>(begin: 0, end: 0).animate(
          CurvedAnimation(parent: _snapBackController, curve: Curves.easeOut),
        )..addListener(() {
          setState(() {
            _dragOffset = _snapBackAnimation.value;
          });
        });
  }

  @override
  void dispose() {
    _outerPageController.dispose();
    _snapBackController.dispose();
    super.dispose();
  }

  /// Precaches the first (unviewed) image of the next provider so entering it
  /// is seamless. Only the first story is warmed here — the rest are handled
  /// by the per-story prefetch inside ProviderStoriesView. Videos are skipped
  /// (handled by the next-video controller on the provider's own view).
  void _precacheNextProviderFirstImage(
    BuildContext context,
    StoriesState state,
  ) {
    final nextIndex = state.currentProviderIndex + 1;
    if (nextIndex >= state.providers.length) return;

    final nextId = state.providers[nextIndex].providerId;
    final box = state.providerStories[nextId];
    if (box == null ||
        !box.isSuccess ||
        box.data == null ||
        box.data!.isEmpty) {
      // Not loaded yet — the API preload will fetch it; precache happens when
      // the user actually reaches it.
      return;
    }

    final stories = box.data!;
    int idx = stories.indexWhere((e) => !e.isViewed);
    if (idx == -1) idx = 0;

    final first = stories[idx];
    if (first.mediaType == 'VIDEO') return;

    final url = first.mediaUrl.startsWith('http')
        ? first.mediaUrl
        : '${Constants.baseUrl}${first.mediaUrl}';

    precacheImage(AppImage.getImageProvider(path: url), context);
  }

  void _onVerticalDragStart(DragStartDetails details) {
    _snapBackController.stop();
    _isDragging = true;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (!_isDragging) return;
    setState(() {
      // Only allow dragging down (positive offset)
      _dragOffset = (_dragOffset + details.delta.dy).clamp(
        0.0,
        double.infinity,
      );
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    _isDragging = false;
    final velocity = details.primaryVelocity ?? 0;

    if (_dragOffset > _dismissThreshold || velocity > 800) {
      // Dismiss — animate off screen then pop
      final screenHeight = MediaQuery.of(context).size.height;
      _snapBackAnimation = Tween<double>(begin: _dragOffset, end: screenHeight)
          .animate(
            CurvedAnimation(parent: _snapBackController, curve: Curves.easeIn),
          );
      _snapBackController.forward(from: 0).then((_) {
        if (mounted) Navigator.of(context).pop();
      });
    } else {
      // Snap back
      _snapBackAnimation = Tween<double>(begin: _dragOffset, end: 0.0).animate(
        CurvedAnimation(parent: _snapBackController, curve: Curves.easeOut),
      );
      _snapBackController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final progress = (_dragOffset / screenHeight).clamp(0.0, 1.0);
    final opacity = (1.0 - progress * 1.5).clamp(0.0, 1.0);
    final scale = (1.0 - progress * 0.15).clamp(0.85, 1.0);

    return Material(
      type: MaterialType.transparency,
      child: Container(
        color: Colors.black.withOpacity(opacity),
        child: GestureDetector(
          onVerticalDragStart: _onVerticalDragStart,
          onVerticalDragUpdate: _onVerticalDragUpdate,
          onVerticalDragEnd: _onVerticalDragEnd,
          child: Transform.translate(
            offset: Offset(0, _dragOffset),
            child: Transform.scale(
              scale: scale,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(progress * 24),
                child: Container(
                  color: Colors.black,
                  child: BlocListener<StoriesCubit, StoriesState>(
                    listenWhen: (previous, current) =>
                        previous.currentProviderIndex !=
                        current.currentProviderIndex,
                    listener: (context, state) {
                      if (_outerPageController.hasClients &&
                          _outerPageController.page?.round() !=
                              state.currentProviderIndex) {
                        _outerPageController.animateToPage(
                          state.currentProviderIndex,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                      _precacheNextProviderFirstImage(context, state);
                    },
                    child: BlocBuilder<StoriesCubit, StoriesState>(
                      builder: (context, state) {
                        if (state.providers.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFE6C27A),
                            ),
                          );
                        }

                        return PageView.builder(
                          controller: _outerPageController,
                          onPageChanged: (index) {
                            context.read<StoriesCubit>().setCurrentProvider(
                              index,
                            );
                          },
                          itemCount: state.providers.length,
                          itemBuilder: (context, index) {
                            final provider = state.providers[index];
                            return ProviderStoriesView(
                              provider: provider,
                              onAllStoriesCompleted: () {
                                final cubit = context.read<StoriesCubit>();
                                if (cubit.state.currentProviderIndex <
                                    cubit.state.providers.length - 1) {
                                  cubit.setCurrentProvider(
                                    cubit.state.currentProviderIndex + 1,
                                  );
                                } else {
                                  Navigator.of(context).pop();
                                }
                              },
                              onPreviousProviderRequested: () {
                                final cubit = context.read<StoriesCubit>();
                                if (cubit.state.currentProviderIndex > 0) {
                                  cubit.setCurrentProvider(
                                    cubit.state.currentProviderIndex - 1,
                                  );
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProviderStoriesView extends StatefulWidget {
  final StoryProviderEntity provider;
  final VoidCallback onAllStoriesCompleted;
  final VoidCallback onPreviousProviderRequested;

  const ProviderStoriesView({
    super.key,
    required this.provider,
    required this.onAllStoriesCompleted,
    required this.onPreviousProviderRequested,
  });

  @override
  State<ProviderStoriesView> createState() => _ProviderStoriesViewState();
}

class _ProviderStoriesViewState extends State<ProviderStoriesView> {
  VideoPlayerController? _videoController;
  Timer? _timer;
  final ValueNotifier<double> _progress = ValueNotifier<double>(0.0);
  bool _isInitialized = false;
  bool _isSettingUp = false;
  bool _isPlaying = true;
  int _videoElapsedMs = 0;
  int _lastActiveStoryIndex = -1;

  // Pre-initialized controller kept warm for the *next* video story so it can
  // start instantly without a spinner. Only one is ever held at a time.
  VideoPlayerController? _nextVideoController;
  String? _nextVideoStoryId;

  @override
  void initState() {
    super.initState();
    context.read<StoriesCubit>().loadProviderStories(
      widget.provider.providerId,
    );

    // When the outer PageView creates this widget for a provider whose
    // stories are already loaded (preloaded), the BlocConsumer listener
    // won't fire because there's no state *change*. We need to check
    // after the first frame and initialize media if applicable.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _tryInitializeIfActive();
    });
  }

  void _tryInitializeIfActive() {
    final state = context.read<StoriesCubit>().state;
    final activeProviderId =
        state.providers.isNotEmpty &&
            state.currentProviderIndex < state.providers.length
        ? state.providers[state.currentProviderIndex].providerId
        : null;

    if (activeProviderId != widget.provider.providerId) return;

    final box = state.providerStories[widget.provider.providerId];
    if (box != null &&
        box.isSuccess &&
        box.data != null &&
        box.data!.isNotEmpty) {
      final idx = state.currentStoryIndex[widget.provider.providerId] ?? 0;
      if ((idx != _lastActiveStoryIndex || !_isInitialized) && !_isSettingUp) {
        _lastActiveStoryIndex = idx;
        _setupActiveStory(box.data![idx]);
      }
    }
  }

  @override
  void dispose() {
    _cleanupActiveStory();
    _disposePrefetchedVideo();
    _progress.dispose();
    super.dispose();
  }

  void _cleanupActiveStory() {
    _timer?.cancel();
    _timer = null;
    _videoController?.dispose();
    _videoController = null;
    _isInitialized = false;
    _videoElapsedMs = 0;
    _progress.value = 0.0;
  }

  void _disposePrefetchedVideo() {
    _nextVideoController?.dispose();
    _nextVideoController = null;
    _nextVideoStoryId = null;
  }

  void _setupActiveStory(StoryEntity story) {
    _isSettingUp = true;
    _cleanupActiveStory();
    _isPlaying = true;

    if (story.mediaType == 'VIDEO') {
      // If we pre-initialized this exact video for the previous transition,
      // adopt it so playback starts instantly with no spinner.
      final prefetched = _nextVideoController;
      if (prefetched != null &&
          _nextVideoStoryId == story.id &&
          prefetched.value.isInitialized) {
        _nextVideoController = null;
        _nextVideoStoryId = null;
        _videoController = prefetched;
        _isSettingUp = false;
        setState(() {
          _isInitialized = true;
        });
        prefetched.play();
        _startVideoProgressTimer();
        _markStoryViewed(story);
        _prefetchUpcomingMedia(story);
        return;
      }

      final url = story.mediaUrl.startsWith('http')
          ? story.mediaUrl
          : '${Constants.baseUrl}${story.mediaUrl}';

      final controller = VideoPlayerController.networkUrl(Uri.parse(url));
      _videoController = controller;

      controller
          .initialize()
          .then((_) {
            _isSettingUp = false;
            if (!mounted || _videoController != controller) {
              controller.dispose();
              return;
            }
            setState(() {
              _isInitialized = true;
            });
            controller.play();
            _startVideoProgressTimer();
            _prefetchUpcomingMedia(story);
          })
          .catchError((err) {
            _isSettingUp = false;
            debugPrint('📹 [story] init FAILED id=${story.id} error=$err');
            // A corrupt/undecodable video must not freeze the viewer on a
            // spinner — fall back to a short fixed display then advance.
            if (mounted && _videoController == controller) {
              _startFallbackTimer();
            }
          });
    } else {
      _isSettingUp = false;
      setState(() {
        _isInitialized = true;
      });
      _startImageTimer();
      _prefetchUpcomingMedia(story);
    }

    _markStoryViewed(story);
  }

  /// Warms the cache for the next story in this provider so the transition is
  /// seamless: images are precached through the app's own image provider
  /// (matching ExtendedImage's cache key), and the next video is initialized
  /// on a controller kept alive until its turn.
  void _prefetchUpcomingMedia(StoryEntity currentStory) {
    if (!mounted) return;

    final cubit = context.read<StoriesCubit>();
    final box = cubit.state.providerStories[widget.provider.providerId];
    if (box == null || !box.isSuccess || box.data == null) return;

    final stories = box.data!;
    final currentIdx = stories.indexWhere((e) => e.id == currentStory.id);
    final nextIdx = currentIdx + 1;
    if (currentIdx == -1 || nextIdx >= stories.length) return;

    final next = stories[nextIdx];
    final url = next.mediaUrl.startsWith('http')
        ? next.mediaUrl
        : '${Constants.baseUrl}${next.mediaUrl}';

    if (next.mediaType == 'VIDEO') {
      // Already prepared for this story → nothing to do.
      if (_nextVideoStoryId == next.id) return;
      _disposePrefetchedVideo();

      final controller = VideoPlayerController.networkUrl(Uri.parse(url));
      _nextVideoStoryId = next.id;
      _nextVideoController = controller;
      controller.initialize().catchError((_) {
        // A failed prefetch is harmless — the real setup will fall back.
      });
    } else {
      // Match the provider AppImage uses so the cache key lines up.
      precacheImage(AppImage.getImageProvider(path: url), context);
    }
  }

  void _markStoryViewed(StoryEntity story) {
    if (!mounted) return;

    final authBloc = context.read<AuthenticationBloc>();
    final storiesCubit = context.read<StoriesCubit>();

    if (!story.isViewed) {
      if (authBloc.isUserAuthenticated()) {
        // Logged-in: record on backend + flip local state.
        storiesCubit.markStoryViewed(widget.provider.providerId, story.id);
      } else {
        // Guest: persist locally with the story's own expiry so we don't
        // keep old data around after the story would have expired on the server.
        storiesCubit.markGuestStoryViewed(
          widget.provider.providerId,
          story.id,
          story.expiresAt,
        );
      }
    }

    // Grey-out the home ring once the user has caught up with this provider
    // (works for both logged-in and guest users).
    final box = storiesCubit.state.providerStories[widget.provider.providerId];
    if (box != null && box.isSuccess && box.data != null && box.data!.isNotEmpty) {
      final isLastStory = story.id == box.data!.last.id;
      final hasUnviewed = box.data!.any((e) => !e.isViewed);
      if (isLastStory || !hasUnviewed) {
        context.read<HomeCubit>().markProviderStoriesAsSeen(
          widget.provider.providerId,
        );
      }
    }
  }

  void _startImageTimer() {
    _timer?.cancel();
    const tick = Duration(milliseconds: 50);
    const totalDuration = Duration(seconds: 5);

    _timer = Timer.periodic(tick, (t) {
      if (!mounted || !_isPlaying) return;

      _progress.value += tick.inMilliseconds / totalDuration.inMilliseconds;

      if (_progress.value >= 1.0) {
        t.cancel();
        _goToNextStory();
      }
    });
  }

  void _startVideoProgressTimer() {
    _timer?.cancel();
    _videoElapsedMs = 0;
    const tick = Duration(milliseconds: 50);

    _timer = Timer.periodic(tick, (t) {
      final controller = _videoController;
      if (!mounted || controller == null || !_isInitialized) return;
      // Skip while paused (long-press) so the bar freezes with the video.
      if (!_isPlaying) return;

      // Drive progress by real elapsed playback time against the video's
      // duration. This is the same reliable mechanism used for images and
      // is immune to decoders that report a bogus `position`.
      //
      // Some malformed uploads report a bogus tiny duration (e.g. 1ms),
      // which made the story skip in under a second. Treat anything under
      // one second as unknown and fall back to a sane default so the story
      // still displays for a reasonable time.
      final reportedMs = controller.value.duration.inMilliseconds;
      final totalMs = reportedMs >= 1000 ? reportedMs : 15000;

      // If the decoder errors out mid-playback (some malformed uploads),
      // don't sit on a frozen frame — move on.
      if (controller.value.hasError) {
        debugPrint('📹 [story] playback error → next story');
        t.cancel();
        _goToNextStory();
        return;
      }

      _videoElapsedMs += tick.inMilliseconds;
      _progress.value = (_videoElapsedMs / totalMs).clamp(0.0, 1.0);

      if (_videoElapsedMs >= totalMs) {
        t.cancel();
        _goToNextStory();
      }
    });
  }

  /// Used when a video fails to initialize (corrupt/undecodable file):
  /// shows the story for a short fixed time so the viewer keeps flowing
  /// instead of hanging on a spinner forever.
  void _startFallbackTimer() {
    _timer?.cancel();
    const tick = Duration(milliseconds: 50);
    const totalDuration = Duration(seconds: 4);

    _timer = Timer.periodic(tick, (t) {
      if (!mounted || !_isPlaying) return;

      _progress.value += tick.inMilliseconds / totalDuration.inMilliseconds;

      if (_progress.value >= 1.0) {
        t.cancel();
        _goToNextStory();
      }
    });
  }

  void _goToNextStory() {
    final cubit = context.read<StoriesCubit>();
    final storiesBox = cubit.state.providerStories[widget.provider.providerId];
    if (storiesBox == null || !storiesBox.isSuccess || storiesBox.data == null)
      return;

    final stories = storiesBox.data!;
    final currentIdx =
        cubit.state.currentStoryIndex[widget.provider.providerId] ?? 0;

    if (currentIdx < stories.length - 1) {
      cubit.setCurrentStoryForProvider(
        widget.provider.providerId,
        currentIdx + 1,
      );
    } else {
      widget.onAllStoriesCompleted();
    }
  }

  void _goToPreviousStory() {
    final cubit = context.read<StoriesCubit>();
    final storiesBox = cubit.state.providerStories[widget.provider.providerId];
    if (storiesBox == null || !storiesBox.isSuccess || storiesBox.data == null)
      return;

    final currentIdx =
        cubit.state.currentStoryIndex[widget.provider.providerId] ?? 0;

    if (currentIdx > 0) {
      cubit.setCurrentStoryForProvider(
        widget.provider.providerId,
        currentIdx - 1,
      );
    } else {
      widget.onPreviousProviderRequested();
    }
  }

  void _pause() {
    setState(() {
      _isPlaying = false;
    });
    _videoController?.pause();
  }

  void _resume() {
    setState(() {
      _isPlaying = true;
    });
    if (_videoController != null) {
      _videoController!.play();
    } else if (_timer == null || !_timer!.isActive) {
      // Only restart the image timer if it isn't already running.
      // The existing timer skips ticks while _isPlaying is false,
      // but resumes automatically when _isPlaying becomes true.
      _startImageTimer();
    }
  }

  String _formatTimeAgo(String dateStr) {
    if (dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 1) return appLocalizer.now;
      if (diff.inMinutes < 60) return appLocalizer.agoMinutes(diff.inMinutes);
      if (diff.inHours < 24) return appLocalizer.agoHours(diff.inHours);
      return appLocalizer.agoDays(diff.inDays);
    } catch (_) {
      return '';
    }
  }

  Widget _buildProgressBars(int count, int activeIdx) {
    return ValueListenableBuilder<double>(
      valueListenable: _progress,
      builder: (context, progress, _) {
        return Row(
          children: List.generate(count, (index) {
            double segmentProgress = 0.0;
            if (index < activeIdx) {
              segmentProgress = 1.0;
            } else if (index == activeIdx) {
              segmentProgress = progress;
            }

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: segmentProgress.clamp(0.0, 1.0),
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                    minHeight: 2.5,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildProviderHeader(StoryEntity story) {
    final avatarUrl = story.providerAvatarUrl.isNotEmpty
        ? (story.providerAvatarUrl.startsWith('http')
              ? story.providerAvatarUrl
              : '${Constants.baseUrl}${story.providerAvatarUrl}')
        : '';

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFE6C27A),
                    width: 1.5,
                  ),
                ),
                child: ClipOval(
                  child: avatarUrl.isNotEmpty
                      ? AppImage(
                          path: avatarUrl,
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.grey.shade800,
                          child: const Icon(
                            Icons.person,
                            color: Colors.white54,
                            size: 20,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      story.providerName.isNotEmpty
                          ? story.providerName
                          : appLocalizer.story,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatTimeAgo(story.createdAt),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close, color: Colors.white, size: 26),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildStoryContent(StoryEntity story) {
    if (story.mediaType == 'VIDEO') {
      final controller = _videoController;
      final isReady =
          controller != null &&
          controller.value.isInitialized &&
          controller.value.size.width > 0 &&
          controller.value.size.height > 0 &&
          _isInitialized;

      if (isReady) {
        return AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        );
      }

      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFE6C27A)),
      );
    } else {
      final imageUrl = story.mediaUrl.startsWith('http')
          ? story.mediaUrl
          : '${Constants.baseUrl}${story.mediaUrl}';

      return AppImage(path: imageUrl, fit: BoxFit.contain);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoriesCubit, StoriesState>(
      listenWhen: (previous, current) {
        final prevActiveId =
            previous.providers.isNotEmpty &&
                previous.currentProviderIndex < previous.providers.length
            ? previous.providers[previous.currentProviderIndex].providerId
            : null;
        final currActiveId =
            current.providers.isNotEmpty &&
                current.currentProviderIndex < current.providers.length
            ? current.providers[current.currentProviderIndex].providerId
            : null;

        final wasActive = prevActiveId == widget.provider.providerId;
        final isActive = currActiveId == widget.provider.providerId;

        final prevStoriesBox =
            previous.providerStories[widget.provider.providerId];
        final currStoriesBox =
            current.providerStories[widget.provider.providerId];

        final prevIdx = previous.currentStoryIndex[widget.provider.providerId];
        final currIdx = current.currentStoryIndex[widget.provider.providerId];

        return wasActive != isActive ||
            prevStoriesBox != currStoriesBox ||
            prevIdx != currIdx;
      },
      listener: (context, state) {
        final activeProviderId =
            state.providers.isNotEmpty &&
                state.currentProviderIndex < state.providers.length
            ? state.providers[state.currentProviderIndex].providerId
            : null;

        final isActive = activeProviderId == widget.provider.providerId;

        if (isActive) {
          final box = state.providerStories[widget.provider.providerId];
          if (box != null &&
              box.isSuccess &&
              box.data != null &&
              box.data!.isNotEmpty) {
            final idx =
                state.currentStoryIndex[widget.provider.providerId] ?? 0;
            if ((idx != _lastActiveStoryIndex || !_isInitialized) &&
                !_isSettingUp) {
              _lastActiveStoryIndex = idx;
              _setupActiveStory(box.data![idx]);
            }
          }
        } else {
          if (_isInitialized || _isSettingUp) {
            _isSettingUp = false;
            _cleanupActiveStory();
            _disposePrefetchedVideo();
            _lastActiveStoryIndex = -1;
          }
        }
      },
      builder: (context, state) {
        final box = state.providerStories[widget.provider.providerId];

        if (box == null || box.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFE6C27A)),
          );
        }

        if (box.isFailure || box.data == null || box.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context).unexpectedError,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    context.read<StoriesCubit>().loadProviderStories(
                      widget.provider.providerId,
                    );
                  },
                  child: Text(AppLocalizations.of(context).retry),
                ),
              ],
            ),
          );
        }

        final stories = box.data!;
        final activeIdx =
            state.currentStoryIndex[widget.provider.providerId] ?? 0;
        final currentStory = stories[activeIdx];
        final topPadding = MediaQuery.of(context).padding.top;

        return GestureDetector(
          onLongPressStart: (_) => _pause(),
          onLongPressEnd: (_) => _resume(),
          child: Stack(
            children: [
              Center(child: _buildStoryContent(currentStory)),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: topPadding + 100,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black54, Colors.transparent],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: topPadding + 8,
                left: 12,
                right: 12,
                child: _buildProgressBars(stories.length, activeIdx),
              ),
              Positioned(
                top: topPadding + 16,
                left: 12,
                right: 12,
                child: _buildProviderHeader(currentStory),
              ),
              Positioned.fill(
                top: topPadding + 80,
                bottom: 100,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: _goToPreviousStory,
                        behavior: HitTestBehavior.translucent,
                        child: const SizedBox.expand(),
                      ),
                    ),
                    const Expanded(flex: 2, child: SizedBox.expand()),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: _goToNextStory,
                        behavior: HitTestBehavior.translucent,
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
