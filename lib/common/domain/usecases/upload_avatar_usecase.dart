import 'package:injectable/injectable.dart';
import 'package:moneeb/common/domain/repo/uploads_repo/uploads_repo.dart';
import 'package:moneeb/core/base/media_utils/media_utils.dart';

@injectable
class UploadAvatarUseCase {
  final UploadsRepository _repo;
  UploadAvatarUseCase(this._repo);

  Future<String> execute(Attachment attachment, {bool forProvider = false}) async {
    return await _repo.uploadAvatar(attachment);
  }
}