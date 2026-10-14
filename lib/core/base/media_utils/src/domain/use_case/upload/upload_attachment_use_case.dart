part of media_utils;

//todo: refactor
@injectable
class UploadAttachmentUseCase {
  final UploadFileUseCase _uploadFileUseCase;
  final AttachmentThumbnailGrabber _attachmentThumbnailGrabber;
  final AttachmentCompressor _attachmentCompressor;
  UploadAttachmentUseCase(this._attachmentCompressor, this._uploadFileUseCase, this._attachmentThumbnailGrabber);

  Future<List<Attachment>> execute({
    required List<Attachment> input,
    bool enableVideoCompress = true,
    // bool extractVideoThumbnail = true,
    required UploadDirectory directory
  }) async {
    List<Attachment> attachmentResults = List.from(input);

    for (int index = 0; index < attachmentResults.length; index++) {
      Attachment attachment = attachmentResults[index];

      if (attachment.url.isEmpty) {
        throw UploadFileFailure(appLocalizer.cantUploadEmptyFile);
      }

      final Attachment compressThenUploadAttachment = await ChainOfTasks.chain<Attachment>(
        attachment,
        [
          (data) async {
            Attachment modifiedAttachment = data;

            final compressMedia = await _attachmentCompressor.compress(data.type, data.url);
            modifiedAttachment = modifiedAttachment.modify(url: compressMedia);

            final thumbnailUrl = data.thumbnail?.url??'';

            if(thumbnailUrl.isEmpty && !data.url.isNetwork){
              final String? grabbedThumbnail = await _attachmentThumbnailGrabber.grabThumbnail(
                attachment.type,
                data.url,
              );

              if(grabbedThumbnail != null){
                final compressThumbnail = await _attachmentCompressor.compress(
                  AttachmentTypeEnum.photo,
                  grabbedThumbnail
                );

                modifiedAttachment = modifiedAttachment.modify(thumbnail: ThumbnailAttachment(
                  id: RandomId.generate(),
                  url: compressThumbnail ?? grabbedThumbnail
                ));
              }
            }

            return modifiedAttachment;
          },
          (compressedAttachment) async {
            return await _uploadAttachment(
              compressedAttachment,
              directory
            );
          }
        ],
      );

      attachmentResults[index] = compressThenUploadAttachment;
    }

    return attachmentResults;
  }

  Future<Attachment> _uploadAttachment(
    Attachment attachment,
    UploadDirectory directory
  ) async {
    Attachment? uploadThumbnail;

    if((attachment.thumbnail?.url??'').isNotEmpty){
      uploadThumbnail = await _uploadFileUseCase.execute(
        Attachment(id: attachment.thumbnail?.id??RandomId.generate(), url: attachment.thumbnail?.url??'', type: AttachmentTypeEnum.photo),
        directory
      );
    }

    Attachment? uploadMedia = await _uploadFileUseCase.execute(attachment,directory);

    if(uploadThumbnail != null){
      uploadMedia = uploadMedia.modify(thumbnail: ThumbnailAttachment(id: uploadThumbnail.id, url: uploadThumbnail.url));
    }

    return uploadMedia;
  }
}
