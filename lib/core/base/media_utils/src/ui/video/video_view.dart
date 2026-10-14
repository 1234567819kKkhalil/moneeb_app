part of media_utils;

class VideoView extends StatefulWidget {
  final Attachment item;
  final BoxFit? thumbnailBoxFit;
  final bool isSingleViewPlay;
  final bool autoPlay;
  final bool isFromOverlay;
  final OptionsVisibilityControl? optionsVisibility;

  //shown instead of the default progress indicator while the controller is being initialized
  final Widget? loadingWidget;

  final double width;
  final double? height;
  const VideoView({super.key, required this.item, this.thumbnailBoxFit, this.isSingleViewPlay = false, required this.width, required this.height, this.autoPlay = false, this.isFromOverlay = false, this.optionsVisibility, this.loadingWidget});

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> with ConnectivityMonitorMixin, FocusMonitorObserverMixin{
  bool enableRetryOnError = true;

  //these variables are to notify us about the widget visibility percentage on the screen
  final String visibilityKey = DateTime.now().millisecondsSinceEpoch.toString();

  double visibleFraction = 0;

  bool get isVisible => visibleFraction >= 0.15 || widget.isSingleViewPlay;

  //This model holds the chewi controller state, this is like a manager for video state like [loading - initialized - error]
  MaestroController? videoViewModel;

  StreamSubscription? creationStateSub;

  @override
  void initState() {
    final List<String> ignoreMonitorOnPages = [
      VideoMaestroFullScreen.routeName
    ];

    if(widget.autoPlay){
      _initializeVideoController();
    }

    initFocusMonitor(
      useAutoTabRecognizer: true,
      ignorePages: ignoreMonitorOnPages,
      onHidden: (hiddenMode) {
        if (widget.isFromOverlay && hiddenMode is! HiddenByAppLoader) return;

        videoViewModel?.pause();
      },
    );

    super.initState();
  }

  @override
  void dispose() {
    creationStateSub?.cancel();
    creationStateSub = null;

    bool isRemoved = videoViewModel?.disposeIfCan() ?? false;

    if(!isRemoved && !widget.isFromOverlay){
      videoViewModel?.pause();
    }

    super.dispose();
  }

  @override
  void onConnectivityChanges(bool isHasInternet) {
    if(isHasInternet && isVisible){
      try{
        if(videoViewModel?.creationState is VideoPlayerFailureState){
          _initializeVideoController();
        }
      }catch(e){}
    }
  }

  bool _tempIsPlaying = false;

  void _videoPlayerListener(){
    if(videoViewModel == null) return;

    final bool isPlaying = videoViewModel?.videoPlayerController.value.isPlaying ?? false;

    //to stop audios when the user play the video
    if(_tempIsPlaying != isPlaying){
      _tempIsPlaying = isPlaying;

      if(_tempIsPlaying == true){
        injector<VideoControllersManager>().pauseAllStack(regularStackName,exceptAttachmentId: widget.item.id);
      }
    }

    //if the controller has an error and the listener does not know about it, then we will try to play the video again, otherwise we notify the listener with the error
    if((videoViewModel?.videoPlayerController.value.hasError ?? false) && videoViewModel!.creationState is! VideoPlayerFailureState){
      if(enableRetryOnError){
        enableRetryOnError = false;
        _saveCurrentPositionToPlaybackCubit();
        _initializeVideoController();
      }else{
        videoViewModel!.setState(VideoPlayerFailureState(appLocalizer.errorPlayingVideo,));
      }
    }

    if(videoViewModel!.isHaveInitializedController) {
      //this widget gets disposed when the user scroll [FOR PERFORMANCE MATTER]
      //so we will save the last position of the video so when the user come back and play this video again, it will start from the last position
      if(!isPlaying && videoViewModel!.modelUsersCount <= 1){
        _saveCurrentPositionToPlaybackCubit();
      }
    }
  }

  void _saveCurrentPositionToPlaybackCubit(){
    // if(videoViewModel == null) return;
    //
    // final position = videoViewModel!.videoPlayerController.value.position;
    //
    // int endDuration = position.inMilliseconds;
    //
    // //reset if the video is ended
    // if(position == videoViewModel!.videoPlayerController.value.duration){
    //   endDuration = 0;
    // }

    // injector<MediaPlaybackCubit>().saveVideoEndDuration(
    //     PlaybackEntity(id: widget.item.id, endDurationInMill: endDuration)
    // );
  }

  void addListenerAndPlaybackObserver(MaestroController controller){
    if(videoViewModel == null) return;

    controller.videoPlayerController.removeListener(_videoPlayerListener);
    controller.videoPlayerController.addListener(_videoPlayerListener);

    //This check is to do nothing if the video is already playing and have one listener
  //  if(controller.videoPlayerController.value.isPlaying && videoViewModel!.modelUsersCount <= 1){
      //Get last duration that the video reached before paused or disposed
    //  final int? endDuration = injector<MediaPlaybackCubit>().getVideoEndDuration(widget.item.id);

     // if(endDuration != null){
     //   controller.videoPlayerController.seekTo(Duration(milliseconds: endDuration));
     // }
   // }
  }

  void setupControllerModel(){
    //This is responsible for maintaining the video controller across different pages
    videoViewModel ??= MaestroController.createOrGet(attachment: widget.item,increaseListenersCount: true);

    //This is necessary to setup listeners if you opened another page that contains the same attachment
    creationStateSub ??= videoViewModel!.playerStateNotifier.listen((state) {
      if(videoViewModel != null && state is VideoPlayerSuccessState){
        addListenerAndPlaybackObserver(videoViewModel!);
      }
    },);
  }

  void _initializeVideoController() async{
    setState(() {
      setupControllerModel();
    });

    if(videoViewModel!.creationState is VideoPlayerSuccessState){
      _playIfCan();
      return;
    }

    try{
      await videoViewModel!.initialize();
      await videoViewModel!.setClosedCaptionFile("assets/captions-example.srt"); //todo: remove
      enableRetryOnError = true;

    }catch(e){
      log(e.toString());
    }

    _playIfCan();
  }

  void _playIfCan(){
    if(isVisible && isCurrent || widget.isFromOverlay){
      videoViewModel?.videoPlayerController.play();
    }
  }

  bool get isCurrent {
    try{
      return ModalRoute.of(context)?.isCurrent ?? false;
    }catch(e){
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: VisibilityDetector(
        key: ValueKey(visibilityKey),
        onVisibilityChanged: (info) {
          visibleFraction = info.visibleFraction;

          if(isCurrent && !isVisible && !(videoViewModel?.isInFullScreen ?? false)){
            videoViewModel?.pause();
          }
        },
        child: ColoredBox(
          color: context.appColors.neutral.shade900,

          child: StreamBuilder(
            stream: videoViewModel?.playerStateNotifier,
            builder: (context, snapshot) {
              final state = snapshot.data ?? VideoPlayerInitialState();

              if(state is VideoPlayerInitialState){
                //while auto playing there is no thumbnail step, the video starts loading right away
                if(widget.autoPlay && widget.loadingWidget != null){
                  return widget.loadingWidget!;
                }

                return VideoThumbnailPreview(
                  onTap : _initializeVideoController,
                  item: widget.item,
                  thumbnailBoxFit: widget.thumbnailBoxFit,
                  width: widget.width,
                  height: widget.height,
                );
              } else if(state is VideoPlayerLoadingState){
                if(widget.loadingWidget != null) return widget.loadingWidget!;

                return const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: AppProgressIndicator(
                      // size: 12,
                      strokeWidth: 3,
                    )
                );
              }else if(state is VideoPlayerFailureState){
                return _BuildErrorWidget(
                  errorMsg: state.message,
                  onRetry: _initializeVideoController,
                );
              }else if(state is VideoPlayerSuccessState) {
                return Center(
                  child: VideoMaestro(
                    controller: videoViewModel!,
                    optionsVisibility: widget.optionsVisibility ?? const OptionsVisibilityControl()
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class _BuildErrorWidget extends StatelessWidget {
  final Function() onRetry;
  final String? errorMsg;
  const _BuildErrorWidget({super.key, required this.onRetry, this.errorMsg});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned.fill(child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withOpacity(0.4),),
        ),

        Center(
          child: NewPageErrorWidget(
            failure: UnExpectedFailure(errorMsg ?? appLocalizer.errorPlayingVideo),
            onReloadTap: onRetry,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
// class VideoView extends StatefulWidget {
//   final Attachment item;
//   final BoxFit? thumbnailBoxFit;
//   final bool isSingleViewPlay;
//   final bool autoPlay;
//
//   final double width;
//   final double? height;
//   const VideoView({super.key, required this.item, this.thumbnailBoxFit, this.isSingleViewPlay = false, required this.width, required this.height, this.autoPlay = false});
//
//   @override
//   State<VideoView> createState() => _VideoViewState();
// }
//
// class _VideoViewState extends State<VideoView> with ConnectivityMonitorMixin, FocusMonitorObserverMixin{
//   bool enableRetryOnError = true;
//
//   //these variables are to notify us about the widget visibility percentage on the screen
//   final String visibilityKey = DateTime.now().millisecondsSinceEpoch.toString();
//
//   double visibleFraction = 0;
//
//   bool get isVisible => visibleFraction >= 0.15 || widget.isSingleViewPlay;
//
//   //This model holds the chewi controller state, this is like a manager for video state like [loading - initialized - error]
//   RegularVideoViewModel? videoViewModel;
//
//   StreamSubscription? creationStateSub;
//
//   @override
//   void initState() {
//     if(widget.autoPlay){
//       _initializeVideoController();
//     }
//
//     initFocusMonitor(
//       useAutoTabRecognizer: true,
//       onHidden: (hiddenMode) {
//         videoViewModel?.chewiController?.pause();
//       },
//     );
//
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     creationStateSub?.cancel();
//     creationStateSub = null;
//
//     if(videoViewModel != null){
//       //if there is no listeners on that video view model, then dispose the video controller and remove the video view model
//       bool isRemoved = injector<VideoControllersManager>().disposeModelIfCan(
//           attachmentId : widget.item.id,
//           stackId: regularStackName,
//           disposeStateController: true
//       );
//
//       if(!isRemoved){
//         videoViewModel!.chewiController?.pause();
//       }
//     }
//
//     super.dispose();
//   }
//
//   @override
//   void onConnectivityChanges(bool isHasInternet) {
//     if(isHasInternet && isVisible){
//       try{
//         if(videoViewModel?.creationState is VideoPlayerFailureState){
//           _initializeVideoController();
//         }
//       }catch(e){}
//     }
//   }
//
//   bool _tempIsPlaying = false;
//
//   void _videoPlayerListener(){
//     if(videoViewModel?.chewiController == null) return;
//
//     final bool isPlaying = videoViewModel!.chewiController?.videoPlayerController.value.isPlaying ?? false;
//
//     //to stop audios when the user play the video
//     if(_tempIsPlaying != isPlaying){
//       _tempIsPlaying = isPlaying;
//
//       if(_tempIsPlaying == true){
//         injector<AudioControllersManager>().pauseAllRecordersAndPlayers();
//       }
//     }
//
//     //if the controller has an error and the listener does not know about it, then we will try to play the video again, otherwise we notify the listener with the error
//     if(videoViewModel!.chewiController!.hasError && videoViewModel!.creationState is! VideoPlayerFailureState){
//       if(enableRetryOnError){
//         enableRetryOnError = false;
//         //_saveCurrentPositionToPlaybackCubit();
//         _initializeVideoController();
//       }else{
//         videoViewModel!.setState(VideoPlayerFailureState(appLocalizer.errorPlayingVideo,));
//       }
//     }
//
//   /*  if(videoViewModel!.chewiController.isPlayerInitialized) {
//       //this widget gets disposed when the user scroll [FOR PERFORMANCE MATTER]
//       //so we will save the last position of the video so when the user come back and play this video again, it will start from the last position
//       if(!isPlaying && videoViewModel!.modelUsersCount <= 1){ //todo: [videoViewModel.modelUsersCount <= 1] check this line
//         _saveCurrentPositionToPlaybackCubit();
//       }
//     }*/
//   }
//
//  /* void _saveCurrentPositionToPlaybackCubit(){
//     if(videoViewModel?.chewiController == null) return;
//
//     final position = videoViewModel!.chewiController!.videoPlayerController.value.position;
//
//     int endDuration = position.inMilliseconds;
//
//     //reset if the video is ended
//     if(position == videoViewModel!.chewiController!.videoPlayerController.value.duration){
//       endDuration = 0;
//     }
//
//     injector<MediaPlaybackCubit>().saveVideoEndDuration(
//         PlaybackEntity(id: widget.item.id, endDurationInMill: endDuration)
//     );
//   }*/
//
//   void addListenerAndPlaybackObserver(ChewieController controller){
//     if(videoViewModel == null) return;
//
//     controller.videoPlayerController.removeListener(_videoPlayerListener);
//     controller.videoPlayerController.addListener(_videoPlayerListener);
//
//     //This check is to do nothing if the video is already playing and have one listener
//     /*if(controller.isPlaying && videoViewModel!.modelUsersCount <= 1){
//       //Get last duration that the video reached before paused or disposed
//       final int? endDuration = injector<MediaPlaybackCubit>().getVideoEndDuration(widget.item.id);
//
//       if(endDuration != null){
//         controller.videoPlayerController.seekTo(Duration(milliseconds: endDuration));
//       }
//     }*/
//   }
//
//   void setupControllerModel(){
//     //This is responsible for maintaining the video controller across different pages
//     videoViewModel ??= injector<VideoControllersManager>().registerViewModel(
//       videoModel: RegularVideoViewModel(attachment: widget.item, stackId: regularStackName),
//       increaseListenersCount: true,
//     );
//
//     //This is necessary to setup listeners if you opened another page that contains the same attachment
//     creationStateSub ??= videoViewModel!.playerStateNotifier.listen((state) {
//       if(videoViewModel!.chewiController != null && state is VideoPlayerSuccessState){
//         addListenerAndPlaybackObserver(videoViewModel!.chewiController!);
//       }
//     },);
//   }
//
//   void _initializeVideoController() async{
//     setState(() {
//       setupControllerModel();
//     });
//
//     if(videoViewModel!.creationState is VideoPlayerSuccessState){
//       _playIfCan();
//       return;
//     }
//
//     videoViewModel!.setState(VideoPlayerLoadingState());
//
//     //Free controller space if needed
//     injector<VideoControllersManager>().freeControllerPlaceIfNeeded(
//       ignoreAttachmentId: videoViewModel!.attachment.id,
//     );
//
//     bool isHaveInternet = await injector<NetworkInfo>().hasConnection;
//     String videoUrl = widget.item.url;
//     bool isHttpLink = videoUrl.isNetwork;
//
//     //isHttpLink and there is no internet, so show error message
//     if(isHttpLink && !isHaveInternet){
//       videoViewModel!.setState(VideoPlayerFailureState(appLocalizer.networkError));
//       return;
//     }
//
//     //if have internet and the video url is a local filePath, then try the fallBackUrl to fetch the video from internet
//     //[fallBackUrl] is the actual url form internet, it will be assigned for CACHED videos,
//     // so when the internet is back, we will use them instead of cached chunks
//     /*if(isHaveInternet && !isHttpLink){
//       final fallBackUrl = widget.item.fallbackUrl??'';
//
//       if(fallBackUrl.isNotEmpty){
//         videoUrl = fallBackUrl;
//       }
//     }*/
//
//     //set video controller
//     videoViewModel!.chewiController = ChewieController(
//         videoPlayerController: AppVideoController(videoUrl),
//         zoomAndPan: true,
//         progressIndicatorDelay: const Duration(seconds: 2),
//         hideControlsTimer : const Duration(seconds: 2),
//         controlsSafeAreaMinimum : const EdgeInsets.symmetric(
//           horizontal: PaddingDimensions.pageHorizontalPadding,
//         ),
//         optionsBuilder: (context, chewieOptions) async{
//           final double? currentPlaybackSpeed = videoViewModel?.chewiController?.videoPlayerController.value.playbackSpeed;
//
//           return await AppBottomSheets.showMenuBottomSheet(
//               context,
//               menuModels: [
//                 MenuBottomSheetModel(
//                   onTap: (_) {
//                     AppRouteNavigator.pop(context);
//                     AppBottomSheets.showPlaybackSpeedBottomSheet(
//                         context,
//                         currentPlaybackSpeed: currentPlaybackSpeed,
//                         onTap: (context, speed){
//                           videoViewModel?.chewiController?.videoPlayerController.setPlaybackSpeed(speed);
//                           AppRouteNavigator.pop(context);
//                         }
//                     );
//                   },
//                   icon: Icons.speed,
//                   title: "${appLocalizer.playbackSpeed} (${(currentPlaybackSpeed ?? 1).toStringAsFixed(1)}x)",
//                 )
//               ]
//           );
//         }
//     );
//
//     try{
//       if(!videoViewModel!.chewiController.isPlayerInitialized){
//         await videoViewModel!.chewiController?.videoPlayerController.initialize();
//       }
//
//       videoViewModel!.setState(VideoPlayerSuccessState());
//
//       enableRetryOnError = true;
//
//       //addListenerAndPlaybackObserver(videoViewModel.chewiController!);
//     }catch(e){
//       videoViewModel!.setState(VideoPlayerFailureState(appLocalizer.errorPlayingVideo),);
//       log(e.toString());
//     }
//
//     _playIfCan();
//   }
//
//   void _playIfCan(){
//     if(isVisible && (ModalRoute.of(context)?.isCurrent ?? false)){
//       videoViewModel!.chewiController?.play();
//     }
//   }
//
//   bool get isCurrent {
//     try{
//       return ModalRoute.of(context)?.isCurrent ?? false;
//     }catch(e){
//       return false;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: widget.width,
//       height: widget.height,
//       child: VisibilityDetector(
//         key: ValueKey(visibilityKey),
//         onVisibilityChanged: (info) {
//           visibleFraction = info.visibleFraction;
//
//           if(isCurrent && !isVisible && !(videoViewModel?.chewiController?.isFullScreen ?? false)){
//             videoViewModel?.chewiController?.pause();
//           }
//         },
//         child: ColoredBox(
//           color: context.appColors.neutral.shade900,
//
//           child: StreamBuilder(
//             stream: videoViewModel?.playerStateNotifier,
//             builder: (context, snapshot) {
//               final state = snapshot.data ?? VideoPlayerInitialState();
//
//               if(state is VideoPlayerInitialState){
//                 return VideoThumbnailPreview(
//                   onTap : _initializeVideoController,
//                   item: widget.item,
//                   thumbnailBoxFit: widget.thumbnailBoxFit,
//                   width: widget.width,
//                   height: widget.height,
//                 );
//               } else if(state is VideoPlayerLoadingState){
//                 return const FittedBox(
//                     fit: BoxFit.scaleDown,
//                     child: AppProgressIndicator(
//                      // size: 12,
//                       strokeWidth: 3,
//                     )
//                 );
//               }else if(state is VideoPlayerFailureState){
//                 return _BuildErrorWidget(
//                   errorMsg: state.message,
//                   onRetry: _initializeVideoController,
//                 );
//               }else if(state is VideoPlayerSuccessState) {
//                 return Center(
//                   child: Chewie(
//                     controller: videoViewModel!.chewiController!,
//                   ),
//                 );
//               }
//
//               return const SizedBox.shrink();
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _BuildErrorWidget extends StatelessWidget {
//   final Function() onRetry;
//   final String? errorMsg;
//   const _BuildErrorWidget({super.key, required this.onRetry, this.errorMsg});
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         Positioned.fill(child: Container(
//           width: double.infinity,
//           height: double.infinity,
//           color: Colors.black.withOpacity(0.4),),
//         ),
//
//         Center(
//           child: NewPageErrorWidget(
//             failure: UnExpectedFailure(errorMsg ?? appLocalizer.errorPlayingVideo),
//             onReloadTap: onRetry,
//             color: Colors.white,
//           ),
//         )
//       ],
//     );
//   }
// }

