part of media_utils;

// class RegularVideoViewModel extends IVideoViewModel<VideoViewPlayerState>{
//   RegularVideoViewModel({required super.attachment, required super.stackId}) : super(playerStateNotifier: BehaviorSubject.seeded(VideoPlayerInitialState()));
//
//   ChewieController? _chewiController;
//   ChewieController? get chewiController => _chewiController;
//   set chewiController(ChewieController? value) => _chewiController = value;
//
//   @override
//   bool get isHaveInitializedController => _chewiController != null;
//
//   @override
//   void pause() {
//     _chewiController?.pause();
//   }
//
//   @override
//   bool get isPlaying => _chewiController?.isPlaying ?? false;
//
//   @override
//   void play() {
//     _chewiController?.play();
//   }
//
//   @override
//   bool disposeIfCan({bool forceDispose = false, bool removeFromStackOnDispose = true}) {
//     if(!forceDispose){
//       modelUsersCount--;
//     }
//
//     if(modelUsersCount <= 0 || forceDispose){
//       _chewiController?.dispose();
//       _chewiController?.videoPlayerController.dispose();
//       _chewiController = null;
//
//       if(removeFromStackOnDispose){
//         playerStateNotifier.close();
//         return true;
//       }else{
//         playerStateNotifier.add(VideoPlayerInitialState());
//         return false;
//       }
//     }
//
//     return false;
//   }
//
// }

