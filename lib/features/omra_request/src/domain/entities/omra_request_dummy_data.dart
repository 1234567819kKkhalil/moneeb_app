part of omra_request;

class OmraSetting {
  String title;
  dynamic data;
  String? icon;
  bool isSelected;

  OmraSetting({
    required this.title,
    this.data,
    this.icon,
    this.isSelected = false,
  });
}

class OmraConst {
  static const String KEY_MARTYR = 'martyr';
  static const String KEY_SICK = 'sick';
  static const String KEY_DECEASED = 'deceased';
  static const String KEY_HELPLESS = 'disabled';

  static const String icons = 'assets/icons/';
  static const String iconPilgrim = 'assets/icons/icon_pilgrim.svg';
  static const String iconUploadImage = 'assets/icons/icon_upload_image.svg';
  static const String iconRemoveImage = 'assets/icons/icon_remove_image.svg';
  static const String iconDate = 'assets/icons/icon_date.svg';
  static const String iconGenderSelected = 'assets/icons/icon_gender_selected.svg';
  static const String iconGenderUnselected = 'assets/icons/icon_gender_unselected.svg';
  
  static const String arrowBlack = 'assets/icons/arrow_black.svg';
  static const String arrowBtnWhite = 'assets/icons/arrow_btn_white.svg';
}
