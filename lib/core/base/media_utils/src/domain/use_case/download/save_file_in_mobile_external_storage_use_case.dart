// part of media_utils;
//
// @injectable
// class SaveFileInMobileExternalStorageUseCase {
//   final _documentOBJ = DocumentFileSavePlus();
//
//   Future<void> execute({required File file, AttachmentTypeEnum? type}) async {
//     switch (type) {
//       case AttachmentTypeEnum.photo:
//         await Gal.putImage(file.path, album: Constants.appName);
//         break;
//       case AttachmentTypeEnum.video:
//         await Gal.putVideo(file.path, album: Constants.appName);
//         break;
//
//       case AttachmentTypeEnum.document:
//       case AttachmentTypeEnum.sound:
//       default:
//         await _saveInDownloads(file);
//         break;
//     }
//   }
//
//   Future<void> _saveInDownloads(File file) async {
//     final fileAsBytes = await file.readAsBytes();
//     final String fileName = file.path.split('-').last;
//     await _documentOBJ.saveFile(fileAsBytes, fileName, _getMimeType(fileName));
//   }
//
//   String _getMimeType(String fileName) {
//     final mimeType = lookupMimeType(fileName);
//     return mimeType ?? 'application/pdf';
//   }
// }
