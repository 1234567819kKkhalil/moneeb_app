part of media_utils;

@injectable
class AttachmentThumbnailGrabber {
  final GetVideoThumbnailUseCase _getVideoThumbnail;
  // final GetFileThumbnailUseCase _getFileThumbnailUseCase;

  AttachmentThumbnailGrabber(
      this._getVideoThumbnail, );

  Future<String?> grabThumbnail(
      AttachmentTypeEnum? attachmentType, String fileUrl, {int quality = 80}) async {
    switch (attachmentType) {
      case AttachmentTypeEnum.video:
        return await _getVideoThumbnail.execute(videoPath: fileUrl, quality: quality);

      // case AttachmentTypeEnum.document:
      //   return await _getFileThumbnailUseCase.execute(File(fileUrl), quality: quality);

      default:
        return null;
    }
  }
}
