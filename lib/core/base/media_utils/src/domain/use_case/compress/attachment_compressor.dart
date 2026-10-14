part of media_utils;

@lazySingleton
class AttachmentCompressor {
  final ImageCompressionUseCase _compressImageUseCase;
  final VideoCompressUseCase _compressVideoUseCase;

  AttachmentCompressor(this._compressImageUseCase, this._compressVideoUseCase);

  Future<String?> compress(
    AttachmentTypeEnum? attachmentType,
    String? filePath,
  ) async {
    String compressedMedia = filePath ?? '';

    if (compressedMedia.isEmpty || compressedMedia.isNetwork) {
      return compressedMedia;
    }

    if (attachmentType == AttachmentTypeEnum.photo) {
      compressedMedia = await _compressImageUseCase.execute(filePath!);
    } else if (attachmentType == AttachmentTypeEnum.video) {
      compressedMedia = await _compressVideoUseCase.compress(filePath!);
    }

    if (kDebugMode) {
      log("""
        Before compress: ${await filePath?.getFileSizeInMb}
        After compress: ${await compressedMedia.getFileSizeInMb}
      """);
    }

    return compressedMedia;
  }
}
