import 'dart:io';

enum DeviceEnum { IOS, ANDROID }

DeviceEnum get getDeviceType {
  if (Platform.isIOS) {
    return DeviceEnum.IOS;
  } else {
    return DeviceEnum.ANDROID;
  }
}
