sealed class VideoViewPlayerState{}
class VideoPlayerInitialState extends VideoViewPlayerState{}
class VideoPlayerLoadingState extends VideoViewPlayerState{}
class VideoPlayerSuccessState extends VideoViewPlayerState{}
class VideoPlayerFailureState extends VideoViewPlayerState{
  final String message;
  VideoPlayerFailureState(this.message);
}
