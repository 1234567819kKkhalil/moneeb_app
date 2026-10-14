part of app_utils;

enum AppDirType{
  appDirectory,
  tempDirectory
}

class AppUtilsDirectoriesPaths{
  //Video compress and thumbnail extraction
  static const String videoThumbnailsDirName = 'video_thumbnails';
  static const String notificationThumbnailsDirName = 'notification_thumbnails';

  //Trimmer
  static const String trimmerDirName = 'Trimmer';
  static const String trimmerTempThumbnailsDirName = 'trimmer_thumbnails';

  //Compress
  static const String compressDirName = 'compressed_videos';

  //Edited images
  static const String editedImageDirName = 'edited_images';

  //--- App Directory Paths ---
  static String? _appDocumentDirPath;
  static String? _appCacheDirPath;

  static Future<String> get getAppDirectoryPath async{
    _appDocumentDirPath ??=(await getApplicationDocumentsDirectory()).path;
    return _appDocumentDirPath!;
  }

  static Future<String> get getTempDirectoryPath async{
    _appCacheDirPath ??=(await getTemporaryDirectory()).path;
    return _appCacheDirPath!;
  }

  //Video Utils
  static Future<String> getVideoThumbnailsPath({String? joinWithFileName}) async => await getDirPathFor(
      dirName: videoThumbnailsDirName,
      dirType: AppDirType.appDirectory,
      joinWithFileName: joinWithFileName
  );

  //Trimmer
  static Future<String> getTrimmerTempThumbnailsPath() async => await getDirPathFor(
    dirName: trimmerTempThumbnailsDirName,
    dirType: AppDirType.tempDirectory,
  );

  static Future<String> getTrimmerDirPath() async => await getDirPathFor(
    dirName: trimmerDirName,
    dirType: AppDirType.appDirectory,
  );

  //Compress
  static Future<String> getCompressDirPath({List<String>? joinWithDirectories, String? joinWithFileName}) async => await getDirPathFor(
    dirName: compressDirName,
    dirType: AppDirType.appDirectory,
    joinWithDirectories: joinWithDirectories,
    joinWithFileName: joinWithFileName,
  );

  //Notification thumbnails
  static Future<String> getNotificationThumbnailsDirPath() async => await getDirPathFor(
      dirName: notificationThumbnailsDirName,
      dirType: AppDirType.tempDirectory
  );

  //Edited images path
  static Future<String> getEditedImagesDirPath({List<String>? joinWithDirectories, String? joinWithFileName}) async => await getDirPathFor(
    dirName: editedImageDirName,
    joinWithDirectories: joinWithDirectories,
    joinWithFileName: joinWithFileName,
  );

  //Helpers
  static Future<String> getDirPathFor({required String dirName, AppDirType dirType = AppDirType.appDirectory, List<String>? joinWithDirectories, String? joinWithFileName}) async{
    final appDirectoryPath = await (dirType == AppDirType.appDirectory ? getAppDirectoryPath : getTempDirectoryPath);

    final Directory directory = Directory(path.joinAll([
      appDirectoryPath,dirName,

      if(joinWithDirectories != null)
        ...joinWithDirectories
    ]));

    if(!await directory.exists()){
      await directory.create(recursive: true);
    }

    if(joinWithFileName != null){
      return path.join(directory.path,joinWithFileName);
    }

    return directory.path;
  }

/*  static Future<void> moveFile(String fileToMove, Directory destinationDir) async {
    File sourceFile = File(fileToMove);

    if (!(await sourceFile.exists())) {
      return;
    }

    if(!(await destinationDir.exists())){
      await destinationDir.create();
    }

    await sourceFile.rename(path.join(destinationDir.path,path.basename(fileToMove)));
  }*/
}
