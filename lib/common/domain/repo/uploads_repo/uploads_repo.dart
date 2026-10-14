import 'package:injectable/injectable.dart';
import 'package:moneeb/common/data/endpoints/uploads_endpoints.dart';
import 'package:moneeb/core/base/media_utils/media_utils.dart';
import 'package:moneeb/core/config/config.dart';
import 'package:moneeb/core/utils/utils_imports.dart';

@lazySingleton
class UploadsRepository {
  final DioHelper _dioHelper;
  final UploadAttachmentUseCase _uploadAttachmentUseCase;
  UploadsRepository(this._dioHelper, this._uploadAttachmentUseCase);

  Future<String> uploadAvatar(Attachment attachment) async {
    if (attachment.url.isNetwork) {
      return attachment.url;
    }

    final data = await _uploadAttachmentUseCase.execute(
      input: [attachment],
      directory: UploadDirectory.avatars,
    );

    final uploadedAttachment = data.firstOrNull;

    await _dioHelper.patch(
      UploadsEndpoints.uploadAvatar,
      data: {"fileId": uploadedAttachment?.id},
    );

    //  return uploadedAttachment?.url.addBaseUrl ?? '';
    return uploadedAttachment?.url ?? '';
  }

  Future<String> uploadProviderAvatar(Attachment attachment) async {
    if (attachment.url.isNetwork) {
      return attachment.url;
    }

    final data = await _uploadAttachmentUseCase.execute(
      input: [attachment],
      directory: UploadDirectory.avatars,
    );

    final uploadedAttachment = data.firstOrNull;

    await _dioHelper.patch(
      UploadsEndpoints.uploadProviderAvatar,
      data: {"fileId": uploadedAttachment?.id},
    );

    return uploadedAttachment?.url ?? '';
  }

  Future<String> uploadCertificates(
    Attachment attachment,
    String nameOfCertificate,
  ) async {
    if (attachment.url.isNetwork) {
      return attachment.url;
    }

    final data = await _uploadAttachmentUseCase.execute(
      input: [attachment],
      directory: UploadDirectory.certificates,
    );

    final uploadedAttachment = data.firstOrNull;

    await _dioHelper.post(
      UploadsEndpoints.uploadProviderCertificates,
      data: {"fileId": uploadedAttachment?.id, "title": nameOfCertificate},
    );

    return uploadedAttachment?.url??'';
  }

  Future<String> uploadIdentification(Attachment attachment) async {
    if (attachment.url.isNetwork) {
      return attachment.url;
    }

    final data = await _uploadAttachmentUseCase.execute(
      input: [attachment],
      directory: UploadDirectory.providerIdentification,
    );

    final uploadedAttachment = data.firstOrNull;

    await _dioHelper.patch(
      UploadsEndpoints.uploadProviderIdentifier,
      data: {"fileId": uploadedAttachment?.id},
    );

    return uploadedAttachment?.url??'';
  }
}
