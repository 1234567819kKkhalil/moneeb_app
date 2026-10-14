part of media_utils;

class PickerImagesProperty extends Equatable{
  final int maxCount;
  final int maxSizeLimitInMB;
  final int currentPickedImagesCount;

  const PickerImagesProperty({
    this.currentPickedImagesCount = 0,
    this.maxCount = AppLimits.maxAllowedMediaCount,
    this.maxSizeLimitInMB = AppLimits.maxAllowedImageSizeInMB});

  @override
  List<Object?> get props => [maxCount, maxSizeLimitInMB,currentPickedImagesCount];
}