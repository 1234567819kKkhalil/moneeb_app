import 'package:injectable/injectable.dart';
import 'package:moneeb/common/domain/repo/uploads_repo/uploads_repo.dart';
import 'package:moneeb/core/base/media_utils/media_utils.dart';

@injectable
class UploadProviderAvatarUseCase {
  final UploadsRepository _repo;
  UploadProviderAvatarUseCase(this._repo);

  Future<String> execute(Attachment attachment) async {
    return await _repo.uploadProviderAvatar(attachment);
  }
}
