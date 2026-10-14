part of media_utils;

@injectable
class UploadFileUseCase {
  final MediaUtilsRepository _repository;

  UploadFileUseCase(this._repository);

  Future<Attachment> execute(Attachment attachment, UploadDirectory directory) async {
    if(attachment.url.isNetwork) {
      return attachment;
    }

    return await _repository.upload(attachment, directory);
  }
}
