part of video_maestro;

class MaestroController extends IVideoViewModel{
  MaestroController._({required super.attachment, required super.stackId}) : super(playerStateNotifier: BehaviorSubject.seeded(VideoPlayerInitialState()));

  static createOrGet({required Attachment attachment, String stackId = regularStackName, bool increaseListenersCount = true}){
    return injector<VideoControllersManager>().registerViewModel(
      increaseListenersCount: increaseListenersCount,
      videoModel: MaestroController._(attachment: attachment, stackId: stackId),
    );
  }

  bool isControllerClosed = false;

  late VideoPlayerController _videoPlayerController = AppVideoController(attachment.url);
  VideoPlayerController get videoPlayerController => _videoPlayerController;

  @override
  bool get isHaveInitializedController => _videoPlayerController.value.isInitialized;

  bool isInFullScreen = false;

  Future<void> initialize() async{
    setState(VideoPlayerLoadingState());

    //Free controller space if needed
    injector<VideoControllersManager>().freeControllerPlaceIfNeeded(
      ignoreAttachmentId: attachment.id,
    );

    bool isHaveInternet = await injector<NetworkInfo>().hasConnection;
    String videoUrl = attachment.url ?? '';
    bool isHttpLink = videoUrl.isNetwork;

    //isHttpLink and there is no internet, so show error message
    if(isHttpLink && !isHaveInternet){
      setState(VideoPlayerFailureState(appLocalizer.networkError));
      throw NoInternetFailure();
    }

    if(isControllerClosed){
      _videoPlayerController = AppVideoController(attachment.url);
      isControllerClosed = false;
    }

    if(!_videoPlayerController.value.isInitialized){
      await _videoPlayerController.initialize();
    }

    _videoPlayerController.removeListener(errorListener);
    _videoPlayerController.addListener(errorListener);
    setState(VideoPlayerSuccessState());
  }

  void errorListener() {
    if(_videoPlayerController.value.hasError) {
      print("ERROR OCCCCCCURED");
      print(_videoPlayerController.value.errorDescription);
    }
  }

  Future<void> setClosedCaptionFile(String filePath) async {
    try{
      await _videoPlayerController.setClosedCaptionFile(loadCaption(filePath));
    } catch(e){
      print("Could not set closed caption file: $e");
    }
  }

  Future<ClosedCaptionFile> loadCaption(String path) async {
    String content = '';

    if(path.isAssetFile){
      content = await rootBundle.loadString(path);
    } else if (path.isNetwork) {
      //todo: download
    }  else {
      content = await File(path).readAsString();
    }

    if(path.endsWith('.vtt')) {
      return WebVTTCaptionFile(content);
    } else {
      return SubRipCaptionFile(content);
    }
  }

  @override
  void pause() {
    _videoPlayerController.pause();
  }

  @override
  bool get isPlaying => _videoPlayerController.value.isPlaying;

  @override
  void play() {
    _videoPlayerController.play();
  }

  @override
  bool disposeIfCan({bool forceDispose = false, bool removeFromStackOnDispose = true}) {
    if(!forceDispose){
      modelUsersCount--;
    }

    if(modelUsersCount <= 0 || forceDispose){
      _videoPlayerController.dispose();
      isControllerClosed = true;

      if(removeFromStackOnDispose){
        playerStateNotifier.close();
        injector<VideoControllersManager>().removeModelFromStack(attachmentId: attachment.id,stackId: stackId);
        return true;
      }else{
        playerStateNotifier.add(VideoPlayerInitialState());
        return false;
      }
    }

    return false;
  }
}