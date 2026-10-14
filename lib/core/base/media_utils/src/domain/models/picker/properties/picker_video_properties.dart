part of media_utils;

class PickerVideoProperties{
  final Duration? maxRecordDuration;
  final int maxAllowedSizeInMB;
  final bool generateThumbnail;
  final bool ignoreSizeRestrictions;
  final int maxCount;

  const PickerVideoProperties({
    this.maxAllowedSizeInMB = AppLimits.maxAllowedVideoSizeInMB,
    this.maxRecordDuration,
    this.generateThumbnail = true,
    this.ignoreSizeRestrictions = false,
    this.maxCount = 1
  });
}
