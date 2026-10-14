part of image_editor;

enum EditImageType {
  gif,
  jpg,
  png;

  factory EditImageType.fromExtension(String? extension) {
    switch(extension) {
      case 'png':
        return EditImageType.png;
      case 'gif':
        return EditImageType.gif;

      case 'jpg':
      default:
        return EditImageType.jpg;
    }
  }
}

class EditImageInfo {
  final Uint8List? data;
  final EditImageType imageType;
  const EditImageInfo(this.data, this.imageType,);
}