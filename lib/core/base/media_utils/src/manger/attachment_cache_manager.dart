part of media_utils;

///Pass it to the [UploadAttachmentUseCase] to save the uploaded media in the cache to not upload them again
/// No additional actions are required beyond saving this object in your Cubit or any persistent object for the lifetime of your page.
class AttachmentCacheManager{
  final List<AttachmentCacheEntity> cachedAttachments = [];

  AttachmentCacheEntity? getCachedAttachment({required String id}) {
    if(id.isEmpty) return null;

    return cachedAttachments.firstWhereOrNull((e) => e.id == id);
  }

  void cacheCompressedMedia({required String id,required String compressedUrl}){
    if(compressedUrl.isEmpty && id.isNotEmpty) return;

    log("SET CACHE (COMPRESSED MEDIA) : {id: $id, compressedUrl: $compressedUrl}");
    _setCacheAttachment(
      searchForId: id,
      ifAbsent: () {
        cachedAttachments.add(AttachmentCacheEntity(
            id: id,
            compressedMedia: compressedUrl
        ));
      },
      ifExists: (index) {
        cachedAttachments[index] = cachedAttachments[index].copyWith(
            compressedMedia: compressedUrl
        );
      },
    );
  }

  void cacheCompressedThumbnail({required String id,required String compressedUrl}){
    if(compressedUrl.isEmpty) return;

    _setCacheAttachment(
      searchForId: id,
      ifAbsent: () {
        cachedAttachments.add(AttachmentCacheEntity(
            id: id,
            compressedThumbnail: compressedUrl
        ));
      },
      ifExists: (index) {
        cachedAttachments[index] = cachedAttachments[index].copyWith(
            compressedThumbnail: compressedUrl
        );
      },
    );
  }

  void cacheUploadedMedia({required String id,required String uploadedUrl}){
    if(uploadedUrl.isEmpty) return;

    _setCacheAttachment(
      searchForId: id,
      ifAbsent: () {
        cachedAttachments.add(AttachmentCacheEntity(
          id: id,
          uploadedMedia: uploadedUrl,
        ));
      },
      ifExists: (index) {
        cachedAttachments[index] = cachedAttachments[index].copyWith(
            uploadedMedia: uploadedUrl
        );
      },
    );
  }

  void cacheUploadedThumbnail({required String id,required String uploadedUrl}){
    if(uploadedUrl.isEmpty) return;

    debugPrint("SET CACHE (UPLOADED MEDIA) : {id: $id, compressedUrl: $uploadedUrl}");

    _setCacheAttachment(
      searchForId: id,
      ifAbsent: () {
        cachedAttachments.add(AttachmentCacheEntity(
          id: id,
          uploadedThumbnail: uploadedUrl,
        ));
      },
      ifExists: (index) {
        cachedAttachments[index] = cachedAttachments[index].copyWith(
            uploadedThumbnail: uploadedUrl
        );
      },
    );
  }

  void _setCacheAttachment({
    required String searchForId,
    required Function(int index) ifExists,
    required Function() ifAbsent,
  }) {
    if (searchForId.isEmpty) return;

    final int indexOf = cachedAttachments.indexWhere((element) => element.id == searchForId);

    if (indexOf != -1) {
      ifExists(indexOf);
    } else {
      ifAbsent();
    }
  }
}

class AttachmentCacheEntity {
  final String id;
  final String? compressedMedia;
  final String? uploadedMedia;
  final String? compressedThumbnail;
  final String? uploadedThumbnail;

  const AttachmentCacheEntity({
    required this.id,
    this.compressedMedia,
    this.uploadedMedia,
    this.compressedThumbnail,
    this.uploadedThumbnail,
  });

  bool get isMediaUploaded => uploadedMedia?.isNotEmpty ?? false;

  bool get isMediaCompressed {
    if (compressedMedia?.isNotEmpty ?? false) {
      return File(compressedMedia!).existsSync();
    } else {
      return false;
    }
  }

  bool get isThumbnailUploaded => uploadedThumbnail?.isNotEmpty ?? false;

  bool get isThumbnailCompressed {
    if (compressedThumbnail?.isNotEmpty ?? false) {
      return File(compressedThumbnail!).existsSync();
    } else {
      return false;
    }
  }

  AttachmentCacheEntity copyWith({
    String? compressedMedia,
    String? uploadedMedia,
    String? compressedThumbnail,
    String? uploadedThumbnail,
  }) {
    return AttachmentCacheEntity(
        id: id,
        compressedMedia: compressedMedia ?? this.compressedMedia,
        uploadedMedia: uploadedMedia ?? this.uploadedMedia,
        compressedThumbnail: compressedThumbnail ?? this.compressedThumbnail,
        uploadedThumbnail: uploadedThumbnail ?? this.uploadedThumbnail);
  }
}