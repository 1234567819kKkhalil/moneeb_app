part of fire_base;

class NotificationStyleHandler{
  final String thumbnail;
  const NotificationStyleHandler(this.thumbnail);

  Future<StyleInformation?> getAndroidStyle() async {
    String downloadedThumbnail = await _downloadAndSaveFile(thumbnail);

    if (downloadedThumbnail.isNotEmpty) {
      return BigPictureStyleInformation(
        FilePathAndroidBitmap(downloadedThumbnail),
      );
    }

    return null;
  }

  Future<List<DarwinNotificationAttachment>?> getIosAttachments() async {
    String downloadedThumbnail = await _downloadAndSaveFile(thumbnail);

    if (downloadedThumbnail.isNotEmpty) {
      return [DarwinNotificationAttachment(downloadedThumbnail)];
    }

    return null;
  }

  Future<String> _downloadAndSaveFile(String url) async {
    if (thumbnail.isEmpty) return '';

    try {
      final String dirPath = await AppUtilsDirectoriesPaths.getNotificationThumbnailsDirPath();
      final File file = File(path.join(dirPath,DateTime.now().millisecondsSinceEpoch.toString()));

      final http.Response response = await http.get(Uri.parse(url));
      await file.writeAsBytes(response.bodyBytes);
      return file.path;
    } catch (e) {
      log("Error Download Notification Thumbnail: ${e.toString()}");
      return '';
    }
  }
}