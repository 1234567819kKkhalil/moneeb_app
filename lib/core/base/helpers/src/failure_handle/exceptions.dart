part of helpers;

class Failure {
  final String errorMessage;

  const Failure(this.errorMessage);
}

class ApiRequestFailure extends Failure {
  final int statusCode;

  const ApiRequestFailure(
    this.statusCode,
    super.errorMessage,
  );

  @override
  String toString() {
    return """
    ApiRequestFailure: 
      statusCode = $statusCode
      errorMessage = $errorMessage
    """
        .trim();
  }
}

class ServerFailure extends Failure {
  const ServerFailure(super.errorMessage);
}

class UnExpectedFailure extends Failure {
  const UnExpectedFailure(super.errorMessage);
}

class RetrieveFcmTokenFailure extends Failure {
  const RetrieveFcmTokenFailure() : super('');
}

//Media Utils Exceptions
class IsolationException extends Failure {
  IsolationException(super.error);
}

class NoAttachmentPickedFailure extends Failure {
  NoAttachmentPickedFailure() : super(appLocalizer.mediaPickupCanceled);
}

class AttachmentCompressionFailure extends Failure {
  AttachmentCompressionFailure(super.errorMessage);
}

class GenerateThumbnailFailure extends Failure {
  GenerateThumbnailFailure(super.errorMessage);
}

class FileSizeFailure extends Failure {
  FileSizeFailure(super.errorMessage);
}

class UploadFileFailure extends Failure {
  UploadFileFailure(super.errorMessage);
}

class FileTypeFailure extends Failure {
  FileTypeFailure(super.errorMessage);
}

class CancelDownloadFileFailure extends Failure {
  CancelDownloadFileFailure() : super('');
}

class UnSupportedFileTypeFailure extends Failure {
  UnSupportedFileTypeFailure({required List<String> allowedExtensions})
      : super("${appLocalizer.supportedFileTypeIs} (${allowedExtensions.join(', ').replaceAll('.', '').toUpperCase()})");
}

class ExceededLimitAttachmentsFailure extends Failure {
  final int maxSize;
  final int skippedNumber;

  ExceededLimitAttachmentsFailure(this.maxSize,this.skippedNumber) : super('');
}

class FileNotExistsFailure extends Failure {
  FileNotExistsFailure() : super(appLocalizer.fileDoesNotExist);
}

class MultiImagePickFailure extends Failure {
  final PickedMultiMediaLimitHandler pickedMultiImagesEntity;
  const MultiImagePickFailure(super.errorMessage, {required this.pickedMultiImagesEntity});
}

//Internet Exceptions
class NoInternetFailure extends Failure {
  NoInternetFailure() : super(appLocalizer.networkError);
}

class OfflineException extends Failure {
  OfflineException() : super('');
}

//Location Exceptions

class LocationFailure extends Failure {
  final bool isDeniedForEver;
  final bool isDenied;
  final bool isLocationServiceDisabled;
  LocationFailure(super.errorMessage,{this.isDeniedForEver = false, this.isDenied = false, this.isLocationServiceDisabled = false});
}

//Permission Exceptions
class PermissionFailure extends Failure {
  final bool shouldOpenSettings;
  const PermissionFailure(super.errorMessage, {required this.shouldOpenSettings});
}