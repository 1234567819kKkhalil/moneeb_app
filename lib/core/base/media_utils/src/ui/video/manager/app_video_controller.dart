part of media_utils;

class AppVideoController extends VideoPlayerController{
  AppVideoController._asset(super.dataSource) : super.asset();
  AppVideoController._network(String url) : super.networkUrl(Uri.parse(url));
  AppVideoController._file(String url) : super.file(File(url));

  BehaviorSubject<bool> playStateSub = BehaviorSubject<bool>();

  factory AppVideoController(String url) {
    if (url.isNetwork) {
      return AppVideoController._network(url);
    } else if (url.isAssetFile) {
      return AppVideoController._asset(url);
    } else {
      return AppVideoController._file(url);
    }
  }
}