part of media_utils;

class PickedMultiMediaLimitHandler{
  final int maxSizeLimit;
  final int maxCountLimit;
  PickedMultiMediaLimitHandler({required this.maxSizeLimit,required this.maxCountLimit});

  final List<Attachment> attachmentList = [];
  final List<Attachment> exceededSizeLimitAttachments = [];
  final List<Attachment> unSupportedFormatAttachments = [];
  int exceededCountLength = 0;


  bool get hasError => getErrorMessage().isNotEmpty;

  void addAttachment(Attachment attachment){
    attachmentList.add(attachment);
  }

  void addExceededSizeLimitAttachment(Attachment attachment){
    exceededSizeLimitAttachments.add(attachment);
  }

  void addExceededMaxCount(int length){
    exceededCountLength = length;
  }

  void addUnsupportedFormatAttachment(Attachment attachment){
    unSupportedFormatAttachments.add(attachment);
  }

  String getErrorMessage(){
    String errorMsg = "";

    if (unSupportedFormatAttachments.isNotEmpty) {
      errorMsg += getUnsupportedFormatErrorMsg;
    }

    if (exceededSizeLimitAttachments.isNotEmpty) {
      if(errorMsg.isNotEmpty){
        errorMsg += "\n\n";
      }

      errorMsg += getExceededSizeLimitErrorMsg;
    }

    if (exceededCountLength > 0) {
      if(errorMsg.isNotEmpty){
        errorMsg += "\n\n";
      }

      errorMsg += getExceededMaxCountErrorMsg;
    }

    return errorMsg;
  }

  String get getUnsupportedFormatErrorMsg => '${appLocalizer.unSupportedMediaSkipped(unSupportedFormatAttachments.length)} (${MediaUtils.allowedImageExtensions.join(', ').replaceAll('.', '').toUpperCase()}).';
  String get getExceededSizeLimitErrorMsg => appLocalizer.mediaExceededSizeLimitSkipped(exceededSizeLimitAttachments.length, maxSizeLimit.toString());
  String get getExceededMaxCountErrorMsg => appLocalizer.mediaExceededMaxCountLimitSkipped(exceededCountLength, maxCountLimit.toString());

}