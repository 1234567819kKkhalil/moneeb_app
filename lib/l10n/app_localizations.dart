import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @updateApp.
  ///
  /// In en, this message translates to:
  /// **'Update App'**
  String get updateApp;

  /// No description provided for @updateAppTitle.
  ///
  /// In en, this message translates to:
  /// **'A new version is available. Please update now to continue using the app.'**
  String get updateAppTitle;

  /// No description provided for @updateAppDes.
  ///
  /// In en, this message translates to:
  /// **'This version is no longer supported.'**
  String get updateAppDes;

  /// No description provided for @updateNow.
  ///
  /// In en, this message translates to:
  /// **'update Now'**
  String get updateNow;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @versionInfoNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Version info not available'**
  String get versionInfoNotAvailable;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @noNotificationsHint.
  ///
  /// In en, this message translates to:
  /// **'You have no notifications'**
  String get noNotificationsHint;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @noNotificationHint.
  ///
  /// In en, this message translates to:
  /// **'You have no notifications'**
  String get noNotificationHint;

  /// No description provided for @notificationDeleted.
  ///
  /// In en, this message translates to:
  /// **'Notification deleted'**
  String get notificationDeleted;

  /// No description provided for @notificationDeletedError.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete notification'**
  String get notificationDeletedError;

  /// No description provided for @notificationDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Notification deleted successfully'**
  String get notificationDeletedSuccess;

  /// No description provided for @notificationUpdated.
  ///
  /// In en, this message translates to:
  /// **'Notification updated'**
  String get notificationUpdated;

  /// No description provided for @notificationUpdatedError.
  ///
  /// In en, this message translates to:
  /// **'Failed to update notification'**
  String get notificationUpdatedError;

  /// No description provided for @notificationUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Notification updated successfully'**
  String get notificationUpdatedSuccess;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'custom'**
  String get custom;

  /// No description provided for @original.
  ///
  /// In en, this message translates to:
  /// **'original'**
  String get original;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @redo.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get redo;

  /// No description provided for @flip.
  ///
  /// In en, this message translates to:
  /// **'Flip'**
  String get flip;

  /// No description provided for @rotateRight.
  ///
  /// In en, this message translates to:
  /// **'Rotate Right'**
  String get rotateRight;

  /// No description provided for @imageEditor.
  ///
  /// In en, this message translates to:
  /// **'Image Editor'**
  String get imageEditor;

  /// No description provided for @editImage.
  ///
  /// In en, this message translates to:
  /// **'Edit Image'**
  String get editImage;

  /// No description provided for @verification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verification;

  /// No description provided for @viewVerification.
  ///
  /// In en, this message translates to:
  /// **'View Verification'**
  String get viewVerification;

  /// No description provided for @savingToGallery.
  ///
  /// In en, this message translates to:
  /// **'Saving your image to gallery'**
  String get savingToGallery;

  /// No description provided for @editingImagePleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Editing your image, please wait..'**
  String get editingImagePleaseWait;

  /// No description provided for @saveToGallery.
  ///
  /// In en, this message translates to:
  /// **'Save to gallery'**
  String get saveToGallery;

  /// No description provided for @couldNotSaveImage.
  ///
  /// In en, this message translates to:
  /// **'Could not save the image'**
  String get couldNotSaveImage;

  /// No description provided for @imageSavedToGallery.
  ///
  /// In en, this message translates to:
  /// **'Image saved to gallery'**
  String get imageSavedToGallery;

  /// No description provided for @failedToEditImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to edit your image'**
  String get failedToEditImage;

  /// No description provided for @kb.
  ///
  /// In en, this message translates to:
  /// **'KB'**
  String get kb;

  /// No description provided for @mb.
  ///
  /// In en, this message translates to:
  /// **'MB'**
  String get mb;

  /// No description provided for @gb.
  ///
  /// In en, this message translates to:
  /// **'GB'**
  String get gb;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get image;

  /// No description provided for @video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get video;

  /// No description provided for @audio.
  ///
  /// In en, this message translates to:
  /// **'Voice note'**
  String get audio;

  /// No description provided for @document.
  ///
  /// In en, this message translates to:
  /// **'Document'**
  String get document;

  /// No description provided for @embedLink.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get embedLink;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @takeVideo.
  ///
  /// In en, this message translates to:
  /// **'Take Video'**
  String get takeVideo;

  /// No description provided for @chooseFromLibrary.
  ///
  /// In en, this message translates to:
  /// **'Choose from library'**
  String get chooseFromLibrary;

  /// No description provided for @imagesGallery.
  ///
  /// In en, this message translates to:
  /// **'Images Gallery'**
  String get imagesGallery;

  /// No description provided for @chooseAFile.
  ///
  /// In en, this message translates to:
  /// **'Choose a file'**
  String get chooseAFile;

  /// No description provided for @jPGPNGExtensions.
  ///
  /// In en, this message translates to:
  /// **'JPG, PNG'**
  String get jPGPNGExtensions;

  /// No description provided for @stopped.
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get stopped;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'Recording'**
  String get recording;

  /// No description provided for @preparingRecorder.
  ///
  /// In en, this message translates to:
  /// **'Preparing..'**
  String get preparingRecorder;

  /// No description provided for @typeAudioTitle.
  ///
  /// In en, this message translates to:
  /// **'Type audio title'**
  String get typeAudioTitle;

  /// No description provided for @playbackSpeed.
  ///
  /// In en, this message translates to:
  /// **'Playback Speed'**
  String get playbackSpeed;

  /// No description provided for @errorStartRecording.
  ///
  /// In en, this message translates to:
  /// **'Error, could not start the recording.'**
  String get errorStartRecording;

  /// No description provided for @couldNotStopRecord.
  ///
  /// In en, this message translates to:
  /// **'Could not stop the record'**
  String get couldNotStopRecord;

  /// No description provided for @couldNotPauseRecord.
  ///
  /// In en, this message translates to:
  /// **'Could not pause the recorder..'**
  String get couldNotPauseRecord;

  /// No description provided for @couldNotResumeRecord.
  ///
  /// In en, this message translates to:
  /// **'Could not resume the record..'**
  String get couldNotResumeRecord;

  /// No description provided for @errorPlayingVideo.
  ///
  /// In en, this message translates to:
  /// **'Error playing the video'**
  String get errorPlayingVideo;

  /// No description provided for @mediaExceededSizeLimitSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped {count} media because {count, plural, =1{it} other{they}} exceeded the size limit of {maxSize} MB'**
  String mediaExceededSizeLimitSkipped(num count, Object maxSize);

  /// No description provided for @mediaExceededMaxCountLimitSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped {count} media because {count, plural, =1{it} other{they}} exceeded the max count limit of {maxSize}'**
  String mediaExceededMaxCountLimitSkipped(num count, Object maxSize);

  /// No description provided for @unsupportedFileType.
  ///
  /// In en, this message translates to:
  /// **'Unsupported file type'**
  String get unsupportedFileType;

  /// No description provided for @unSupportedMediaSkipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped {count} media because {count, plural, =1{it is} other{they are}} not in supported formats'**
  String unSupportedMediaSkipped(num count);

  /// No description provided for @maximumAllowedAudio.
  ///
  /// In en, this message translates to:
  /// **'(maximum {count} audio)'**
  String maximumAllowedAudio(int count);

  /// No description provided for @maximumAllowedImages.
  ///
  /// In en, this message translates to:
  /// **'(maximum {count} images)'**
  String maximumAllowedImages(int count);

  /// No description provided for @maximumAllowedVideos.
  ///
  /// In en, this message translates to:
  /// **'(maximum {count} video)'**
  String maximumAllowedVideos(int count);

  /// No description provided for @sizeLimitExceeded.
  ///
  /// In en, this message translates to:
  /// **'Size limit exceeded, max size is: {maxSize} MB'**
  String sizeLimitExceeded(int maxSize);

  /// No description provided for @supportedFileTypeIs.
  ///
  /// In en, this message translates to:
  /// **'Supported formats are'**
  String get supportedFileTypeIs;

  /// No description provided for @permissionNotGranted.
  ///
  /// In en, this message translates to:
  /// **'Permission not granted'**
  String get permissionNotGranted;

  /// No description provided for @givePermissionsManually.
  ///
  /// In en, this message translates to:
  /// **'You have to give permissions manually from settings'**
  String get givePermissionsManually;

  /// No description provided for @removeImage.
  ///
  /// In en, this message translates to:
  /// **'Remove Image'**
  String get removeImage;

  /// No description provided for @videoSavedToGallery.
  ///
  /// In en, this message translates to:
  /// **'Video has been saved to the gallery'**
  String get videoSavedToGallery;

  /// No description provided for @errorPickingMedia.
  ///
  /// In en, this message translates to:
  /// **'Error while picking your media'**
  String get errorPickingMedia;

  /// No description provided for @errorFileSize.
  ///
  /// In en, this message translates to:
  /// **'File Too Large'**
  String get errorFileSize;

  /// No description provided for @uploadCancelled.
  ///
  /// In en, this message translates to:
  /// **'Upload canceled'**
  String get uploadCancelled;

  /// No description provided for @maximumSizeLimitWithSkippedError.
  ///
  /// In en, this message translates to:
  /// **'The maximum size is {limit} megabytes, {count, plural, =1{1 file} other{{count} files}} skipped'**
  String maximumSizeLimitWithSkippedError(num limit, num count);

  /// No description provided for @uploadError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error during file upload'**
  String get uploadError;

  /// No description provided for @uploadFailedError.
  ///
  /// In en, this message translates to:
  /// **'Upload Failed'**
  String get uploadFailedError;

  /// No description provided for @videoLoadingError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load video'**
  String get videoLoadingError;

  /// No description provided for @compressionError.
  ///
  /// In en, this message translates to:
  /// **'File compression failed'**
  String get compressionError;

  /// No description provided for @thumbnailError.
  ///
  /// In en, this message translates to:
  /// **'get video thumbnail failed'**
  String get thumbnailError;

  /// No description provided for @maximumAttachmentLimitError.
  ///
  /// In en, this message translates to:
  /// **'maximum limit is ({limit})'**
  String maximumAttachmentLimitError(num limit);

  /// No description provided for @maximumImagesLimitError.
  ///
  /// In en, this message translates to:
  /// **'maximum limit is ({limit}) images'**
  String maximumImagesLimitError(num limit);

  /// No description provided for @maximumVideoLimitError.
  ///
  /// In en, this message translates to:
  /// **'maximum limit is ({limit}) video'**
  String maximumVideoLimitError(num limit);

  /// No description provided for @maximumAudioLimitError.
  ///
  /// In en, this message translates to:
  /// **'maximum limit is ({limit}) audio'**
  String maximumAudioLimitError(num limit);

  /// No description provided for @maximumCountSizeLimitError.
  ///
  /// In en, this message translates to:
  /// **'The maximum limit for selecting is {count}, and the maximum size is {limit} megabytes'**
  String maximumCountSizeLimitError(num limit, num count);

  /// No description provided for @maximumSizeLimitError.
  ///
  /// In en, this message translates to:
  /// **'The maximum size is {limit} megabytes'**
  String maximumSizeLimitError(num limit);

  /// No description provided for @fileSizeError.
  ///
  /// In en, this message translates to:
  /// **'File is too large'**
  String get fileSizeError;

  /// No description provided for @fileDoesNotExist.
  ///
  /// In en, this message translates to:
  /// **'File does not exist'**
  String get fileDoesNotExist;

  /// No description provided for @fileExceedError.
  ///
  /// In en, this message translates to:
  /// **'File exceed {limit}MB'**
  String fileExceedError(num limit);

  /// No description provided for @mediaPickupCanceled.
  ///
  /// In en, this message translates to:
  /// **'Media pickup canceled، Please try again later'**
  String get mediaPickupCanceled;

  /// No description provided for @couldNotDownloadFileError.
  ///
  /// In en, this message translates to:
  /// **'Could not download the file'**
  String get couldNotDownloadFileError;

  /// No description provided for @fileCorruptionError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong with this file'**
  String get fileCorruptionError;

  /// No description provided for @emptyFileError.
  ///
  /// In en, this message translates to:
  /// **'Cant Upload Empty File ,Make Sure You Upload Valid File'**
  String get emptyFileError;

  /// No description provided for @pickPdfValidationError.
  ///
  /// In en, this message translates to:
  /// **'Please, Choose a valid file'**
  String get pickPdfValidationError;

  /// No description provided for @couldNotOpenRecord.
  ///
  /// In en, this message translates to:
  /// **'Could not open the record'**
  String get couldNotOpenRecord;

  /// No description provided for @downloadSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Downloaded successfully'**
  String get downloadSuccessfully;

  /// No description provided for @failedToLoadTheAudio.
  ///
  /// In en, this message translates to:
  /// **'Failed To Load The Audio '**
  String get failedToLoadTheAudio;

  /// No description provided for @failedToLoadTheVideo.
  ///
  /// In en, this message translates to:
  /// **'Failed To Load The Video '**
  String get failedToLoadTheVideo;

  /// No description provided for @mediaLimit.
  ///
  /// In en, this message translates to:
  /// **'Media Limit Exceeded, added '**
  String get mediaLimit;

  /// No description provided for @outOf.
  ///
  /// In en, this message translates to:
  /// **'out of'**
  String get outOf;

  /// No description provided for @videoLimit.
  ///
  /// In en, this message translates to:
  /// **'Max video upload limit is 1'**
  String get videoLimit;

  /// No description provided for @pickingMedia.
  ///
  /// In en, this message translates to:
  /// **'Picking your media..'**
  String get pickingMedia;

  /// No description provided for @addImages.
  ///
  /// In en, this message translates to:
  /// **'Add images'**
  String get addImages;

  /// No description provided for @emptyEmailError.
  ///
  /// In en, this message translates to:
  /// **'Email field is required and cannot be empty.'**
  String get emptyEmailError;

  /// No description provided for @emailFormatError.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format. Please try again.'**
  String get emailFormatError;

  /// No description provided for @emailCapitalCharactersError.
  ///
  /// In en, this message translates to:
  /// **'Email should not contain capital characters'**
  String get emailCapitalCharactersError;

  /// No description provided for @emailContainArabicError.
  ///
  /// In en, this message translates to:
  /// **'Email should not contain arabic characters'**
  String get emailContainArabicError;

  /// No description provided for @emailHasSpaceError.
  ///
  /// In en, this message translates to:
  /// **'Email can not have spaces'**
  String get emailHasSpaceError;

  /// No description provided for @passwordDoesNotMatchError.
  ///
  /// In en, this message translates to:
  /// **'The password does not match with new password.'**
  String get passwordDoesNotMatchError;

  /// No description provided for @emptyPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Password field is required and cannot be empty.'**
  String get emptyPasswordError;

  /// No description provided for @lengthPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Password length must be at least 8'**
  String get lengthPasswordError;

  /// No description provided for @uppercaseLetterPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter'**
  String get uppercaseLetterPasswordError;

  /// No description provided for @lowercaseLetterPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one lowercase letter'**
  String get lowercaseLetterPasswordError;

  /// No description provided for @digitPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one digit'**
  String get digitPasswordError;

  /// No description provided for @specialCharPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one special character'**
  String get specialCharPasswordError;

  /// No description provided for @emptyNameError.
  ///
  /// In en, this message translates to:
  /// **'Name field is required and cannot be empty.'**
  String get emptyNameError;

  /// No description provided for @emptyFirstNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter first name'**
  String get emptyFirstNameError;

  /// No description provided for @emptyLastNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter last name'**
  String get emptyLastNameError;

  /// No description provided for @nameIsRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Name field is required and cannot be empty.'**
  String get nameIsRequiredError;

  /// No description provided for @inValidNameError.
  ///
  /// In en, this message translates to:
  /// **'Your name must only contain letters'**
  String get inValidNameError;

  /// No description provided for @nameLengthError.
  ///
  /// In en, this message translates to:
  /// **'Name should be between 2 and 25 characters'**
  String get nameLengthError;

  /// No description provided for @enterMobileNumberError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your Mobile number'**
  String get enterMobileNumberError;

  /// No description provided for @otpNumberExceeded.
  ///
  /// In en, this message translates to:
  /// **'You have exceeded the number allowed to send the activation code. Please try again another time after'**
  String get otpNumberExceeded;

  /// No description provided for @userCancelSocialLoginError.
  ///
  /// In en, this message translates to:
  /// **'Sign Is Canceled'**
  String get userCancelSocialLoginError;

  /// No description provided for @failedToLoginWithFacebookError.
  ///
  /// In en, this message translates to:
  /// **'Failed to sign in with Facebook'**
  String get failedToLoginWithFacebookError;

  /// No description provided for @failedToLoginWithTwitterError.
  ///
  /// In en, this message translates to:
  /// **'Failed to sign in with X'**
  String get failedToLoginWithTwitterError;

  /// No description provided for @failedToLoginWithAppleError.
  ///
  /// In en, this message translates to:
  /// **'Failed to sign in with Apple'**
  String get failedToLoginWithAppleError;

  /// No description provided for @failedToLoginWithGoogleError.
  ///
  /// In en, this message translates to:
  /// **'Failed to sign in with Google'**
  String get failedToLoginWithGoogleError;

  /// No description provided for @socialRegisterDataNotCompleteError.
  ///
  /// In en, this message translates to:
  /// **'Register Data Not Complete Make Sure Every Thing is Ok'**
  String get socialRegisterDataNotCompleteError;

  /// No description provided for @couldNotLaunchError.
  ///
  /// In en, this message translates to:
  /// **'Could not launch the link'**
  String get couldNotLaunchError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error, please try again later'**
  String get serverError;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'UnExpected error, please try again later'**
  String get unexpectedError;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'no internet'**
  String get networkError;

  /// No description provided for @hasInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'has internet connection'**
  String get hasInternetConnection;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'no internet connection'**
  String get noInternetConnection;

  /// No description provided for @permissionNotGrantedError.
  ///
  /// In en, this message translates to:
  /// **'Permission not granted'**
  String get permissionNotGrantedError;

  /// No description provided for @voicePermissionError.
  ///
  /// In en, this message translates to:
  /// **'Could not grant voice permissions'**
  String get voicePermissionError;

  /// No description provided for @cameraPermissionError.
  ///
  /// In en, this message translates to:
  /// **'Could not grant camera permissions'**
  String get cameraPermissionError;

  /// No description provided for @mediaPermissionError.
  ///
  /// In en, this message translates to:
  /// **'Could not grant media permissions'**
  String get mediaPermissionError;

  /// No description provided for @locationPermissionError.
  ///
  /// In en, this message translates to:
  /// **'Could not grant location permissions'**
  String get locationPermissionError;

  /// No description provided for @notificationPermissionError.
  ///
  /// In en, this message translates to:
  /// **'Could not grant notification permissions'**
  String get notificationPermissionError;

  /// No description provided for @photoVideoPermissionError.
  ///
  /// In en, this message translates to:
  /// **'Could not grant photos and videos permissions'**
  String get photoVideoPermissionError;

  /// No description provided for @videosPermissionError.
  ///
  /// In en, this message translates to:
  /// **'Could not grant videos permissions'**
  String get videosPermissionError;

  /// No description provided for @noItemFoundError.
  ///
  /// In en, this message translates to:
  /// **'no Item Found'**
  String get noItemFoundError;

  /// No description provided for @noResultsFoundError.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFoundError;

  /// No description provided for @failedToGetUserInfoError.
  ///
  /// In en, this message translates to:
  /// **'Failed to get user info'**
  String get failedToGetUserInfoError;

  /// No description provided for @blockedErrorTitleError.
  ///
  /// In en, this message translates to:
  /// **'Access Blocked'**
  String get blockedErrorTitleError;

  /// No description provided for @blockedErrorDescError.
  ///
  /// In en, this message translates to:
  /// **'Sorry, your account has been blocked.'**
  String get blockedErrorDescError;

  /// No description provided for @unAuthorizedErrorTitleError.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized'**
  String get unAuthorizedErrorTitleError;

  /// No description provided for @unAuthorizedErrorDescError.
  ///
  /// In en, this message translates to:
  /// **'Sorry, you do not have permission to perform this operation.'**
  String get unAuthorizedErrorDescError;

  /// No description provided for @invalidLinkError.
  ///
  /// In en, this message translates to:
  /// **'invalid link, please make sure link is valid'**
  String get invalidLinkError;

  /// No description provided for @seemTobeOffline.
  ///
  /// In en, this message translates to:
  /// **'You seem to be offline!'**
  String get seemTobeOffline;

  /// No description provided for @hangWeReconnecting.
  ///
  /// In en, this message translates to:
  /// **'Hang tight! We\'re trying to reconnect'**
  String get hangWeReconnecting;

  /// No description provided for @noSearchResults.
  ///
  /// In en, this message translates to:
  /// **'No results found for {text}'**
  String noSearchResults(String text);

  /// No description provided for @noSearchResultsHint.
  ///
  /// In en, this message translates to:
  /// **'Check the spelling and try again or search for something new'**
  String get noSearchResultsHint;

  /// No description provided for @permissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Allow {value} access in device settings'**
  String permissionRequired(String value);

  /// No description provided for @permissionRequiredDesc.
  ///
  /// In en, this message translates to:
  /// **'to use this feature, please enable {value} access in device settings'**
  String permissionRequiredDesc(String value);

  /// No description provided for @welcomeSplash.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcomeSplash;

  /// No description provided for @allRightsReserved.
  ///
  /// In en, this message translates to:
  /// **'All rights reserved © All rights reserved'**
  String get allRightsReserved;

  /// No description provided for @quranQuote.
  ///
  /// In en, this message translates to:
  /// **'( And complete the Hajj and \'Umrah for Allah )'**
  String get quranQuote;

  /// No description provided for @chooseGender.
  ///
  /// In en, this message translates to:
  /// **'Choose gender'**
  String get chooseGender;

  /// No description provided for @pleaseChooseGender.
  ///
  /// In en, this message translates to:
  /// **'Please choose gender'**
  String get pleaseChooseGender;

  /// No description provided for @quranHafiz.
  ///
  /// In en, this message translates to:
  /// **'Are you a Hafiz of the Holy Quran?'**
  String get quranHafiz;

  /// No description provided for @pleaseChooseQuranMemorization.
  ///
  /// In en, this message translates to:
  /// **'Please choose if you are a Hafiz of the Holy Quran'**
  String get pleaseChooseQuranMemorization;

  /// No description provided for @certificateNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Certificate name is required'**
  String get certificateNameRequired;

  /// No description provided for @uploadCertificateImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Certificate Image'**
  String get uploadCertificateImage;

  /// No description provided for @bioRequired.
  ///
  /// In en, this message translates to:
  /// **'Biography is required'**
  String get bioRequired;

  /// No description provided for @umrahCountRequired.
  ///
  /// In en, this message translates to:
  /// **'Number of Umrahs performed is required'**
  String get umrahCountRequired;

  /// No description provided for @enterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get enterValidNumber;

  /// No description provided for @idNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'ID number is required'**
  String get idNumberRequired;

  /// No description provided for @pleaseUploadImage.
  ///
  /// In en, this message translates to:
  /// **'Please upload the image'**
  String get pleaseUploadImage;

  /// No description provided for @pleaseUploadIdImage.
  ///
  /// In en, this message translates to:
  /// **'Please upload the ID image'**
  String get pleaseUploadIdImage;

  /// No description provided for @providerOath.
  ///
  /// In en, this message translates to:
  /// **'I swear by Almighty Allah,\nTo perform Umrah or Hajj with honesty and sincerity,\nAnd to intend the work purely for the sake of Allah Almighty,\nAnd to adhere to all Sharia rulings and ethical standards.\n\nAnd I pledge:\n• To perform the rituals on behalf of the Umrah owner as requested of me without deficiency or neglect.\n• To be honest in the information, documentation, and photos sent within the application.\n• To preserve the confidentiality of the Umrah owners\' data and not misuse it.\n• To respect the sanctity of the place and time, and represent the application in the best way.\n• To fear Allah in every action I take within this application.\n\nI acknowledge that any violation of the above forfeits my right to use the application, and I bear full responsibility before Allah and then before the application management.\n\"And Allah is witness over what I say.\"'**
  String get providerOath;

  /// No description provided for @downloadApp.
  ///
  /// In en, this message translates to:
  /// **'Download app'**
  String get downloadApp;

  /// No description provided for @shareAppTitleContent.
  ///
  /// In en, this message translates to:
  /// **'Experience a seamless path to all...'**
  String get shareAppTitleContent;

  /// No description provided for @biometricAuth.
  ///
  /// In en, this message translates to:
  /// **'Pass key'**
  String get biometricAuth;

  /// No description provided for @useToOpen.
  ///
  /// In en, this message translates to:
  /// **'Unlock with {biometric} to open your app.'**
  String useToOpen(String biometric);

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'disabled'**
  String get disabled;

  /// No description provided for @immediately.
  ///
  /// In en, this message translates to:
  /// **'Immediately'**
  String get immediately;

  /// No description provided for @after10Sec.
  ///
  /// In en, this message translates to:
  /// **'After 10 seconds'**
  String get after10Sec;

  /// No description provided for @after30Sec.
  ///
  /// In en, this message translates to:
  /// **'After 30 seconds'**
  String get after30Sec;

  /// No description provided for @afterMinute.
  ///
  /// In en, this message translates to:
  /// **'After 1 minute'**
  String get afterMinute;

  /// No description provided for @appLock.
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get appLock;

  /// No description provided for @enableFaceTouchId.
  ///
  /// In en, this message translates to:
  /// **'Enable Face ID or Touch ID to protect access to your app.'**
  String get enableFaceTouchId;

  /// No description provided for @enableAppLock.
  ///
  /// In en, this message translates to:
  /// **'Enable app lock'**
  String get enableAppLock;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open setting'**
  String get openSettings;

  /// No description provided for @passkey.
  ///
  /// In en, this message translates to:
  /// **'Pass key'**
  String get passkey;

  /// No description provided for @useBiometric.
  ///
  /// In en, this message translates to:
  /// **'Use {biometric}'**
  String useBiometric(String biometric);

  /// No description provided for @faceRecognition.
  ///
  /// In en, this message translates to:
  /// **'Face ID'**
  String get faceRecognition;

  /// No description provided for @fingerprint.
  ///
  /// In en, this message translates to:
  /// **'Touch ID'**
  String get fingerprint;

  /// No description provided for @iris.
  ///
  /// In en, this message translates to:
  /// **'Iris Scan'**
  String get iris;

  /// No description provided for @anyBiometric.
  ///
  /// In en, this message translates to:
  /// **'available biometric'**
  String get anyBiometric;

  /// No description provided for @toUseApp.
  ///
  /// In en, this message translates to:
  /// **'to access your app'**
  String get toUseApp;

  /// No description provided for @noBiometricAvailable.
  ///
  /// In en, this message translates to:
  /// **'No biometric authentication available. Please use your passcode if available'**
  String get noBiometricAvailable;

  /// No description provided for @biometricFailure.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication is not available.'**
  String get biometricFailure;

  /// No description provided for @addressTitle.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressTitle;

  /// No description provided for @searchAddress.
  ///
  /// In en, this message translates to:
  /// **'Search for address'**
  String get searchAddress;

  /// No description provided for @addAddressButtonText.
  ///
  /// In en, this message translates to:
  /// **'Add address'**
  String get addAddressButtonText;

  /// No description provided for @addAddress.
  ///
  /// In en, this message translates to:
  /// **'Add an address for easier deliveries'**
  String get addAddress;

  /// No description provided for @addAddressDes.
  ///
  /// In en, this message translates to:
  /// **'You can add your home address, work address, or any other address you want your orders delivered to.'**
  String get addAddressDes;

  /// No description provided for @addressSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Address Saved successfully'**
  String get addressSavedSuccessfully;

  /// No description provided for @addressDetails.
  ///
  /// In en, this message translates to:
  /// **'Address Details'**
  String get addressDetails;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @additionalAddressInfo.
  ///
  /// In en, this message translates to:
  /// **'Additional Address information'**
  String get additionalAddressInfo;

  /// No description provided for @apt.
  ///
  /// In en, this message translates to:
  /// **'Apt. no.'**
  String get apt;

  /// No description provided for @buildingName.
  ///
  /// In en, this message translates to:
  /// **'Building name'**
  String get buildingName;

  /// No description provided for @addressName.
  ///
  /// In en, this message translates to:
  /// **'Address name'**
  String get addressName;

  /// No description provided for @floor.
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get floor;

  /// No description provided for @street.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get street;

  /// No description provided for @additionalDirections.
  ///
  /// In en, this message translates to:
  /// **'Additional directions'**
  String get additionalDirections;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address label'**
  String get addressLabel;

  /// No description provided for @additionalInstructions.
  ///
  /// In en, this message translates to:
  /// **'Additional Instructions'**
  String get additionalInstructions;

  /// No description provided for @pickLocation.
  ///
  /// In en, this message translates to:
  /// **'Pick location'**
  String get pickLocation;

  /// No description provided for @findCaterersNearby.
  ///
  /// In en, this message translates to:
  /// **'Find caterers nearby'**
  String get findCaterersNearby;

  /// No description provided for @findCaterersNearbyDes.
  ///
  /// In en, this message translates to:
  /// **'Tell us where the gathering\'s at! We\'ll find delicious catering options near you.'**
  String get findCaterersNearbyDes;

  /// No description provided for @shareLocation.
  ///
  /// In en, this message translates to:
  /// **'Share your location'**
  String get shareLocation;

  /// No description provided for @enableLocation.
  ///
  /// In en, this message translates to:
  /// **'Enable location for nearby catering fun'**
  String get enableLocation;

  /// No description provided for @deliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get deliveryAddress;

  /// No description provided for @confirmPinLocation.
  ///
  /// In en, this message translates to:
  /// **'Confirm pin location'**
  String get confirmPinLocation;

  /// No description provided for @confirmLocation.
  ///
  /// In en, this message translates to:
  /// **'Confirm location'**
  String get confirmLocation;

  /// No description provided for @detecting.
  ///
  /// In en, this message translates to:
  /// **'Detecting...'**
  String get detecting;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No description provided for @selectLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Set Location'**
  String get selectLocationHint;

  /// No description provided for @updateLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Location'**
  String get updateLocationTitle;

  /// No description provided for @updateLocationConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you want to update your current location?'**
  String get updateLocationConfirmation;

  /// No description provided for @yesUpdate.
  ///
  /// In en, this message translates to:
  /// **'Yes, Update'**
  String get yesUpdate;

  /// No description provided for @enableLocationServicePrompt.
  ///
  /// In en, this message translates to:
  /// **'Please enable location services to detect your location'**
  String get enableLocationServicePrompt;

  /// No description provided for @locationPermissionDeniedForeverPrompt.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied. Please enable it from the app settings'**
  String get locationPermissionDeniedForeverPrompt;

  /// No description provided for @unnamedRoad.
  ///
  /// In en, this message translates to:
  /// **'Unnamed road'**
  String get unnamedRoad;

  /// No description provided for @chooseDeliveryLocation.
  ///
  /// In en, this message translates to:
  /// **'Choose delivery location'**
  String get chooseDeliveryLocation;

  /// No description provided for @savedAddress.
  ///
  /// In en, this message translates to:
  /// **'Saved addresses'**
  String get savedAddress;

  /// No description provided for @deliverToDifferentLocation.
  ///
  /// In en, this message translates to:
  /// **'Deliver to different location'**
  String get deliverToDifferentLocation;

  /// No description provided for @zoomInMore.
  ///
  /// In en, this message translates to:
  /// **'Please zoom in more to find your exact delivery location'**
  String get zoomInMore;

  /// No description provided for @selectYourArea.
  ///
  /// In en, this message translates to:
  /// **'Select your area'**
  String get selectYourArea;

  /// No description provided for @shareYourLocation.
  ///
  /// In en, this message translates to:
  /// **'Share your location'**
  String get shareYourLocation;

  /// No description provided for @byAllowLocation.
  ///
  /// In en, this message translates to:
  /// **'By allowing App to detect your location, We can show you nearby restaurants more accurately'**
  String get byAllowLocation;

  /// No description provided for @goToSetting.
  ///
  /// In en, this message translates to:
  /// **'Go to setting'**
  String get goToSetting;

  /// No description provided for @searchCountry.
  ///
  /// In en, this message translates to:
  /// **'Search country'**
  String get searchCountry;

  /// No description provided for @searchArea.
  ///
  /// In en, this message translates to:
  /// **'Search area'**
  String get searchArea;

  /// No description provided for @searchCity.
  ///
  /// In en, this message translates to:
  /// **'Search city'**
  String get searchCity;

  /// No description provided for @dates.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get dates;

  /// No description provided for @sinceDate.
  ///
  /// In en, this message translates to:
  /// **'Since'**
  String get sinceDate;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just Now'**
  String get justNow;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 year} =1{1 year} other{{count} years}}'**
  String year(num count);

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 month} =1{1 month} other{{count} months}}'**
  String month(num count);

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 week} =1{1 week} other{{count} weeks}}'**
  String week(num count);

  /// No description provided for @sinceWeek.
  ///
  /// In en, this message translates to:
  /// **'since {count, plural, =0{0 weeks} =1{1 week} other{{count} weeks}}'**
  String sinceWeek(num count);

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 day} =1{1 day} other{{count} days}}'**
  String day(num count);

  /// No description provided for @sinceDay.
  ///
  /// In en, this message translates to:
  /// **'since {count, plural, =0{0 days} =1{1 day} other{{count} days}}'**
  String sinceDay(num count);

  /// No description provided for @hour.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 hour} =1{1 hour} other{{count} hours}}'**
  String hour(num count);

  /// No description provided for @sinceHour.
  ///
  /// In en, this message translates to:
  /// **'since {count, plural, =0{0 hours} =1{1 hour} other{{count} hours}}'**
  String sinceHour(num count);

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 min} =1{1 min} other{{count} mins}}'**
  String min(num count);

  /// No description provided for @sinceMin.
  ///
  /// In en, this message translates to:
  /// **'since {count, plural, =0{0 min} =1{1 min} other{{count} mins}}'**
  String sinceMin(num count);

  /// No description provided for @minute.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 minute} =1{1 minute} other{{count} minutes}}'**
  String minute(num count);

  /// No description provided for @sinceMinute.
  ///
  /// In en, this message translates to:
  /// **'since {count, plural, =0{0 minute} =1{1 minute} other{{count} minutes}}'**
  String sinceMinute(num count);

  /// No description provided for @second.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 seconds} =1{1 second} other{{count} seconds}}'**
  String second(num count);

  /// No description provided for @sinceSecond.
  ///
  /// In en, this message translates to:
  /// **'since {count, plural, =0{0 seconds} =1{1 second} other{{count} seconds}}'**
  String sinceSecond(num count);

  /// No description provided for @sec.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{0 Sec} =1{1 Sec} other{{count} Secs}}'**
  String sec(num count);

  /// No description provided for @sinceSec.
  ///
  /// In en, this message translates to:
  /// **'since {count, plural, =0{0 Sec} =1{1 Sec} other{{count} Secs}}'**
  String sinceSec(num count);

  /// No description provided for @h.
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get h;

  /// No description provided for @m.
  ///
  /// In en, this message translates to:
  /// **'m'**
  String get m;

  /// No description provided for @s.
  ///
  /// In en, this message translates to:
  /// **'s'**
  String get s;

  /// No description provided for @eveningPM.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get eveningPM;

  /// No description provided for @morningAM.
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get morningAM;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @weeks.
  ///
  /// In en, this message translates to:
  /// **'Weeks'**
  String get weeks;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get months;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get years;

  /// No description provided for @turnOn.
  ///
  /// In en, this message translates to:
  /// **'Turn on'**
  String get turnOn;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @cont.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get cont;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @sureYouWantToExit.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit?'**
  String get sureYouWantToExit;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @stay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get stay;

  /// No description provided for @sendMedia.
  ///
  /// In en, this message translates to:
  /// **'Send a photo or video'**
  String get sendMedia;

  /// No description provided for @sendPdf.
  ///
  /// In en, this message translates to:
  /// **'Upload Documents'**
  String get sendPdf;

  /// No description provided for @openCamera.
  ///
  /// In en, this message translates to:
  /// **'Take a photo'**
  String get openCamera;

  /// No description provided for @wait.
  ///
  /// In en, this message translates to:
  /// **'Wait'**
  String get wait;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get showMore;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get showLess;

  /// No description provided for @reSend.
  ///
  /// In en, this message translates to:
  /// **'Re-send'**
  String get reSend;

  /// No description provided for @recall.
  ///
  /// In en, this message translates to:
  /// **'Recall'**
  String get recall;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @typing.
  ///
  /// In en, this message translates to:
  /// **'Typing..'**
  String get typing;

  /// No description provided for @copyMessage.
  ///
  /// In en, this message translates to:
  /// **'The message has been copied'**
  String get copyMessage;

  /// No description provided for @selectYour.
  ///
  /// In en, this message translates to:
  /// **'Select your'**
  String get selectYour;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @verifyTextBtn.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyTextBtn;

  /// No description provided for @unlinkAccount.
  ///
  /// In en, this message translates to:
  /// **'Unlink'**
  String get unlinkAccount;

  /// No description provided for @linkAccount.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get linkAccount;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCode;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchWithDots.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchWithDots;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @record.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get record;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @disable.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get disable;

  /// No description provided for @clickHere.
  ///
  /// In en, this message translates to:
  /// **'Click here'**
  String get clickHere;

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get loadMore;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See More'**
  String get seeMore;

  /// No description provided for @book.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get book;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @getStartedNow.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStartedNow;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @viewMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get viewMore;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @viewLess.
  ///
  /// In en, this message translates to:
  /// **'Read less'**
  String get viewLess;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @agoMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String agoMinutes(int count);

  /// No description provided for @agoHours.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String agoHours(int count);

  /// No description provided for @agoDays.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String agoDays(int count);

  /// No description provided for @dailyApps.
  ///
  /// In en, this message translates to:
  /// **'Daily Apps'**
  String get dailyApps;

  /// No description provided for @liveFromHaram.
  ///
  /// In en, this message translates to:
  /// **'Live from Al-Masjid al-Haram now'**
  String get liveFromHaram;

  /// No description provided for @currentUmrah.
  ///
  /// In en, this message translates to:
  /// **'Current Umrah..'**
  String get currentUmrah;

  /// No description provided for @videos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get videos;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @welcomeTo.
  ///
  /// In en, this message translates to:
  /// **'Welcome in '**
  String get welcomeTo;

  /// No description provided for @welcomeGuest.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcomeGuest;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String welcome(String name);

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'----'**
  String get appName;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get mobileNumber;

  /// No description provided for @tapToSelect.
  ///
  /// In en, this message translates to:
  /// **'Tap to select'**
  String get tapToSelect;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get area;

  /// No description provided for @lang.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get lang;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @noAnswer.
  ///
  /// In en, this message translates to:
  /// **'Doesn\'t matter'**
  String get noAnswer;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success !'**
  String get success;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @youAreGuestLogin.
  ///
  /// In en, this message translates to:
  /// **'You are a guest, login to continue.'**
  String get youAreGuestLogin;

  /// No description provided for @exitDescription.
  ///
  /// In en, this message translates to:
  /// **'Do you want to exit an App'**
  String get exitDescription;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @addedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Added successfully'**
  String get addedSuccessfully;

  /// No description provided for @pastYourLink.
  ///
  /// In en, this message translates to:
  /// **'Past your link here'**
  String get pastYourLink;

  /// No description provided for @selectYourCountry.
  ///
  /// In en, this message translates to:
  /// **'Select your country'**
  String get selectYourCountry;

  /// No description provided for @appLocked.
  ///
  /// In en, this message translates to:
  /// **'App Locked'**
  String get appLocked;

  /// No description provided for @searchResults.
  ///
  /// In en, this message translates to:
  /// **'Search results'**
  String get searchResults;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **' or '**
  String get or;

  /// No description provided for @pleaseReadContentCarefully.
  ///
  /// In en, this message translates to:
  /// **'Please read the content carefully to know more about the app'**
  String get pleaseReadContentCarefully;

  /// No description provided for @searchHere.
  ///
  /// In en, this message translates to:
  /// **'Search here'**
  String get searchHere;

  /// No description provided for @azkar.
  ///
  /// In en, this message translates to:
  /// **'Azkar'**
  String get azkar;

  /// No description provided for @dua.
  ///
  /// In en, this message translates to:
  /// **'Dua'**
  String get dua;

  /// No description provided for @tasbeeh.
  ///
  /// In en, this message translates to:
  /// **'Electronic Sebha'**
  String get tasbeeh;

  /// No description provided for @tasbeehDescription.
  ///
  /// In en, this message translates to:
  /// **'Enjoy the electronic sebha experience inside the app, and record your praises with ease and accuracy'**
  String get tasbeehDescription;

  /// No description provided for @praiseNow.
  ///
  /// In en, this message translates to:
  /// **'Praise Now'**
  String get praiseNow;

  /// No description provided for @prayerTimes.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get prayerTimes;

  /// No description provided for @prayerTimesDescription.
  ///
  /// In en, this message translates to:
  /// **'Follow prayer times accurately according to your current location'**
  String get prayerTimesDescription;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @occasions.
  ///
  /// In en, this message translates to:
  /// **'Occasions'**
  String get occasions;

  /// No description provided for @read.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get read;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @selectDhikr.
  ///
  /// In en, this message translates to:
  /// **'Select the Dhikr'**
  String get selectDhikr;

  /// No description provided for @resetSebha.
  ///
  /// In en, this message translates to:
  /// **'Reset the Sebha'**
  String get resetSebha;

  /// No description provided for @tasbeehPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Subhan Allah wa bihamdihi'**
  String get tasbeehPlaceholder;

  /// No description provided for @qiblah.
  ///
  /// In en, this message translates to:
  /// **'Qiblah Direction'**
  String get qiblah;

  /// No description provided for @qiblahDescription.
  ///
  /// In en, this message translates to:
  /// **'Find the Qiblah direction accurately based on your current location'**
  String get qiblahDescription;

  /// No description provided for @qiblahNow.
  ///
  /// In en, this message translates to:
  /// **'Find Qiblah'**
  String get qiblahNow;

  /// No description provided for @enterDhikr.
  ///
  /// In en, this message translates to:
  /// **'Enter Dhikr'**
  String get enterDhikr;

  /// No description provided for @timings.
  ///
  /// In en, this message translates to:
  /// **'Timings'**
  String get timings;

  /// No description provided for @daysRemainingUntil.
  ///
  /// In en, this message translates to:
  /// **'{days} days remaining until {eventName}. Occasion date: {date}'**
  String daysRemainingUntil(Object date, Object days, Object eventName);

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days} days left'**
  String daysLeft(String days);

  /// No description provided for @loginRequired.
  ///
  /// In en, this message translates to:
  /// **'Login required'**
  String get loginRequired;

  /// No description provided for @journeyStartDesc.
  ///
  /// In en, this message translates to:
  /// **'Your blessed journey starts here'**
  String get journeyStartDesc;

  /// No description provided for @moneebSaudiDesc.
  ///
  /// In en, this message translates to:
  /// **'Moneeb .. from Makkah Al-Mukarramah'**
  String get moneebSaudiDesc;

  /// No description provided for @story.
  ///
  /// In en, this message translates to:
  /// **'Story'**
  String get story;

  /// No description provided for @theBest.
  ///
  /// In en, this message translates to:
  /// **'The Best'**
  String get theBest;

  /// No description provided for @trustedPilgrims.
  ///
  /// In en, this message translates to:
  /// **'Trusted Mutamers'**
  String get trustedPilgrims;

  /// No description provided for @ritualsDocumentation.
  ///
  /// In en, this message translates to:
  /// **'Rituals with Authentic Documentation'**
  String get ritualsDocumentation;

  /// No description provided for @umrahTracking.
  ///
  /// In en, this message translates to:
  /// **'Umrah Rituals Tracking'**
  String get umrahTracking;

  /// No description provided for @trackLocation.
  ///
  /// In en, this message translates to:
  /// **'Track Location'**
  String get trackLocation;

  /// No description provided for @umrahForBeneficiary.
  ///
  /// In en, this message translates to:
  /// **'Umrah for {beneficiary}'**
  String umrahForBeneficiary(String beneficiary);

  /// No description provided for @beneficiaryMartyr.
  ///
  /// In en, this message translates to:
  /// **'Martyr'**
  String get beneficiaryMartyr;

  /// No description provided for @beneficiarySick.
  ///
  /// In en, this message translates to:
  /// **'Sick'**
  String get beneficiarySick;

  /// No description provided for @beneficiaryDeceased.
  ///
  /// In en, this message translates to:
  /// **'Deceased'**
  String get beneficiaryDeceased;

  /// No description provided for @beneficiaryHelpless.
  ///
  /// In en, this message translates to:
  /// **'Helpless'**
  String get beneficiaryHelpless;

  /// No description provided for @completedStatus.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedStatus;

  /// No description provided for @hijriMonth1.
  ///
  /// In en, this message translates to:
  /// **'Muharram'**
  String get hijriMonth1;

  /// No description provided for @hijriMonth2.
  ///
  /// In en, this message translates to:
  /// **'Safar'**
  String get hijriMonth2;

  /// No description provided for @hijriMonth3.
  ///
  /// In en, this message translates to:
  /// **'Rabi Al-Awwal'**
  String get hijriMonth3;

  /// No description provided for @hijriMonth4.
  ///
  /// In en, this message translates to:
  /// **'Rabi Al-Thani'**
  String get hijriMonth4;

  /// No description provided for @hijriMonth5.
  ///
  /// In en, this message translates to:
  /// **'Jumada Al-Awwal'**
  String get hijriMonth5;

  /// No description provided for @hijriMonth6.
  ///
  /// In en, this message translates to:
  /// **'Jumada Al-Thani'**
  String get hijriMonth6;

  /// No description provided for @hijriMonth7.
  ///
  /// In en, this message translates to:
  /// **'Rajab'**
  String get hijriMonth7;

  /// No description provided for @hijriMonth8.
  ///
  /// In en, this message translates to:
  /// **'Shaban'**
  String get hijriMonth8;

  /// No description provided for @hijriMonth9.
  ///
  /// In en, this message translates to:
  /// **'Ramadan'**
  String get hijriMonth9;

  /// No description provided for @hijriMonth10.
  ///
  /// In en, this message translates to:
  /// **'Shawwal'**
  String get hijriMonth10;

  /// No description provided for @hijriMonth11.
  ///
  /// In en, this message translates to:
  /// **'Dhul Qadah'**
  String get hijriMonth11;

  /// No description provided for @hijriMonth12.
  ///
  /// In en, this message translates to:
  /// **'Dhul Hijjah'**
  String get hijriMonth12;

  /// No description provided for @inProgressStatus.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgressStatus;

  /// No description provided for @fajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get fajr;

  /// No description provided for @fajrPrayer.
  ///
  /// In en, this message translates to:
  /// **'Fajr Prayer'**
  String get fajrPrayer;

  /// No description provided for @sunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunrise;

  /// No description provided for @dhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get dhuhr;

  /// No description provided for @dhuhrPrayer.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr Prayer'**
  String get dhuhrPrayer;

  /// No description provided for @asr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get asr;

  /// No description provided for @asrPrayer.
  ///
  /// In en, this message translates to:
  /// **'Asr Prayer'**
  String get asrPrayer;

  /// No description provided for @maghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get maghrib;

  /// No description provided for @maghribPrayer.
  ///
  /// In en, this message translates to:
  /// **'Maghrib Prayer'**
  String get maghribPrayer;

  /// No description provided for @isha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get isha;

  /// No description provided for @ishaPrayer.
  ///
  /// In en, this message translates to:
  /// **'Isha Prayer'**
  String get ishaPrayer;

  /// No description provided for @prayerTimeAlert.
  ///
  /// In en, this message translates to:
  /// **'It\'s time for {prayerName}'**
  String prayerTimeAlert(String prayerName);

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllAsRead;

  /// No description provided for @quranVerse.
  ///
  /// In en, this message translates to:
  /// **'( And complete the Hajj and \'umrah for Allah )'**
  String get quranVerse;

  /// No description provided for @ongoingOmrah.
  ///
  /// In en, this message translates to:
  /// **'Ongoing Umrah...'**
  String get ongoingOmrah;

  /// No description provided for @reviewDetails.
  ///
  /// In en, this message translates to:
  /// **'Review Details'**
  String get reviewDetails;

  /// No description provided for @mutamerRating.
  ///
  /// In en, this message translates to:
  /// **'Mutamer Rating'**
  String get mutamerRating;

  /// No description provided for @rateMutamerDesc.
  ///
  /// In en, this message translates to:
  /// **'Please rate the mutamer based on your experience'**
  String get rateMutamerDesc;

  /// No description provided for @userRoleName.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get userRoleName;

  /// No description provided for @noComment.
  ///
  /// In en, this message translates to:
  /// **'No comment'**
  String get noComment;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get selectGender;

  /// No description provided for @pleaseSelectGender.
  ///
  /// In en, this message translates to:
  /// **'Please select gender'**
  String get pleaseSelectGender;

  /// No description provided for @notReachedStatus.
  ///
  /// In en, this message translates to:
  /// **'Not Reached'**
  String get notReachedStatus;

  /// No description provided for @ihram.
  ///
  /// In en, this message translates to:
  /// **'Ihram'**
  String get ihram;

  /// No description provided for @miqat.
  ///
  /// In en, this message translates to:
  /// **'Miqat'**
  String get miqat;

  /// No description provided for @mekatInstruction1Title.
  ///
  /// In en, this message translates to:
  /// **'Bathing and Perfuming'**
  String get mekatInstruction1Title;

  /// No description provided for @mekatInstruction1Desc.
  ///
  /// In en, this message translates to:
  /// **'It is recommended for a Muslim to bathe and apply perfume before Ihram.\n\n• Bathing is a confirmed Sunnah before Ihram\n• A man applies perfume to his body (not to the Ihram clothes)\n• A woman avoids perfume if she will intermingle with men\n\nThe purpose of this is:\n• Cleanliness\n• Preparing to enter the ritual'**
  String get mekatInstruction1Desc;

  /// No description provided for @mekatInstruction2Title.
  ///
  /// In en, this message translates to:
  /// **'Wearing Ihram Clothes'**
  String get mekatInstruction2Title;

  /// No description provided for @mekatInstruction2Desc.
  ///
  /// In en, this message translates to:
  /// **'How to wear Ihram clothes:\n\nFor men:\n• Wear an Izar and a Rida (two unsewn pieces of cloth)\n• Do not cover the head\n• Wear sandals (preferably open)\n\nFor women:\n• Wear normal modest clothing (without adornment)\n• No specific color is required\n• Do not wear the Niqab or gloves\n\nNotes:\n• Clothes must be clean\n• Use of perfume is prohibited after Ihram'**
  String get mekatInstruction2Desc;

  /// No description provided for @mekatInstruction3Title.
  ///
  /// In en, this message translates to:
  /// **'Intention'**
  String get mekatInstruction3Title;

  /// No description provided for @mekatInstruction3Desc.
  ///
  /// In en, this message translates to:
  /// **'Intention is the entering into the ritual.\n\n• Its place is the heart (verbalization is not required)\n• It is recommended to say:\n\"Labbayk Allahumma Umrah\"\n\nNotes:\n• Intention should be made upon reaching the Miqat\n• Ihram is not valid without intention'**
  String get mekatInstruction3Desc;

  /// No description provided for @mekatInstruction4Title.
  ///
  /// In en, this message translates to:
  /// **'Miqat'**
  String get mekatInstruction4Title;

  /// No description provided for @mekatInstruction4Desc.
  ///
  /// In en, this message translates to:
  /// **'The Miqat is the place from which Ihram must be assumed.\n\n• It is not permissible to pass it without Ihram for those intending Umrah\n\nFamous Miqats:\n• Dhu\'l-Hulayfah (People of Madinah)\n• Al-Juhfah (People of Sham)\n• Qarn al-Manazil (People of Najd)\n• Yalamlam (People of Yemen)\n• Dhat Irq (People of Iraq)\n\nNotes:\n• Those within the Miqat boundaries assume Ihram from their place\n• Those in an airplane assume Ihram when parallel to the Miqat'**
  String get mekatInstruction4Desc;

  /// No description provided for @mekatInstruction5Title.
  ///
  /// In en, this message translates to:
  /// **'Talbiyah'**
  String get mekatInstruction5Title;

  /// No description provided for @mekatInstruction5Desc.
  ///
  /// In en, this message translates to:
  /// **'The pilgrim begins the Talbiyah immediately after assuming Ihram.\n\nText of the Talbiyah:\n\"Labbayk Allahumma Umrah, Labbayka la sharika laka Labbayk, Innal-hamda wan-ni\'mata laka wal-mulk, la sharika lak\"\n\nWhen to say it:\n• Immediately after the intention\n• Repeated during the way to Makkah\n\nNotes:\n• A man raises his voice with it\n• A woman says it in a low voice\n• It continues until the start of Tawaf'**
  String get mekatInstruction5Desc;

  /// No description provided for @tawaf.
  ///
  /// In en, this message translates to:
  /// **'Tawaf'**
  String get tawaf;

  /// No description provided for @tawafInstruction1Title.
  ///
  /// In en, this message translates to:
  /// **'Entering Al-Masjid Al-Haram'**
  String get tawafInstruction1Title;

  /// No description provided for @tawafInstruction1Desc.
  ///
  /// In en, this message translates to:
  /// **'When entering Al-Masjid Al-Haram:\n\n• Enter with the right foot\n• Say: \"Bismillah, Allahumma salli \'ala Muhammad\"\n• And say: \"Allahumma-ftah li abwaba rahmatik\"\n\nNotes:\n• Enter with tranquility and calmness\n• Do not crowd people\n• Recall the greatness of the place'**
  String get tawafInstruction1Desc;

  /// No description provided for @tawafInstruction2Title.
  ///
  /// In en, this message translates to:
  /// **'At the Black Stone'**
  String get tawafInstruction2Title;

  /// No description provided for @tawafInstruction2Desc.
  ///
  /// In en, this message translates to:
  /// **'Upon reaching the Black Stone:\n\n• If possible: Touch it with your right hand and kiss it\n• If you cannot: Touch it with your hand and kiss your hand\n• If you cannot: Point to it with your hand and say \"Allahu Akbar\"\n\nNotes:\n• Do not harm others by crowding\n• Pointing is sufficient during crowding'**
  String get tawafInstruction2Desc;

  /// No description provided for @tawafInstruction3Title.
  ///
  /// In en, this message translates to:
  /// **'Tawaf around the Kaaba'**
  String get tawafInstruction3Title;

  /// No description provided for @tawafInstruction3Desc.
  ///
  /// In en, this message translates to:
  /// **'How to perform Tawaf:\n\n• Keep the Kaaba to your left\n• Start from the Black Stone\n• Perform 7 complete rounds\n\nNotes:\n• Each round starts and ends at the Black Stone\n• It is recommended to hasten slightly (Raml) for men in the first 3 rounds\n• Normal walking in the remaining rounds'**
  String get tawafInstruction3Desc;

  /// No description provided for @tawafInstruction4Title.
  ///
  /// In en, this message translates to:
  /// **'Remembrance and Supplication during Tawaf'**
  String get tawafInstruction4Title;

  /// No description provided for @tawafInstruction4Desc.
  ///
  /// In en, this message translates to:
  /// **'During Tawaf:\n\n• Increase remembrance and supplication\n• Read what is easy of the Quran\n\nIt is recommended between the Yemeni Corner and the Black Stone:\n\"Rabbana atina fid-dunya hasanatan wa fil-akhirati hasanatan wa qina \'adhaban-nar\"\n\nNotes:\n• There is no specific supplication for each round\n• Supplicate for whatever you wish'**
  String get tawafInstruction4Desc;

  /// No description provided for @tawafInstruction5Title.
  ///
  /// In en, this message translates to:
  /// **'Praying two Raka\'ahs after Tawaf'**
  String get tawafInstruction5Title;

  /// No description provided for @tawafInstruction5Desc.
  ///
  /// In en, this message translates to:
  /// **'After finishing Tawaf:\n\n• Pray two Raka\'ahs behind Maqam Ibrahim if possible\n• If not possible, pray anywhere in the Masjid\n\nIn the two Raka\'ahs:\n• Read Al-Fatihah\n• Preferably read:\n  - Al-Kafirun in the first\n  - Al-Ikhlas in the second\n\nNotes:\n• Do not crowd people at the Maqam'**
  String get tawafInstruction5Desc;

  /// No description provided for @makamInstruction1Title.
  ///
  /// In en, this message translates to:
  /// **'Heading to Maqam Ibrahim'**
  String get makamInstruction1Title;

  /// No description provided for @makamInstruction1Desc.
  ///
  /// In en, this message translates to:
  /// **'After finishing Tawaf:\n\n• Head to Maqam Ibrahim if possible\n• Place the Maqam between yourself and the Kaaba\n\nAllah Almighty said:\n\"And take, [O believers], from the standing place of Abraham a place of prayer\"\n\nNotes:\n• It is not necessary to stand directly next to the Maqam\n• You can pray anywhere inside the Mosque'**
  String get makamInstruction1Desc;

  /// No description provided for @makamInstruction2Title.
  ///
  /// In en, this message translates to:
  /// **'Praying two Rak\'ahs'**
  String get makamInstruction2Title;

  /// No description provided for @makamInstruction2Desc.
  ///
  /// In en, this message translates to:
  /// **'Pray two Rak\'ahs after Tawaf:\n\n• The first Rak\'ah:\n  - Al-Fatiha\n  - Surah Al-Kafirun (recommended)\n\n• The second Rak\'ah:\n  - Al-Fatiha\n  - Surah Al-Ikhlas (recommended)\n\nNotes:\n• Prayer is a confirmed Sunnah after Tawaf\n• Do not crowd people for the sake of praying at the Maqam'**
  String get makamInstruction2Desc;

  /// No description provided for @makamInstruction3Title.
  ///
  /// In en, this message translates to:
  /// **'Prayer Place'**
  String get makamInstruction3Title;

  /// No description provided for @makamInstruction3Desc.
  ///
  /// In en, this message translates to:
  /// **'Prayer Place:\n\n• Best: Behind Maqam Ibrahim\n• If not possible due to crowding:\n  - Pray anywhere inside the Grand Mosque\n\nNotes:\n• Avoid extreme crowding\n• Reverence is better than proximity'**
  String get makamInstruction3Desc;

  /// No description provided for @makamInstruction4Title.
  ///
  /// In en, this message translates to:
  /// **'After Prayer'**
  String get makamInstruction4Title;

  /// No description provided for @makamInstruction4Desc.
  ///
  /// In en, this message translates to:
  /// **'After finishing the two Rak\'ahs:\n\n• Drink from Zamzam water if possible\n• Supplicate to Allah as you wish\n• Prepare to go for Sa\'i between Safa and Marwa\n\nNotes:\n• Zamzam water is Sunnah, not obligatory\n• It is recommended to supplicate a lot'**
  String get makamInstruction4Desc;

  /// No description provided for @pleaseCompleteInstructions.
  ///
  /// In en, this message translates to:
  /// **'Please complete all instructions to proceed'**
  String get pleaseCompleteInstructions;

  /// No description provided for @pleaseReadInstructionsCarefully.
  ///
  /// In en, this message translates to:
  /// **'Please read the instructions carefully to perform Tawaf correctly'**
  String get pleaseReadInstructionsCarefully;

  /// No description provided for @pleaseVerifyMapFirst.
  ///
  /// In en, this message translates to:
  /// **'Please complete map verification first'**
  String get pleaseVerifyMapFirst;

  /// No description provided for @prayerBehindMakam.
  ///
  /// In en, this message translates to:
  /// **'Prayer behind the Station of Ibrahim'**
  String get prayerBehindMakam;

  /// No description provided for @makamIbrahim.
  ///
  /// In en, this message translates to:
  /// **'Maqam Ibrahim'**
  String get makamIbrahim;

  /// No description provided for @sai.
  ///
  /// In en, this message translates to:
  /// **'Sa\'i between Safa and Marwa'**
  String get sai;

  /// No description provided for @safaMarwaInstruction1Title.
  ///
  /// In en, this message translates to:
  /// **'Heading to Safa'**
  String get safaMarwaInstruction1Title;

  /// No description provided for @safaMarwaInstruction1Desc.
  ///
  /// In en, this message translates to:
  /// **'After finishing Tawaf and praying two Raka\'ahs:\n\n• Head to Safa Hill to start Sa\'i\n• When approaching, read:\n\"Innas-Safa wal-Marwata min sha\'a\'irillah\"\n\nNotes:\n• This verse is said once at the beginning of Sa\'i'**
  String get safaMarwaInstruction1Desc;

  /// No description provided for @safaMarwaInstruction2Title.
  ///
  /// In en, this message translates to:
  /// **'Standing on Safa'**
  String get safaMarwaInstruction2Title;

  /// No description provided for @safaMarwaInstruction2Desc.
  ///
  /// In en, this message translates to:
  /// **'Upon ascending Safa Hill:\n\n• Face the Kaaba if possible\n• Raise your hands and supplicate to Allah\n\nIt is recommended to say:\n\"Allahu Akbar, Allahu Akbar, Allahu Akbar\nLa ilaha illallahu wahdahu la sharika lah...\"\n\nNotes:\n• Repeat the remembrance and supplication 3 times\n• Supplicate for whatever good you wish of this world and the hereafter'**
  String get safaMarwaInstruction2Desc;

  /// No description provided for @safaMarwaInstruction3Title.
  ///
  /// In en, this message translates to:
  /// **'Sa\'i between Safa and Marwa'**
  String get safaMarwaInstruction3Title;

  /// No description provided for @safaMarwaInstruction3Desc.
  ///
  /// In en, this message translates to:
  /// **'Start Sa\'i from Safa to Marwa:\n\n• Set your direction toward Marwa\n• At the two green markers:\n  - Men hasten (light jogging)\n  - Women walk normally\n\nNotes:\n• The rest of the distance is normal walking\n• Increase remembrance and supplication'**
  String get safaMarwaInstruction3Desc;

  /// No description provided for @safaMarwaInstruction4Title.
  ///
  /// In en, this message translates to:
  /// **'Number of Rounds'**
  String get safaMarwaInstruction4Title;

  /// No description provided for @safaMarwaInstruction4Desc.
  ///
  /// In en, this message translates to:
  /// **'Number of Sa\'i rounds:\n\n• 7 complete rounds\n\nThe method:\n• From Safa to Marwa = round 1\n• From Marwa to Safa = round 2\n• And so on until you finish at Marwa\n\nNotes:\n• Start from Safa\n• End at Marwa'**
  String get safaMarwaInstruction4Desc;

  /// No description provided for @safaMarwaInstruction5Title.
  ///
  /// In en, this message translates to:
  /// **'Supplication during Sa\'i'**
  String get safaMarwaInstruction5Title;

  /// No description provided for @safaMarwaInstruction5Desc.
  ///
  /// In en, this message translates to:
  /// **'During Sa\'i:\n\n• Increase supplication and remembrance\n• Read what is easy of the Quran\n\nNotes:\n• There is no specific supplication for each round\n• Supplicate for whatever you love'**
  String get safaMarwaInstruction5Desc;

  /// No description provided for @safaMarwaInstruction6Title.
  ///
  /// In en, this message translates to:
  /// **'After finishing Sa\'i'**
  String get safaMarwaInstruction6Title;

  /// No description provided for @safaMarwaInstruction6Desc.
  ///
  /// In en, this message translates to:
  /// **'After completing 7 rounds:\n\n• You have finished Sa\'i\n• Prepare for shaving or cutting hair\n\nNotes:\n• Sa\'i is a pillar of Umrah\n• Umrah is not valid without it'**
  String get safaMarwaInstruction6Desc;

  /// No description provided for @saiMinimized.
  ///
  /// In en, this message translates to:
  /// **'Sa\'i'**
  String get saiMinimized;

  /// No description provided for @tahalol.
  ///
  /// In en, this message translates to:
  /// **'Tahallull'**
  String get tahalol;

  /// No description provided for @shaving.
  ///
  /// In en, this message translates to:
  /// **'Shaving'**
  String get shaving;

  /// No description provided for @finishedUmrah.
  ///
  /// In en, this message translates to:
  /// **'Umrah Finished'**
  String get finishedUmrah;

  /// No description provided for @umrahTrackingFinishedStep.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get umrahTrackingFinishedStep;

  /// No description provided for @quranQuoteHome.
  ///
  /// In en, this message translates to:
  /// **'Who feared the Most Merciful in the unseen and came with a heart returning [in repentance].'**
  String get quranQuoteHome;

  /// No description provided for @enterRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Enter the required fields'**
  String get enterRequiredFields;

  /// No description provided for @forWhomOmra.
  ///
  /// In en, this message translates to:
  /// **'For whom is the Umrah?'**
  String get forWhomOmra;

  /// No description provided for @beneficiaryCondition.
  ///
  /// In en, this message translates to:
  /// **'Beneficiary condition'**
  String get beneficiaryCondition;

  /// No description provided for @beneficiaryGenderLabel.
  ///
  /// In en, this message translates to:
  /// **'Beneficiary gender'**
  String get beneficiaryGenderLabel;

  /// No description provided for @requesterName.
  ///
  /// In en, this message translates to:
  /// **'Requester'**
  String get requesterName;

  /// No description provided for @pleaseSelectOmraType.
  ///
  /// In en, this message translates to:
  /// **'Please select the Umrah type'**
  String get pleaseSelectOmraType;

  /// No description provided for @beneficiaryNameHint.
  ///
  /// In en, this message translates to:
  /// **'Beneficiary Name'**
  String get beneficiaryNameHint;

  /// No description provided for @pleaseEnterBeneficiaryName.
  ///
  /// In en, this message translates to:
  /// **'Please enter the beneficiary name'**
  String get pleaseEnterBeneficiaryName;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @deleteImage.
  ///
  /// In en, this message translates to:
  /// **'Delete Image'**
  String get deleteImage;

  /// No description provided for @pleaseUploadBeneficiaryImage.
  ///
  /// In en, this message translates to:
  /// **'Please upload the beneficiary image'**
  String get pleaseUploadBeneficiaryImage;

  /// No description provided for @writeYourNotes.
  ///
  /// In en, this message translates to:
  /// **'Write your notes'**
  String get writeYourNotes;

  /// No description provided for @requestDate.
  ///
  /// In en, this message translates to:
  /// **'Request Date'**
  String get requestDate;

  /// No description provided for @pleaseSelectRequestDate.
  ///
  /// In en, this message translates to:
  /// **'Please select the request date'**
  String get pleaseSelectRequestDate;

  /// No description provided for @assignUmrahProvider.
  ///
  /// In en, this message translates to:
  /// **'Assign Umrah Provider'**
  String get assignUmrahProvider;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @submitOrderErrorDesc.
  ///
  /// In en, this message translates to:
  /// **'Make sure to enter all fields correctly and try again'**
  String get submitOrderErrorDesc;

  /// No description provided for @orderSubmittedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Order submitted successfully'**
  String get orderSubmittedSuccessfully;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @confirmText.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmText;

  /// No description provided for @pilgrims.
  ///
  /// In en, this message translates to:
  /// **'Pilgrims'**
  String get pilgrims;

  /// No description provided for @martyr.
  ///
  /// In en, this message translates to:
  /// **'Martyr'**
  String get martyr;

  /// No description provided for @sick.
  ///
  /// In en, this message translates to:
  /// **'Sick'**
  String get sick;

  /// No description provided for @deceased.
  ///
  /// In en, this message translates to:
  /// **'Deceased'**
  String get deceased;

  /// No description provided for @helpless.
  ///
  /// In en, this message translates to:
  /// **'Helpless'**
  String get helpless;

  /// No description provided for @omra.
  ///
  /// In en, this message translates to:
  /// **'Umrah'**
  String get omra;

  /// No description provided for @sendRequest.
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get sendRequest;

  /// No description provided for @shareProviderProfile.
  ///
  /// In en, this message translates to:
  /// **'Meet {name} (@{username}) - A verified Umrah provider on Moneeb 🕋\n\nMoneeb is a platform specialized in proxy Umrah, allowing users to request Umrah on behalf of the sick, the elderly, the deceased, and martyrs through verified and accredited Umrah providers approved by the app administration.\n\nThe app provides a reliable and transparent experience, enabling the requester to follow all stages of Umrah execution step by step, with documentation for each stage through photos, videos, and live location during execution.\n\nMoneeb... A documented and transparent experience for proxy Umrah with full confidence and peace of mind.'**
  String shareProviderProfile(String name, String username);

  /// No description provided for @repeatTheseAzkarWithHumilityAndSincerityToGod.
  ///
  /// In en, this message translates to:
  /// **'Repeat these azkar and preserve them with humility and pure intention for God'**
  String get repeatTheseAzkarWithHumilityAndSincerityToGod;

  /// No description provided for @toBeSaidAtLeast.
  ///
  /// In en, this message translates to:
  /// **'To be said {count} times at least'**
  String toBeSaidAtLeast(String count);

  /// No description provided for @underReview.
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get underReview;

  /// No description provided for @profileChangesUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Your Request is Under Review'**
  String get profileChangesUnderReview;

  /// No description provided for @profileChangesUnderReviewDescription.
  ///
  /// In en, this message translates to:
  /// **'Your changes have been submitted successfully and are now under review by the administration.\nYou will be notified once the changes are approved or rejected.'**
  String get profileChangesUnderReviewDescription;

  /// No description provided for @umrahRequestAccepted.
  ///
  /// In en, this message translates to:
  /// **'Umrah request accepted'**
  String get umrahRequestAccepted;

  /// No description provided for @umrahRequestRejected.
  ///
  /// In en, this message translates to:
  /// **'Umrah request rejected'**
  String get umrahRequestRejected;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get orderDetails;

  /// No description provided for @umrahFor.
  ///
  /// In en, this message translates to:
  /// **'Umrah for {type}'**
  String umrahFor(Object type);

  /// No description provided for @serialNumber.
  ///
  /// In en, this message translates to:
  /// **'Serial Number'**
  String get serialNumber;

  /// No description provided for @beneficiaryImage.
  ///
  /// In en, this message translates to:
  /// **'Beneficiary Image'**
  String get beneficiaryImage;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @pilgrimName.
  ///
  /// In en, this message translates to:
  /// **'Pilgrim Name'**
  String get pilgrimName;

  /// No description provided for @pilgrimImage.
  ///
  /// In en, this message translates to:
  /// **'Pilgrim Image'**
  String get pilgrimImage;

  /// No description provided for @autoAssignPilgrim.
  ///
  /// In en, this message translates to:
  /// **'Automatically assign pilgrim'**
  String get autoAssignPilgrim;

  /// No description provided for @firstPageTitleForUser.
  ///
  /// In en, this message translates to:
  /// **'--'**
  String get firstPageTitleForUser;

  /// No description provided for @firstPageDescriptionForUser.
  ///
  /// In en, this message translates to:
  /// **'----'**
  String get firstPageDescriptionForUser;

  /// No description provided for @secondPageTitleForUser.
  ///
  /// In en, this message translates to:
  /// **'--'**
  String get secondPageTitleForUser;

  /// No description provided for @secondPageDescriptionForUser.
  ///
  /// In en, this message translates to:
  /// **'----'**
  String get secondPageDescriptionForUser;

  /// No description provided for @thirdPageTitleForUser.
  ///
  /// In en, this message translates to:
  /// **'--'**
  String get thirdPageTitleForUser;

  /// No description provided for @thirdPageDescriptionForUser.
  ///
  /// In en, this message translates to:
  /// **'----'**
  String get thirdPageDescriptionForUser;

  /// No description provided for @firstPageTitle.
  ///
  /// In en, this message translates to:
  /// **'--'**
  String get firstPageTitle;

  /// No description provided for @firstPageDescription.
  ///
  /// In en, this message translates to:
  /// **'----'**
  String get firstPageDescription;

  /// No description provided for @secondPageTitle.
  ///
  /// In en, this message translates to:
  /// **'--'**
  String get secondPageTitle;

  /// No description provided for @secondPageDescription.
  ///
  /// In en, this message translates to:
  /// **'----'**
  String get secondPageDescription;

  /// No description provided for @thirdPageTitle.
  ///
  /// In en, this message translates to:
  /// **'--'**
  String get thirdPageTitle;

  /// No description provided for @thirdPageDescription.
  ///
  /// In en, this message translates to:
  /// **'----'**
  String get thirdPageDescription;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @useSystemSetting.
  ///
  /// In en, this message translates to:
  /// **'Use System Setting'**
  String get useSystemSetting;

  /// No description provided for @deleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting'**
  String get deleting;

  /// No description provided for @deleteChat.
  ///
  /// In en, this message translates to:
  /// **'Delete Chat'**
  String get deleteChat;

  /// No description provided for @areYouSureYouWantToDeleteThisChat.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this chat?'**
  String get areYouSureYouWantToDeleteThisChat;

  /// No description provided for @chatDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Chat Deleted Successfully'**
  String get chatDeletedSuccessfully;

  /// No description provided for @contactToExpert.
  ///
  /// In en, this message translates to:
  /// **'Contact the expert'**
  String get contactToExpert;

  /// No description provided for @chatListTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get chatListTitle;

  /// No description provided for @youSent.
  ///
  /// In en, this message translates to:
  /// **'You sent'**
  String get youSent;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'sent'**
  String get sent;

  /// No description provided for @clearChat.
  ///
  /// In en, this message translates to:
  /// **'Clear chat'**
  String get clearChat;

  /// No description provided for @clearChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear chat !'**
  String get clearChatTitle;

  /// No description provided for @muteNotification.
  ///
  /// In en, this message translates to:
  /// **'Mute Notification'**
  String get muteNotification;

  /// No description provided for @viewProfile.
  ///
  /// In en, this message translates to:
  /// **'View {firstName} profile'**
  String viewProfile(String firstName);

  /// No description provided for @clearChatDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear chat with  {chatUserName}? if you confirm that, you cant restore messages again'**
  String clearChatDescription(String chatUserName);

  /// No description provided for @deleteChatDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete chat with {chatUserName}? If you confirm, you can\'t restore the chat.'**
  String deleteChatDescription(String chatUserName);

  /// No description provided for @caption.
  ///
  /// In en, this message translates to:
  /// **'Caption'**
  String get caption;

  /// No description provided for @clearChatWithMessage.
  ///
  /// In en, this message translates to:
  /// **'Clear chat messages from your side'**
  String get clearChatWithMessage;

  /// No description provided for @chatCardName.
  ///
  /// In en, this message translates to:
  /// **'chat'**
  String get chatCardName;

  /// No description provided for @messageCardName.
  ///
  /// In en, this message translates to:
  /// **'message'**
  String get messageCardName;

  /// No description provided for @anOffer.
  ///
  /// In en, this message translates to:
  /// **'an offer'**
  String get anOffer;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @sendTo.
  ///
  /// In en, this message translates to:
  /// **'Send to'**
  String get sendTo;

  /// No description provided for @sendFailed.
  ///
  /// In en, this message translates to:
  /// **'Send failed'**
  String get sendFailed;

  /// No description provided for @deletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Deleted message'**
  String get deletedMessage;

  /// No description provided for @preparingChatRoom.
  ///
  /// In en, this message translates to:
  /// **'Preparing chat room ...'**
  String get preparingChatRoom;

  /// No description provided for @messageCopied.
  ///
  /// In en, this message translates to:
  /// **'Message copied!'**
  String get messageCopied;

  /// No description provided for @unMute.
  ///
  /// In en, this message translates to:
  /// **'Un mute'**
  String get unMute;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @clearChatSuccess.
  ///
  /// In en, this message translates to:
  /// **'Chat cleared successfully'**
  String get clearChatSuccess;

  /// No description provided for @chatMutedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Chat muted successfully'**
  String get chatMutedSuccessfully;

  /// No description provided for @chatUnMutedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Chat un muted successfully'**
  String get chatUnMutedSuccessfully;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'offline'**
  String get offline;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'online'**
  String get online;

  /// No description provided for @isAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get isAvailable;

  /// No description provided for @isNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get isNotAvailable;

  /// No description provided for @offlineVisibilityWarning.
  ///
  /// In en, this message translates to:
  /// **'When you are not available, you will not appear to Umrah requesters.'**
  String get offlineVisibilityWarning;

  /// No description provided for @activeNow.
  ///
  /// In en, this message translates to:
  /// **'active now'**
  String get activeNow;

  /// No description provided for @activeSince.
  ///
  /// In en, this message translates to:
  /// **'active since'**
  String get activeSince;

  /// No description provided for @minuteSince.
  ///
  /// In en, this message translates to:
  /// **'minute'**
  String get minuteSince;

  /// No description provided for @hourSince.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get hourSince;

  /// No description provided for @exitWarning.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit?'**
  String get exitWarning;

  /// No description provided for @exitWarningDescription.
  ///
  /// In en, this message translates to:
  /// **'if you leave this record will be deleted'**
  String get exitWarningDescription;

  /// No description provided for @couldNotFindTheReply.
  ///
  /// In en, this message translates to:
  /// **'Could not find the reply, the message maybe has been deleted'**
  String get couldNotFindTheReply;

  /// No description provided for @youHavenTAnyMessage.
  ///
  /// In en, this message translates to:
  /// **'You haven’t any message yet, Start chatting'**
  String get youHavenTAnyMessage;

  /// No description provided for @youHavenTAnyMessageYet.
  ///
  /// In en, this message translates to:
  /// **'You haven’t any message yet'**
  String get youHavenTAnyMessageYet;

  /// No description provided for @deleteText.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteText;

  /// No description provided for @deleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete Message'**
  String get deleteMessage;

  /// No description provided for @areYouSureYouWantToDeleteThisMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this message'**
  String get areYouSureYouWantToDeleteThisMessage;

  /// No description provided for @youBlockedDec.
  ///
  /// In en, this message translates to:
  /// **'You have blocked this user, you can not communicate with each other '**
  String get youBlockedDec;

  /// No description provided for @language_settings.
  ///
  /// In en, this message translates to:
  /// **'Language Settings'**
  String get language_settings;

  /// No description provided for @change_password_settings.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password_settings;

  /// No description provided for @orders_settings.
  ///
  /// In en, this message translates to:
  /// **'Orders Settings'**
  String get orders_settings;

  /// No description provided for @my_rate_settings.
  ///
  /// In en, this message translates to:
  /// **'My Ratings'**
  String get my_rate_settings;

  /// No description provided for @verify_moneeb_settings.
  ///
  /// In en, this message translates to:
  /// **'Verify Moneeb'**
  String get verify_moneeb_settings;

  /// No description provided for @policy_settings.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get policy_settings;

  /// No description provided for @terms_settings.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get terms_settings;

  /// No description provided for @about_settings.
  ///
  /// In en, this message translates to:
  /// **'About Moneeb'**
  String get about_settings;

  /// No description provided for @who_moneeb_settings.
  ///
  /// In en, this message translates to:
  /// **'Who is Moneeb?'**
  String get who_moneeb_settings;

  /// No description provided for @tazkiyah_settings.
  ///
  /// In en, this message translates to:
  /// **'Tazkiyah'**
  String get tazkiyah_settings;

  /// No description provided for @logout_settings.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout_settings;

  /// No description provided for @delete_account_settings.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account_settings;

  /// No description provided for @delete_account_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account_dialog_title;

  /// No description provided for @delete_account_dialog_desc.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. Your account will be deactivated immediately and your request for final deletion will be submitted to the administration.'**
  String get delete_account_dialog_desc;

  /// No description provided for @delete_account_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Confirm Final Deletion'**
  String get delete_account_confirm_title;

  /// No description provided for @delete_account_confirm_desc.
  ///
  /// In en, this message translates to:
  /// **'Are you absolutely sure? You will not be able to access your account after this action.'**
  String get delete_account_confirm_desc;

  /// No description provided for @delete_account_success.
  ///
  /// In en, this message translates to:
  /// **'Account deletion request submitted successfully'**
  String get delete_account_success;

  /// No description provided for @account_will_be_deleted.
  ///
  /// In en, this message translates to:
  /// **'Your request will be reviewed and the account will be permanently deleted'**
  String get account_will_be_deleted;

  /// No description provided for @i_understand_delete_my_account.
  ///
  /// In en, this message translates to:
  /// **'I understand and agree to permanently and completely delete my account'**
  String get i_understand_delete_my_account;

  /// No description provided for @trusted_platform_badge.
  ///
  /// In en, this message translates to:
  /// **'Moneeb .. a trusted Saudi platform with a commercial registration'**
  String get trusted_platform_badge;

  /// No description provided for @follow_us.
  ///
  /// In en, this message translates to:
  /// **'Follow us on our page!'**
  String get follow_us;

  /// No description provided for @social_media_description.
  ///
  /// In en, this message translates to:
  /// **'We are happy to have you with us! Follow us for more updates.'**
  String get social_media_description;

  /// No description provided for @app_version.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get app_version;

  /// No description provided for @select_language.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get select_language;

  /// No description provided for @select_your_language.
  ///
  /// In en, this message translates to:
  /// **'Select your language'**
  String get select_your_language;

  /// No description provided for @homeNav.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeNav;

  /// No description provided for @ordersNav.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersNav;

  /// No description provided for @requestOmraNav.
  ///
  /// In en, this message translates to:
  /// **'Request'**
  String get requestOmraNav;

  /// No description provided for @zadNav.
  ///
  /// In en, this message translates to:
  /// **'Zad'**
  String get zadNav;

  /// No description provided for @settingsNav.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsNav;

  /// No description provided for @stories.
  ///
  /// In en, this message translates to:
  /// **'Stories'**
  String get stories;

  /// No description provided for @no_stories_available.
  ///
  /// In en, this message translates to:
  /// **'No stories available at the moment'**
  String get no_stories_available;

  /// No description provided for @banners.
  ///
  /// In en, this message translates to:
  /// **'Banners'**
  String get banners;

  /// No description provided for @no_banners_available.
  ///
  /// In en, this message translates to:
  /// **'No banners available'**
  String get no_banners_available;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgot_password;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @registered_email.
  ///
  /// In en, this message translates to:
  /// **'Registered Email'**
  String get registered_email;

  /// No description provided for @forgot_password_description.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a verification code and reset your password.'**
  String get forgot_password_description;

  /// No description provided for @please_enter_email.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get please_enter_email;

  /// No description provided for @continue_label.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_label;

  /// No description provided for @verified_successfully.
  ///
  /// In en, this message translates to:
  /// **'Verified successfully'**
  String get verified_successfully;

  /// No description provided for @code_resent_successfully.
  ///
  /// In en, this message translates to:
  /// **'Code resent successfully'**
  String get code_resent_successfully;

  /// No description provided for @enter_verification_code.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code'**
  String get enter_verification_code;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @didnt_receive_code.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive a code? '**
  String get didnt_receive_code;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @password_updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get password_updated_successfully;

  /// No description provided for @reset_password.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get reset_password;

  /// No description provided for @set_new_password.
  ///
  /// In en, this message translates to:
  /// **'Set New Password'**
  String get set_new_password;

  /// No description provided for @reset_password_instruction.
  ///
  /// In en, this message translates to:
  /// **'Please enter a strong new password.'**
  String get reset_password_instruction;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get new_password;

  /// No description provided for @password_too_short.
  ///
  /// In en, this message translates to:
  /// **'Password too short (min 8 characters)'**
  String get password_too_short;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password;

  /// No description provided for @passwords_do_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwords_do_not_match;

  /// No description provided for @update_password.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get update_password;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @yourRating.
  ///
  /// In en, this message translates to:
  /// **'Your Rating'**
  String get yourRating;

  /// No description provided for @hisRating.
  ///
  /// In en, this message translates to:
  /// **'His Rating'**
  String get hisRating;

  /// No description provided for @myRating.
  ///
  /// In en, this message translates to:
  /// **'My Rating'**
  String get myRating;

  /// No description provided for @myUmrahsExecuted.
  ///
  /// In en, this message translates to:
  /// **'My Executed Umrahs'**
  String get myUmrahsExecuted;

  /// No description provided for @hisUmrahsExecuted.
  ///
  /// In en, this message translates to:
  /// **'His Executed Umrahs'**
  String get hisUmrahsExecuted;

  /// No description provided for @providerImage.
  ///
  /// In en, this message translates to:
  /// **'Provider Image'**
  String get providerImage;

  /// No description provided for @yourProviderImage.
  ///
  /// In en, this message translates to:
  /// **'Your Provider Image'**
  String get yourProviderImage;

  /// No description provided for @providerVideo.
  ///
  /// In en, this message translates to:
  /// **'Provider Video'**
  String get providerVideo;

  /// No description provided for @yourProviderVideo.
  ///
  /// In en, this message translates to:
  /// **'Your Provider Video'**
  String get yourProviderVideo;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet'**
  String get noReviewsYet;

  /// No description provided for @loadingReview.
  ///
  /// In en, this message translates to:
  /// **'Loading review...'**
  String get loadingReview;

  /// No description provided for @accountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account Info'**
  String get accountInfo;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Enter Name'**
  String get enterName;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get enterEmail;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @enterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter Phone Number'**
  String get enterPhone;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get selectCountry;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @providerInfo.
  ///
  /// In en, this message translates to:
  /// **'Provider Info'**
  String get providerInfo;

  /// No description provided for @idNumber.
  ///
  /// In en, this message translates to:
  /// **'ID / National ID'**
  String get idNumber;

  /// No description provided for @enterIdNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter ID or National ID'**
  String get enterIdNumber;

  /// No description provided for @previousUmrahCount.
  ///
  /// In en, this message translates to:
  /// **'Previous Umrah Count'**
  String get previousUmrahCount;

  /// No description provided for @enterPreviousUmrahCount.
  ///
  /// In en, this message translates to:
  /// **'Enter how many Umrahs you performed'**
  String get enterPreviousUmrahCount;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @bioHint.
  ///
  /// In en, this message translates to:
  /// **'Write a short bio that appears to pilgrims'**
  String get bioHint;

  /// No description provided for @isQuranHafiz.
  ///
  /// In en, this message translates to:
  /// **'Quran Hafiz'**
  String get isQuranHafiz;

  /// No description provided for @updatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Updated successfully'**
  String get updatedSuccessfully;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @omrahStepMeqat.
  ///
  /// In en, this message translates to:
  /// **'Meqat'**
  String get omrahStepMeqat;

  /// No description provided for @omrahStepTawaf.
  ///
  /// In en, this message translates to:
  /// **'Tawaf'**
  String get omrahStepTawaf;

  /// No description provided for @omrahStepPrayingBehindMakam.
  ///
  /// In en, this message translates to:
  /// **'Praying behind Makam Ibrahim'**
  String get omrahStepPrayingBehindMakam;

  /// No description provided for @omrahStepMakamIbrahim.
  ///
  /// In en, this message translates to:
  /// **'Makam Ibrahim'**
  String get omrahStepMakamIbrahim;

  /// No description provided for @omrahStepSafaAndMarwa.
  ///
  /// In en, this message translates to:
  /// **'Safa and Marwa'**
  String get omrahStepSafaAndMarwa;

  /// No description provided for @omrahStepSafaAndMarwaShort.
  ///
  /// In en, this message translates to:
  /// **'Safa and Marwa'**
  String get omrahStepSafaAndMarwaShort;

  /// No description provided for @omrahStepTahalol.
  ///
  /// In en, this message translates to:
  /// **'Tahalol'**
  String get omrahStepTahalol;

  /// No description provided for @omrahStepFinishOmrah.
  ///
  /// In en, this message translates to:
  /// **'Finish Umrah'**
  String get omrahStepFinishOmrah;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @phaseMekat.
  ///
  /// In en, this message translates to:
  /// **'Miqat Documentation'**
  String get phaseMekat;

  /// No description provided for @phaseTawaf.
  ///
  /// In en, this message translates to:
  /// **'Tawaf Documentation'**
  String get phaseTawaf;

  /// No description provided for @tawafInstructions.
  ///
  /// In en, this message translates to:
  /// **'Tawaf Instructions'**
  String get tawafInstructions;

  /// No description provided for @documentationTitle.
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get documentationTitle;

  /// No description provided for @tawafVerifyInsideHaram.
  ///
  /// In en, this message translates to:
  /// **'Verify you are inside the Haram'**
  String get tawafVerifyInsideHaram;

  /// No description provided for @tawafVerifyDuaa.
  ///
  /// In en, this message translates to:
  /// **'Verify video of Duaa for the Umrah owner'**
  String get tawafVerifyDuaa;

  /// No description provided for @phaseMakam.
  ///
  /// In en, this message translates to:
  /// **'Maqam Ibrahim Documentation'**
  String get phaseMakam;

  /// No description provided for @makamInstructions.
  ///
  /// In en, this message translates to:
  /// **'Makam Ibrahim Instructions'**
  String get makamInstructions;

  /// No description provided for @makamInstructionDesc.
  ///
  /// In en, this message translates to:
  /// **'Please read the instructions carefully to properly perform the Makam Ibrahim prayer'**
  String get makamInstructionDesc;

  /// No description provided for @makamVerifyFirst.
  ///
  /// In en, this message translates to:
  /// **'verifying the Makam Ibrahim prayer'**
  String get makamVerifyFirst;

  /// No description provided for @makamVerifyImage.
  ///
  /// In en, this message translates to:
  /// **'Picture of the place from behind or the glass dome of the Makam.'**
  String get makamVerifyImage;

  /// No description provided for @phaseSafaAndMarwa.
  ///
  /// In en, this message translates to:
  /// **'Safa and Marwa Documentation'**
  String get phaseSafaAndMarwa;

  /// No description provided for @safaMarwaInstructions.
  ///
  /// In en, this message translates to:
  /// **'Safa and Marwa'**
  String get safaMarwaInstructions;

  /// No description provided for @safaMarwaInstructionDesc.
  ///
  /// In en, this message translates to:
  /// **'Please read instructions carefully to properly perform Safa and Marwa'**
  String get safaMarwaInstructionDesc;

  /// No description provided for @safaMarwaVerifyFirst.
  ///
  /// In en, this message translates to:
  /// **'Verify video while standing on Mount Safa'**
  String get safaMarwaVerifyFirst;

  /// No description provided for @safaMarwaVerifyMap.
  ///
  /// In en, this message translates to:
  /// **'Map tracking for seven rounds'**
  String get safaMarwaVerifyMap;

  /// No description provided for @safaMarwaVerifyInsideMasaa.
  ///
  /// In en, this message translates to:
  /// **'Verify you are inside the Mas\'a between Safa and Marwa'**
  String get safaMarwaVerifyInsideMasaa;

  /// No description provided for @mekatInstructions.
  ///
  /// In en, this message translates to:
  /// **'Ihram Instructions'**
  String get mekatInstructions;

  /// No description provided for @mekatInstructionDesc.
  ///
  /// In en, this message translates to:
  /// **'Please read instructions carefully to properly perform Ihram'**
  String get mekatInstructionDesc;

  /// No description provided for @mekatVerifyFirst.
  ///
  /// In en, this message translates to:
  /// **'First documentation via Google Maps to determine Meqat'**
  String get mekatVerifyFirst;

  /// No description provided for @mekatVerifySecond.
  ///
  /// In en, this message translates to:
  /// **'Second documentation via Video'**
  String get mekatVerifySecond;

  /// No description provided for @phaseTahalol.
  ///
  /// In en, this message translates to:
  /// **'Tahallul Documentation'**
  String get phaseTahalol;

  /// No description provided for @tahalolVideo.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get tahalolVideo;

  /// No description provided for @tahalolVerifyVideo.
  ///
  /// In en, this message translates to:
  /// **'Please select a video or image for Tahalol'**
  String get tahalolVerifyVideo;

  /// No description provided for @tahalolVerifyTitle.
  ///
  /// In en, this message translates to:
  /// **'Tahalol Documentation'**
  String get tahalolVerifyTitle;

  /// No description provided for @tahalolVerifyImageDesc.
  ///
  /// In en, this message translates to:
  /// **'Picture for Tahalol'**
  String get tahalolVerifyImageDesc;

  /// No description provided for @tahalolVerifyVideoDesc.
  ///
  /// In en, this message translates to:
  /// **'Video for Tahalol'**
  String get tahalolVerifyVideoDesc;

  /// No description provided for @omrahJourneyFinishPrefix.
  ///
  /// In en, this message translates to:
  /// **'End of journey '**
  String get omrahJourneyFinishPrefix;

  /// No description provided for @omrahRituals.
  ///
  /// In en, this message translates to:
  /// **'Umrah Rituals'**
  String get omrahRituals;

  /// No description provided for @providerStillDoingStep.
  ///
  /// In en, this message translates to:
  /// **'The provider is still performing this step'**
  String get providerStillDoingStep;

  /// No description provided for @trackProviderOnMap.
  ///
  /// In en, this message translates to:
  /// **'Track their location on the map'**
  String get trackProviderOnMap;

  /// No description provided for @videoSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Video saved to gallery successfully'**
  String get videoSavedSuccessfully;

  /// No description provided for @videoSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save video'**
  String get videoSaveFailed;

  /// No description provided for @omrahVideoTitle.
  ///
  /// In en, this message translates to:
  /// **'Umrah Video'**
  String get omrahVideoTitle;

  /// No description provided for @videoShareFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to share video'**
  String get videoShareFailed;

  /// No description provided for @waitProviderLocation.
  ///
  /// In en, this message translates to:
  /// **'Please wait a moment until the Mutamer sends their location'**
  String get waitProviderLocation;

  /// No description provided for @loadingRoute.
  ///
  /// In en, this message translates to:
  /// **'Loading the route...'**
  String get loadingRoute;

  /// No description provided for @noRouteRecorded.
  ///
  /// In en, this message translates to:
  /// **'No route was recorded for this Umrah'**
  String get noRouteRecorded;

  /// No description provided for @grantPermission.
  ///
  /// In en, this message translates to:
  /// **'Grant Permission'**
  String get grantPermission;

  /// No description provided for @readGuideConfirm.
  ///
  /// In en, this message translates to:
  /// **'Please read the guide content and commit, click \"Confirm\"'**
  String get readGuideConfirm;

  /// No description provided for @verifyVideoInsideMosque.
  ///
  /// In en, this message translates to:
  /// **'Verify video when entering the Grand Mosque'**
  String get verifyVideoInsideMosque;

  /// No description provided for @prayDuaaTakbeer.
  ///
  /// In en, this message translates to:
  /// **'Do not forget the Takbeer and the supplication for the person you intended this Umrah for'**
  String get prayDuaaTakbeer;

  /// No description provided for @imageTranslate.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get imageTranslate;

  /// No description provided for @verifyImageTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Image'**
  String get verifyImageTitle;

  /// No description provided for @pickFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Pick from gallery'**
  String get pickFromGallery;

  /// Verification step title
  ///
  /// In en, this message translates to:
  /// **'Verify {stepName}'**
  String omrahVerifyStep(String stepName);

  /// No description provided for @notReachedYet.
  ///
  /// In en, this message translates to:
  /// **'Not reached'**
  String get notReachedYet;

  /// No description provided for @executedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Executed'**
  String get executedSuccessfully;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get inProgress;

  /// No description provided for @videoProofUploadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Video proof uploaded successfully'**
  String get videoProofUploadedSuccessfully;

  /// No description provided for @ritualsList.
  ///
  /// In en, this message translates to:
  /// **'Rituals'**
  String get ritualsList;

  /// No description provided for @finishOmrah.
  ///
  /// In en, this message translates to:
  /// **'Finish Umrah'**
  String get finishOmrah;

  /// No description provided for @didYouFinishOmrah.
  ///
  /// In en, this message translates to:
  /// **'Did you finish the Umrah?'**
  String get didYouFinishOmrah;

  /// No description provided for @yesIFinishedOmrah.
  ///
  /// In en, this message translates to:
  /// **'Yes, I performed the Umrah'**
  String get yesIFinishedOmrah;

  /// No description provided for @noNotYet.
  ///
  /// In en, this message translates to:
  /// **'No, not yet'**
  String get noNotYet;

  /// No description provided for @ordersHeader.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersHeader;

  /// No description provided for @noOrdersMessage.
  ///
  /// In en, this message translates to:
  /// **'There are no orders'**
  String get noOrdersMessage;

  /// No description provided for @orderStatusWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get orderStatusWaiting;

  /// No description provided for @orderStatusAcceptReject.
  ///
  /// In en, this message translates to:
  /// **'Accept / Reject'**
  String get orderStatusAcceptReject;

  /// No description provided for @orderStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get orderStatusApproved;

  /// No description provided for @orderStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get orderStatusRejected;

  /// No description provided for @orderStatusExecuting.
  ///
  /// In en, this message translates to:
  /// **'Executing'**
  String get orderStatusExecuting;

  /// No description provided for @orderStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get orderStatusCompleted;

  /// No description provided for @orderStatusCanceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get orderStatusCanceled;

  /// No description provided for @orderStatusUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get orderStatusUnderReview;

  /// No description provided for @orderStatusAssigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get orderStatusAssigned;

  /// No description provided for @orderStatusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get orderStatusAccepted;

  /// No description provided for @orderStatusRefused.
  ///
  /// In en, this message translates to:
  /// **'Refused'**
  String get orderStatusRefused;

  /// No description provided for @orderStatusCompletedFemale.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get orderStatusCompletedFemale;

  /// No description provided for @orderStatusCanceledFemale.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get orderStatusCanceledFemale;

  /// No description provided for @cancelOrderBtn.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get cancelOrderBtn;

  /// No description provided for @rejectBtn.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get rejectBtn;

  /// Umrah for beneficiary message
  ///
  /// In en, this message translates to:
  /// **'Umrah for {name}'**
  String omrahForBeneficiary(String name);

  /// No description provided for @orderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order Number'**
  String get orderNumber;

  /// No description provided for @continueOmrah.
  ///
  /// In en, this message translates to:
  /// **'Continue Umrah'**
  String get continueOmrah;

  /// No description provided for @viewOmrah.
  ///
  /// In en, this message translates to:
  /// **'View Umrah'**
  String get viewOmrah;

  /// No description provided for @orderCanceledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Order cancelled successfully'**
  String get orderCanceledSuccess;

  /// No description provided for @mapTitle.
  ///
  /// In en, this message translates to:
  /// **'The Map'**
  String get mapTitle;

  /// No description provided for @findNearestMeqat.
  ///
  /// In en, this message translates to:
  /// **'Find the Nearest Meqat'**
  String get findNearestMeqat;

  /// No description provided for @verifyYourLocation.
  ///
  /// In en, this message translates to:
  /// **'Verify your location'**
  String get verifyYourLocation;

  /// No description provided for @yesAuth.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesAuth;

  /// No description provided for @noAuth.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noAuth;

  /// No description provided for @someParts.
  ///
  /// In en, this message translates to:
  /// **'Some Parts'**
  String get someParts;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailHint;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @mutamerName.
  ///
  /// In en, this message translates to:
  /// **'Mutamer Name'**
  String get mutamerName;

  /// No description provided for @mobileNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumberHint;

  /// No description provided for @countryHint.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryHint;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordHint;

  /// No description provided for @pleaseConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm password'**
  String get pleaseConfirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @registerBtn.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerBtn;

  /// No description provided for @welcomeAuth.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcomeAuth;

  /// No description provided for @loginToViewOrdersDesc.
  ///
  /// In en, this message translates to:
  /// **'Log in to view Umrah orders and perform Umrah for them with confidence and safety.'**
  String get loginToViewOrdersDesc;

  /// No description provided for @orAuth.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get orAuth;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Have an account?'**
  String get haveAccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @loginBtn.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginBtn;

  /// No description provided for @pleaseSelectType.
  ///
  /// In en, this message translates to:
  /// **'Please select a type'**
  String get pleaseSelectType;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameHint;

  /// No description provided for @chooseType.
  ///
  /// In en, this message translates to:
  /// **'Choose type'**
  String get chooseType;

  /// No description provided for @nextAuth.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextAuth;

  /// No description provided for @loginToViewMutamersDesc.
  ///
  /// In en, this message translates to:
  /// **'Log in to view Mutamers and request an Umrah'**
  String get loginToViewMutamersDesc;

  /// No description provided for @createAccountAlt.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccountAlt;

  /// No description provided for @welcomeToMoneeb.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Moneeb'**
  String get welcomeToMoneeb;

  /// No description provided for @omrahForYouOrLovedOne.
  ///
  /// In en, this message translates to:
  /// **'Umrah for you or someone you love... to the House of God'**
  String get omrahForYouOrLovedOne;

  /// No description provided for @docTrackComply.
  ///
  /// In en, this message translates to:
  /// **'Documentation • Tracking • Compliance'**
  String get docTrackComply;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @continueAsGuest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continueAsGuest;

  /// No description provided for @chooseAccountType.
  ///
  /// In en, this message translates to:
  /// **'Choose your account type'**
  String get chooseAccountType;

  /// No description provided for @selectServiceToContinue.
  ///
  /// In en, this message translates to:
  /// **'Select the desired service to continue the registration process'**
  String get selectServiceToContinue;

  /// No description provided for @requestOmrahTitle.
  ///
  /// In en, this message translates to:
  /// **'Request Umrah'**
  String get requestOmrahTitle;

  /// No description provided for @providerServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Provider Service'**
  String get providerServiceTitle;

  /// No description provided for @startBtnAuth.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startBtnAuth;

  /// No description provided for @completeProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete Profile'**
  String get completeProfileTitle;

  /// No description provided for @logoutString.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutString;

  /// No description provided for @doYouWantToLogout.
  ///
  /// In en, this message translates to:
  /// **'Do you want to logout?'**
  String get doYouWantToLogout;

  /// No description provided for @cancelString.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelString;

  /// No description provided for @createMutamerProfile.
  ///
  /// In en, this message translates to:
  /// **'Create Mutamer Profile'**
  String get createMutamerProfile;

  /// No description provided for @enterDataToCompleteProfile.
  ///
  /// In en, this message translates to:
  /// **'Enter the following data to complete setting up your account'**
  String get enterDataToCompleteProfile;

  /// No description provided for @uploadImageTitle.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImageTitle;

  /// No description provided for @yourBioHint.
  ///
  /// In en, this message translates to:
  /// **'Your Biography'**
  String get yourBioHint;

  /// No description provided for @timesPerformedOmrah.
  ///
  /// In en, this message translates to:
  /// **'Number of times you performed Umrah'**
  String get timesPerformedOmrah;

  /// No description provided for @uploadIdImage.
  ///
  /// In en, this message translates to:
  /// **'Upload ID Image'**
  String get uploadIdImage;

  /// No description provided for @idNumberHint.
  ///
  /// In en, this message translates to:
  /// **'ID Number'**
  String get idNumberHint;

  /// No description provided for @continueAuth.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAuth;

  /// No description provided for @oneStepLeft.
  ///
  /// In en, this message translates to:
  /// **'One step left'**
  String get oneStepLeft;

  /// No description provided for @uploadTrustedCertificates.
  ///
  /// In en, this message translates to:
  /// **'Upload some reliable certificates'**
  String get uploadTrustedCertificates;

  /// No description provided for @certificateName.
  ///
  /// In en, this message translates to:
  /// **'Certificate Name'**
  String get certificateName;

  /// No description provided for @backBtn.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backBtn;

  /// No description provided for @finishBtnAuth.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finishBtnAuth;

  /// No description provided for @kasamTitle.
  ///
  /// In en, this message translates to:
  /// **'The Oath'**
  String get kasamTitle;

  /// No description provided for @agreeAndPledge.
  ///
  /// In en, this message translates to:
  /// **'I agree and pledge to the above'**
  String get agreeAndPledge;

  /// No description provided for @iSwearThat.
  ///
  /// In en, this message translates to:
  /// **'I swear to that'**
  String get iSwearThat;

  /// No description provided for @thankYouFor.
  ///
  /// In en, this message translates to:
  /// **'Thank you for '**
  String get thankYouFor;

  /// No description provided for @creatingYourAccount.
  ///
  /// In en, this message translates to:
  /// **'creating your account'**
  String get creatingYourAccount;

  /// No description provided for @orderReceivedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your request has been received successfully,\nand it will be reviewed by the app administration shortly.'**
  String get orderReceivedSuccessfully;

  /// No description provided for @returnToHome.
  ///
  /// In en, this message translates to:
  /// **'Return to Home'**
  String get returnToHome;

  /// No description provided for @loginTitleBtn.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginTitleBtn;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @tazkiyahSuccess.
  ///
  /// In en, this message translates to:
  /// **'Tazkiyah (Recommendation) added successfully'**
  String get tazkiyahSuccess;

  /// No description provided for @tazkiyahAlreadySubmitted.
  ///
  /// In en, this message translates to:
  /// **'You have already submitted a recommendation for this person'**
  String get tazkiyahAlreadySubmitted;

  /// No description provided for @noTazkiyahsYet.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t made any recommendations yet'**
  String get noTazkiyahsYet;

  /// No description provided for @previousTazkiyahs.
  ///
  /// In en, this message translates to:
  /// **'Previous Recommendations'**
  String get previousTazkiyahs;

  /// No description provided for @tazkiyahTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommendation'**
  String get tazkiyahTitle;

  /// No description provided for @tazkiyahDesc.
  ///
  /// In en, this message translates to:
  /// **'We recommend this person and testify to their honesty, good manners, and commitment, and they are trustworthy if God wills.'**
  String get tazkiyahDesc;

  /// No description provided for @changeTazkiyah.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changeTazkiyah;

  /// No description provided for @tazkiyahReasons.
  ///
  /// In en, this message translates to:
  /// **'Reasons for recommendation'**
  String get tazkiyahReasons;

  /// No description provided for @pleaseEnterTazkiyahReason.
  ///
  /// In en, this message translates to:
  /// **'Please enter the reason for recommendation'**
  String get pleaseEnterTazkiyahReason;

  /// No description provided for @oathText.
  ///
  /// In en, this message translates to:
  /// **'I testify, based on my personal knowledge of the applicant, that I know him to be honest and of good conduct, and that I consider him fit to bear the responsibility of performing Umrah on behalf of others and to comply with the documentation requirements approved by the Moneeb platform. I acknowledge that this statement is based on genuine knowledge and is not made in exchange for any financial benefit or personal interest.\n\nStrengthen your application with a Tazkiyah\nApproved Moneeb performers who know you personally can vouch for your eligibility and trustworthiness.\nTazkiyahs help the Moneeb team assess your application, but they do not mean automatic acceptance; every application is reviewed and verified according to the platform\'s criteria.'**
  String get oathText;

  /// No description provided for @reviewSentSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Review sent successfully'**
  String get reviewSentSuccessfully;

  /// No description provided for @evaluateOmrah.
  ///
  /// In en, this message translates to:
  /// **'Rate Umrah'**
  String get evaluateOmrah;

  /// No description provided for @addYourCommentHere.
  ///
  /// In en, this message translates to:
  /// **'Add your comment here...'**
  String get addYourCommentHere;

  /// No description provided for @confirmEvaluation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Evaluation'**
  String get confirmEvaluation;

  /// No description provided for @omrahCompletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Umrah completed successfully'**
  String get omrahCompletedSuccessfully;

  /// No description provided for @omrahWord.
  ///
  /// In en, this message translates to:
  /// **'Umrah'**
  String get omrahWord;

  /// No description provided for @afterSpiritualJourneyDesc.
  ///
  /// In en, this message translates to:
  /// **'After this deep spiritual journey, we hope your heart is clearer, and may you find blessing and mercy in every step you took in Makkah. May Allah accept from you and reward you well'**
  String get afterSpiritualJourneyDesc;

  /// No description provided for @locationNotValidForMiqat.
  ///
  /// In en, this message translates to:
  /// **'Location not valid for miqat'**
  String get locationNotValidForMiqat;

  /// No description provided for @locationNotValidForTawaf.
  ///
  /// In en, this message translates to:
  /// **'Location not valid for tawaf'**
  String get locationNotValidForTawaf;

  /// No description provided for @locationNotValidForSai.
  ///
  /// In en, this message translates to:
  /// **'Location not valid for Sa\'i'**
  String get locationNotValidForSai;

  /// No description provided for @locationProofed.
  ///
  /// In en, this message translates to:
  /// **'Location proofed'**
  String get locationProofed;

  /// No description provided for @grantLocationPermissionPlease.
  ///
  /// In en, this message translates to:
  /// **'Please grant location permission'**
  String get grantLocationPermissionPlease;

  /// No description provided for @grantLocationDesc.
  ///
  /// In en, this message translates to:
  /// **'Please grant location permission so the requester can track the Umrah'**
  String get grantLocationDesc;

  /// No description provided for @noVideoFound.
  ///
  /// In en, this message translates to:
  /// **'No video found'**
  String get noVideoFound;

  /// No description provided for @videoSavedToGallerySuccess.
  ///
  /// In en, this message translates to:
  /// **'The video has been saved to the gallery successfully'**
  String get videoSavedToGallerySuccess;

  /// No description provided for @failedToSaveVideo.
  ///
  /// In en, this message translates to:
  /// **'Failed to save the video'**
  String get failedToSaveVideo;

  /// No description provided for @omrahVideoUrlShare.
  ///
  /// In en, this message translates to:
  /// **'Umrah Video'**
  String get omrahVideoUrlShare;

  /// No description provided for @failedToShareVideo.
  ///
  /// In en, this message translates to:
  /// **'Failed to share video'**
  String get failedToShareVideo;

  /// No description provided for @imageSavedToGallerySuccess.
  ///
  /// In en, this message translates to:
  /// **'The image has been saved to the gallery successfully'**
  String get imageSavedToGallerySuccess;

  /// No description provided for @failedToSaveImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to save the image'**
  String get failedToSaveImage;

  /// No description provided for @omrahImageUrlShare.
  ///
  /// In en, this message translates to:
  /// **'Umrah Image'**
  String get omrahImageUrlShare;

  /// No description provided for @failedToShareImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to share image'**
  String get failedToShareImage;

  /// No description provided for @proofAlreadySubmitted.
  ///
  /// In en, this message translates to:
  /// **'You already submitted your proof'**
  String get proofAlreadySubmitted;

  /// No description provided for @omrahConclusion.
  ///
  /// In en, this message translates to:
  /// **'Conclusion'**
  String get omrahConclusion;

  /// No description provided for @endOfJourney.
  ///
  /// In en, this message translates to:
  /// **'End of the '**
  String get endOfJourney;

  /// No description provided for @omrahCompletionConfirmed.
  ///
  /// In en, this message translates to:
  /// **'The pilgrim confirmed completing the Umrah'**
  String get omrahCompletionConfirmed;

  /// No description provided for @omrahCompletionConfirmedFor.
  ///
  /// In en, this message translates to:
  /// **'The pilgrim confirmed completing the Umrah on behalf of'**
  String get omrahCompletionConfirmedFor;

  /// No description provided for @omrahAcceptedSupplication.
  ///
  /// In en, this message translates to:
  /// **'May Allah accept from us and from you all righteous deeds'**
  String get omrahAcceptedSupplication;

  /// No description provided for @evaluate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get evaluate;

  /// No description provided for @omrahRequestReassignHintForUser.
  ///
  /// In en, this message translates to:
  /// **'If the provider did not accept your Umrah request within 12 hours, it will be automatically reassigned to another provider.'**
  String get omrahRequestReassignHintForUser;

  /// No description provided for @omrahRequestReassignHintForProvider.
  ///
  /// In en, this message translates to:
  /// **'Please accept the requests within 12 hours, otherwise it will be reassigned to another provider.'**
  String get omrahRequestReassignHintForProvider;

  /// No description provided for @meeqatVideoDocumentation.
  ///
  /// In en, this message translates to:
  /// **'Miqat Video Documentation'**
  String get meeqatVideoDocumentation;

  /// No description provided for @tawafVideoDocumentation.
  ///
  /// In en, this message translates to:
  /// **'Documentation of the start of the Tawaf'**
  String get tawafVideoDocumentation;

  /// No description provided for @saiVideoDocumentation.
  ///
  /// In en, this message translates to:
  /// **'Video documentation of the Sai stage'**
  String get saiVideoDocumentation;

  /// No description provided for @ibrahimMakamPrayerVideo.
  ///
  /// In en, this message translates to:
  /// **'Ibrahim Makam Prayer Video'**
  String get ibrahimMakamPrayerVideo;

  /// No description provided for @tahalulVideoDocumentation.
  ///
  /// In en, this message translates to:
  /// **'Tahalul Video Documentation'**
  String get tahalulVideoDocumentation;

  /// No description provided for @stepDocumentedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Step Documented Successfully'**
  String get stepDocumentedSuccessfully;

  /// No description provided for @nextStepIs.
  ///
  /// In en, this message translates to:
  /// **'The next step is {nextStep}'**
  String nextStepIs(String nextStep);

  /// No description provided for @nextStep.
  ///
  /// In en, this message translates to:
  /// **'Next Step'**
  String get nextStep;

  /// No description provided for @tapToCaptureImage.
  ///
  /// In en, this message translates to:
  /// **'Tap to capture image'**
  String get tapToCaptureImage;

  /// No description provided for @cantUploadEmptyFile.
  ///
  /// In en, this message translates to:
  /// **'Can\'t upload empty file, make sure you upload a valid file'**
  String get cantUploadEmptyFile;

  /// No description provided for @imageCompressFailed.
  ///
  /// In en, this message translates to:
  /// **'Image compress failed'**
  String get imageCompressFailed;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid Phone number'**
  String get invalidPhoneNumber;

  /// No description provided for @sharedPost.
  ///
  /// In en, this message translates to:
  /// **'Shared post'**
  String get sharedPost;

  /// No description provided for @couldNotDownloadFile.
  ///
  /// In en, this message translates to:
  /// **'Could not download the file'**
  String get couldNotDownloadFile;

  /// No description provided for @couldNotFetchLocation.
  ///
  /// In en, this message translates to:
  /// **'Could not fetch the location'**
  String get couldNotFetchLocation;

  /// No description provided for @imageProofUploadedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Image proof uploaded successfully'**
  String get imageProofUploadedSuccessfully;

  /// No description provided for @emailOrPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Email or Phone Number'**
  String get emailOrPhoneHint;

  /// No description provided for @emptyEmailOrPhoneError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email or phone number.'**
  String get emptyEmailOrPhoneError;

  /// No description provided for @invalidSaudiPhoneError.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number. Must start with 05 or 5 and be 9 or 10 digits.'**
  String get invalidSaudiPhoneError;

  /// No description provided for @invalidSaudiPhonePrefixError.
  ///
  /// In en, this message translates to:
  /// **'Phone number must start with 05 or 5'**
  String get invalidSaudiPhonePrefixError;

  /// No description provided for @saudiPhoneNineDigitsError.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be 9 digits'**
  String get saudiPhoneNineDigitsError;

  /// No description provided for @saudiPhoneTenDigitsError.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be 10 digits'**
  String get saudiPhoneTenDigitsError;

  /// No description provided for @emailOrPhoneFieldError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email or phone number.'**
  String get emailOrPhoneFieldError;

  /// No description provided for @homeLive.
  ///
  /// In en, this message translates to:
  /// **'Live Streams'**
  String get homeLive;

  /// No description provided for @emailTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailTabLabel;

  /// No description provided for @phoneTabLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneTabLabel;

  /// No description provided for @loginWithOtpDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your email or phone number to receive a verification code.'**
  String get loginWithOtpDesc;

  /// No description provided for @registerAsServiceProvider.
  ///
  /// In en, this message translates to:
  /// **'Register as a Service Provider'**
  String get registerAsServiceProvider;

  /// No description provided for @chooseVerificationMethod.
  ///
  /// In en, this message translates to:
  /// **'Choose a verification method'**
  String get chooseVerificationMethod;

  /// No description provided for @chooseVerificationMethodDesc.
  ///
  /// In en, this message translates to:
  /// **'Select how you\'d like to receive your code.'**
  String get chooseVerificationMethodDesc;

  /// No description provided for @otpChannelWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get otpChannelWhatsapp;

  /// No description provided for @otpChannelSms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get otpChannelSms;

  /// No description provided for @otpChannelCall.
  ///
  /// In en, this message translates to:
  /// **'Phone call'**
  String get otpChannelCall;

  /// No description provided for @otpChannelEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get otpChannelEmail;

  /// No description provided for @verificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verificationTitle;

  /// No description provided for @codeSentTo.
  ///
  /// In en, this message translates to:
  /// **'We sent a verification code to'**
  String get codeSentTo;

  /// No description provided for @changeVerificationMethod.
  ///
  /// In en, this message translates to:
  /// **'Change verification method'**
  String get changeVerificationMethod;

  /// No description provided for @providerIdentityDesc.
  ///
  /// In en, this message translates to:
  /// **'Verify your email or phone to register as a service provider.'**
  String get providerIdentityDesc;

  /// No description provided for @passwordOptionalHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordOptionalHint;

  /// No description provided for @providerNotFound.
  ///
  /// In en, this message translates to:
  /// **'No provider found with these details'**
  String get providerNotFound;

  /// No description provided for @searchByEmailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Search for the provider by email or phone number'**
  String get searchByEmailOrPhone;

  /// No description provided for @omrahCertificate.
  ///
  /// In en, this message translates to:
  /// **'Umrah certificate'**
  String get omrahCertificate;

  /// No description provided for @myCertificates.
  ///
  /// In en, this message translates to:
  /// **'My certificates'**
  String get myCertificates;

  /// No description provided for @generateCertificate.
  ///
  /// In en, this message translates to:
  /// **'Generate certificate'**
  String get generateCertificate;

  /// No description provided for @viewCertificate.
  ///
  /// In en, this message translates to:
  /// **'View certificate'**
  String get viewCertificate;

  /// No description provided for @generatingCertificate.
  ///
  /// In en, this message translates to:
  /// **'Preparing the certificate…'**
  String get generatingCertificate;

  /// No description provided for @certificateGeneratedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Certificate generated successfully'**
  String get certificateGeneratedSuccessfully;

  /// No description provided for @certificateHintForProvider.
  ///
  /// In en, this message translates to:
  /// **'Generate a certificate proving the Umrah was performed, then download it or share it with the requester.'**
  String get certificateHintForProvider;

  /// No description provided for @certificateHintForUser.
  ///
  /// In en, this message translates to:
  /// **'Generate a certificate proving the Umrah was performed, then download it or share it with whoever you like.'**
  String get certificateHintForUser;

  /// No description provided for @loadingCertificate.
  ///
  /// In en, this message translates to:
  /// **'Loading the certificate…'**
  String get loadingCertificate;

  /// No description provided for @certificatePreviewUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not display the certificate. You can still share it as a PDF file.'**
  String get certificatePreviewUnavailable;

  /// No description provided for @certificateSavedToGallery.
  ///
  /// In en, this message translates to:
  /// **'Certificate saved to your gallery'**
  String get certificateSavedToGallery;

  /// No description provided for @failedToSaveCertificate.
  ///
  /// In en, this message translates to:
  /// **'Could not save the certificate'**
  String get failedToSaveCertificate;

  /// No description provided for @failedToShareCertificate.
  ///
  /// In en, this message translates to:
  /// **'Could not share the certificate'**
  String get failedToShareCertificate;

  /// No description provided for @certificateShareMessage.
  ///
  /// In en, this message translates to:
  /// **'Umrah certificate performed on behalf of {name}'**
  String certificateShareMessage(String name);

  /// No description provided for @certificatePageIndicator.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String certificatePageIndicator(int current, int total);

  /// No description provided for @charterPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Integrity Charter and Oath'**
  String get charterPageTitle;

  /// No description provided for @charterHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Integrity Charter and Oath'**
  String get charterHeaderTitle;

  /// No description provided for @charterHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Read the charter in full — agreement is enabled only once you reach the end.'**
  String get charterHeaderSubtitle;

  /// No description provided for @charterNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Before you continue'**
  String get charterNoticeTitle;

  /// No description provided for @charterNoticeBody.
  ///
  /// In en, this message translates to:
  /// **'This charter contains an oath sworn by Allah Almighty and a binding undertaking. You must read it in full, and you may not agree to it before understanding everything it contains and being able to abide by it.'**
  String get charterNoticeBody;

  /// No description provided for @charterSectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Clause {index} of {total}'**
  String charterSectionLabel(int index, int total);

  /// No description provided for @charterS1Title.
  ///
  /// In en, this message translates to:
  /// **'First: Accuracy of data and eligibility'**
  String get charterS1Title;

  /// No description provided for @charterS1Intro.
  ///
  /// In en, this message translates to:
  /// **'I acknowledge the following:'**
  String get charterS1Intro;

  /// No description provided for @charterS1I1.
  ///
  /// In en, this message translates to:
  /// **'All data and documents I have submitted are accurate, complete and belong to me personally.'**
  String get charterS1I1;

  /// No description provided for @charterS1I2.
  ///
  /// In en, this message translates to:
  /// **'I have not used another person\'s data, and I have not allowed anyone else to register or use the account on my behalf.'**
  String get charterS1I2;

  /// No description provided for @charterS1I3.
  ///
  /// In en, this message translates to:
  /// **'I have previously performed Umrah for myself.'**
  String get charterS1I3;

  /// No description provided for @charterS1I4.
  ///
  /// In en, this message translates to:
  /// **'I am medically and physically able to perform the full rites of Umrah.'**
  String get charterS1I4;

  /// No description provided for @charterS1I5.
  ///
  /// In en, this message translates to:
  /// **'I will update my data as soon as any change occurs that affects my eligibility to perform Umrah.'**
  String get charterS1I5;

  /// No description provided for @charterS1I6.
  ///
  /// In en, this message translates to:
  /// **'I will disclose to Moneeb any medical, legal or religious impediment that may affect my ability to fulfil requests.'**
  String get charterS1I6;

  /// No description provided for @charterS2Title.
  ///
  /// In en, this message translates to:
  /// **'Second: Integrity of endorsements'**
  String get charterS2Title;

  /// No description provided for @charterS2Intro.
  ///
  /// In en, this message translates to:
  /// **'I acknowledge and undertake the following:'**
  String get charterS2Intro;

  /// No description provided for @charterS2I1.
  ///
  /// In en, this message translates to:
  /// **'I will only request an endorsement from someone who knows me personally and genuinely.'**
  String get charterS2I1;

  /// No description provided for @charterS2I2.
  ///
  /// In en, this message translates to:
  /// **'I will not request or arrange any fictitious or inaccurate endorsement.'**
  String get charterS2I2;

  /// No description provided for @charterS2I3.
  ///
  /// In en, this message translates to:
  /// **'I will not use the data of any approved performer to obtain an endorsement without their knowledge and consent.'**
  String get charterS2I3;

  /// No description provided for @charterS2I4.
  ///
  /// In en, this message translates to:
  /// **'I am responsible for the accuracy of what I submit; endorsements neither exempt me from liability nor guarantee that my application is accepted.'**
  String get charterS2I4;

  /// No description provided for @charterS2I5.
  ///
  /// In en, this message translates to:
  /// **'Moneeb has the right to verify endorsements and to exclude any endorsement that does not meet the platform\'s criteria.'**
  String get charterS2I5;

  /// No description provided for @charterS3Title.
  ///
  /// In en, this message translates to:
  /// **'Third: Performing the Umrah'**
  String get charterS3Title;

  /// No description provided for @charterS3Intro.
  ///
  /// In en, this message translates to:
  /// **'If I am accepted as a performer with Moneeb, I undertake the following:'**
  String get charterS3Intro;

  /// No description provided for @charterS3I1.
  ///
  /// In en, this message translates to:
  /// **'I will not accept any request unless I am able to fulfil it completely within the specified time.'**
  String get charterS3I1;

  /// No description provided for @charterS3I2.
  ///
  /// In en, this message translates to:
  /// **'I will perform the Umrah myself on behalf of the person named in the request, and will not delegate it to anyone else.'**
  String get charterS3I2;

  /// No description provided for @charterS3I3.
  ///
  /// In en, this message translates to:
  /// **'I will make the intention for the person named in the request, and will not change that person or combine more than one request in a single Umrah.'**
  String get charterS3I3;

  /// No description provided for @charterS3I4.
  ///
  /// In en, this message translates to:
  /// **'I will enter Ihram from the applicable Miqat, then perform Tawaf, Sa\'i and shaving or trimming until the Umrah is complete and I have exited Ihram.'**
  String get charterS3I4;

  /// No description provided for @charterS3I5.
  ///
  /// In en, this message translates to:
  /// **'I will abide by the religious rulings relating to proxy Umrah and by the operational instructions approved by Moneeb.'**
  String get charterS3I5;

  /// No description provided for @charterS3I6.
  ///
  /// In en, this message translates to:
  /// **'I will not confirm any stage before actually performing it.'**
  String get charterS3I6;

  /// No description provided for @charterS3I7.
  ///
  /// In en, this message translates to:
  /// **'I will stop and notify Moneeb immediately if anything prevents me from completing the Umrah, and will not declare it complete when it is not.'**
  String get charterS3I7;

  /// No description provided for @charterS4Title.
  ///
  /// In en, this message translates to:
  /// **'Fourth: Documentation and verification'**
  String get charterS4Title;

  /// No description provided for @charterS4Intro.
  ///
  /// In en, this message translates to:
  /// **'I undertake that the documentation of the Umrah will be genuine and contemporaneous with its performance, as follows:'**
  String get charterS4Intro;

  /// No description provided for @charterS4I1.
  ///
  /// In en, this message translates to:
  /// **'I will document the required stages exclusively from within the Moneeb app, from their actual locations and at their real times.'**
  String get charterS4I1;

  /// No description provided for @charterS4I2.
  ///
  /// In en, this message translates to:
  /// **'I will document Ihram, Tawaf, Sa\'i and exiting Ihram according to the instructions shown in the app.'**
  String get charterS4I2;

  /// No description provided for @charterS4I3.
  ///
  /// In en, this message translates to:
  /// **'I will state the details of the person on whose behalf the Umrah is performed wherever the platform requires it, to prove the Umrah is dedicated to them.'**
  String get charterS4I3;

  /// No description provided for @charterS4I4.
  ///
  /// In en, this message translates to:
  /// **'I will not use previous recordings, photos or clips belonging to another Umrah or another person.'**
  String get charterS4I4;

  /// No description provided for @charterS4I5.
  ///
  /// In en, this message translates to:
  /// **'I will not alter or falsify documentation, nor re-enact any stage after it has ended and present it as live documentation.'**
  String get charterS4I5;

  /// No description provided for @charterS4I6.
  ///
  /// In en, this message translates to:
  /// **'I will not allow anyone else to carry my device or use my account to complete documentation on my behalf.'**
  String get charterS4I6;

  /// No description provided for @charterS4I7.
  ///
  /// In en, this message translates to:
  /// **'I will not use any means to circumvent the location, time, camera or verification systems within the app.'**
  String get charterS4I7;

  /// No description provided for @charterS4I8.
  ///
  /// In en, this message translates to:
  /// **'I consent to the app\'s use of location, time and camera to verify the Umrah stages while a request is being fulfilled.'**
  String get charterS4I8;

  /// No description provided for @charterS5Title.
  ///
  /// In en, this message translates to:
  /// **'Fifth: Privacy and conduct'**
  String get charterS5Title;

  /// No description provided for @charterS5Intro.
  ///
  /// In en, this message translates to:
  /// **'I undertake the following:'**
  String get charterS5Intro;

  /// No description provided for @charterS5I1.
  ///
  /// In en, this message translates to:
  /// **'To keep the data of the requester and of the person on whose behalf the Umrah is performed confidential, and not to use or share it outside the purpose of fulfilling the request.'**
  String get charterS5I1;

  /// No description provided for @charterS5I2.
  ///
  /// In en, this message translates to:
  /// **'To respect the sanctity of the Grand Mosque and the privacy of pilgrims, and to ensure documentation never harms or obstructs others.'**
  String get charterS5I2;

  /// No description provided for @charterS5I3.
  ///
  /// In en, this message translates to:
  /// **'To comply with the regulations and instructions issued by the competent authorities within the Kingdom of Saudi Arabia.'**
  String get charterS5I3;

  /// No description provided for @charterS5I4.
  ///
  /// In en, this message translates to:
  /// **'To communicate honestly and respectfully with Moneeb, and to answer truthfully any enquiry relating to fulfilment or documentation.'**
  String get charterS5I4;

  /// No description provided for @charterS6Title.
  ///
  /// In en, this message translates to:
  /// **'Sixth: Liability and procedures'**
  String get charterS6Title;

  /// No description provided for @charterS6Intro.
  ///
  /// In en, this message translates to:
  /// **'I acknowledge that:'**
  String get charterS6Intro;

  /// No description provided for @charterS6I1.
  ///
  /// In en, this message translates to:
  /// **'Submitting a registration request or obtaining endorsements does not mean I am automatically accepted as an Umrah performer.'**
  String get charterS6I1;

  /// No description provided for @charterS6I2.
  ///
  /// In en, this message translates to:
  /// **'Moneeb has the right to verify my data, documents, endorsements and record of fulfilled requests.'**
  String get charterS6I2;

  /// No description provided for @charterS6I3.
  ///
  /// In en, this message translates to:
  /// **'Any inaccurate data, falsified documentation, circumvention, or fulfilment by another person constitutes a material breach.'**
  String get charterS6I3;

  /// No description provided for @charterS6I4.
  ///
  /// In en, this message translates to:
  /// **'Where a breach is established, Moneeb may reject the application, suspend or cancel the account, and take the measures set out in the Terms of Use and the agreement.'**
  String get charterS6I4;

  /// No description provided for @charterS6I5.
  ///
  /// In en, this message translates to:
  /// **'I am not entitled to payment for any Umrah I did not fully perform, or whose performance or documentation is shown to be inaccurate.'**
  String get charterS6I5;

  /// No description provided for @charterS6I6.
  ///
  /// In en, this message translates to:
  /// **'I bear legal responsibility for any forgery, fraud or misuse, and Moneeb may refer the breach to the competent authority whenever required.'**
  String get charterS6I6;

  /// No description provided for @charterOathTitle.
  ///
  /// In en, this message translates to:
  /// **'The Oath'**
  String get charterOathTitle;

  /// No description provided for @charterOathBody.
  ///
  /// In en, this message translates to:
  /// **'I swear by Allah Almighty that all the data, documents and declarations I have submitted are accurate; that I have previously performed Umrah for myself; and that if I am accepted as a performer on the Moneeb platform, I will perform every Umrah I accept myself, on behalf of the person named in the request, completing all its rites until exiting Ihram, and documenting its stages genuinely from their actual locations and at their correct times, without lying, forgery, circumvention, substitution or delegation to another person, and that I will abide by everything set out in this charter. Allah is my witness to what I say.'**
  String get charterOathBody;

  /// No description provided for @charterEndOfDocument.
  ///
  /// In en, this message translates to:
  /// **'End of the charter'**
  String get charterEndOfDocument;

  /// No description provided for @charterScrollHint.
  ///
  /// In en, this message translates to:
  /// **'Scroll down to read the remaining clauses'**
  String get charterScrollHint;

  /// No description provided for @charterReadPercent.
  ///
  /// In en, this message translates to:
  /// **'{percent}%'**
  String charterReadPercent(int percent);

  /// No description provided for @charterAgreeCheckbox.
  ///
  /// In en, this message translates to:
  /// **'I confirm that I have read all clauses of this charter, understood them, and agree to them'**
  String get charterAgreeCheckbox;

  /// No description provided for @charterSwearButton.
  ///
  /// In en, this message translates to:
  /// **'I swear by Allah to that'**
  String get charterSwearButton;

  /// No description provided for @charterGoToEnd.
  ///
  /// In en, this message translates to:
  /// **'Go to the end of the charter'**
  String get charterGoToEnd;

  /// No description provided for @proofGeoFenceVerified.
  ///
  /// In en, this message translates to:
  /// **'The pilgrim\'s presence inside the geographic zone has been verified'**
  String get proofGeoFenceVerified;

  /// No description provided for @omrahAlreadyRated.
  ///
  /// In en, this message translates to:
  /// **'This Umrah has already been rated'**
  String get omrahAlreadyRated;

  /// No description provided for @omrahRatingOnceOnly.
  ///
  /// In en, this message translates to:
  /// **'Rating is available only once per Umrah'**
  String get omrahRatingOnceOnly;

  /// No description provided for @proofCapturedInsideAppOnly.
  ///
  /// In en, this message translates to:
  /// **'This documentation was filmed by the pilgrim exclusively and directly from within the app'**
  String get proofCapturedInsideAppOnly;

  /// No description provided for @voiceDocumentationTitle.
  ///
  /// In en, this message translates to:
  /// **'Voice documentation phrase'**
  String get voiceDocumentationTitle;

  /// No description provided for @voiceDocumentationHintMiqat.
  ///
  /// In en, this message translates to:
  /// **'While recording the video you can state the following documentation'**
  String get voiceDocumentationHintMiqat;

  /// No description provided for @voiceDocumentationHintTawaf.
  ///
  /// In en, this message translates to:
  /// **'State the following phrase while you record the video'**
  String get voiceDocumentationHintTawaf;

  /// No description provided for @voiceDocumentationHintSai.
  ///
  /// In en, this message translates to:
  /// **'While recording the video, state the following phrase'**
  String get voiceDocumentationHintSai;

  /// No description provided for @voiceDocumentationHintTahalol.
  ///
  /// In en, this message translates to:
  /// **'State the following phrase while you record the Tahallul video'**
  String get voiceDocumentationHintTahalol;

  /// No description provided for @voiceDocumentationActionMiqat.
  ///
  /// In en, this message translates to:
  /// **'At the Miqat and when entering Ihram, say:'**
  String get voiceDocumentationActionMiqat;

  /// No description provided for @voiceDocumentationActionTawaf.
  ///
  /// In en, this message translates to:
  /// **'Before starting the Tawaf, say:'**
  String get voiceDocumentationActionTawaf;

  /// No description provided for @voiceDocumentationActionSai.
  ///
  /// In en, this message translates to:
  /// **'While standing on Safa, before starting the Sa\'i, say:'**
  String get voiceDocumentationActionSai;

  /// No description provided for @voiceDocumentationActionTahalol.
  ///
  /// In en, this message translates to:
  /// **'Film the act of trimming'**
  String get voiceDocumentationActionTahalol;

  /// No description provided for @voiceDocumentationPhraseMiqat.
  ///
  /// In en, this message translates to:
  /// **'Labbayk Allahumma labbayk, an Umrah on behalf of {beneficiary}'**
  String voiceDocumentationPhraseMiqat(String beneficiary);

  /// No description provided for @voiceDocumentationPhraseTawaf.
  ///
  /// In en, this message translates to:
  /// **'Documentation of the start of the Tawaf of the Umrah on behalf of {beneficiary}, Bismillah, Allahu Akbar'**
  String voiceDocumentationPhraseTawaf(String beneficiary);

  /// No description provided for @voiceDocumentationPhraseSai.
  ///
  /// In en, this message translates to:
  /// **'Documentation of the Sa\'i of an Umrah on behalf of {beneficiary}'**
  String voiceDocumentationPhraseSai(String beneficiary);

  /// No description provided for @voiceDocumentationPhraseTahalol.
  ///
  /// In en, this message translates to:
  /// **'The trimming is complete, and with it the Umrah on behalf of {beneficiary} is complete'**
  String voiceDocumentationPhraseTahalol(String beneficiary);

  /// No description provided for @voiceDocumentationNoteTawaf.
  ///
  /// In en, this message translates to:
  /// **'Then say the Takbeer when you align with the Black Stone.'**
  String get voiceDocumentationNoteTawaf;

  /// No description provided for @stepProofRejected.
  ///
  /// In en, this message translates to:
  /// **'The administration rejected this step\'s proof'**
  String get stepProofRejected;

  /// No description provided for @rejectionReason.
  ///
  /// In en, this message translates to:
  /// **'Rejection reason'**
  String get rejectionReason;

  /// No description provided for @reuploadStepProofHint.
  ///
  /// In en, this message translates to:
  /// **'Please document this step and upload its proof again.'**
  String get reuploadStepProofHint;

  /// No description provided for @proofRejectedStatus.
  ///
  /// In en, this message translates to:
  /// **'Proof rejected'**
  String get proofRejectedStatus;

  /// No description provided for @omrahStartsIn.
  ///
  /// In en, this message translates to:
  /// **'Rituals start in'**
  String get omrahStartsIn;

  /// No description provided for @omrahStartsInUser.
  ///
  /// In en, this message translates to:
  /// **'Time until your Umrah begins'**
  String get omrahStartsInUser;

  /// No description provided for @countdownDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get countdownDays;

  /// No description provided for @countdownHours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get countdownHours;

  /// No description provided for @countdownMinutes.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get countdownMinutes;

  /// No description provided for @countdownSeconds.
  ///
  /// In en, this message translates to:
  /// **'Sec'**
  String get countdownSeconds;

  /// No description provided for @omrahStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start date: {date}'**
  String omrahStartDate(String date);

  /// No description provided for @omrahTimeArrivedProvider.
  ///
  /// In en, this message translates to:
  /// **'It\'s time to begin the rituals, you can start now'**
  String get omrahTimeArrivedProvider;

  /// No description provided for @omrahTimeArrivedUser.
  ///
  /// In en, this message translates to:
  /// **'Your Umrah day has arrived, the provider will begin the rituals shortly'**
  String get omrahTimeArrivedUser;

  /// No description provided for @ritualsLockedUntil.
  ///
  /// In en, this message translates to:
  /// **'Rituals start on {date}'**
  String ritualsLockedUntil(String date);

  /// No description provided for @omrahNotStartedYet.
  ///
  /// In en, this message translates to:
  /// **'The requested date has not arrived yet, rituals start on {date}'**
  String omrahNotStartedYet(String date);

  /// No description provided for @upcomingOmrah.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Umrah'**
  String get upcomingOmrah;

  /// No description provided for @startsInDaysHours.
  ///
  /// In en, this message translates to:
  /// **'Starts in {days}d {hours}h'**
  String startsInDaysHours(int days, int hours);

  /// No description provided for @startsInClock.
  ///
  /// In en, this message translates to:
  /// **'Starts in {time}'**
  String startsInClock(String time);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
