part of media_utils;

@LazySingleton(as: MediaUtilsRepository)
class MediaUtilsRepositoryImp implements MediaUtilsRepository {
  final DioHelper _dioHelper;
  MediaUtilsRepositoryImp(this._dioHelper);

  @override
  Future<Attachment> upload(Attachment input, UploadDirectory directory) async {
    final apiUploadFileInput = await input.mapToApiInput;

    final response = await _dioHelper.post(
      "files/${directory.toApi()}",
      data: FormData.fromMap({
        "file": apiUploadFileInput.file
      }),
      isForUpload: true
    );
    
    return ApiAttachmentModel.fromJson(response.data?["data"]??{}).toEntity();
  }

  @override
  Future<File> downloadFile(String url) async {
    final token = (await injector<TokenManager>().token)?.accessToken ?? '';

    final headers = {"Authorization": "Bearer $token"};

    final String downloadsDir = await _getTemporaryAppDownloadsDirectoryPath();

    final downloadedFileName = url.split('/').last;

    String downloadedFilePath = "$downloadsDir/$downloadedFileName";
    final request = await _dioHelper.downloadFile(
      url: url,
      headers: headers,
      path: downloadedFilePath,
    );
    final file = File(downloadedFilePath);
    if (request.statusCode == 200 && file.existsSync()) {
      return file;
    } else {
      throw ApiRequestFailure(
        request.statusCode ?? 0,
        request.statusMessage ?? '',
      );
    }
  }

  Future<String> _getTemporaryAppDownloadsDirectoryPath() async {
    final directory = await getTemporaryDirectory();
    final downloadsDirectory =
    await Directory('${directory.path}/Downloads').create(recursive: true);
    return downloadsDirectory.path;
  }
}
