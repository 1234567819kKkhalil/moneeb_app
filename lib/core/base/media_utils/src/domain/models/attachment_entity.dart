part of media_utils;

class Attachment extends Equatable {
  final String id;
  final String url;
  final AttachmentTypeEnum type;
  final ThumbnailAttachment? thumbnail;
  final int? durationInSec;

  Attachment({
    required this.id,
    required this.url,
    required this.type,
    this.thumbnail,
    this.durationInSec,
  });

  Attachment modify({
    String? id,
    String? url,
    AttachmentTypeEnum? type,
    ThumbnailAttachment? thumbnail,
    int? durationInSec,
  }) =>
      Attachment(
        id: id ?? this.id,
        url: url ?? this.url,
        type: type ?? this.type,
        thumbnail: thumbnail ?? this.thumbnail,
        durationInSec: durationInSec ?? this.durationInSec,
      );

  static Attachment empty() {
    return Attachment(
        id: "",
        url: "",
        type: AttachmentTypeEnum.photo,
        thumbnail: ThumbnailAttachment.empty(),
        durationInSec: 0,
    );
  }

  @override
  String toString() {
    return 'Attachment{id: $id, url: $url, thumbnail: $thumbnail, durationInSec: $durationInSec, type: $type}';
  }

  @override
  List<Object?> get props => [
    id,
    url,
    type,
    thumbnail,
    durationInSec,
  ];
}

enum AttachmentTypeEnum {
  document,
  video,
  photo;

  factory AttachmentTypeEnum.fromMimeType(String mimetype){
      if (mimetype.startsWith('image/')) {
        return AttachmentTypeEnum.photo;
      } else if (mimetype.startsWith('video/')) {
        return AttachmentTypeEnum.video;
      } else {
        return AttachmentTypeEnum.document;
      }
  }

  String get localizedName {
    switch (this) {
      case AttachmentTypeEnum.photo:
        return appLocalizer.image;
      case AttachmentTypeEnum.video:
        return appLocalizer.video;
      case AttachmentTypeEnum.document:
        return appLocalizer.file;
    }
  }
}

class ThumbnailAttachment{
  final String id;
  final String url;

  ThumbnailAttachment({required this.id,required this.url});

  factory ThumbnailAttachment.empty() {
    return ThumbnailAttachment(
      id: "",
      url: "",
    );
  }

  ThumbnailAttachment copyWith({
    String? id,
    String? url,
  }) =>
      ThumbnailAttachment(
        id: id ?? this.id,
        url: url ?? this.url,
      );
}