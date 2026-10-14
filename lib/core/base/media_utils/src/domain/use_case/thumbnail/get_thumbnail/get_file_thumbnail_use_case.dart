// part of media_utils;
//
// @injectable
// class GetFileThumbnailUseCase {
//   Future<String> execute(File file, {int quality = 80}) async {
//     final List<int> bytes = await imageFromPdfFileFullImage(_getPdfDocument(file), quality: quality);
//     final thumbnail = await extractImage(bytes);
//
//     return (thumbnail);
//   }
//
//   // Future<List<int>> imageFromPdfFileFullImage(Future<PdfDocument> pdfFile,{int quality = 80}) async {
//   //   final im.Image image;
//   //
//   //   final document = await pdfFile;
//   //   im.Image imImage;
//   //
//   //   final page = await document.getPage(1);
//   //
//   //   final pdfPageImage = await page.render(
//   //       width: page.width,
//   //       height: page.height,
//   //       quality: quality,
//   //       format: PdfPageImageFormat.jpeg);
//   //
//   //   imImage = im.decodeJpg(pdfPageImage!.bytes) ?? im.Image(width: 100, height: 100);
//   //
//   //   image = imImage;
//   //
//   //   await page.close();
//   //
//   //   return im.encodePng(image);
//   // }
//
//   Future<String> extractImage(List<int> list) async {
//     final tempDir = await getTemporaryDirectory();
//     File? imageFile;
//
//     imageFile = File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_image.png')
//       ..createSync(recursive: true)
//       ..writeAsBytesSync(list);
//
//     return imageFile.path;
//   }
// }
//
// // Future<PdfDocument> _getPdfDocument(File file) async {
// //   final pdfSize = file.lengthSync();
// //   logDebug(pdfSize);
// //   return await PdfDocument.openFile(file.path);
// // }
