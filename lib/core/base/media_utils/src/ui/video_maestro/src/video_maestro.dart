part of video_maestro;

enum SeekingType{
  forward,backward
}

class VideoMaestro extends StatefulWidget {
  final MaestroController controller;
  final bool isFullScreen;
  final OptionsVisibilityControl optionsVisibility;
  const VideoMaestro({super.key, required this.controller, this.isFullScreen = false, required this.optionsVisibility, });

  @override
  State<VideoMaestro> createState() => _VideoMaestroState();
}

class _VideoMaestroState extends State<VideoMaestro> {
  VideoPlayerValue get vidPlayerValue => widget.controller.videoPlayerController.value;
  VideoPlayerController get videoPlayerController => widget.controller.videoPlayerController;

  bool isPlaying = true;
  final GlobalKey playerWidgetKey = GlobalKey();

  SeekingType? seekingType;
  Timer? seekingDebounce;
  double? playBackValBeforeChange;
  bool isBuffering = false;
  bool hideControls = false;
  DateTime? lastPlayTime;
  int orientation = 0;

  @override
  void initState() {
    videoPlayerController.addListener(_playerListener);
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.removeListener(_playerListener);
    super.dispose();
  }

  void _playerListener(){
    if(!mounted) return;

    //BUFFER
    bool buffering = isActuallyBuffering();

    if(buffering != isBuffering){
      setState(() => isBuffering = buffering);
    }

    // PLAY & PAUSE - HideControls
    if(vidPlayerValue.isPlaying){
      if(!hideControls && !isBuffering){
        lastPlayTime ??= DateTime.now();

        if(lastPlayTime != null && DateTime.now().difference(lastPlayTime!).inSeconds >= 3) {
          setState(() {
            hideControls = true;
            lastPlayTime = null;
          });
        }
      }

      if(!isPlaying){
        setState(() => isPlaying = !isPlaying);
      }
    }else{
      if(isPlaying){
        setState(() {
          lastPlayTime = null;
          hideControls = false;
          isPlaying = !isPlaying;
        });
      }
    }
  }

  bool isActuallyBuffering() {
    final position = vidPlayerValue.position;
    final buffered = vidPlayerValue.buffered;

    for (final range in buffered) {
      if (position >= range.start && position <= range.end) {
        return false;
      }
    }

    return true;
  }

  void _startSeekingDebounce(SeekingType type){
    _stopSeekingDebounce();

    setState(() {
      seekingType = type;
    });

    seekingDebounce = Timer(const Duration(seconds: 1), () {
      setState(() {
        seekingType = null;
      });
    });
  }

  void _stopSeekingDebounce(){
    seekingDebounce?.cancel();
    seekingDebounce = null;
  }

