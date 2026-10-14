part of app_utils;

//Todo: Change to ur Enum
enum ShareTypeEnum {
  post;

  factory ShareTypeEnum.fromName(String name) {
    switch (name) {
      case "post":
        return ShareTypeEnum.post;

      default:
        return ShareTypeEnum.post;
    }
  }
}
