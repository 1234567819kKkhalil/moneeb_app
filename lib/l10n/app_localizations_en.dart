// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get updateApp => 'Update App';

  @override
  String get updateAppTitle =>
      'A new version is available. Please update now to continue using the app.';

  @override
  String get updateAppDes => 'This version is no longer supported.';

  @override
  String get updateNow => 'update Now';

  @override
  String get version => 'Version';

  @override
  String get versionInfoNotAvailable => 'Version info not available';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'No notifications';

  @override
  String get noNotificationsHint => 'You have no notifications';

  @override
  String get notification => 'Notification';

  @override
  String get noNotificationHint => 'You have no notifications';

  @override
  String get notificationDeleted => 'Notification deleted';

  @override
  String get notificationDeletedError => 'Failed to delete notification';

  @override
  String get notificationDeletedSuccess => 'Notification deleted successfully';

  @override
  String get notificationUpdated => 'Notification updated';

  @override
  String get notificationUpdatedError => 'Failed to update notification';

  @override
  String get notificationUpdatedSuccess => 'Notification updated successfully';

  @override
  String get custom => 'custom';

  @override
  String get original => 'original';

  @override
  String get undo => 'Undo';

  @override
  String get redo => 'Redo';

  @override
  String get flip => 'Flip';

  @override
  String get rotateRight => 'Rotate Right';

  @override
  String get imageEditor => 'Image Editor';

  @override
  String get editImage => 'Edit Image';

  @override
  String get verification => 'Verification';

  @override
  String get viewVerification => 'View Verification';

  @override
  String get savingToGallery => 'Saving your image to gallery';

  @override
  String get editingImagePleaseWait => 'Editing your image, please wait..';

  @override
  String get saveToGallery => 'Save to gallery';

  @override
  String get couldNotSaveImage => 'Could not save the image';

  @override
  String get imageSavedToGallery => 'Image saved to gallery';

  @override
  String get failedToEditImage => 'Failed to edit your image';

  @override
  String get kb => 'KB';

  @override
  String get mb => 'MB';

  @override
  String get gb => 'GB';

  @override
  String get image => 'Photo';

  @override
  String get video => 'Video';

  @override
  String get audio => 'Voice note';

  @override
  String get document => 'Document';

  @override
  String get embedLink => 'Link';

  @override
  String get file => 'File';

  @override
  String get gallery => 'Gallery';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get takeVideo => 'Take Video';

  @override
  String get chooseFromLibrary => 'Choose from library';

  @override
  String get imagesGallery => 'Images Gallery';

  @override
  String get chooseAFile => 'Choose a file';

  @override
  String get jPGPNGExtensions => 'JPG, PNG';

  @override
  String get stopped => 'Stopped';

  @override
  String get paused => 'Paused';

  @override
  String get recording => 'Recording';

  @override
  String get preparingRecorder => 'Preparing..';

  @override
  String get typeAudioTitle => 'Type audio title';

  @override
  String get playbackSpeed => 'Playback Speed';

  @override
  String get errorStartRecording => 'Error, could not start the recording.';

  @override
  String get couldNotStopRecord => 'Could not stop the record';

  @override
  String get couldNotPauseRecord => 'Could not pause the recorder..';

  @override
  String get couldNotResumeRecord => 'Could not resume the record..';

  @override
  String get errorPlayingVideo => 'Error playing the video';

  @override
  String mediaExceededSizeLimitSkipped(num count, Object maxSize) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'they',
      one: 'it',
    );
    return 'Skipped $countString media because $_temp0 exceeded the size limit of $maxSize MB';
  }

  @override
  String mediaExceededMaxCountLimitSkipped(num count, Object maxSize) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'they',
      one: 'it',
    );
    return 'Skipped $countString media because $_temp0 exceeded the max count limit of $maxSize';
  }

  @override
  String get unsupportedFileType => 'Unsupported file type';

  @override
  String unSupportedMediaSkipped(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'they are',
      one: 'it is',
    );
    return 'Skipped $countString media because $_temp0 not in supported formats';
  }

  @override
  String maximumAllowedAudio(int count) {
    return '(maximum $count audio)';
  }

  @override
  String maximumAllowedImages(int count) {
    return '(maximum $count images)';
  }

  @override
  String maximumAllowedVideos(int count) {
    return '(maximum $count video)';
  }

  @override
  String sizeLimitExceeded(int maxSize) {
    return 'Size limit exceeded, max size is: $maxSize MB';
  }

  @override
  String get supportedFileTypeIs => 'Supported formats are';

  @override
  String get permissionNotGranted => 'Permission not granted';

  @override
  String get givePermissionsManually =>
      'You have to give permissions manually from settings';

  @override
  String get removeImage => 'Remove Image';

  @override
  String get videoSavedToGallery => 'Video has been saved to the gallery';

  @override
  String get errorPickingMedia => 'Error while picking your media';

  @override
  String get errorFileSize => 'File Too Large';

  @override
  String get uploadCancelled => 'Upload canceled';

  @override
  String maximumSizeLimitWithSkippedError(num limit, num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count files',
      one: '1 file',
    );
    return 'The maximum size is $limit megabytes, $_temp0 skipped';
  }

  @override
  String get uploadError => 'Unexpected error during file upload';

  @override
  String get uploadFailedError => 'Upload Failed';

  @override
  String get videoLoadingError => 'Failed to load video';

  @override
  String get compressionError => 'File compression failed';

  @override
  String get thumbnailError => 'get video thumbnail failed';

  @override
  String maximumAttachmentLimitError(num limit) {
    return 'maximum limit is ($limit)';
  }

  @override
  String maximumImagesLimitError(num limit) {
    return 'maximum limit is ($limit) images';
  }

  @override
  String maximumVideoLimitError(num limit) {
    return 'maximum limit is ($limit) video';
  }

  @override
  String maximumAudioLimitError(num limit) {
    return 'maximum limit is ($limit) audio';
  }

  @override
  String maximumCountSizeLimitError(num limit, num count) {
    return 'The maximum limit for selecting is $count, and the maximum size is $limit megabytes';
  }

  @override
  String maximumSizeLimitError(num limit) {
    return 'The maximum size is $limit megabytes';
  }

  @override
  String get fileSizeError => 'File is too large';

  @override
  String get fileDoesNotExist => 'File does not exist';

  @override
  String fileExceedError(num limit) {
    return 'File exceed ${limit}MB';
  }

  @override
  String get mediaPickupCanceled =>
      'Media pickup canceled، Please try again later';

  @override
  String get couldNotDownloadFileError => 'Could not download the file';

  @override
  String get fileCorruptionError => 'Something went wrong with this file';

  @override
  String get emptyFileError =>
      'Cant Upload Empty File ,Make Sure You Upload Valid File';

  @override
  String get pickPdfValidationError => 'Please, Choose a valid file';

  @override
  String get couldNotOpenRecord => 'Could not open the record';

  @override
  String get downloadSuccessfully => 'Downloaded successfully';

  @override
  String get failedToLoadTheAudio => 'Failed To Load The Audio ';

  @override
  String get failedToLoadTheVideo => 'Failed To Load The Video ';

  @override
  String get mediaLimit => 'Media Limit Exceeded, added ';

  @override
  String get outOf => 'out of';

  @override
  String get videoLimit => 'Max video upload limit is 1';

  @override
  String get pickingMedia => 'Picking your media..';

  @override
  String get addImages => 'Add images';

  @override
  String get emptyEmailError => 'Email field is required and cannot be empty.';

  @override
  String get emailFormatError => 'Invalid email format. Please try again.';

  @override
  String get emailCapitalCharactersError =>
      'Email should not contain capital characters';

  @override
  String get emailContainArabicError =>
      'Email should not contain arabic characters';

  @override
  String get emailHasSpaceError => 'Email can not have spaces';

  @override
  String get passwordDoesNotMatchError =>
      'The password does not match with new password.';

  @override
  String get emptyPasswordError =>
      'Password field is required and cannot be empty.';

  @override
  String get lengthPasswordError => 'Password length must be at least 8';

  @override
  String get uppercaseLetterPasswordError =>
      'Password must contain at least one uppercase letter';

  @override
  String get lowercaseLetterPasswordError =>
      'Password must contain at least one lowercase letter';

  @override
  String get digitPasswordError => 'Password must contain at least one digit';

  @override
  String get specialCharPasswordError =>
      'Password must contain at least one special character';

  @override
  String get emptyNameError => 'Name field is required and cannot be empty.';

  @override
  String get emptyFirstNameError => 'Please enter first name';

  @override
  String get emptyLastNameError => 'Please enter last name';

  @override
  String get nameIsRequiredError =>
      'Name field is required and cannot be empty.';

  @override
  String get inValidNameError => 'Your name must only contain letters';

  @override
  String get nameLengthError => 'Name should be between 2 and 25 characters';

  @override
  String get enterMobileNumberError => 'Please enter your Mobile number';

  @override
  String get otpNumberExceeded =>
      'You have exceeded the number allowed to send the activation code. Please try again another time after';

  @override
  String get userCancelSocialLoginError => 'Sign Is Canceled';

  @override
  String get failedToLoginWithFacebookError =>
      'Failed to sign in with Facebook';

  @override
  String get failedToLoginWithTwitterError => 'Failed to sign in with X';

  @override
  String get failedToLoginWithAppleError => 'Failed to sign in with Apple';

  @override
  String get failedToLoginWithGoogleError => 'Failed to sign in with Google';

  @override
  String get socialRegisterDataNotCompleteError =>
      'Register Data Not Complete Make Sure Every Thing is Ok';

  @override
  String get couldNotLaunchError => 'Could not launch the link';

  @override
  String get serverError => 'Server error, please try again later';

  @override
  String get unexpectedError => 'UnExpected error, please try again later';

  @override
  String get networkError => 'no internet';

  @override
  String get hasInternetConnection => 'has internet connection';

  @override
  String get noInternetConnection => 'no internet connection';

  @override
  String get permissionNotGrantedError => 'Permission not granted';

  @override
  String get voicePermissionError => 'Could not grant voice permissions';

  @override
  String get cameraPermissionError => 'Could not grant camera permissions';

  @override
  String get mediaPermissionError => 'Could not grant media permissions';

  @override
  String get locationPermissionError => 'Could not grant location permissions';

  @override
  String get notificationPermissionError =>
      'Could not grant notification permissions';

  @override
  String get photoVideoPermissionError =>
      'Could not grant photos and videos permissions';

  @override
  String get videosPermissionError => 'Could not grant videos permissions';

  @override
  String get noItemFoundError => 'no Item Found';

  @override
  String get noResultsFoundError => 'No results found';

  @override
  String get failedToGetUserInfoError => 'Failed to get user info';

  @override
  String get blockedErrorTitleError => 'Access Blocked';

  @override
  String get blockedErrorDescError => 'Sorry, your account has been blocked.';

  @override
  String get unAuthorizedErrorTitleError => 'Unauthorized';

  @override
  String get unAuthorizedErrorDescError =>
      'Sorry, you do not have permission to perform this operation.';

  @override
  String get invalidLinkError => 'invalid link, please make sure link is valid';

  @override
  String get seemTobeOffline => 'You seem to be offline!';

  @override
  String get hangWeReconnecting => 'Hang tight! We\'re trying to reconnect';

  @override
  String noSearchResults(String text) {
    return 'No results found for $text';
  }

  @override
  String get noSearchResultsHint =>
      'Check the spelling and try again or search for something new';

  @override
  String permissionRequired(String value) {
    return 'Allow $value access in device settings';
  }

  @override
  String permissionRequiredDesc(String value) {
    return 'to use this feature, please enable $value access in device settings';
  }

  @override
  String get welcomeSplash => 'Welcome';

  @override
  String get allRightsReserved => 'All rights reserved © All rights reserved';

  @override
  String get quranQuote => '( And complete the Hajj and \'Umrah for Allah )';

  @override
  String get chooseGender => 'Choose gender';

  @override
  String get pleaseChooseGender => 'Please choose gender';

  @override
  String get quranHafiz => 'Are you a Hafiz of the Holy Quran?';

  @override
  String get pleaseChooseQuranMemorization =>
      'Please choose if you are a Hafiz of the Holy Quran';

  @override
  String get certificateNameRequired => 'Certificate name is required';

  @override
  String get uploadCertificateImage => 'Upload Certificate Image';

  @override
  String get bioRequired => 'Biography is required';

  @override
  String get umrahCountRequired => 'Number of Umrahs performed is required';

  @override
  String get enterValidNumber => 'Enter a valid number';

  @override
  String get idNumberRequired => 'ID number is required';

  @override
  String get pleaseUploadImage => 'Please upload the image';

  @override
  String get pleaseUploadIdImage => 'Please upload the ID image';

  @override
  String get providerOath =>
      'I swear by Almighty Allah,\nTo perform Umrah or Hajj with honesty and sincerity,\nAnd to intend the work purely for the sake of Allah Almighty,\nAnd to adhere to all Sharia rulings and ethical standards.\n\nAnd I pledge:\n• To perform the rituals on behalf of the Umrah owner as requested of me without deficiency or neglect.\n• To be honest in the information, documentation, and photos sent within the application.\n• To preserve the confidentiality of the Umrah owners\' data and not misuse it.\n• To respect the sanctity of the place and time, and represent the application in the best way.\n• To fear Allah in every action I take within this application.\n\nI acknowledge that any violation of the above forfeits my right to use the application, and I bear full responsibility before Allah and then before the application management.\n\"And Allah is witness over what I say.\"';

  @override
  String get downloadApp => 'Download app';

  @override
  String get shareAppTitleContent => 'Experience a seamless path to all...';

  @override
  String get biometricAuth => 'Pass key';

  @override
  String useToOpen(String biometric) {
    return 'Unlock with $biometric to open your app.';
  }

  @override
  String get on => 'On';

  @override
  String get off => 'Off';

  @override
  String get enabled => 'enabled';

  @override
  String get disabled => 'disabled';

  @override
  String get immediately => 'Immediately';

  @override
  String get after10Sec => 'After 10 seconds';

  @override
  String get after30Sec => 'After 30 seconds';

  @override
  String get afterMinute => 'After 1 minute';

  @override
  String get appLock => 'App lock';

  @override
  String get enableFaceTouchId =>
      'Enable Face ID or Touch ID to protect access to your app.';

  @override
  String get enableAppLock => 'Enable app lock';

  @override
  String get openSettings => 'Open setting';

  @override
  String get passkey => 'Pass key';

  @override
  String useBiometric(String biometric) {
    return 'Use $biometric';
  }

  @override
  String get faceRecognition => 'Face ID';

  @override
  String get fingerprint => 'Touch ID';

  @override
  String get iris => 'Iris Scan';

  @override
  String get anyBiometric => 'available biometric';

  @override
  String get toUseApp => 'to access your app';

  @override
  String get noBiometricAvailable =>
      'No biometric authentication available. Please use your passcode if available';

  @override
  String get biometricFailure => 'Biometric authentication is not available.';

  @override
  String get addressTitle => 'Address';

  @override
  String get searchAddress => 'Search for address';

  @override
  String get addAddressButtonText => 'Add address';

  @override
  String get addAddress => 'Add an address for easier deliveries';

  @override
  String get addAddressDes =>
      'You can add your home address, work address, or any other address you want your orders delivered to.';

  @override
  String get addressSavedSuccessfully => 'Address Saved successfully';

  @override
  String get addressDetails => 'Address Details';

  @override
  String get location => 'Location';

  @override
  String get additionalAddressInfo => 'Additional Address information';

  @override
  String get apt => 'Apt. no.';

  @override
  String get buildingName => 'Building name';

  @override
  String get addressName => 'Address name';

  @override
  String get floor => 'Floor';

  @override
  String get street => 'Street';

  @override
  String get additionalDirections => 'Additional directions';

  @override
  String get addressLabel => 'Address label';

  @override
  String get additionalInstructions => 'Additional Instructions';

  @override
  String get pickLocation => 'Pick location';

  @override
  String get findCaterersNearby => 'Find caterers nearby';

  @override
  String get findCaterersNearbyDes =>
      'Tell us where the gathering\'s at! We\'ll find delicious catering options near you.';

  @override
  String get shareLocation => 'Share your location';

  @override
  String get enableLocation => 'Enable location for nearby catering fun';

  @override
  String get deliveryAddress => 'Delivery Address';

  @override
  String get confirmPinLocation => 'Confirm pin location';

  @override
  String get confirmLocation => 'Confirm location';

  @override
  String get detecting => 'Detecting...';

  @override
  String get currentLocation => 'Current Location';

  @override
  String get selectLocationHint => 'Set Location';

  @override
  String get updateLocationTitle => 'Update Location';

  @override
  String get updateLocationConfirmation =>
      'Do you want to update your current location?';

  @override
  String get yesUpdate => 'Yes, Update';

  @override
  String get enableLocationServicePrompt =>
      'Please enable location services to detect your location';

  @override
  String get locationPermissionDeniedForeverPrompt =>
      'Location permission denied. Please enable it from the app settings';

  @override
  String get unnamedRoad => 'Unnamed road';

  @override
  String get chooseDeliveryLocation => 'Choose delivery location';

  @override
  String get savedAddress => 'Saved addresses';

  @override
  String get deliverToDifferentLocation => 'Deliver to different location';

  @override
  String get zoomInMore =>
      'Please zoom in more to find your exact delivery location';

  @override
  String get selectYourArea => 'Select your area';

  @override
  String get shareYourLocation => 'Share your location';

  @override
  String get byAllowLocation =>
      'By allowing App to detect your location, We can show you nearby restaurants more accurately';

  @override
  String get goToSetting => 'Go to setting';

  @override
  String get searchCountry => 'Search country';

  @override
  String get searchArea => 'Search area';

  @override
  String get searchCity => 'Search city';

  @override
  String get dates => 'Dates';

  @override
  String get sinceDate => 'Since';

  @override
  String get justNow => 'Just Now';

  @override
  String year(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString years',
      one: '1 year',
      zero: '0 year',
    );
    return '$_temp0';
  }

  @override
  String month(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString months',
      one: '1 month',
      zero: '0 month',
    );
    return '$_temp0';
  }

  @override
  String week(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString weeks',
      one: '1 week',
      zero: '0 week',
    );
    return '$_temp0';
  }

  @override
  String sinceWeek(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString weeks',
      one: '1 week',
      zero: '0 weeks',
    );
    return 'since $_temp0';
  }

  @override
  String day(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString days',
      one: '1 day',
      zero: '0 day',
    );
    return '$_temp0';
  }

  @override
  String sinceDay(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString days',
      one: '1 day',
      zero: '0 days',
    );
    return 'since $_temp0';
  }

  @override
  String hour(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString hours',
      one: '1 hour',
      zero: '0 hour',
    );
    return '$_temp0';
  }

  @override
  String sinceHour(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString hours',
      one: '1 hour',
      zero: '0 hours',
    );
    return 'since $_temp0';
  }

  @override
  String min(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString mins',
      one: '1 min',
      zero: '0 min',
    );
    return '$_temp0';
  }

  @override
  String sinceMin(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString mins',
      one: '1 min',
      zero: '0 min',
    );
    return 'since $_temp0';
  }

  @override
  String minute(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString minutes',
      one: '1 minute',
      zero: '0 minute',
    );
    return '$_temp0';
  }

  @override
  String sinceMinute(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString minutes',
      one: '1 minute',
      zero: '0 minute',
    );
    return 'since $_temp0';
  }

  @override
  String second(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString seconds',
      one: '1 second',
      zero: '0 seconds',
    );
    return '$_temp0';
  }

  @override
  String sinceSecond(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString seconds',
      one: '1 second',
      zero: '0 seconds',
    );
    return 'since $_temp0';
  }

  @override
  String sec(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Secs',
      one: '1 Sec',
      zero: '0 Sec',
    );
    return '$_temp0';
  }

  @override
  String sinceSec(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Secs',
      one: '1 Sec',
      zero: '0 Sec',
    );
    return 'since $_temp0';
  }

  @override
  String get h => 'h';

  @override
  String get m => 'm';

  @override
  String get s => 's';

  @override
  String get eveningPM => 'PM';

  @override
  String get morningAM => 'AM';

  @override
  String get minutes => 'Minutes';

  @override
  String get hours => 'Hours';

  @override
  String get days => 'Days';

  @override
  String get weeks => 'Weeks';

  @override
  String get months => 'Months';

  @override
  String get years => 'Years';

  @override
  String get turnOn => 'Turn on';

  @override
  String get later => 'Later';

  @override
  String get start => 'Start';

  @override
  String get share => 'Share';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get done => 'Done';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get change => 'Change';

  @override
  String get cont => 'Continue';

  @override
  String get add => 'Add';

  @override
  String get accept => 'Accept';

  @override
  String get save => 'Save';

  @override
  String get retry => 'Retry';

  @override
  String get ok => 'Ok';

  @override
  String get send => 'Send';

  @override
  String get back => 'Back';

  @override
  String get sureYouWantToExit => 'Are you sure you want to exit?';

  @override
  String get leave => 'Leave';

  @override
  String get stay => 'Stay';

  @override
  String get sendMedia => 'Send a photo or video';

  @override
  String get sendPdf => 'Upload Documents';

  @override
  String get openCamera => 'Take a photo';

  @override
  String get wait => 'Wait';

  @override
  String get showMore => 'Show more';

  @override
  String get showLess => 'Show less';

  @override
  String get reSend => 'Re-send';

  @override
  String get recall => 'Recall';

  @override
  String get reply => 'Reply';

  @override
  String get copy => 'Copy';

  @override
  String get typing => 'Typing..';

  @override
  String get copyMessage => 'The message has been copied';

  @override
  String get selectYour => 'Select your';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get verifyTextBtn => 'Verify';

  @override
  String get unlinkAccount => 'Unlink';

  @override
  String get linkAccount => 'Link';

  @override
  String get discard => 'Discard';

  @override
  String get proceed => 'Proceed';

  @override
  String get close => 'Close';

  @override
  String get sendCode => 'Send Code';

  @override
  String get previous => 'Previous';

  @override
  String get reset => 'Reset';

  @override
  String get search => 'Search';

  @override
  String get searchWithDots => 'Search...';

  @override
  String get logOut => 'Log Out';

  @override
  String get upload => 'Upload';

  @override
  String get record => 'Record';

  @override
  String get clear => 'Clear';

  @override
  String get remove => 'Remove';

  @override
  String get enable => 'Enable';

  @override
  String get disable => 'Disable';

  @override
  String get clickHere => 'Click here';

  @override
  String get loadMore => 'Load More';

  @override
  String get seeMore => 'See More';

  @override
  String get book => 'Book';

  @override
  String get logIn => 'Log in';

  @override
  String get getStarted => 'Get Started';

  @override
  String get getStartedNow => 'Get Started';

  @override
  String get tryAgain => 'Try again';

  @override
  String get select => 'Select';

  @override
  String get apply => 'Apply';

  @override
  String get refresh => 'Refresh';

  @override
  String get viewMore => 'Read more';

  @override
  String get more => 'More';

  @override
  String get viewLess => 'Read less';

  @override
  String get now => 'Now';

  @override
  String agoMinutes(int count) {
    return '${count}m ago';
  }

  @override
  String agoHours(int count) {
    return '${count}h ago';
  }

  @override
  String agoDays(int count) {
    return '${count}d ago';
  }

  @override
  String get dailyApps => 'Daily Apps';

  @override
  String get liveFromHaram => 'Live from Al-Masjid al-Haram now';

  @override
  String get currentUmrah => 'Current Umrah..';

  @override
  String get videos => 'Videos';

  @override
  String get details => 'Details';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get welcomeTo => 'Welcome in ';

  @override
  String get welcomeGuest => 'Welcome';

  @override
  String welcome(String name) {
    return 'Welcome, $name';
  }

  @override
  String get appName => '----';

  @override
  String get mobileNumber => 'Mobile number';

  @override
  String get tapToSelect => 'Tap to select';

  @override
  String get country => 'Country';

  @override
  String get city => 'City';

  @override
  String get area => 'Area';

  @override
  String get lang => 'العربية';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get noAnswer => 'Doesn\'t matter';

  @override
  String get success => 'Success !';

  @override
  String get guest => 'Guest';

  @override
  String get youAreGuestLogin => 'You are a guest, login to continue.';

  @override
  String get exitDescription => 'Do you want to exit an App';

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get addedSuccessfully => 'Added successfully';

  @override
  String get pastYourLink => 'Past your link here';

  @override
  String get selectYourCountry => 'Select your country';

  @override
  String get appLocked => 'App Locked';

  @override
  String get searchResults => 'Search results';

  @override
  String get or => ' or ';

  @override
  String get pleaseReadContentCarefully =>
      'Please read the content carefully to know more about the app';

  @override
  String get searchHere => 'Search here';

  @override
  String get azkar => 'Azkar';

  @override
  String get dua => 'Dua';

  @override
  String get tasbeeh => 'Electronic Sebha';

  @override
  String get tasbeehDescription =>
      'Enjoy the electronic sebha experience inside the app, and record your praises with ease and accuracy';

  @override
  String get praiseNow => 'Praise Now';

  @override
  String get prayerTimes => 'Prayer Times';

  @override
  String get prayerTimesDescription =>
      'Follow prayer times accurately according to your current location';

  @override
  String get time => 'Time';

  @override
  String get occasions => 'Occasions';

  @override
  String get read => 'Read';

  @override
  String get today => 'Today';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get remaining => 'Remaining';

  @override
  String get selectDhikr => 'Select the Dhikr';

  @override
  String get resetSebha => 'Reset the Sebha';

  @override
  String get tasbeehPlaceholder => 'Subhan Allah wa bihamdihi';

  @override
  String get qiblah => 'Qiblah Direction';

  @override
  String get qiblahDescription =>
      'Find the Qiblah direction accurately based on your current location';

  @override
  String get qiblahNow => 'Find Qiblah';

  @override
  String get enterDhikr => 'Enter Dhikr';

  @override
  String get timings => 'Timings';

  @override
  String daysRemainingUntil(Object date, Object days, Object eventName) {
    return '$days days remaining until $eventName. Occasion date: $date';
  }

  @override
  String daysLeft(String days) {
    return '$days days left';
  }

  @override
  String get loginRequired => 'Login required';

  @override
  String get journeyStartDesc => 'Your blessed journey starts here';

  @override
  String get moneebSaudiDesc => 'Moneeb .. from Makkah Al-Mukarramah';

  @override
  String get story => 'Story';

  @override
  String get theBest => 'The Best';

  @override
  String get trustedPilgrims => 'Trusted Mutamers';

  @override
  String get ritualsDocumentation => 'Rituals with Authentic Documentation';

  @override
  String get umrahTracking => 'Umrah Rituals Tracking';

  @override
  String get trackLocation => 'Track Location';

  @override
  String umrahForBeneficiary(String beneficiary) {
    return 'Umrah for $beneficiary';
  }

  @override
  String get beneficiaryMartyr => 'Martyr';

  @override
  String get beneficiarySick => 'Sick';

  @override
  String get beneficiaryDeceased => 'Deceased';

  @override
  String get beneficiaryHelpless => 'Helpless';

  @override
  String get completedStatus => 'Completed';

  @override
  String get hijriMonth1 => 'Muharram';

  @override
  String get hijriMonth2 => 'Safar';

  @override
  String get hijriMonth3 => 'Rabi Al-Awwal';

  @override
  String get hijriMonth4 => 'Rabi Al-Thani';

  @override
  String get hijriMonth5 => 'Jumada Al-Awwal';

  @override
  String get hijriMonth6 => 'Jumada Al-Thani';

  @override
  String get hijriMonth7 => 'Rajab';

  @override
  String get hijriMonth8 => 'Shaban';

  @override
  String get hijriMonth9 => 'Ramadan';

  @override
  String get hijriMonth10 => 'Shawwal';

  @override
  String get hijriMonth11 => 'Dhul Qadah';

  @override
  String get hijriMonth12 => 'Dhul Hijjah';

  @override
  String get inProgressStatus => 'In Progress';

  @override
  String get fajr => 'Fajr';

  @override
  String get fajrPrayer => 'Fajr Prayer';

  @override
  String get sunrise => 'Sunrise';

  @override
  String get dhuhr => 'Dhuhr';

  @override
  String get dhuhrPrayer => 'Dhuhr Prayer';

  @override
  String get asr => 'Asr';

  @override
  String get asrPrayer => 'Asr Prayer';

  @override
  String get maghrib => 'Maghrib';

  @override
  String get maghribPrayer => 'Maghrib Prayer';

  @override
  String get isha => 'Isha';

  @override
  String get ishaPrayer => 'Isha Prayer';

  @override
  String prayerTimeAlert(String prayerName) {
    return 'It\'s time for $prayerName';
  }

  @override
  String get markAllAsRead => 'Mark all as read';

  @override
  String get quranVerse => '( And complete the Hajj and \'umrah for Allah )';

  @override
  String get ongoingOmrah => 'Ongoing Umrah...';

  @override
  String get reviewDetails => 'Review Details';

  @override
  String get mutamerRating => 'Mutamer Rating';

  @override
  String get rateMutamerDesc =>
      'Please rate the mutamer based on your experience';

  @override
  String get userRoleName => 'User';

  @override
  String get noComment => 'No comment';

  @override
  String get selectGender => 'Select Gender';

  @override
  String get pleaseSelectGender => 'Please select gender';

  @override
  String get notReachedStatus => 'Not Reached';

  @override
  String get ihram => 'Ihram';

  @override
  String get miqat => 'Miqat';

  @override
  String get mekatInstruction1Title => 'Bathing and Perfuming';

  @override
  String get mekatInstruction1Desc =>
      'It is recommended for a Muslim to bathe and apply perfume before Ihram.\n\n• Bathing is a confirmed Sunnah before Ihram\n• A man applies perfume to his body (not to the Ihram clothes)\n• A woman avoids perfume if she will intermingle with men\n\nThe purpose of this is:\n• Cleanliness\n• Preparing to enter the ritual';

  @override
  String get mekatInstruction2Title => 'Wearing Ihram Clothes';

  @override
  String get mekatInstruction2Desc =>
      'How to wear Ihram clothes:\n\nFor men:\n• Wear an Izar and a Rida (two unsewn pieces of cloth)\n• Do not cover the head\n• Wear sandals (preferably open)\n\nFor women:\n• Wear normal modest clothing (without adornment)\n• No specific color is required\n• Do not wear the Niqab or gloves\n\nNotes:\n• Clothes must be clean\n• Use of perfume is prohibited after Ihram';

  @override
  String get mekatInstruction3Title => 'Intention';

  @override
  String get mekatInstruction3Desc =>
      'Intention is the entering into the ritual.\n\n• Its place is the heart (verbalization is not required)\n• It is recommended to say:\n\"Labbayk Allahumma Umrah\"\n\nNotes:\n• Intention should be made upon reaching the Miqat\n• Ihram is not valid without intention';

  @override
  String get mekatInstruction4Title => 'Miqat';

  @override
  String get mekatInstruction4Desc =>
      'The Miqat is the place from which Ihram must be assumed.\n\n• It is not permissible to pass it without Ihram for those intending Umrah\n\nFamous Miqats:\n• Dhu\'l-Hulayfah (People of Madinah)\n• Al-Juhfah (People of Sham)\n• Qarn al-Manazil (People of Najd)\n• Yalamlam (People of Yemen)\n• Dhat Irq (People of Iraq)\n\nNotes:\n• Those within the Miqat boundaries assume Ihram from their place\n• Those in an airplane assume Ihram when parallel to the Miqat';

  @override
  String get mekatInstruction5Title => 'Talbiyah';

  @override
  String get mekatInstruction5Desc =>
      'The pilgrim begins the Talbiyah immediately after assuming Ihram.\n\nText of the Talbiyah:\n\"Labbayk Allahumma Umrah, Labbayka la sharika laka Labbayk, Innal-hamda wan-ni\'mata laka wal-mulk, la sharika lak\"\n\nWhen to say it:\n• Immediately after the intention\n• Repeated during the way to Makkah\n\nNotes:\n• A man raises his voice with it\n• A woman says it in a low voice\n• It continues until the start of Tawaf';

  @override
  String get tawaf => 'Tawaf';

  @override
  String get tawafInstruction1Title => 'Entering Al-Masjid Al-Haram';

  @override
  String get tawafInstruction1Desc =>
      'When entering Al-Masjid Al-Haram:\n\n• Enter with the right foot\n• Say: \"Bismillah, Allahumma salli \'ala Muhammad\"\n• And say: \"Allahumma-ftah li abwaba rahmatik\"\n\nNotes:\n• Enter with tranquility and calmness\n• Do not crowd people\n• Recall the greatness of the place';

  @override
  String get tawafInstruction2Title => 'At the Black Stone';

  @override
  String get tawafInstruction2Desc =>
      'Upon reaching the Black Stone:\n\n• If possible: Touch it with your right hand and kiss it\n• If you cannot: Touch it with your hand and kiss your hand\n• If you cannot: Point to it with your hand and say \"Allahu Akbar\"\n\nNotes:\n• Do not harm others by crowding\n• Pointing is sufficient during crowding';

  @override
  String get tawafInstruction3Title => 'Tawaf around the Kaaba';

  @override
  String get tawafInstruction3Desc =>
      'How to perform Tawaf:\n\n• Keep the Kaaba to your left\n• Start from the Black Stone\n• Perform 7 complete rounds\n\nNotes:\n• Each round starts and ends at the Black Stone\n• It is recommended to hasten slightly (Raml) for men in the first 3 rounds\n• Normal walking in the remaining rounds';

  @override
  String get tawafInstruction4Title =>
      'Remembrance and Supplication during Tawaf';

  @override
  String get tawafInstruction4Desc =>
      'During Tawaf:\n\n• Increase remembrance and supplication\n• Read what is easy of the Quran\n\nIt is recommended between the Yemeni Corner and the Black Stone:\n\"Rabbana atina fid-dunya hasanatan wa fil-akhirati hasanatan wa qina \'adhaban-nar\"\n\nNotes:\n• There is no specific supplication for each round\n• Supplicate for whatever you wish';

  @override
  String get tawafInstruction5Title => 'Praying two Raka\'ahs after Tawaf';

  @override
  String get tawafInstruction5Desc =>
      'After finishing Tawaf:\n\n• Pray two Raka\'ahs behind Maqam Ibrahim if possible\n• If not possible, pray anywhere in the Masjid\n\nIn the two Raka\'ahs:\n• Read Al-Fatihah\n• Preferably read:\n  - Al-Kafirun in the first\n  - Al-Ikhlas in the second\n\nNotes:\n• Do not crowd people at the Maqam';

  @override
  String get makamInstruction1Title => 'Heading to Maqam Ibrahim';

  @override
  String get makamInstruction1Desc =>
      'After finishing Tawaf:\n\n• Head to Maqam Ibrahim if possible\n• Place the Maqam between yourself and the Kaaba\n\nAllah Almighty said:\n\"And take, [O believers], from the standing place of Abraham a place of prayer\"\n\nNotes:\n• It is not necessary to stand directly next to the Maqam\n• You can pray anywhere inside the Mosque';

  @override
  String get makamInstruction2Title => 'Praying two Rak\'ahs';

  @override
  String get makamInstruction2Desc =>
      'Pray two Rak\'ahs after Tawaf:\n\n• The first Rak\'ah:\n  - Al-Fatiha\n  - Surah Al-Kafirun (recommended)\n\n• The second Rak\'ah:\n  - Al-Fatiha\n  - Surah Al-Ikhlas (recommended)\n\nNotes:\n• Prayer is a confirmed Sunnah after Tawaf\n• Do not crowd people for the sake of praying at the Maqam';

  @override
  String get makamInstruction3Title => 'Prayer Place';

  @override
  String get makamInstruction3Desc =>
      'Prayer Place:\n\n• Best: Behind Maqam Ibrahim\n• If not possible due to crowding:\n  - Pray anywhere inside the Grand Mosque\n\nNotes:\n• Avoid extreme crowding\n• Reverence is better than proximity';

  @override
  String get makamInstruction4Title => 'After Prayer';

  @override
  String get makamInstruction4Desc =>
      'After finishing the two Rak\'ahs:\n\n• Drink from Zamzam water if possible\n• Supplicate to Allah as you wish\n• Prepare to go for Sa\'i between Safa and Marwa\n\nNotes:\n• Zamzam water is Sunnah, not obligatory\n• It is recommended to supplicate a lot';

  @override
  String get pleaseCompleteInstructions =>
      'Please complete all instructions to proceed';

  @override
  String get pleaseReadInstructionsCarefully =>
      'Please read the instructions carefully to perform Tawaf correctly';

  @override
  String get pleaseVerifyMapFirst => 'Please complete map verification first';

  @override
  String get prayerBehindMakam => 'Prayer behind the Station of Ibrahim';

  @override
  String get makamIbrahim => 'Maqam Ibrahim';

  @override
  String get sai => 'Sa\'i between Safa and Marwa';

  @override
  String get safaMarwaInstruction1Title => 'Heading to Safa';

  @override
  String get safaMarwaInstruction1Desc =>
      'After finishing Tawaf and praying two Raka\'ahs:\n\n• Head to Safa Hill to start Sa\'i\n• When approaching, read:\n\"Innas-Safa wal-Marwata min sha\'a\'irillah\"\n\nNotes:\n• This verse is said once at the beginning of Sa\'i';

  @override
  String get safaMarwaInstruction2Title => 'Standing on Safa';

  @override
  String get safaMarwaInstruction2Desc =>
      'Upon ascending Safa Hill:\n\n• Face the Kaaba if possible\n• Raise your hands and supplicate to Allah\n\nIt is recommended to say:\n\"Allahu Akbar, Allahu Akbar, Allahu Akbar\nLa ilaha illallahu wahdahu la sharika lah...\"\n\nNotes:\n• Repeat the remembrance and supplication 3 times\n• Supplicate for whatever good you wish of this world and the hereafter';

  @override
  String get safaMarwaInstruction3Title => 'Sa\'i between Safa and Marwa';

  @override
  String get safaMarwaInstruction3Desc =>
      'Start Sa\'i from Safa to Marwa:\n\n• Set your direction toward Marwa\n• At the two green markers:\n  - Men hasten (light jogging)\n  - Women walk normally\n\nNotes:\n• The rest of the distance is normal walking\n• Increase remembrance and supplication';

  @override
  String get safaMarwaInstruction4Title => 'Number of Rounds';

  @override
  String get safaMarwaInstruction4Desc =>
      'Number of Sa\'i rounds:\n\n• 7 complete rounds\n\nThe method:\n• From Safa to Marwa = round 1\n• From Marwa to Safa = round 2\n• And so on until you finish at Marwa\n\nNotes:\n• Start from Safa\n• End at Marwa';

  @override
  String get safaMarwaInstruction5Title => 'Supplication during Sa\'i';

  @override
  String get safaMarwaInstruction5Desc =>
      'During Sa\'i:\n\n• Increase supplication and remembrance\n• Read what is easy of the Quran\n\nNotes:\n• There is no specific supplication for each round\n• Supplicate for whatever you love';

  @override
  String get safaMarwaInstruction6Title => 'After finishing Sa\'i';

  @override
  String get safaMarwaInstruction6Desc =>
      'After completing 7 rounds:\n\n• You have finished Sa\'i\n• Prepare for shaving or cutting hair\n\nNotes:\n• Sa\'i is a pillar of Umrah\n• Umrah is not valid without it';

  @override
  String get saiMinimized => 'Sa\'i';

  @override
  String get tahalol => 'Tahallull';

  @override
  String get shaving => 'Shaving';

  @override
  String get finishedUmrah => 'Umrah Finished';

  @override
  String get umrahTrackingFinishedStep => 'Finished';

  @override
  String get quranQuoteHome =>
      'Who feared the Most Merciful in the unseen and came with a heart returning [in repentance].';

  @override
  String get enterRequiredFields => 'Enter the required fields';

  @override
  String get forWhomOmra => 'For whom is the Umrah?';

  @override
  String get beneficiaryCondition => 'Beneficiary condition';

  @override
  String get beneficiaryGenderLabel => 'Beneficiary gender';

  @override
  String get requesterName => 'Requester';

  @override
  String get pleaseSelectOmraType => 'Please select the Umrah type';

  @override
  String get beneficiaryNameHint => 'Beneficiary Name';

  @override
  String get pleaseEnterBeneficiaryName => 'Please enter the beneficiary name';

  @override
  String get uploadImage => 'Upload Image';

  @override
  String get deleteImage => 'Delete Image';

  @override
  String get pleaseUploadBeneficiaryImage =>
      'Please upload the beneficiary image';

  @override
  String get writeYourNotes => 'Write your notes';

  @override
  String get requestDate => 'Request Date';

  @override
  String get pleaseSelectRequestDate => 'Please select the request date';

  @override
  String get assignUmrahProvider => 'Assign Umrah Provider';

  @override
  String get errorOccurred => 'An error occurred';

  @override
  String get submitOrderErrorDesc =>
      'Make sure to enter all fields correctly and try again';

  @override
  String get orderSubmittedSuccessfully => 'Order submitted successfully';

  @override
  String get continueText => 'Continue';

  @override
  String get confirmText => 'Confirm';

  @override
  String get pilgrims => 'Pilgrims';

  @override
  String get martyr => 'Martyr';

  @override
  String get sick => 'Sick';

  @override
  String get deceased => 'Deceased';

  @override
  String get helpless => 'Helpless';

  @override
  String get omra => 'Umrah';

  @override
  String get sendRequest => 'Send Request';

  @override
  String shareProviderProfile(String name, String username) {
    return 'Meet $name (@$username) - A verified Umrah provider on Moneeb 🕋\n\nMoneeb is a platform specialized in proxy Umrah, allowing users to request Umrah on behalf of the sick, the elderly, the deceased, and martyrs through verified and accredited Umrah providers approved by the app administration.\n\nThe app provides a reliable and transparent experience, enabling the requester to follow all stages of Umrah execution step by step, with documentation for each stage through photos, videos, and live location during execution.\n\nMoneeb... A documented and transparent experience for proxy Umrah with full confidence and peace of mind.';
  }

  @override
  String get repeatTheseAzkarWithHumilityAndSincerityToGod =>
      'Repeat these azkar and preserve them with humility and pure intention for God';

  @override
  String toBeSaidAtLeast(String count) {
    return 'To be said $count times at least';
  }

  @override
  String get underReview => 'Under Review';

  @override
  String get profileChangesUnderReview => 'Your Request is Under Review';

  @override
  String get profileChangesUnderReviewDescription =>
      'Your changes have been submitted successfully and are now under review by the administration.\nYou will be notified once the changes are approved or rejected.';

  @override
  String get umrahRequestAccepted => 'Umrah request accepted';

  @override
  String get umrahRequestRejected => 'Umrah request rejected';

  @override
  String get orderDetails => 'Details';

  @override
  String umrahFor(Object type) {
    return 'Umrah for $type';
  }

  @override
  String get serialNumber => 'Serial Number';

  @override
  String get beneficiaryImage => 'Beneficiary Image';

  @override
  String get notes => 'Notes';

  @override
  String get pilgrimName => 'Pilgrim Name';

  @override
  String get pilgrimImage => 'Pilgrim Image';

  @override
  String get autoAssignPilgrim => 'Automatically assign pilgrim';

  @override
  String get firstPageTitleForUser => '--';

  @override
  String get firstPageDescriptionForUser => '----';

  @override
  String get secondPageTitleForUser => '--';

  @override
  String get secondPageDescriptionForUser => '----';

  @override
  String get thirdPageTitleForUser => '--';

  @override
  String get thirdPageDescriptionForUser => '----';

  @override
  String get firstPageTitle => '--';

  @override
  String get firstPageDescription => '----';

  @override
  String get secondPageTitle => '--';

  @override
  String get secondPageDescription => '----';

  @override
  String get thirdPageTitle => '--';

  @override
  String get thirdPageDescription => '----';

  @override
  String get menu => 'Menu';

  @override
  String get light => 'Light';

  @override
  String get dark => 'Dark';

  @override
  String get useSystemSetting => 'Use System Setting';

  @override
  String get deleting => 'Deleting';

  @override
  String get deleteChat => 'Delete Chat';

  @override
  String get areYouSureYouWantToDeleteThisChat =>
      'Are you sure you want to delete this chat?';

  @override
  String get chatDeletedSuccessfully => 'Chat Deleted Successfully';

  @override
  String get contactToExpert => 'Contact the expert';

  @override
  String get chatListTitle => 'Messages';

  @override
  String get youSent => 'You sent';

  @override
  String get sent => 'sent';

  @override
  String get clearChat => 'Clear chat';

  @override
  String get clearChatTitle => 'Clear chat !';

  @override
  String get muteNotification => 'Mute Notification';

  @override
  String viewProfile(String firstName) {
    return 'View $firstName profile';
  }

  @override
  String clearChatDescription(String chatUserName) {
    return 'Are you sure you want to clear chat with  $chatUserName? if you confirm that, you cant restore messages again';
  }

  @override
  String deleteChatDescription(String chatUserName) {
    return 'Are you sure you want to delete chat with $chatUserName? If you confirm, you can\'t restore the chat.';
  }

  @override
  String get caption => 'Caption';

  @override
  String get clearChatWithMessage => 'Clear chat messages from your side';

  @override
  String get chatCardName => 'chat';

  @override
  String get messageCardName => 'message';

  @override
  String get anOffer => 'an offer';

  @override
  String get you => 'You';

  @override
  String get sendTo => 'Send to';

  @override
  String get sendFailed => 'Send failed';

  @override
  String get deletedMessage => 'Deleted message';

  @override
  String get preparingChatRoom => 'Preparing chat room ...';

  @override
  String get messageCopied => 'Message copied!';

  @override
  String get unMute => 'Un mute';

  @override
  String get message => 'Message';

  @override
  String get clearChatSuccess => 'Chat cleared successfully';

  @override
  String get chatMutedSuccessfully => 'Chat muted successfully';

  @override
  String get chatUnMutedSuccessfully => 'Chat un muted successfully';

  @override
  String get offline => 'offline';

  @override
  String get online => 'online';

  @override
  String get isAvailable => 'Available';

  @override
  String get isNotAvailable => 'Not Available';

  @override
  String get offlineVisibilityWarning =>
      'When you are not available, you will not appear to Umrah requesters.';

  @override
  String get activeNow => 'active now';

  @override
  String get activeSince => 'active since';

  @override
  String get minuteSince => 'minute';

  @override
  String get hourSince => 'hour';

  @override
  String get exitWarning => 'Are you sure you want to exit?';

  @override
  String get exitWarningDescription =>
      'if you leave this record will be deleted';

  @override
  String get couldNotFindTheReply =>
      'Could not find the reply, the message maybe has been deleted';

  @override
  String get youHavenTAnyMessage =>
      'You haven’t any message yet, Start chatting';

  @override
  String get youHavenTAnyMessageYet => 'You haven’t any message yet';

  @override
  String get deleteText => 'Delete';

  @override
  String get deleteMessage => 'Delete Message';

  @override
  String get areYouSureYouWantToDeleteThisMessage =>
      'Are you sure you want to delete this message';

  @override
  String get youBlockedDec =>
      'You have blocked this user, you can not communicate with each other ';

  @override
  String get language_settings => 'Language Settings';

  @override
  String get change_password_settings => 'Change Password';

  @override
  String get orders_settings => 'Orders Settings';

  @override
  String get my_rate_settings => 'My Ratings';

  @override
  String get verify_moneeb_settings => 'Verify Moneeb';

  @override
  String get policy_settings => 'Privacy Policy';

  @override
  String get terms_settings => 'Terms & Conditions';

  @override
  String get about_settings => 'About Moneeb';

  @override
  String get who_moneeb_settings => 'Who is Moneeb?';

  @override
  String get tazkiyah_settings => 'Tazkiyah';

  @override
  String get logout_settings => 'Logout';

  @override
  String get delete_account_settings => 'Delete Account';

  @override
  String get delete_account_dialog_title => 'Delete Account';

  @override
  String get delete_account_dialog_desc =>
      'This action cannot be undone. Your account will be deactivated immediately and your request for final deletion will be submitted to the administration.';

  @override
  String get delete_account_confirm_title => 'Confirm Final Deletion';

  @override
  String get delete_account_confirm_desc =>
      'Are you absolutely sure? You will not be able to access your account after this action.';

  @override
  String get delete_account_success =>
      'Account deletion request submitted successfully';

  @override
  String get account_will_be_deleted =>
      'Your request will be reviewed and the account will be permanently deleted';

  @override
  String get i_understand_delete_my_account =>
      'I understand and agree to permanently and completely delete my account';

  @override
  String get trusted_platform_badge =>
      'Moneeb .. a trusted Saudi platform with a commercial registration';

  @override
  String get follow_us => 'Follow us on our page!';

  @override
  String get social_media_description =>
      'We are happy to have you with us! Follow us for more updates.';

  @override
  String get app_version => 'App Version';

  @override
  String get select_language => 'Select Language';

  @override
  String get select_your_language => 'Select your language';

  @override
  String get homeNav => 'Home';

  @override
  String get ordersNav => 'Orders';

  @override
  String get requestOmraNav => 'Request';

  @override
  String get zadNav => 'Zad';

  @override
  String get settingsNav => 'Settings';

  @override
  String get stories => 'Stories';

  @override
  String get no_stories_available => 'No stories available at the moment';

  @override
  String get banners => 'Banners';

  @override
  String get no_banners_available => 'No banners available';

  @override
  String get forgot_password => 'Forgot Password';

  @override
  String get email => 'Email';

  @override
  String get registered_email => 'Registered Email';

  @override
  String get forgot_password_description =>
      'Enter your email to receive a verification code and reset your password.';

  @override
  String get please_enter_email => 'Please enter your email';

  @override
  String get continue_label => 'Continue';

  @override
  String get verified_successfully => 'Verified successfully';

  @override
  String get code_resent_successfully => 'Code resent successfully';

  @override
  String get enter_verification_code => 'Enter verification code';

  @override
  String get verify => 'Verify';

  @override
  String get didnt_receive_code => 'Didn\'t receive a code? ';

  @override
  String get resend => 'Resend';

  @override
  String get password_updated_successfully => 'Password updated successfully';

  @override
  String get reset_password => 'Reset Password';

  @override
  String get set_new_password => 'Set New Password';

  @override
  String get reset_password_instruction =>
      'Please enter a strong new password.';

  @override
  String get new_password => 'New Password';

  @override
  String get password_too_short => 'Password too short (min 8 characters)';

  @override
  String get confirm_password => 'Confirm Password';

  @override
  String get passwords_do_not_match => 'Passwords do not match';

  @override
  String get update_password => 'Update Password';

  @override
  String get profile => 'Profile';

  @override
  String get yourRating => 'Your Rating';

  @override
  String get hisRating => 'His Rating';

  @override
  String get myRating => 'My Rating';

  @override
  String get myUmrahsExecuted => 'My Executed Umrahs';

  @override
  String get hisUmrahsExecuted => 'His Executed Umrahs';

  @override
  String get providerImage => 'Provider Image';

  @override
  String get yourProviderImage => 'Your Provider Image';

  @override
  String get providerVideo => 'Provider Video';

  @override
  String get yourProviderVideo => 'Your Provider Video';

  @override
  String get reviews => 'Reviews';

  @override
  String get noReviewsYet => 'No reviews yet';

  @override
  String get loadingReview => 'Loading review...';

  @override
  String get accountInfo => 'Account Info';

  @override
  String get name => 'Name';

  @override
  String get enterName => 'Enter Name';

  @override
  String get enterEmail => 'Enter Email';

  @override
  String get phone => 'Phone Number';

  @override
  String get enterPhone => 'Enter Phone Number';

  @override
  String get selectCountry => 'Select Country';

  @override
  String get gender => 'Gender';

  @override
  String get providerInfo => 'Provider Info';

  @override
  String get idNumber => 'ID / National ID';

  @override
  String get enterIdNumber => 'Enter ID or National ID';

  @override
  String get previousUmrahCount => 'Previous Umrah Count';

  @override
  String get enterPreviousUmrahCount => 'Enter how many Umrahs you performed';

  @override
  String get bio => 'Bio';

  @override
  String get bioHint => 'Write a short bio that appears to pilgrims';

  @override
  String get isQuranHafiz => 'Quran Hafiz';

  @override
  String get updatedSuccessfully => 'Updated successfully';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get omrahStepMeqat => 'Meqat';

  @override
  String get omrahStepTawaf => 'Tawaf';

  @override
  String get omrahStepPrayingBehindMakam => 'Praying behind Makam Ibrahim';

  @override
  String get omrahStepMakamIbrahim => 'Makam Ibrahim';

  @override
  String get omrahStepSafaAndMarwa => 'Safa and Marwa';

  @override
  String get omrahStepSafaAndMarwaShort => 'Safa and Marwa';

  @override
  String get omrahStepTahalol => 'Tahalol';

  @override
  String get omrahStepFinishOmrah => 'Finish Umrah';

  @override
  String get finish => 'Finish';

  @override
  String get phaseMekat => 'Miqat Documentation';

  @override
  String get phaseTawaf => 'Tawaf Documentation';

  @override
  String get tawafInstructions => 'Tawaf Instructions';

  @override
  String get documentationTitle => 'Documentation';

  @override
  String get tawafVerifyInsideHaram => 'Verify you are inside the Haram';

  @override
  String get tawafVerifyDuaa => 'Verify video of Duaa for the Umrah owner';

  @override
  String get phaseMakam => 'Maqam Ibrahim Documentation';

  @override
  String get makamInstructions => 'Makam Ibrahim Instructions';

  @override
  String get makamInstructionDesc =>
      'Please read the instructions carefully to properly perform the Makam Ibrahim prayer';

  @override
  String get makamVerifyFirst => 'verifying the Makam Ibrahim prayer';

  @override
  String get makamVerifyImage =>
      'Picture of the place from behind or the glass dome of the Makam.';

  @override
  String get phaseSafaAndMarwa => 'Safa and Marwa Documentation';

  @override
  String get safaMarwaInstructions => 'Safa and Marwa';

  @override
  String get safaMarwaInstructionDesc =>
      'Please read instructions carefully to properly perform Safa and Marwa';

  @override
  String get safaMarwaVerifyFirst =>
      'Verify video while standing on Mount Safa';

  @override
  String get safaMarwaVerifyMap => 'Map tracking for seven rounds';

  @override
  String get safaMarwaVerifyInsideMasaa =>
      'Verify you are inside the Mas\'a between Safa and Marwa';

  @override
  String get mekatInstructions => 'Ihram Instructions';

  @override
  String get mekatInstructionDesc =>
      'Please read instructions carefully to properly perform Ihram';

  @override
  String get mekatVerifyFirst =>
      'First documentation via Google Maps to determine Meqat';

  @override
  String get mekatVerifySecond => 'Second documentation via Video';

  @override
  String get phaseTahalol => 'Tahallul Documentation';

  @override
  String get tahalolVideo => 'Video';

  @override
  String get tahalolVerifyVideo => 'Please select a video or image for Tahalol';

  @override
  String get tahalolVerifyTitle => 'Tahalol Documentation';

  @override
  String get tahalolVerifyImageDesc => 'Picture for Tahalol';

  @override
  String get tahalolVerifyVideoDesc => 'Video for Tahalol';

  @override
  String get omrahJourneyFinishPrefix => 'End of journey ';

  @override
  String get omrahRituals => 'Umrah Rituals';

  @override
  String get providerStillDoingStep =>
      'The provider is still performing this step';

  @override
  String get trackProviderOnMap => 'Track their location on the map';

  @override
  String get videoSavedSuccessfully => 'Video saved to gallery successfully';

  @override
  String get videoSaveFailed => 'Failed to save video';

  @override
  String get omrahVideoTitle => 'Umrah Video';

  @override
  String get videoShareFailed => 'Failed to share video';

  @override
  String get waitProviderLocation =>
      'Please wait a moment until the Mutamer sends their location';

  @override
  String get loadingRoute => 'Loading the route...';

  @override
  String get noRouteRecorded => 'No route was recorded for this Umrah';

  @override
  String get grantPermission => 'Grant Permission';

  @override
  String get readGuideConfirm =>
      'Please read the guide content and commit, click \"Confirm\"';

  @override
  String get verifyVideoInsideMosque =>
      'Verify video when entering the Grand Mosque';

  @override
  String get prayDuaaTakbeer =>
      'Do not forget the Takbeer and the supplication for the person you intended this Umrah for';

  @override
  String get imageTranslate => 'Image';

  @override
  String get verifyImageTitle => 'Verify Image';

  @override
  String get pickFromGallery => 'Pick from gallery';

  @override
  String omrahVerifyStep(String stepName) {
    return 'Verify $stepName';
  }

  @override
  String get notReachedYet => 'Not reached';

  @override
  String get executedSuccessfully => 'Executed';

  @override
  String get inProgress => 'In progress';

  @override
  String get videoProofUploadedSuccessfully =>
      'Video proof uploaded successfully';

  @override
  String get ritualsList => 'Rituals';

  @override
  String get finishOmrah => 'Finish Umrah';

  @override
  String get didYouFinishOmrah => 'Did you finish the Umrah?';

  @override
  String get yesIFinishedOmrah => 'Yes, I performed the Umrah';

  @override
  String get noNotYet => 'No, not yet';

  @override
  String get ordersHeader => 'Orders';

  @override
  String get noOrdersMessage => 'There are no orders';

  @override
  String get orderStatusWaiting => 'Waiting';

  @override
  String get orderStatusAcceptReject => 'Accept / Reject';

  @override
  String get orderStatusApproved => 'Approved';

  @override
  String get orderStatusRejected => 'Rejected';

  @override
  String get orderStatusExecuting => 'Executing';

  @override
  String get orderStatusCompleted => 'Completed';

  @override
  String get orderStatusCanceled => 'Canceled';

  @override
  String get orderStatusUnderReview => 'Under Review';

  @override
  String get orderStatusAssigned => 'Assigned';

  @override
  String get orderStatusAccepted => 'Accepted';

  @override
  String get orderStatusRefused => 'Refused';

  @override
  String get orderStatusCompletedFemale => 'Completed';

  @override
  String get orderStatusCanceledFemale => 'Canceled';

  @override
  String get cancelOrderBtn => 'Cancel Order';

  @override
  String get rejectBtn => 'Reject';

  @override
  String omrahForBeneficiary(String name) {
    return 'Umrah for $name';
  }

  @override
  String get orderNumber => 'Order Number';

  @override
  String get continueOmrah => 'Continue Umrah';

  @override
  String get viewOmrah => 'View Umrah';

  @override
  String get orderCanceledSuccess => 'Order cancelled successfully';

  @override
  String get mapTitle => 'The Map';

  @override
  String get findNearestMeqat => 'Find the Nearest Meqat';

  @override
  String get verifyYourLocation => 'Verify your location';

  @override
  String get yesAuth => 'Yes';

  @override
  String get noAuth => 'No';

  @override
  String get someParts => 'Some Parts';

  @override
  String get emailHint => 'Email Address';

  @override
  String get createAccount => 'Create Account';

  @override
  String get mutamerName => 'Mutamer Name';

  @override
  String get mobileNumberHint => 'Mobile Number';

  @override
  String get countryHint => 'Country';

  @override
  String get searchHint => 'Search';

  @override
  String get passwordHint => 'Password';

  @override
  String get confirmPasswordHint => 'Confirm Password';

  @override
  String get pleaseConfirmPassword => 'Please confirm password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get registerBtn => 'Register';

  @override
  String get welcomeAuth => 'Welcome';

  @override
  String get loginToViewOrdersDesc =>
      'Log in to view Umrah orders and perform Umrah for them with confidence and safety.';

  @override
  String get orAuth => 'Or';

  @override
  String get haveAccount => 'Have an account?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get loginBtn => 'Login';

  @override
  String get pleaseSelectType => 'Please select a type';

  @override
  String get nameHint => 'Name';

  @override
  String get chooseType => 'Choose type';

  @override
  String get nextAuth => 'Next';

  @override
  String get loginToViewMutamersDesc =>
      'Log in to view Mutamers and request an Umrah';

  @override
  String get createAccountAlt => 'Create Account';

  @override
  String get welcomeToMoneeb => 'Welcome to Moneeb';

  @override
  String get omrahForYouOrLovedOne =>
      'Umrah for you or someone you love... to the House of God';

  @override
  String get docTrackComply => 'Documentation • Tracking • Compliance';

  @override
  String get continueBtn => 'Continue';

  @override
  String get continueAsGuest => 'Continue as Guest';

  @override
  String get chooseAccountType => 'Choose your account type';

  @override
  String get selectServiceToContinue =>
      'Select the desired service to continue the registration process';

  @override
  String get requestOmrahTitle => 'Request Umrah';

  @override
  String get providerServiceTitle => 'Provider Service';

  @override
  String get startBtnAuth => 'Start';

  @override
  String get completeProfileTitle => 'Complete Profile';

  @override
  String get logoutString => 'Logout';

  @override
  String get doYouWantToLogout => 'Do you want to logout?';

  @override
  String get cancelString => 'Cancel';

  @override
  String get createMutamerProfile => 'Create Mutamer Profile';

  @override
  String get enterDataToCompleteProfile =>
      'Enter the following data to complete setting up your account';

  @override
  String get uploadImageTitle => 'Upload Image';

  @override
  String get yourBioHint => 'Your Biography';

  @override
  String get timesPerformedOmrah => 'Number of times you performed Umrah';

  @override
  String get uploadIdImage => 'Upload ID Image';

  @override
  String get idNumberHint => 'ID Number';

  @override
  String get continueAuth => 'Continue';

  @override
  String get oneStepLeft => 'One step left';

  @override
  String get uploadTrustedCertificates => 'Upload some reliable certificates';

  @override
  String get certificateName => 'Certificate Name';

  @override
  String get backBtn => 'Back';

  @override
  String get finishBtnAuth => 'Finish';

  @override
  String get kasamTitle => 'The Oath';

  @override
  String get agreeAndPledge => 'I agree and pledge to the above';

  @override
  String get iSwearThat => 'I swear to that';

  @override
  String get thankYouFor => 'Thank you for ';

  @override
  String get creatingYourAccount => 'creating your account';

  @override
  String get orderReceivedSuccessfully =>
      'Your request has been received successfully,\nand it will be reviewed by the app administration shortly.';

  @override
  String get returnToHome => 'Return to Home';

  @override
  String get loginTitleBtn => 'Login';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get tazkiyahSuccess => 'Tazkiyah (Recommendation) added successfully';

  @override
  String get tazkiyahAlreadySubmitted =>
      'You have already submitted a recommendation for this person';

  @override
  String get noTazkiyahsYet => 'You haven\'t made any recommendations yet';

  @override
  String get previousTazkiyahs => 'Previous Recommendations';

  @override
  String get tazkiyahTitle => 'Recommendation';

  @override
  String get tazkiyahDesc =>
      'We recommend this person and testify to their honesty, good manners, and commitment, and they are trustworthy if God wills.';

  @override
  String get changeTazkiyah => 'Change';

  @override
  String get tazkiyahReasons => 'Reasons for recommendation';

  @override
  String get pleaseEnterTazkiyahReason =>
      'Please enter the reason for recommendation';

  @override
  String get oathText =>
      'I testify, based on my personal knowledge of the applicant, that I know him to be honest and of good conduct, and that I consider him fit to bear the responsibility of performing Umrah on behalf of others and to comply with the documentation requirements approved by the Moneeb platform. I acknowledge that this statement is based on genuine knowledge and is not made in exchange for any financial benefit or personal interest.\n\nStrengthen your application with a Tazkiyah\nApproved Moneeb performers who know you personally can vouch for your eligibility and trustworthiness.\nTazkiyahs help the Moneeb team assess your application, but they do not mean automatic acceptance; every application is reviewed and verified according to the platform\'s criteria.';

  @override
  String get reviewSentSuccessfully => 'Review sent successfully';

  @override
  String get evaluateOmrah => 'Rate Umrah';

  @override
  String get addYourCommentHere => 'Add your comment here...';

  @override
  String get confirmEvaluation => 'Confirm Evaluation';

  @override
  String get omrahCompletedSuccessfully => 'Umrah completed successfully';

  @override
  String get omrahWord => 'Umrah';

  @override
  String get afterSpiritualJourneyDesc =>
      'After this deep spiritual journey, we hope your heart is clearer, and may you find blessing and mercy in every step you took in Makkah. May Allah accept from you and reward you well';

  @override
  String get locationNotValidForMiqat => 'Location not valid for miqat';

  @override
  String get locationNotValidForTawaf => 'Location not valid for tawaf';

  @override
  String get locationNotValidForSai => 'Location not valid for Sa\'i';

  @override
  String get locationProofed => 'Location proofed';

  @override
  String get grantLocationPermissionPlease =>
      'Please grant location permission';

  @override
  String get grantLocationDesc =>
      'Please grant location permission so the requester can track the Umrah';

  @override
  String get noVideoFound => 'No video found';

  @override
  String get videoSavedToGallerySuccess =>
      'The video has been saved to the gallery successfully';

  @override
  String get failedToSaveVideo => 'Failed to save the video';

  @override
  String get omrahVideoUrlShare => 'Umrah Video';

  @override
  String get failedToShareVideo => 'Failed to share video';

  @override
  String get imageSavedToGallerySuccess =>
      'The image has been saved to the gallery successfully';

  @override
  String get failedToSaveImage => 'Failed to save the image';

  @override
  String get omrahImageUrlShare => 'Umrah Image';

  @override
  String get failedToShareImage => 'Failed to share image';

  @override
  String get proofAlreadySubmitted => 'You already submitted your proof';

  @override
  String get omrahConclusion => 'Conclusion';

  @override
  String get endOfJourney => 'End of the ';

  @override
  String get omrahCompletionConfirmed =>
      'The pilgrim confirmed completing the Umrah';

  @override
  String get omrahCompletionConfirmedFor =>
      'The pilgrim confirmed completing the Umrah on behalf of';

  @override
  String get omrahAcceptedSupplication =>
      'May Allah accept from us and from you all righteous deeds';

  @override
  String get evaluate => 'Rate';

  @override
  String get omrahRequestReassignHintForUser =>
      'If the provider did not accept your Umrah request within 12 hours, it will be automatically reassigned to another provider.';

  @override
  String get omrahRequestReassignHintForProvider =>
      'Please accept the requests within 12 hours, otherwise it will be reassigned to another provider.';

  @override
  String get meeqatVideoDocumentation => 'Miqat Video Documentation';

  @override
  String get tawafVideoDocumentation =>
      'Documentation of the start of the Tawaf';

  @override
  String get saiVideoDocumentation => 'Video documentation of the Sai stage';

  @override
  String get ibrahimMakamPrayerVideo => 'Ibrahim Makam Prayer Video';

  @override
  String get tahalulVideoDocumentation => 'Tahalul Video Documentation';

  @override
  String get stepDocumentedSuccessfully => 'Step Documented Successfully';

  @override
  String nextStepIs(String nextStep) {
    return 'The next step is $nextStep';
  }

  @override
  String get nextStep => 'Next Step';

  @override
  String get tapToCaptureImage => 'Tap to capture image';

  @override
  String get cantUploadEmptyFile =>
      'Can\'t upload empty file, make sure you upload a valid file';

  @override
  String get imageCompressFailed => 'Image compress failed';

  @override
  String get invalidPhoneNumber => 'Invalid Phone number';

  @override
  String get sharedPost => 'Shared post';

  @override
  String get couldNotDownloadFile => 'Could not download the file';

  @override
  String get couldNotFetchLocation => 'Could not fetch the location';

  @override
  String get imageProofUploadedSuccessfully =>
      'Image proof uploaded successfully';

  @override
  String get emailOrPhoneHint => 'Email or Phone Number';

  @override
  String get emptyEmailOrPhoneError =>
      'Please enter your email or phone number.';

  @override
  String get invalidSaudiPhoneError =>
      'Invalid phone number. Must start with 05 or 5 and be 9 or 10 digits.';

  @override
  String get invalidSaudiPhonePrefixError =>
      'Phone number must start with 05 or 5';

  @override
  String get saudiPhoneNineDigitsError => 'Phone number must be 9 digits';

  @override
  String get saudiPhoneTenDigitsError => 'Phone number must be 10 digits';

  @override
  String get emailOrPhoneFieldError =>
      'Please enter a valid email or phone number.';

  @override
  String get homeLive => 'Live Streams';

  @override
  String get emailTabLabel => 'Email';

  @override
  String get phoneTabLabel => 'Phone';

  @override
  String get loginWithOtpDesc =>
      'Enter your email or phone number to receive a verification code.';

  @override
  String get registerAsServiceProvider => 'Register as a Service Provider';

  @override
  String get chooseVerificationMethod => 'Choose a verification method';

  @override
  String get chooseVerificationMethodDesc =>
      'Select how you\'d like to receive your code.';

  @override
  String get otpChannelWhatsapp => 'WhatsApp';

  @override
  String get otpChannelSms => 'SMS';

  @override
  String get otpChannelCall => 'Phone call';

  @override
  String get otpChannelEmail => 'Email';

  @override
  String get verificationTitle => 'Verification';

  @override
  String get codeSentTo => 'We sent a verification code to';

  @override
  String get changeVerificationMethod => 'Change verification method';

  @override
  String get providerIdentityDesc =>
      'Verify your email or phone to register as a service provider.';

  @override
  String get passwordOptionalHint => 'Password';

  @override
  String get providerNotFound => 'No provider found with these details';

  @override
  String get searchByEmailOrPhone =>
      'Search for the provider by email or phone number';

  @override
  String get omrahCertificate => 'Umrah certificate';

  @override
  String get myCertificates => 'My certificates';

  @override
  String get generateCertificate => 'Generate certificate';

  @override
  String get viewCertificate => 'View certificate';

  @override
  String get generatingCertificate => 'Preparing the certificate…';

  @override
  String get certificateGeneratedSuccessfully =>
      'Certificate generated successfully';

  @override
  String get certificateHintForProvider =>
      'Generate a certificate proving the Umrah was performed, then download it or share it with the requester.';

  @override
  String get certificateHintForUser =>
      'Generate a certificate proving the Umrah was performed, then download it or share it with whoever you like.';

  @override
  String get loadingCertificate => 'Loading the certificate…';

  @override
  String get certificatePreviewUnavailable =>
      'Could not display the certificate. You can still share it as a PDF file.';

  @override
  String get certificateSavedToGallery => 'Certificate saved to your gallery';

  @override
  String get failedToSaveCertificate => 'Could not save the certificate';

  @override
  String get failedToShareCertificate => 'Could not share the certificate';

  @override
  String certificateShareMessage(String name) {
    return 'Umrah certificate performed on behalf of $name';
  }

  @override
  String certificatePageIndicator(int current, int total) {
    return 'Page $current of $total';
  }

  @override
  String get charterPageTitle => 'Integrity Charter and Oath';

  @override
  String get charterHeaderTitle => 'Integrity Charter and Oath';

  @override
  String get charterHeaderSubtitle =>
      'Read the charter in full — agreement is enabled only once you reach the end.';

  @override
  String get charterNoticeTitle => 'Before you continue';

  @override
  String get charterNoticeBody =>
      'This charter contains an oath sworn by Allah Almighty and a binding undertaking. You must read it in full, and you may not agree to it before understanding everything it contains and being able to abide by it.';

  @override
  String charterSectionLabel(int index, int total) {
    return 'Clause $index of $total';
  }

  @override
  String get charterS1Title => 'First: Accuracy of data and eligibility';

  @override
  String get charterS1Intro => 'I acknowledge the following:';

  @override
  String get charterS1I1 =>
      'All data and documents I have submitted are accurate, complete and belong to me personally.';

  @override
  String get charterS1I2 =>
      'I have not used another person\'s data, and I have not allowed anyone else to register or use the account on my behalf.';

  @override
  String get charterS1I3 => 'I have previously performed Umrah for myself.';

  @override
  String get charterS1I4 =>
      'I am medically and physically able to perform the full rites of Umrah.';

  @override
  String get charterS1I5 =>
      'I will update my data as soon as any change occurs that affects my eligibility to perform Umrah.';

  @override
  String get charterS1I6 =>
      'I will disclose to Moneeb any medical, legal or religious impediment that may affect my ability to fulfil requests.';

  @override
  String get charterS2Title => 'Second: Integrity of endorsements';

  @override
  String get charterS2Intro => 'I acknowledge and undertake the following:';

  @override
  String get charterS2I1 =>
      'I will only request an endorsement from someone who knows me personally and genuinely.';

  @override
  String get charterS2I2 =>
      'I will not request or arrange any fictitious or inaccurate endorsement.';

  @override
  String get charterS2I3 =>
      'I will not use the data of any approved performer to obtain an endorsement without their knowledge and consent.';

  @override
  String get charterS2I4 =>
      'I am responsible for the accuracy of what I submit; endorsements neither exempt me from liability nor guarantee that my application is accepted.';

  @override
  String get charterS2I5 =>
      'Moneeb has the right to verify endorsements and to exclude any endorsement that does not meet the platform\'s criteria.';

  @override
  String get charterS3Title => 'Third: Performing the Umrah';

  @override
  String get charterS3Intro =>
      'If I am accepted as a performer with Moneeb, I undertake the following:';

  @override
  String get charterS3I1 =>
      'I will not accept any request unless I am able to fulfil it completely within the specified time.';

  @override
  String get charterS3I2 =>
      'I will perform the Umrah myself on behalf of the person named in the request, and will not delegate it to anyone else.';

  @override
  String get charterS3I3 =>
      'I will make the intention for the person named in the request, and will not change that person or combine more than one request in a single Umrah.';

  @override
  String get charterS3I4 =>
      'I will enter Ihram from the applicable Miqat, then perform Tawaf, Sa\'i and shaving or trimming until the Umrah is complete and I have exited Ihram.';

  @override
  String get charterS3I5 =>
      'I will abide by the religious rulings relating to proxy Umrah and by the operational instructions approved by Moneeb.';

  @override
  String get charterS3I6 =>
      'I will not confirm any stage before actually performing it.';

  @override
  String get charterS3I7 =>
      'I will stop and notify Moneeb immediately if anything prevents me from completing the Umrah, and will not declare it complete when it is not.';

  @override
  String get charterS4Title => 'Fourth: Documentation and verification';

  @override
  String get charterS4Intro =>
      'I undertake that the documentation of the Umrah will be genuine and contemporaneous with its performance, as follows:';

  @override
  String get charterS4I1 =>
      'I will document the required stages exclusively from within the Moneeb app, from their actual locations and at their real times.';

  @override
  String get charterS4I2 =>
      'I will document Ihram, Tawaf, Sa\'i and exiting Ihram according to the instructions shown in the app.';

  @override
  String get charterS4I3 =>
      'I will state the details of the person on whose behalf the Umrah is performed wherever the platform requires it, to prove the Umrah is dedicated to them.';

  @override
  String get charterS4I4 =>
      'I will not use previous recordings, photos or clips belonging to another Umrah or another person.';

  @override
  String get charterS4I5 =>
      'I will not alter or falsify documentation, nor re-enact any stage after it has ended and present it as live documentation.';

  @override
  String get charterS4I6 =>
      'I will not allow anyone else to carry my device or use my account to complete documentation on my behalf.';

  @override
  String get charterS4I7 =>
      'I will not use any means to circumvent the location, time, camera or verification systems within the app.';

  @override
  String get charterS4I8 =>
      'I consent to the app\'s use of location, time and camera to verify the Umrah stages while a request is being fulfilled.';

  @override
  String get charterS5Title => 'Fifth: Privacy and conduct';

  @override
  String get charterS5Intro => 'I undertake the following:';

  @override
  String get charterS5I1 =>
      'To keep the data of the requester and of the person on whose behalf the Umrah is performed confidential, and not to use or share it outside the purpose of fulfilling the request.';

  @override
  String get charterS5I2 =>
      'To respect the sanctity of the Grand Mosque and the privacy of pilgrims, and to ensure documentation never harms or obstructs others.';

  @override
  String get charterS5I3 =>
      'To comply with the regulations and instructions issued by the competent authorities within the Kingdom of Saudi Arabia.';

  @override
  String get charterS5I4 =>
      'To communicate honestly and respectfully with Moneeb, and to answer truthfully any enquiry relating to fulfilment or documentation.';

  @override
  String get charterS6Title => 'Sixth: Liability and procedures';

  @override
  String get charterS6Intro => 'I acknowledge that:';

  @override
  String get charterS6I1 =>
      'Submitting a registration request or obtaining endorsements does not mean I am automatically accepted as an Umrah performer.';

  @override
  String get charterS6I2 =>
      'Moneeb has the right to verify my data, documents, endorsements and record of fulfilled requests.';

  @override
  String get charterS6I3 =>
      'Any inaccurate data, falsified documentation, circumvention, or fulfilment by another person constitutes a material breach.';

  @override
  String get charterS6I4 =>
      'Where a breach is established, Moneeb may reject the application, suspend or cancel the account, and take the measures set out in the Terms of Use and the agreement.';

  @override
  String get charterS6I5 =>
      'I am not entitled to payment for any Umrah I did not fully perform, or whose performance or documentation is shown to be inaccurate.';

  @override
  String get charterS6I6 =>
      'I bear legal responsibility for any forgery, fraud or misuse, and Moneeb may refer the breach to the competent authority whenever required.';

  @override
  String get charterOathTitle => 'The Oath';

  @override
  String get charterOathBody =>
      'I swear by Allah Almighty that all the data, documents and declarations I have submitted are accurate; that I have previously performed Umrah for myself; and that if I am accepted as a performer on the Moneeb platform, I will perform every Umrah I accept myself, on behalf of the person named in the request, completing all its rites until exiting Ihram, and documenting its stages genuinely from their actual locations and at their correct times, without lying, forgery, circumvention, substitution or delegation to another person, and that I will abide by everything set out in this charter. Allah is my witness to what I say.';

  @override
  String get charterEndOfDocument => 'End of the charter';

  @override
  String get charterScrollHint => 'Scroll down to read the remaining clauses';

  @override
  String charterReadPercent(int percent) {
    return '$percent%';
  }

  @override
  String get charterAgreeCheckbox =>
      'I confirm that I have read all clauses of this charter, understood them, and agree to them';

  @override
  String get charterSwearButton => 'I swear by Allah to that';

  @override
  String get charterGoToEnd => 'Go to the end of the charter';

  @override
  String get proofGeoFenceVerified =>
      'The pilgrim\'s presence inside the geographic zone has been verified';

  @override
  String get omrahAlreadyRated => 'This Umrah has already been rated';

  @override
  String get omrahRatingOnceOnly => 'Rating is available only once per Umrah';

  @override
  String get proofCapturedInsideAppOnly =>
      'This documentation was filmed by the pilgrim exclusively and directly from within the app';

  @override
  String get voiceDocumentationTitle => 'Voice documentation phrase';

  @override
  String get voiceDocumentationHintMiqat =>
      'While recording the video you can state the following documentation';

  @override
  String get voiceDocumentationHintTawaf =>
      'State the following phrase while you record the video';

  @override
  String get voiceDocumentationHintSai =>
      'While recording the video, state the following phrase';

  @override
  String get voiceDocumentationHintTahalol =>
      'State the following phrase while you record the Tahallul video';

  @override
  String get voiceDocumentationActionMiqat =>
      'At the Miqat and when entering Ihram, say:';

  @override
  String get voiceDocumentationActionTawaf => 'Before starting the Tawaf, say:';

  @override
  String get voiceDocumentationActionSai =>
      'While standing on Safa, before starting the Sa\'i, say:';

  @override
  String get voiceDocumentationActionTahalol => 'Film the act of trimming';

  @override
  String voiceDocumentationPhraseMiqat(String beneficiary) {
    return 'Labbayk Allahumma labbayk, an Umrah on behalf of $beneficiary';
  }

  @override
  String voiceDocumentationPhraseTawaf(String beneficiary) {
    return 'Documentation of the start of the Tawaf of the Umrah on behalf of $beneficiary, Bismillah, Allahu Akbar';
  }

  @override
  String voiceDocumentationPhraseSai(String beneficiary) {
    return 'Documentation of the Sa\'i of an Umrah on behalf of $beneficiary';
  }

  @override
  String voiceDocumentationPhraseTahalol(String beneficiary) {
    return 'The trimming is complete, and with it the Umrah on behalf of $beneficiary is complete';
  }

  @override
  String get voiceDocumentationNoteTawaf =>
      'Then say the Takbeer when you align with the Black Stone.';

  @override
  String get stepProofRejected =>
      'The administration rejected this step\'s proof';

  @override
  String get rejectionReason => 'Rejection reason';

  @override
  String get reuploadStepProofHint =>
      'Please document this step and upload its proof again.';

  @override
  String get proofRejectedStatus => 'Proof rejected';

  @override
  String get omrahStartsIn => 'Rituals start in';

  @override
  String get omrahStartsInUser => 'Time until your Umrah begins';

  @override
  String get countdownDays => 'Days';

  @override
  String get countdownHours => 'Hours';

  @override
  String get countdownMinutes => 'Min';

  @override
  String get countdownSeconds => 'Sec';

  @override
  String omrahStartDate(String date) {
    return 'Start date: $date';
  }

  @override
  String get omrahTimeArrivedProvider =>
      'It\'s time to begin the rituals, you can start now';

  @override
  String get omrahTimeArrivedUser =>
      'Your Umrah day has arrived, the provider will begin the rituals shortly';

  @override
  String ritualsLockedUntil(String date) {
    return 'Rituals start on $date';
  }

  @override
  String omrahNotStartedYet(String date) {
    return 'The requested date has not arrived yet, rituals start on $date';
  }

  @override
  String get upcomingOmrah => 'Upcoming Umrah';

  @override
  String startsInDaysHours(int days, int hours) {
    return 'Starts in ${days}d ${hours}h';
  }

  @override
  String startsInClock(String time) {
    return 'Starts in $time';
  }
}