  void onDoubleTapDown(SeekingType seekType) {
    if(seekType == SeekingType.forward){
      videoPlayerController.seekTo(Duration(seconds: videoPlayerController.value.position.inSeconds + 10));
      _startSeekingDebounce(SeekingType.forward);
    } else {
      videoPlayerController.seekTo(Duration(seconds: videoPlayerController.value.position.inSeconds - 10));
      _startSeekingDebounce(SeekingType.backward);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: orientation == 0,
      child: RotatedBox(
        quarterTurns: orientation,
        child: ColoredBox(
          color: Colors.black,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onLongPressStart: (details) {
              setState(() {
                playBackValBeforeChange = videoPlayerController.value.playbackSpeed;
              });
              videoPlayerController.setPlaybackSpeed(2);
            },
            onLongPressUp: () {
              if(playBackValBeforeChange != null){
                videoPlayerController.setPlaybackSpeed(playBackValBeforeChange!);
                setState(() {
                  playBackValBeforeChange = null;
                });
              }
            },
            onTap: () {
              if(vidPlayerValue.isPlaying){
                videoPlayerController.pause();
              }else {
                videoPlayerController.play();
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                // VIDEO VIEW
                AspectRatio(
                  key: playerWidgetKey,
                  aspectRatio: videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(videoPlayerController)
                ),

               //PLAY BUTTON OVERLAY
                if(isBuffering)
                  const AppProgressIndicator(
                    strokeWidth: 4,
                    //color: Colors.white,
                  )
                else
                  AnimatedOpacity(
                    opacity: isPlaying ? 0 : 1,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.ease,
                    child: const Icon(
                      Iconsax.play,
                      color: Colors.white38,
                      size: IconDimensions.large + 2,
                    ),
                  ),

                // BACKWARD SEEK BUTTON
                Positioned(
                  right: null,
                  left: 0,
                  child: _SeekVerticalBarView(
                    currentSeekType: seekingType,
                    value: SeekingType.backward,
                    width: orientation != 0 ? context.height / 4.6 : context.width / 4.6,
                    height: playerWidgetKey.getSize().height,
                    onDoubleTapDown: onDoubleTapDown,
                  )
                ),

                //FORWARD SEEK BUTTON
                if(widget.optionsVisibility.doubleTapToSeek)
                Positioned(
                  right: 0,
                  left: null,
                  child: _SeekVerticalBarView(
                    currentSeekType: seekingType,
                    value: SeekingType.forward,
                    height: playerWidgetKey.getSize().height,
                    width: orientation != 0 ? context.height / 4.6  : context.width / 4.6,
                    onDoubleTapDown: onDoubleTapDown,
                  )
                ),

                // BOTTOM CONTROLS BAR
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if(widget.optionsVisibility.showCaptions)
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ClosedCaption(
                            text: widget.controller.videoPlayerController.value.caption.text,
                            textStyle: context.medium.copyWith(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ),

                      AnimatedOpacity(
                        opacity: hideControls ? 0 : 1,
                        duration: const Duration(milliseconds: 220),
                        child: AnimatedSize(
                          duration: const Duration(milliseconds: 240),
                          curve: Curves.ease,
                          child: hideControls ? const SizedBox() : AbsorbPointer(
                            absorbing: hideControls,
                            child: MaestroBottomControls(
                              controller: widget.controller,
                              orientation: orientation,
                              optionsVisibility: widget.optionsVisibility,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //HOLD TO SEEK 2x
                if(widget.optionsVisibility.holdToDoubleSpeed)
                  if(playBackValBeforeChange != null)
                  Positioned(
                    top: 25,
                    child: MaestroDoubleSpeedView(controller: videoPlayerController),
                  ),

                //ORIENTATION
                if(widget.isFullScreen)
                  Positioned(
                  top: 8,
                  left: 0,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        if(orientation > 0){
                          orientation = 0;
                        } else {
                          orientation = 1;
                        }
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.screen_rotation,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black12,
                            offset: Offset(0, 2),
                            blurRadius: 4,
                          )
                        ],
                        size: 20,
                      ),
                    ),
                  )
                ),

                //OVERLAY BUTTON
                // if(widget.optionsVisibility.showOverlayButton)
                // Positioned(
                //     top: 8,
                //     right: 0,
                //     child: GestureDetector(
                //       behavior: HitTestBehavior.opaque,
                //       onTap: () {
                //         if (widget.isFullScreen) AppRouteNavigator.pop(context);
                //         VideoOverlayManager.showOverlay(context, widget.controller.attachment);
                //       },
                //       child: Padding(
                //         padding: const EdgeInsets.all(16.0),
                //         child: Icon(
                //           Icons.featured_video,
                //           color: context.appColors.neutral.shade100,
                //           shadows: [
                //             const Shadow(
                //               color: Colors.black12,
                //               offset: Offset(0, 2),
                //               blurRadius: 4,
                //             )
                //           ],
                //           size: 20,
                //         ),
                //       ),
                //     )
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SeekVerticalBarView extends StatelessWidget {
  final void Function(SeekingType type) onDoubleTapDown;
  final SeekingType? currentSeekType;
  final SeekingType value;
  final double height;
  final double width;
  const _SeekVerticalBarView({super.key, required this.onDoubleTapDown, required this.currentSeekType, required this.value, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,

      onDoubleTapDown: (details) {
        onDoubleTapDown(value);
      },
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 380),
        opacity: currentSeekType == value ? 1 : 0,
        child: currentSeekType != value
          ? SizedBox(width:width, height: height)
          : Container(
              height: height,
              width: width,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black12,
                      Colors.black26,
                    ]
                  )
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Icon(
                  value == SeekingType.forward ? Icons.fast_forward_rounded : Icons.fast_rewind_rounded,
                  color: Colors.black54,
                  size: 34,
                ),
              ),
            ),
      ),
    );
  }
}
