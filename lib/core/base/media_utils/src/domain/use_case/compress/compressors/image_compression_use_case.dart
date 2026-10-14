part of media_utils;

@injectable
class ImageCompressionUseCase {
  Future<String> execute(String imageFilePath) async {
    if (imageFilePath.isEmpty) return '';

    try {
      final fileName = "${DateTime.now().millisecondsSinceEpoch}-mobilecompressed.jpg";
      final targetPath = "${(await getTemporaryDirectory()).path}/$fileName";
      final result = await FlutterImageCompress.compressAndGetFile(
        imageFilePath,
        targetPath,
        format: CompressFormat.jpeg,
        quality: 90,
      );
      if (result != null) {
        return targetPath;
      } else {
        logDebug("CompressedImage: Failure}");
        throw AttachmentCompressionFailure(appLocalizer.imageCompressFailed);
      }
    } catch (e) {
      logDebug("CompressedImage: Failure}");
      logDebug(e);
      throw AttachmentCompressionFailure(appLocalizer.imageCompressFailed);
    }
  }
}


/*@injectable
class ImageCompressionUseCase {
  Future<String> execute(String imageFilePath) async {
    logDebug("startedCompressing");
    final resultPort = ReceivePort();

    try {
      await _crateIsolate(resultPort, imageFilePath);
    } catch (e) {
      resultPort.close();
      if (e is ImageCompressionFailure) {
        throw ImageCompressionFailure(e.errorMessage);
      }
    }

    final response = await resultPort.first;

    if (response == null) {
      throw IsolationException('No message');
    } else if (response is List) {
      final errorAsString = response[0];
      throw IsolationException(errorAsString);
    } else {
      resultPort.close();
      return response as String;
    }
  }

  Future<void> _crateIsolate(
      ReceivePort resultPort, String imageFilePath) async {
    RootIsolateToken rootToken = RootIsolateToken.instance!;
    await Isolate.spawn(
      _compress,
      [resultPort.sendPort, imageFilePath, rootToken],
      errorsAreFatal: true,
      onExit: resultPort.sendPort,
      onError: resultPort.sendPort,
    );
  }

  Future<void> _compress(List<dynamic> args) async {
    final String filePath = args[1];
    SendPort resultPort = args[0];
    BackgroundIsolateBinaryMessenger.ensureInitialized(args[2]);
    if (Platform.isAndroid) PathProviderAndroid.registerWith();
    if (Platform.isIOS) PathProviderIOS.registerWith();

    try {
      final fileName =
          "${DateTime.now().millisecondsSinceEpoch}-mobilecompressed.jpg";
      final targetPath = "${(await getTemporaryDirectory()).path}/$fileName";
      logDebug("Original Image: ${(await filePath.getFileSizeInMb)}");
      final result = await FlutterImageCompress.compressAndGetFile(
        filePath,
        targetPath,
        format: CompressFormat.jpeg,
        quality: 90,
      );
      if (result != null) {
        logDebug("CompressedImage: ${(await targetPath.getFileSizeInMb)}");
        logDebug("finishedCompressing");
        Isolate.exit(resultPort, targetPath);
      } else {
        logDebug("CompressedImage: Failure}");
        throw ImageCompressionFailure(appLocalizer.compressionError);
      }
    } catch (e) {
      logDebug("CompressedImage: Failure}");
      logDebug(e);
      throw ImageCompressionFailure(appLocalizer.compressionError);
    }
  }
}*/
