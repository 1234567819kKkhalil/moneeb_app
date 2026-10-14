part of helpers;

abstract class StatusCodes {
  StatusCodes._();

  static const success = 200;
  static const unknown = 800;
  static const guestCode = 980;
  static const userNotFound = 606;
  static const unauthorizedCode = 401;
  static const accessTokenExpired = 498;
  static const blockedUser = 604;
  static const compressionError = 811;
  static const phoneNotVerified = 605;
  static const failedToLoginWithFacebook = 813;
  static const failedToGetFacebookUser = 814;
  static const userCancelledSocialLogin = 815;
  static const failedToLoginWithApple = 816;
  static const failedToGetAppleUser = 817;
  static const failedToLoginWithGoogle = 818;
  static const failedToGetGoogleUser = 819;
  static const hasNoVerifiedPhoneError = 820;
  static const userCanSocialRegister = 1002;

}
