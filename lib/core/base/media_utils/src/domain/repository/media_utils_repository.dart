part of media_utils;

abstract class MediaUtilsRepository{
  Future<Attachment> upload(Attachment input, UploadDirectory directory);
  Future<File> downloadFile(String url);
}