part of media_utils;

class ApiAttachmentModel {
  String? id;
  String? url;
  ApiThumbnailAttachment? thumbnail;
  AttachmentTypeEnum? type;
  // int? durationInSec;
  int? size;

  ApiAttachmentModel({
    this.id,
    this.url,
    this.thumbnail,
    this.type,
    // this.durationInSec,
    this.size,
  });

  factory ApiAttachmentModel.fromJson(Map<String, dynamic> json) =>
      ApiAttachmentModel(
        id: json["fileId"],
        url: json["url"],
        size: json["size"],
        // thumbnail: json["thumbnail"], //todo:
        type: json["mimetype"] == null ? null : AttachmentTypeEnum.fromMimeType(json["mimetype"]??''),
        // durationInSec: json["durationInSec"],
      );

  factory ApiAttachmentModel.fromEntity(Attachment attachment) {
    return ApiAttachmentModel(
      id: attachment.id,
      type: attachment.type,
      // thumbnail: attachment.thumbnail, //todo:
      url: attachment.url,
      // durationInSec: attachment.durationInSec,
    );
  }

  Attachment toEntity() {
    return Attachment(
      id: id ?? RandomId.generate(),
      url: url?.addBaseUrl ?? '',
      type: type ?? AttachmentTypeEnum.photo,
      thumbnail: thumbnail?.toEntity(),
      // durationInSec: durationInSec,
    );
  }

  @override
  String toString() {
    return 'ApiAttachment{id: $id, url: $url, type: $type, }';
  }
}

class ApiThumbnailAttachment{
  String? id;
  String? url;
  ApiThumbnailAttachment({this.id,this.url});

  factory ApiThumbnailAttachment.fromJson(Map<String, dynamic> json) =>
      ApiThumbnailAttachment(
        id: json["fileId"],
        url: json["url"],
      );

  factory ApiThumbnailAttachment.fromEntity(ThumbnailAttachment attachment){
    return ApiThumbnailAttachment(
      id: attachment.id,
      url: attachment.url,
    );
  }

  ThumbnailAttachment toEntity() {
    return ThumbnailAttachment(
      id: id ?? RandomId.generate(),
      url: url?.addBaseUrl ?? '',
    );
  }
}