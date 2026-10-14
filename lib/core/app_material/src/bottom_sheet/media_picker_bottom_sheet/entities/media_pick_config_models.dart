part of app_material;

sealed class MediaPickItemConfig{
  final String? label;
  final IconData? icon;
  final String? secondLabel;
  const MediaPickItemConfig({required this.label,required this.icon,required this.secondLabel});
}

// IMAGES CONFIG
class MediaPickImageConfig extends MediaPickItemConfig{
  final bool isMultiple;
  final bool isCamera;
  final bool canModifyImage;
  final PickerImagesProperty multiPicksProperties;
  const MediaPickImageConfig.single({
    super.label,
    super.icon,
    super.secondLabel,
    this.isCamera = false,
    this.canModifyImage = false
  }) : isMultiple = false, multiPicksProperties = const PickerImagesProperty(maxCount: 1,currentPickedImagesCount: 0,);

  const MediaPickImageConfig.multiple({
    super.label,
    super.icon,
    super.secondLabel,
    this.multiPicksProperties = const PickerImagesProperty(maxCount: 15, currentPickedImagesCount: 0),
  }) :
      isMultiple = true,
      isCamera = false,
      canModifyImage = false;
}

// VIDEOS CONFIG
class MediaPickVideoConfig extends MediaPickItemConfig{
  final PickerVideoProperties pickerVideoProperties;
  final bool isCamera;

  const MediaPickVideoConfig({
    super.label,
    super.icon,
    super.secondLabel,
    this.isCamera = false,
    this.pickerVideoProperties = const PickerVideoProperties()
  });
}

// MEDIA CONFIG (IMAGES OR VIDEOS)
class MediaPickMediaConfig extends MediaPickItemConfig{
  final PickerVideoProperties videoProperties;
  final PickerImagesProperty imagesProperties;

  //todo: add single media picker

  const MediaPickMediaConfig.multiple({
    super.label,
    super.icon,
    super.secondLabel,
    this.videoProperties = const PickerVideoProperties(),
    this.imagesProperties = const PickerImagesProperty(maxCount: 15, currentPickedImagesCount: 0),
  });
}

// CUSTOM
class MediaPickCustomConfig extends MediaPickItemConfig{
  final void Function()? callback;
  const MediaPickCustomConfig({
    required super.label,
    required super.icon,
    super.secondLabel,
    this.callback,
  });
}

