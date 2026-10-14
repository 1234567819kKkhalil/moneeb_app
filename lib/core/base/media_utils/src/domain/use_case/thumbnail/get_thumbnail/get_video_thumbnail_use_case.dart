part of media_utils;

@injectable
class GetVideoThumbnailUseCase {
  Future<String> execute({required String videoPath, int quality = 80}) async {
    final thumbnail = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      imageFormat: ImageFormat.JPEG,
      quality: quality,
      thumbnailPath: await AppUtilsDirectoriesPaths.getVideoThumbnailsPath(joinWithFileName: '${DateTime.now().millisecondsSinceEpoch}-thumbnail.jpg'),
    );

    if (thumbnail == null) {
      throw GenerateThumbnailFailure(appLocalizer.thumbnailError);
    } else {
      return thumbnail;
    }
  }
}
