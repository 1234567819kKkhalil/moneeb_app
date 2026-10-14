part of app_utils;

//Todo: Add svg paths
class SvgPaths {
  SvgPaths._();

  static const String _svgDir = 'assets/icons';
  static const String _omrahDir = 'assets/icons/omrah';
  static const String _authDir = 'assets/icons/auth';

  //Omrah Icons
  static const String sai = '$_omrahDir/sai.svg';
  static const String kaaba = '$_omrahDir/kaaba.svg';
  static const String makam = '$_omrahDir/makam.svg';
  static const String man_with_ehram_clothe =
      '$_omrahDir/man_with_ehram_clothe.svg';
  static const String muslim_man = '$_omrahDir/muslim_man.svg';
  static const String scissors = '$_omrahDir/scissors.svg';

  //Auth icons
  static const String email = '$_authDir/email.svg';
  static const String lock = '$_authDir/lock.svg';
  static const String phone = '$_authDir/phone.svg';
  static const String user_in_circle = '$_authDir/user_in_circle.svg';

  static const String playButton = '$_svgDir/play_button.svg';
}
