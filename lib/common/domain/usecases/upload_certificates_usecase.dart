import 'package:injectable/injectable.dart';
import 'package:moneeb/common/domain/repo/uploads_repo/uploads_repo.dart';
import 'package:moneeb/core/base/media_utils/media_utils.dart';

@injectable
class UploadCertificatesUseCase {
  final UploadsRepository _repo;
  UploadCertificatesUseCase(this._repo);

  Future<String> execute(Attachment attachment, String nameOfCertificate) async {
    return await _repo.uploadCertificates(attachment, nameOfCertificate);
  }
}