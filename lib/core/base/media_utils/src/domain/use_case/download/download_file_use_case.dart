// part of media_utils;
//
// @injectable
// class DownloadFileUseCase {
//   final MediaUtilsRepository _repository;
//   final SaveFileInMobileExternalStorageUseCase _saveFileInStorageUseCase;
//
//   DownloadFileUseCase(this._repository,this._saveFileInStorageUseCase);
//
//   Future<AsyncStream<void>> downloadStream({required String url, required String fileName ,AttachmentTypeEnum? type}) async {
//     final stream = await _repository.downloadFileStream(url);
//     return stream.map((resultValue) async {
//       await _saveFileInStorageUseCase.execute(file: resultValue, type: type);
//       resultValue.deleteSync();
//     });
//   }
//
//   Future<File> download({required String url, required String fileName, AttachmentTypeEnum? type}) async {
//     final result = await _repository.downloadFile(url);
//     await _saveFileInStorageUseCase.execute(file: result, type: type);
//     result.deleteSync();
//     return result;
//   }
// }
