part of media_utils;

@injectable
class VideoCompressUseCase {
  Future<String> compress(String filePath) async {
    logDebug("Original video: ${await filePath.getFileSizeInMb}");
    try {
      final MediaInfo? info = await VideoCompress.compressVideo(
        filePath,
        quality: VideoQuality.Res1280x720Quality,
        deleteOrigin: false,
        includeAudio: true,
      );
      if (info?.path == null) {
        // throw VideoCompressionException();
        logDebug("Cant Compress: ${await filePath.getFileSizeInMb}");
        return filePath;
      } else {
        logDebug(
            "CompressedVideo: ${await (info?.path ?? '').getFileSizeInMb}");
        return info?.path ?? '';
      }
    } catch (e) {
      logDebug('Already have a compression process');
      return filePath;
    }
  }

// Future<void> clearCache() async{
//   try{
//     await VideoCompress.deleteAllCache();
//   }catch(e){
//     //do not throw error if this fails
//   }
// }

/*Future<String> getVideoThumbnail(String path) async{
    final thumbnail = await VideoCompress.getFileThumbnail(
        path,
        quality: 70,
        position: -1
    );

    return thumbnail.path;
  }*/
}
