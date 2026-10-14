// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get updateApp => 'تحديث التطبيق';

  @override
  String get updateAppTitle =>
      'يتوفر إصدار جديد. يرجى التحديث الآن لمتابعة استخدام التطبيق.';

  @override
  String get updateAppDes => 'هذا الإصدار لم يعد مدعومًا.';

  @override
  String get updateNow => 'تحديث الآن';

  @override
  String get version => 'الاصدار';

  @override
  String get versionInfoNotAvailable => 'ملعومات الاصدار غير متاحة';

  @override
  String get notifications => 'الاشعارات';

  @override
  String get noNotifications => 'لا يوجد اشعارات';

  @override
  String get noNotificationsHint => 'لم يتم العثور على اشعارات';

  @override
  String get notification => 'الاشعار';

  @override
  String get noNotificationHint => 'لم يتم العثور على اشعارات';

  @override
  String get notificationDeleted => 'تم حذف الاشعار';

  @override
  String get notificationDeletedError => 'فشل في حذف الاشعار';

  @override
  String get notificationDeletedSuccess => 'تم حذف الاشعار بنجاح';

  @override
  String get notificationUpdated => 'تم تحديث الاشعار';

  @override
  String get notificationUpdatedError => 'فشل في تحديث الاشعار';

  @override
  String get notificationUpdatedSuccess => 'تم تحديث الاشعار بنجاح';

  @override
  String get custom => 'مخصص';

  @override
  String get original => 'أصلي';

  @override
  String get undo => 'تراجع';

  @override
  String get redo => 'إعادة';

  @override
  String get flip => 'انعكاس';

  @override
  String get rotateRight => 'تدوير لليمين';

  @override
  String get imageEditor => 'محرر الصور';

  @override
  String get editImage => 'تعديل الصورة';

  @override
  String get verification => 'التوثيق';

  @override
  String get viewVerification => 'View Verification';

  @override
  String get savingToGallery => 'جارٍ حفظ الصورة في المعرض';

  @override
  String get editingImagePleaseWait => 'جارٍ تعديل الصورة، يرجى الانتظار..';

  @override
  String get saveToGallery => 'حفظ في المعرض';

  @override
  String get couldNotSaveImage => 'تعذر حفظ الصورة';

  @override
  String get imageSavedToGallery => 'تم حفظ الصورة في المعرض';

  @override
  String get failedToEditImage => 'فشل في تعديل صورتك';

  @override
  String get kb => 'KB';

  @override
  String get mb => 'MB';

  @override
  String get gb => 'GB';

  @override
  String get image => 'صورة';

  @override
  String get video => 'فيديو';

  @override
  String get audio => 'مقطع صوتي';

  @override
  String get document => 'ملف';

  @override
  String get embedLink => 'رابط';

  @override
  String get file => 'ملف';

  @override
  String get gallery => 'المعرض';

  @override
  String get takePhoto => 'التقاط صورة';

  @override
  String get takeVideo => 'التقاط فيديو';

  @override
  String get chooseFromLibrary => 'اختر من معرض الصور ';

  @override
  String get imagesGallery => 'معرض الصور';

  @override
  String get chooseAFile => 'Choose a file';

  @override
  String get jPGPNGExtensions => 'JPG، PNG';

  @override
  String get stopped => 'انتهي';

  @override
  String get paused => 'متوقف';

  @override
  String get recording => 'يسجل';

  @override
  String get preparingRecorder => 'جاري التجهيز..';

  @override
  String get typeAudioTitle => 'اكتب عنوان للصوت';

  @override
  String get playbackSpeed => 'سرعة التشغيل';

  @override
  String get errorStartRecording => 'خطأ، لم يتم بدء التسجيل.';

  @override
  String get couldNotStopRecord => 'تعذر إيقاف التسجيل';

  @override
  String get couldNotPauseRecord => 'تعذر إيقاف التسجيل مؤقتًا.';

  @override
  String get couldNotResumeRecord => 'تعذر استئناف التسجيل.';

  @override
  String get errorPlayingVideo => 'خطأ في تشغيل الفيديو';

  @override
  String mediaExceededSizeLimitSkipped(num count, Object maxSize) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return 'تم تخطي $countString من الوسائط لتعدي الحد الأقصى للحجم و هو $maxSize ميجابايت';
  }

  @override
  String mediaExceededMaxCountLimitSkipped(num count, Object maxSize) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return 'تم تخطي $countString من الوسائط لتعدي الحد الأقصى للعدد و هو $maxSize صورة';
  }

  @override
  String get unsupportedFileType => 'Unsupported file type';

  @override
  String unSupportedMediaSkipped(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return 'تم تخطي $countString من الوسائط لان صيغه الصورة غير مدعومة';
  }

  @override
  String maximumAllowedAudio(int count) {
    return 'الحد الأقصى $count';
  }

  @override
  String maximumAllowedImages(int count) {
    return '(الحد الأقصى $count صورة)';
  }

  @override
  String maximumAllowedVideos(int count) {
    return '(الحد الأقصى $count فيديو)';
  }

  @override
  String sizeLimitExceeded(int maxSize) {
    return 'تم تجاوز الحد الأقصى للحجم، الحد الأقصى هو $maxSize ميغابايت ';
  }

  @override
  String get supportedFileTypeIs => 'أنواع الملفات المدعومة هي';

  @override
  String get permissionNotGranted => 'لم يتم منح الإذن';

  @override
  String get givePermissionsManually =>
      'يجب عليك منح الأذونات يدويًا من الإعدادات';

  @override
  String get removeImage => 'حذف الصورة';

  @override
  String get videoSavedToGallery => 'تم حفظ الفيديو في المعرض';

  @override
  String get errorPickingMedia => 'حدث خطأ أثناء اختيار الوسائط';

  @override
  String get errorFileSize => 'الملف كبير جدًا';

  @override
  String get uploadCancelled => 'تم إلغاء رفع الملف';

  @override
  String maximumSizeLimitWithSkippedError(num limit, num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ملفات',
      one: '1 ملف',
    );
    return 'أقصى حجم $limit ميجا, $_temp0 تم تجاهلها';
  }

  @override
  String get uploadError => 'خطأ غير متوقع في رفع الملف';

  @override
  String get uploadFailedError => 'Upload Failed';

  @override
  String get videoLoadingError => 'خطأ فى تحميل الملف';

  @override
  String get compressionError => 'فشل ضغط الملف';

  @override
  String get thumbnailError => 'فشل استخراج للفيديو';

  @override
  String maximumAttachmentLimitError(num limit) {
    return 'الحد الأقصى ($limit)';
  }

  @override
  String maximumImagesLimitError(num limit) {
    return 'الحد الأقصى ($limit) صور';
  }

  @override
  String maximumVideoLimitError(num limit) {
    return 'الحد الأقصى ($limit) فيديو';
  }

  @override
  String maximumAudioLimitError(num limit) {
    return 'الحد الأقصى ($limit) سجل صوتى';
  }

  @override
  String maximumCountSizeLimitError(num limit, num count) {
    return 'الحد الأقصى للإختيار $count ،وأقصى حجم $limit ميجا';
  }

  @override
  String maximumSizeLimitError(num limit) {
    return 'أقصى حجم $limit ميجا';
  }

  @override
  String get fileSizeError => 'الملف كبير جدًا';

  @override
  String get fileDoesNotExist => 'الملف غير موجود';

  @override
  String fileExceedError(num limit) {
    return 'تعدي حجم الملف $limit ميجا';
  }

  @override
  String get mediaPickupCanceled =>
      'تم إلغاء اختيار الوسائط, يرجى المحاولة مرة أخرى';

  @override
  String get couldNotDownloadFileError => 'خطأ فى تحميل الملف';

  @override
  String get fileCorruptionError => 'حدث خطا بهذا الملف';

  @override
  String get emptyFileError => 'لايمكن رفع الملف، تأكد من اختيار ملف صالح';

  @override
  String get pickPdfValidationError => 'من فضلك اختر ملف صحيح';

  @override
  String get couldNotOpenRecord => 'تعذّر فتح التسجيل';

  @override
  String get downloadSuccessfully => 'تم التحميل بنجاح';

  @override
  String get failedToLoadTheAudio => 'فشل في تحميل الصوت ';

  @override
  String get failedToLoadTheVideo => 'فشل في تحميل الفيديو';

  @override
  String get mediaLimit => 'لقد تعديت الحد الاقصي للوسائط، تمت اضافة ';

  @override
  String get outOf => 'من';

  @override
  String get videoLimit => 'الحد الأقصى لتحميل الفيديو هو 1';

  @override
  String get pickingMedia => 'اختيار الوسائط..';

  @override
  String get addImages => 'إضافة صور';

  @override
  String get emptyEmailError =>
      'حقل البريد الإلكتروني مطلوب ولا يمكن أن يكون فارغًا.';

  @override
  String get emailFormatError => 'تنسيق بريد إلكتروني غير صالح. حاول مرة اخرى.';

  @override
  String get emailCapitalCharactersError =>
      'يجب ألا يحتوي البريد الإلكتروني على أحرف كبيرة';

  @override
  String get emailContainArabicError =>
      'يجب ألا يحتوي البريد الإلكتروني على حروف عربية';

  @override
  String get emailHasSpaceError =>
      'لا يمكن للبريد الالكتروني ان يحتوي علي مسافات';

  @override
  String get passwordDoesNotMatchError =>
      'كلمة المرور لا تتطابق مع كلمة المرور الجديدة';

  @override
  String get emptyPasswordError =>
      'حقل كلمة المرور مطلوب ولا يمكن أن يكون فارغًا.';

  @override
  String get lengthPasswordError =>
      'يجب أن يكون طول كلمة المرور على الأقل 8 أحرف';

  @override
  String get uppercaseLetterPasswordError =>
      'يجب أن تحتوي كلمة المرور على حرف كبير على الأقل';

  @override
  String get lowercaseLetterPasswordError =>
      'يجب أن تحتوي كلمة المرور على حرف صغير على الأقل';

  @override
  String get digitPasswordError =>
      'يجب أن تحتوي كلمة المرور على رقم واحد على الأقل';

  @override
  String get specialCharPasswordError =>
      'يجب أن تحتوي كلمة المرور على حرف خاص واحد على الأقل';

  @override
  String get emptyNameError => 'حقل الإسم مطلوب ولا يمكن أن يكون فارغًا.';

  @override
  String get emptyFirstNameError => 'الرجاء إدخال الاسم الأول';

  @override
  String get emptyLastNameError => 'الرجاء إدخال الاسم الأخير';

  @override
  String get nameIsRequiredError => 'حقل الاسم مطلوب ولا يمكن أن يكون فارغًا.';

  @override
  String get inValidNameError => 'رجاء ادخل اسما صحيحا';

  @override
  String get nameLengthError => 'يجب أن يكون الاسم بين 2 و 25 حرفًا';

  @override
  String get enterMobileNumberError => 'من فضلك قم بادخال رقم هاتفك';

  @override
  String get otpNumberExceeded =>
      'لقد تجاوزت العدد المسموح به لإرسال رمز التفعيل, يرجى المحاولة مرة أخرى في وقت آخر بعد';

  @override
  String get userCancelSocialLoginError => 'تم إلغاء التسجيل';

  @override
  String get failedToLoginWithFacebookError =>
      'فشل تسجيل الدخول باستخدام فيسبوك';

  @override
  String get failedToLoginWithTwitterError => 'فشل تسجيل الدخول باستخدام اكس';

  @override
  String get failedToLoginWithAppleError => 'فشل تسجيل الدخول مع آبل';

  @override
  String get failedToLoginWithGoogleError => 'فشل تسجيل الدخول باستخدام جوجل';

  @override
  String get socialRegisterDataNotCompleteError =>
      'Register Data Not Complete Make Sure Every Thing is Ok';

  @override
  String get couldNotLaunchError => 'لا يمكن فتح هذا الرابط';

  @override
  String get serverError => 'خطا بالسيرفر، من فضلك حاول في وقت اخر';

  @override
  String get unexpectedError => 'خطا غير متوقع، من فضلك حاول في وقت اخر';

  @override
  String get networkError => 'لا يوجد انترنت';

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
  String get noItemFoundError => 'لم يتم العثور على أي عنصر';

  @override
  String get noResultsFoundError => 'No results found';

  @override
  String get failedToGetUserInfoError => 'فشل في الحصول على معلومات المستخدم';

  @override
  String get blockedErrorTitleError => 'تم حظر حسابك';

  @override
  String get blockedErrorDescError => 'عذرًا، لقد تم حظر حسابك';

  @override
  String get unAuthorizedErrorTitleError => 'عملية غير مصرح بها';

  @override
  String get unAuthorizedErrorDescError =>
      'عذرًا، ليس لديك الصلاحية لإجراء هذه العملية.';

  @override
  String get invalidLinkError =>
      'الرابط غير صالح، يرجى التأكد من صلاحية الرابط الذي تم لصقه';

  @override
  String get seemTobeOffline => 'يبدو أنك غير متصل بالإنترنت!';

  @override
  String get hangWeReconnecting => 'تمهّل قليلاً! نحن نحاول إعادة الاتصال.';

  @override
  String noSearchResults(String text) {
    return 'لم يتم العثور على نتائج بحث علي $text';
  }

  @override
  String get noSearchResultsHint =>
      'تحقق من صحة الإملاء وحاول مرة أخرى أو ابحث عن شيء جديد';

  @override
  String permissionRequired(String value) {
    return 'السماح بالوصول إلى $value في إعدادات الجهاز';
  }

  @override
  String permissionRequiredDesc(String value) {
    return 'لاستخدام هذه الميزة، يرجى تمكين الوصول إلى $value في إعدادات الجهاز';
  }

  @override
  String get welcomeSplash => 'أهلاً بك';

  @override
  String get allRightsReserved => 'جميع الحقوق محفوظة © All rights reserved';

  @override
  String get quranQuote => '﴿ وَأَتِمُّوا الْحَجَّ وَالْعُمْرَةَ لِلَّهِ ﴾';

  @override
  String get chooseGender => 'أختار النوع';

  @override
  String get pleaseChooseGender => 'من فضلك اختار النوع';

  @override
  String get quranHafiz => 'هل حافظ القران الكريم';

  @override
  String get pleaseChooseQuranMemorization =>
      'من فضلك اختار هل حافظ القران الكريم';

  @override
  String get certificateNameRequired => 'اسم الشهادة مطلوب';

  @override
  String get uploadCertificateImage => 'رفع صورة الشهادة';

  @override
  String get bioRequired => 'سيرة ذاتية مطلوبة';

  @override
  String get umrahCountRequired => 'عدد مرات العمرة مطلوب';

  @override
  String get enterValidNumber => 'أدخل رقم صحيح';

  @override
  String get idNumberRequired => 'رقم الهوية مطلوب';

  @override
  String get pleaseUploadImage => 'الرجاء رفع الصورة';

  @override
  String get pleaseUploadIdImage => 'الرجاء رفع صورة الهوية';

  @override
  String get providerOath =>
      'أقسم بالله العظيم،\nأن أؤدي العمرة أو الحج بأمانة وإخلاص،\nوأن أنوي العمل خالصًا لوجه الله تعالى،\nوأن ألتزم بجميع الأحكام الشرعية والضوابط الأخلاقية.\n\nوأتعهد:\n• أن أؤدي النسك عن صاحب العمرة كما طُلب مني دون تقصير أو إهمال.\n• أن أيكون صادقًا في المعلومات والتوثيق والصور المرسلة داخل التطبيق.\n• أن أحفظ سرية بيانات أصحاب العمرة ولا أُسيء استخدامها.\n• أن أحترم قدسية المكان والزمان، وأمثل التطبيق بأفضل صورة.\n• أن أتقي الله في كل عمل أقوم به داخل هذا التطبيق.\n\nوأقرّ بأن أي مخالفة لما سبق تُسقط حقي في استخدام التطبيق، وأتحمّل كامل المسؤولية أمام الله ثم أمام إدارة التطبيق.\n\"والله على ما أقول شهيد.\"';

  @override
  String get downloadApp => 'تحميل تطبيق';

  @override
  String get shareAppTitleContent => 'تجربة مسار سلس للجميع';

  @override
  String get biometricAuth => 'مفتاح مرور';

  @override
  String useToOpen(String biometric) {
    return 'افتح القفل باستخدام $biometric';
  }

  @override
  String get on => 'مفعل';

  @override
  String get off => 'غير مفعل';

  @override
  String get enabled => 'مفعل';

  @override
  String get disabled => 'غير مفعل';

  @override
  String get immediately => 'على الفور';

  @override
  String get after10Sec => 'بعد 10 ثوانيٍ';

  @override
  String get after30Sec => 'بعد 30 ثانية';

  @override
  String get afterMinute => 'بعد دقيقة واحدة';

  @override
  String get appLock => 'إنشاء مفتاح مرور';

  @override
  String get enableFaceTouchId =>
      'فعّل معرف الوجه أو بصمة الإصبع للوصول السريع جدًا إلى احتفالات الطعام الخاصة بك.';

  @override
  String get enableAppLock => 'إنشاء مفتاح مرور';

  @override
  String get openSettings => 'فتح الإعدادات';

  @override
  String get passkey => 'إدخال مفتاح المرور';

  @override
  String useBiometric(String biometric) {
    return 'استخدم $biometric';
  }

  @override
  String get faceRecognition => 'معرف الوجه';

  @override
  String get fingerprint => 'بصمة الإصبع';

  @override
  String get iris => 'مسح قزحية العين';

  @override
  String get anyBiometric => 'المصادقة البيومترية المتاحة';

  @override
  String get toUseApp => 'لفتح التطبيق';

  @override
  String get noBiometricAvailable =>
      'المصادقة البيومترية غير متاحة. يرجى استخدام رمز المرور إذا كان متاحًا';

  @override
  String get biometricFailure => 'المصادقة البيومترية غير متوفرة.';

  @override
  String get addressTitle => 'العناوين';

  @override
  String get searchAddress => 'بحث عن عنوان';

  @override
  String get addAddressButtonText => 'أضف عنوانًا';

  @override
  String get addAddress => 'أضف عنواناً لتسهيل عمليات التوصيل';

  @override
  String get addAddressDes =>
      'يمكنك إضافة عنوان المنزل أو عنوان العمل أو أي عنوان آخر تريد توصيل طلباتك إليه.';

  @override
  String get addressSavedSuccessfully => 'تم حفظ العنوان بنجاح';

  @override
  String get addressDetails => 'تفاصيل العنوان';

  @override
  String get location => 'الموقع';

  @override
  String get additionalAddressInfo => 'معلومات إضافية عن العنوان';

  @override
  String get apt => 'رقم الشقة';

  @override
  String get buildingName => 'اسم المبنى';

  @override
  String get addressName => 'اسم العنوان';

  @override
  String get floor => 'الطابق';

  @override
  String get street => 'الشارع';

  @override
  String get additionalDirections => 'إرشادات إضافية';

  @override
  String get addressLabel => 'اسم العنوان';

  @override
  String get additionalInstructions => 'تعليمات إضافية';

  @override
  String get pickLocation => 'اختر الموقع';

  @override
  String get findCaterersNearby => 'البحث عن مقدمي الخدمات بالقرب منك';

  @override
  String get findCaterersNearbyDes =>
      'أخبرنا بمكان التجمع! سنجد لك خيارات تقديم الطعام اللذيذة بالقرب منك.';

  @override
  String get shareLocation => 'الموقع الحالي';

  @override
  String get enableLocation =>
      'قم بتنشيط الوصول الى موقعك للوصول الى مقدمي الخدمه بالقرب منك';

  @override
  String get deliveryAddress => 'تفاصيل التوصيل';

  @override
  String get confirmPinLocation => 'تأكيد مكان التسليم';

  @override
  String get confirmLocation => 'تأكيد مكان التسليم';

  @override
  String get detecting => 'تحديد الموقع...';

  @override
  String get currentLocation => 'الموقع الحالي';

  @override
  String get selectLocationHint => 'حدّد موقعك';

  @override
  String get updateLocationTitle => 'تحديث الموقع';

  @override
  String get updateLocationConfirmation => 'هل تريد تحديث موقعك الحالي؟';

  @override
  String get yesUpdate => 'نعم، حدّث';

  @override
  String get enableLocationServicePrompt =>
      'يرجى تفعيل خدمة الموقع لتحديد موقعك';

  @override
  String get locationPermissionDeniedForeverPrompt =>
      'تم رفض إذن الموقع. يرجى تفعيله من إعدادات التطبيق';

  @override
  String get unnamedRoad => 'طريق بدون اسم';

  @override
  String get chooseDeliveryLocation => 'اختر موقع التسليم';

  @override
  String get savedAddress => 'العناوين المحفوظة';

  @override
  String get deliverToDifferentLocation => 'التوصيل إلى موقع مختلف';

  @override
  String get zoomInMore =>
      'يرجى تكبير الصورة أكثر للعثور على موقع التسليم الدقيق الخاص بك';

  @override
  String get selectYourArea => 'إختر المنطقة';

  @override
  String get shareYourLocation => 'Share your location';

  @override
  String get byAllowLocation =>
      'By allowing App to detect your location, We can show you nearby restaurants more accurately';

  @override
  String get goToSetting => 'Go to setting';

  @override
  String get searchCountry => 'ابحث عن الدوله';

  @override
  String get searchArea => 'ابحث عن المنطقة';

  @override
  String get searchCity => 'ابحث عن المدينة';

  @override
  String get dates => 'التواريخ';

  @override
  String get sinceDate => 'منذ';

  @override
  String get justNow => 'الآن';

  @override
  String year(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString سنين',
      one: '1 سنة',
      zero: '0 سنة',
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
      other: '$countString شهور',
      one: '1 شهر',
      zero: '0 شهر',
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
      other: '$countString أسابيع',
      one: '1 أسبوع',
      zero: 'أسبوع',
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
      other: '$countString أسبوع',
      many: '$countString أسبوعًا',
      few: '$countString أسابيع',
      two: 'أسبوعين',
      one: 'أسبوع',
      zero: 'أسبوع',
    );
    return 'منذ $_temp0';
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
      other: '$countString أيام',
      one: '1 يوم',
      zero: '0 يوم',
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
      other: '$countString يوم',
      many: '$countString يومًا',
      few: '$countString أيام',
      two: 'يومين',
      one: 'يوم',
      zero: 'يوم',
    );
    return 'منذ $_temp0';
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
      other: '$countString ساعات',
      one: '1 ساعة',
      zero: 'ساعة',
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
      other: '$countString ساعة',
      many: '$countString ساعة',
      few: '$countString ساعات',
      two: 'ساعتين',
      one: 'ساعة',
      zero: 'ساعة',
    );
    return 'منذ $_temp0';
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
      other: '$countString دقائق',
      one: '1 دقيقة',
      zero: 'دقيقة',
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
      other: '$countString دقيقة',
      many: '$countString دقيقة',
      few: '$countString دقائق',
      two: 'دقيقتين',
      one: 'دقيقة',
      zero: 'دقيقة',
    );
    return 'منذ $_temp0';
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
      other: '$countString دقائق',
      one: '1 دقيقة',
      zero: 'دقيقة',
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
      other: '$countString دقيقة',
      many: '$countString دقيقة',
      few: '$countString دقائق',
      two: 'دقيقتين',
      one: 'دقيقة',
      zero: 'دقيقة',
    );
    return 'منذ $_temp0';
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
      other: '$countString ثانية',
      many: '$countString ثانية',
      few: '$countString ثواني',
      two: 'ثانيتين',
      one: 'ثانية',
      zero: 'ثانية',
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
      other: '$countString ثانية',
      many: '$countString ثانية',
      few: '$countString ثواني',
      two: 'ثانيتين',
      one: 'ثانية',
      zero: 'ثانية',
    );
    return 'منذ $_temp0';
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
      other: '$countString ثانية',
      many: '$countString ثانية',
      few: '$countString ثواني',
      two: 'ثانيتين',
      one: 'ثانية',
      zero: 'ثانية',
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
      other: '$countString ثانية',
      many: '$countString ثانية',
      few: '$countString ثواني',
      two: 'ثانيتين',
      one: 'ثانية',
      zero: 'ثانية',
    );
    return 'منذ $_temp0';
  }

  @override
  String get h => 'س';

  @override
  String get m => 'د';

  @override
  String get s => 'ث';

  @override
  String get eveningPM => ' مساءً';

  @override
  String get morningAM => ' صباحاً';

  @override
  String get minutes => 'دقائق';

  @override
  String get hours => 'ساعات';

  @override
  String get days => 'يوم';

  @override
  String get weeks => 'أسابيع';

  @override
  String get months => 'شهور';

  @override
  String get years => 'سنوات';

  @override
  String get turnOn => 'تشغيل';

  @override
  String get later => 'لاحقاً';

  @override
  String get start => 'ابدأ';

  @override
  String get share => 'مشاركة';

  @override
  String get edit => 'تعديل';

  @override
  String get delete => 'حذف';

  @override
  String get done => 'تم';

  @override
  String get cancel => 'الغاء';

  @override
  String get confirm => 'تاكيد';

  @override
  String get next => 'التالي';

  @override
  String get skip => 'تخطى';

  @override
  String get change => 'تغيير';

  @override
  String get cont => 'متابعة';

  @override
  String get add => 'إضافة';

  @override
  String get accept => 'قبول';

  @override
  String get save => 'حفظ';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get ok => 'حسنا';

  @override
  String get send => 'إرسال';

  @override
  String get back => 'رجوع';

  @override
  String get sureYouWantToExit => 'هل انت متاكد انك تريد الخروج';

  @override
  String get leave => 'مغادرة';

  @override
  String get stay => 'البقاء';

  @override
  String get sendMedia => 'ارسل صورة أو فيديو';

  @override
  String get sendPdf => 'رفع ملف';

  @override
  String get openCamera => 'التقط صورة';

  @override
  String get wait => 'انتظر';

  @override
  String get showMore => 'قراءة المزيد';

  @override
  String get showLess => 'قراءة الأقل';

  @override
  String get reSend => 'إعادة الإرسال';

  @override
  String get recall => 'إعادة الاتصال';

  @override
  String get reply => 'رد';

  @override
  String get copy => 'نسخ';

  @override
  String get typing => 'يكتب..';

  @override
  String get copyMessage => 'تم نسخ الرسالة';

  @override
  String get selectYour => 'اختر';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get verifyTextBtn => 'التحقق';

  @override
  String get unlinkAccount => 'Unlink';

  @override
  String get linkAccount => 'Link';

  @override
  String get discard => 'تجاهل';

  @override
  String get proceed => 'متابعة';

  @override
  String get close => 'إغلاق';

  @override
  String get sendCode => 'أرسل رمز التحقق';

  @override
  String get previous => 'السابق';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get search => 'ابحث';

  @override
  String get searchWithDots => '...بحث';

  @override
  String get logOut => 'تسجيل الخروج';

  @override
  String get upload => 'تحميل';

  @override
  String get record => 'سِجِلّ';

  @override
  String get clear => 'مسح';

  @override
  String get remove => 'إزالة';

  @override
  String get enable => 'تفعيل';

  @override
  String get disable => 'إلغاء التفعيل';

  @override
  String get clickHere => 'اضغط هنا';

  @override
  String get loadMore => 'تحميل المزيد';

  @override
  String get seeMore => 'المزيد';

  @override
  String get book => 'احجز';

  @override
  String get logIn => 'تسجيل الدخول';

  @override
  String get getStarted => 'ابدأ';

  @override
  String get getStartedNow => 'ابدأ الآن';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get select => 'اختر';

  @override
  String get apply => 'تطبيق';

  @override
  String get refresh => 'إعادة المحاولة';

  @override
  String get viewMore => 'قراءة المزيد';

  @override
  String get more => 'المزيد';

  @override
  String get viewLess => 'قراءة الأقل';

  @override
  String get now => 'الآن';

  @override
  String agoMinutes(int count) {
    return 'منذ $count دقيقة';
  }

  @override
  String agoHours(int count) {
    return 'منذ $count ساعة';
  }

  @override
  String agoDays(int count) {
    return 'منذ $count يوم';
  }

  @override
  String get dailyApps => 'تطبيقاتك اليومية';

  @override
  String get liveFromHaram => 'بث من مسجد الحرام الأن';

  @override
  String get currentUmrah => 'العمرة الجارية..';

  @override
  String get videos => 'فيديوهات';

  @override
  String get details => 'التفاصيل';

  @override
  String get changeLanguage => 'تغيير اللغه';

  @override
  String get welcomeTo => 'مرحبآ بك في ';

  @override
  String get welcomeGuest => 'مرحباً';

  @override
  String welcome(String name) {
    return 'مرحباً يا $name';
  }

  @override
  String get appName => '---';

  @override
  String get mobileNumber => 'Mobile number';

  @override
  String get tapToSelect => 'اضغط للتحديد';

  @override
  String get country => 'الدولة';

  @override
  String get city => 'المدينة';

  @override
  String get area => 'المنطقة';

  @override
  String get lang => 'English';

  @override
  String get male => 'ذكر';

  @override
  String get female => 'أنثى';

  @override
  String get noAnswer => 'لا أفضل الإجابة';

  @override
  String get success => 'نجاح !';

  @override
  String get guest => 'ضيف';

  @override
  String get youAreGuestLogin => 'أنت زائر، قم بتسجيل الدخول للمتابعة.';

  @override
  String get exitDescription => 'هل تريد الخروج من التطبيق';

  @override
  String get areYouSure => 'هل أنت متأكد؟';

  @override
  String get addedSuccessfully => 'تمت الاضافه بنجاح';

  @override
  String get pastYourLink => 'قم بلصق الرابط الخاص بك هنا';

  @override
  String get selectYourCountry => 'اختر دولتك';

  @override
  String get appLocked => 'الاب مقفل';

  @override
  String get searchResults => 'نتائج البحث';

  @override
  String get or => ' or ';

  @override
  String get pleaseReadContentCarefully =>
      'يرجى قراءة المحتوى جيداً لمعرفة المزيد عن التطبيق';

  @override
  String get searchHere => 'ابحث هنا';

  @override
  String get azkar => 'الأذكار';

  @override
  String get dua => 'دعاء';

  @override
  String get tasbeeh => 'السبحة الإلكتروني';

  @override
  String get tasbeehDescription =>
      'استمتع بتجربة السبحة الإلكترونية داخل التطبيق، وسجّل تسبيحاتك بكل سهولة ودقة';

  @override
  String get praiseNow => 'سبح الأن';

  @override
  String get prayerTimes => 'مواقيت الصلاة';

  @override
  String get prayerTimesDescription =>
      'تابع مواقيت الصلاة بدقة حسب موقعك الحالي';

  @override
  String get time => 'الوقت';

  @override
  String get occasions => 'مناسبات';

  @override
  String get read => 'قراءة';

  @override
  String get today => 'اليوم';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get remaining => 'باقي';

  @override
  String get selectDhikr => 'اختار الذكر';

  @override
  String get resetSebha => 'تصفير المسبحة';

  @override
  String get tasbeehPlaceholder => 'سبحان الله وبحمده';

  @override
  String get qiblah => 'إتجاه القبلة';

  @override
  String get qiblahDescription =>
      'اعرف إتجاه القبلة بدقة بناءً على موقعك الحالي';

  @override
  String get qiblahNow => 'القبلة الآن';

  @override
  String get enterDhikr => 'أدخل ذكر ';

  @override
  String get timings => 'المواقيت';

  @override
  String daysRemainingUntil(Object date, Object days, Object eventName) {
    return 'تبقى على $eventName $days يوماً، تاريخ المناسبة في $date';
  }

  @override
  String daysLeft(String days) {
    return 'باقي $days يوم';
  }

  @override
  String get loginRequired => 'تسجيل الدخول مطلوب';

  @override
  String get journeyStartDesc => 'رحلة الانابة تبدأ من هنا';

  @override
  String get moneebSaudiDesc => 'منيب .. من مكة المكرمة';

  @override
  String get story => 'قصة';

  @override
  String get theBest => 'الأفضل';

  @override
  String get trustedPilgrims => 'معتمرين موثوقين';

  @override
  String get ritualsDocumentation => 'مناسك بتوثيق حقيقي';

  @override
  String get umrahTracking => 'تتبع مناسك العمرة';

  @override
  String get trackLocation => 'تتبع الموقع';

  @override
  String umrahForBeneficiary(String beneficiary) {
    return 'عمرة عن $beneficiary';
  }

  @override
  String get beneficiaryMartyr => 'شهيد';

  @override
  String get beneficiarySick => 'مريض';

  @override
  String get beneficiaryDeceased => 'متوفى';

  @override
  String get beneficiaryHelpless => 'عاجز';

  @override
  String get completedStatus => 'تم التنفيذ';

  @override
  String get hijriMonth1 => 'المحرم';

  @override
  String get hijriMonth2 => 'صفر';

  @override
  String get hijriMonth3 => 'ربيع الأول';

  @override
  String get hijriMonth4 => 'ربيع الآخر';

  @override
  String get hijriMonth5 => 'جمادى الأولى';

  @override
  String get hijriMonth6 => 'جمادى الآخرة';

  @override
  String get hijriMonth7 => 'رجب';

  @override
  String get hijriMonth8 => 'شعبان';

  @override
  String get hijriMonth9 => 'رمضان';

  @override
  String get hijriMonth10 => 'شوال';

  @override
  String get hijriMonth11 => 'ذو القعدة';

  @override
  String get hijriMonth12 => 'ذو الحجة';

  @override
  String get inProgressStatus => 'جاري التنفيذ';

  @override
  String get fajr => 'الفجر';

  @override
  String get fajrPrayer => 'صلاة الفجر';

  @override
  String get sunrise => 'الشروق';

  @override
  String get dhuhr => 'الظهر';

  @override
  String get dhuhrPrayer => 'صلاة الظهر';

  @override
  String get asr => 'العصر';

  @override
  String get asrPrayer => 'صلاة العصر';

  @override
  String get maghrib => 'المغرب';

  @override
  String get maghribPrayer => 'صلاة المغرب';

  @override
  String get isha => 'العشاء';

  @override
  String get ishaPrayer => 'صلاة العشاء';

  @override
  String prayerTimeAlert(String prayerName) {
    return 'حان الآن موعد $prayerName';
  }

  @override
  String get markAllAsRead => 'تحديد الكل كمقروء';

  @override
  String get quranVerse => '( وَأَتِمُّوا الْحَجَّ وَالْعُمْرَةَ لِلَّهِ )';

  @override
  String get ongoingOmrah => 'العمرة الجارية..';

  @override
  String get reviewDetails => 'تفاصيل التعليق';

  @override
  String get mutamerRating => 'تقييم المعتمر';

  @override
  String get rateMutamerDesc => 'يرجى تقييم المعتمر بناءً على تجربتك';

  @override
  String get userRoleName => 'مستخدم';

  @override
  String get noComment => 'لا يوجد تعليق';

  @override
  String get selectGender => 'اختر النوع';

  @override
  String get pleaseSelectGender => 'من فضلك اختر النوع';

  @override
  String get notReachedStatus => 'لم يصل اليها';

  @override
  String get ihram => 'الإحرام';

  @override
  String get miqat => 'الميقات';

  @override
  String get mekatInstruction1Title => 'الاغتسال والتطيب';

  @override
  String get mekatInstruction1Desc =>
      'يُستحب للمسلم قبل الإحرام أن يغتسل ويتطيب.\n\n• الاغتسال سنة مؤكدة قبل الإحرام  \n• يتطيب الرجل في بدنه (وليس في ملابس الإحرام)  \n• المرأة تتجنب الطيب إذا كانت ستختلط بالرجال  \n\nالغرض من ذلك:\n• النظافة  \n• الاستعداد للدخول في النسك';

  @override
  String get mekatInstruction2Title => 'لبس ملابس الإحرام';

  @override
  String get mekatInstruction2Desc =>
      'كيفية لبس ملابس الإحرام:\n\nللرجال:\n• لبس إزار ورداء (قطعتين غير مخيطتين)  \n• عدم تغطية الرأس  \n• لبس نعلين (يفضل مفتوحة)  \n\n للنساء:\n• لبس ملابس عادية ساترة (بدون زينة)  \n• لا يشترط لون معين  \n• عدم لبس النقاب أو القفازين  \n\nملاحظات:\n• يجب أن تكون الملابس نظيفة  \n• يُمنع استخدام العطور بعد الإحرام';

  @override
  String get mekatInstruction3Title => 'النية';

  @override
  String get mekatInstruction3Desc =>
      'النية هي الدخول في النسك.\n\n• محلها القلب (ولا يشترط التلفظ بها)  \n• يستحب قول:\n\"لبيك اللهم عمرة\"  \n\nملاحظات:\n• تكون النية عند الوصول للميقات  \n• لا يصح الإحرام بدون نية';

  @override
  String get mekatInstruction4Title => 'الميقات';

  @override
  String get mekatInstruction4Desc =>
      'الميقات هو المكان الذي يجب الإحرام منه.\n\n• لا يجوز تجاوزه بدون إحرام لمن أراد العمرة  \n\nأشهر المواقيت:\n• ذو الحليفة (أهل المدينة)  \n• الجحفة (أهل الشام)  \n• قرن المنازل (أهل نجد)  \n• يلملم (أهل اليمن)  \n• ذات عرق (أهل العراق)  \n\nملاحظات:\n• من كان داخل حدود المواقيت يُحرم من مكانه  \n• من كان في الطائرة يُحرم عند محاذاة الميقات';

  @override
  String get mekatInstruction5Title => 'التلبية';

  @override
  String get mekatInstruction5Desc =>
      'يبدأ المعتمر بالتلبية بعد الإحرام مباشرة.\n\nنص التلبية:\n\"لبيك اللهم عمرة، لبيك لا شريك لك لبيك، إن الحمد والنعمة لك والملك، لا شريك لك\"\n\nمتى تُقال:\n• بعد النية مباشرة  \n• تُكرر أثناء الطريق إلى مكة  \n\nملاحظات:\n• يرفع الرجل صوته بها  \n• المرأة تقولها بصوت منخفض  \n• تستمر حتى بدء الطواف';

  @override
  String get tawaf => 'الطواف';

  @override
  String get tawafInstruction1Title => 'الدخول إلى المسجد الحرام';

  @override
  String get tawafInstruction1Desc =>
      'عند دخول المسجد الحرام:\n\n• ادخل بالرجل اليمنى  \n• قل: \"بسم الله، اللهم صلِّ على محمد\"  \n• وقل: \"اللهم افتح لي أبواب رحمتك\"  \n\nملاحظات:\n• ادخل بسكينة وهدوء  \n• لا تزاحم الناس  \n• استحضر عظمة المكان';

  @override
  String get tawafInstruction2Title => 'عند الحجر الأسود';

  @override
  String get tawafInstruction2Desc =>
      'عند الوصول إلى الحجر الأسود:\n\n• إن تيسر: استلمه بيدك اليمنى وقبّله  \n• إن لم تستطع: المسه بيدك وقبّل يدك  \n• إن لم تستطع: أشر إليه بيدك وقل \"الله أكبر\"  \n\nملاحظات:\n• لا تؤذِ الآخرين بالمزاحمة  \n• الإشارة تكفي عند الزحام';

  @override
  String get tawafInstruction3Title => 'الطواف حول الكعبة';

  @override
  String get tawafInstruction3Desc =>
      'كيفية الطواف:\n\n• اجعل الكعبة عن يسارك  \n• ابدأ من الحجر الأسود  \n• طف 7 أشواط كاملة  \n\nملاحظات:\n• كل شوط يبدأ وينتهي عند الحجر الأسود  \n• يستحب الإسراع الخفيف (الرمل) للرجال في أول 3 أشواط  \n• المشي العادي في باقي الأشواط';

  @override
  String get tawafInstruction4Title => 'الذكر والدعاء أثناء الطواف';

  @override
  String get tawafInstruction4Desc =>
      'أثناء الطواف:\n\n• أكثر من الذكر والدعاء  \n• اقرأ ما تيسر من القرآن  \n\nيستحب بين الركن اليماني والحجر الأسود:\n\"ربنا آتنا في الدنيا حسنة وفي الآخرة حسنة وقنا عذاب النار\"\n\nملاحظات:\n• لا يوجد دعاء محدد لكل شوط  \n• ادعُ بما شئت';

  @override
  String get tawafInstruction5Title => 'صلاة ركعتين بعد الطواف';

  @override
  String get tawafInstruction5Desc =>
      'بعد الانتهاء من الطواف:\n\n• صلِّ ركعتين خلف مقام إبراهيم إن تيسر  \n• وإن لم يتيسر، فصلِّ في أي مكان في المسجد  \n\nفي الركعتين:\n• اقرأ الفاتحة  \n• ويفضل قراءة:\n  - الكافرون في الأولى  \n  - الإخلاص في الثانية  \n\nملاحظات:\n• لا تزاحم الناس عند المقام';

  @override
  String get makamInstruction1Title => 'التوجه إلى مقام إبراهيم';

  @override
  String get makamInstruction1Desc =>
      'بعد الانتهاء من الطواف:\n\n• توجّه إلى مقام إبراهيم إن تيسر  \n• اجعل المقام بينك وبين الكعبة  \n\nقال الله تعالى:\n\"واتخذوا من مقام إبراهيم مصلى\"\n\nملاحظات:\n• لا يلزم الوقوف ملاصقًا للمقام  \n• يمكن الصلاة في أي مكان داخل المسجد';

  @override
  String get makamInstruction2Title => 'صلاة ركعتين';

  @override
  String get makamInstruction2Desc =>
      'صلِّ ركعتين بعد الطواف:\n\n• الركعة الأولى:\n  - الفاتحة  \n  - سورة الكافرون (يستحب)  \n\n• الركعة الثانية:\n  - الفاتحة  \n  - سورة الإخلاص (يستحب)  \n\nملاحظات:\n• الصلاة سنة مؤكدة بعد الطواف  \n• لا تزاحم الناس لأجل الصلاة عند المقام';

  @override
  String get makamInstruction3Title => 'مكان الصلاة';

  @override
  String get makamInstruction3Desc =>
      'مكان الصلاة:\n\n• الأفضل: خلف مقام إبراهيم  \n• إن لم يتيسر بسبب الزحام:\n  - صلِّ في أي مكان داخل المسجد الحرام  \n\nملاحظات:\n• تجنب الزحام الشديد  \n• الخشوع أولى من القرب';

  @override
  String get makamInstruction4Title => 'بعد الصلاة';

  @override
  String get makamInstruction4Desc =>
      'بعد الانتهاء من الركعتين:\n\n• اشرب من ماء زمزم إن تيسر  \n• ادعُ الله بما شئت  \n• استعد للذهاب إلى السعي بين الصفا والمروة  \n\nملاحظات:\n• ماء زمزم سنة وليس واجب  \n• يُستحب الإكثار من الدعاء';

  @override
  String get pleaseCompleteInstructions =>
      'الرجاء إكمال باقي الإرشادات للمتابعة';

  @override
  String get pleaseReadInstructionsCarefully =>
      'يرجى قراءة الإرشادات جيداً لتطبيق الطواف بشكل سليم';

  @override
  String get pleaseVerifyMapFirst => 'الرجاء إكمال توثيق الخريطة أولاً';

  @override
  String get prayerBehindMakam => 'الصلاة خلف مقام ابراهيم عليه السلام';

  @override
  String get makamIbrahim => 'مقام ابراهيم';

  @override
  String get sai => 'السعي بين الصفا والمروة';

  @override
  String get safaMarwaInstruction1Title => 'التوجه إلى الصفا';

  @override
  String get safaMarwaInstruction1Desc =>
      'بعد الانتهاء من الطواف وصلاة ركعتين:\n\n• توجّه إلى جبل الصفا لبدء السعي  \n• عند الاقتراب اقرأ:\n\"إن الصفا والمروة من شعائر الله\"\n\nملاحظات:\n• هذه الآية تُقال مرة واحدة عند بداية السعي';

  @override
  String get safaMarwaInstruction2Title => 'الوقوف على الصفا';

  @override
  String get safaMarwaInstruction2Desc =>
      'عند الصعود على الصفا:\n\n• استقبل الكعبة إن تيسر  \n• ارفع يديك وادعُ الله  \n\nيُستحب قول:\n\"الله أكبر، الله أكبر، الله أكبر  \nلا إله إلا الله وحده لا شريك له...\"\n\nملاحظات:\n• كرر الذكر والدعاء 3 مرات  \n• ادعُ بما شئت من خير الدنيا والآخرة';

  @override
  String get safaMarwaInstruction3Title => 'السعي بين الصفا والمروة';

  @override
  String get safaMarwaInstruction3Desc =>
      'ابدأ السعي من الصفا إلى المروة:\n\n• اجعل وجهتك نحو المروة  \n• عند العلامتين الخضراوين:\n  - يُسرع الرجال (هرولة خفيفة)  \n  - تمشي النساء بشكل عادي  \n\nملاحظات:\n• باقي المسافة مشي عادي  \n• أكثر من الذكر والدعاء';

  @override
  String get safaMarwaInstruction4Title => 'عدد الأشواط';

  @override
  String get safaMarwaInstruction4Desc =>
      'عدد أشواط السعي:\n\n• 7 أشواط كاملة  \n\nالطريقة:\n• من الصفا إلى المروة = شوط 1  \n• من المروة إلى الصفا = شوط 2  \n• وهكذا حتى تنتهي عند المروة  \n\nملاحظات:\n• البداية من الصفا  \n• النهاية عند المروة';

  @override
  String get safaMarwaInstruction5Title => 'الدعاء أثناء السعي';

  @override
  String get safaMarwaInstruction5Desc =>
      'أثناء السعي:\n\n• أكثر من الدعاء والذكر  \n• اقرأ ما تيسر من القرآن  \n\nملاحظات:\n• لا يوجد دعاء محدد لكل شوط  \n• ادعُ بما تحب';

  @override
  String get safaMarwaInstruction6Title => 'بعد الانتهاء من السعي';

  @override
  String get safaMarwaInstruction6Desc =>
      'بعد إتمام 7 أشواط:\n\n• تكون قد انتهيت من السعي  \n• تستعد للحلق أو التقصير  \n\nملاحظات:\n• السعي ركن من أركان العمرة  \n• لا تصح العمرة بدونه';

  @override
  String get saiMinimized => 'السعي';

  @override
  String get tahalol => 'التحلل';

  @override
  String get shaving => 'الحلاقة';

  @override
  String get finishedUmrah => 'أنتهاء العمرة';

  @override
  String get umrahTrackingFinishedStep => 'الانتهاء';

  @override
  String get quranQuoteHome =>
      '﴿مَنْ خَشِيَ الرَّحْمَنَ بِالْغَيْبِ وَجَاءَ بِقَلْبٍ مُنِيبٍ﴾';

  @override
  String get enterRequiredFields => 'قم بإدخال الحقول المطلوبة';

  @override
  String get forWhomOmra => 'لمن العمرة';

  @override
  String get beneficiaryCondition => 'حال المعتمر له';

  @override
  String get beneficiaryGenderLabel => 'جنس المعتمر له';

  @override
  String get requesterName => 'مقدم الطلب';

  @override
  String get pleaseSelectOmraType => 'يرجى تحديد نوع العمرة';

  @override
  String get beneficiaryNameHint => 'أسم المعتمر له';

  @override
  String get pleaseEnterBeneficiaryName => 'يرجى إدخال أسم المعتمر له';

  @override
  String get uploadImage => 'رفع الصورة';

  @override
  String get deleteImage => 'حذف الصورة';

  @override
  String get pleaseUploadBeneficiaryImage => 'يرجى رفع صورة المعتمر له';

  @override
  String get writeYourNotes => 'اكتب ملاحظاتك';

  @override
  String get requestDate => 'تاريخ الطلب';

  @override
  String get pleaseSelectRequestDate => 'يرجى تحديد تاريخ الطلب';

  @override
  String get assignUmrahProvider => 'تخصيص مؤدي العمرة';

  @override
  String get errorOccurred => 'حدث خطأ';

  @override
  String get submitOrderErrorDesc =>
      'تأكد من إدخال جميع الحقول بشكل صحيح والمحاولة مرة أخرى';

  @override
  String get orderSubmittedSuccessfully => 'تم تقديم الطلب بنجاح';

  @override
  String get continueText => 'متابعة';

  @override
  String get confirmText => 'تأكيد';

  @override
  String get pilgrims => 'المعتمرين';

  @override
  String get martyr => 'شهيد';

  @override
  String get sick => 'مريض';

  @override
  String get deceased => 'متوفى';

  @override
  String get helpless => 'عاجز';

  @override
  String get omra => 'عمرة';

  @override
  String get sendRequest => 'إرسال طلب';

  @override
  String shareProviderProfile(String name, String username) {
    return 'تعرف على $name (@$username) - مقدم عمرة معتمد على منيب 🕋\n\nمنيب هي منصة متخصصة في العمرة بالنيابة، تتيح للمستخدمين طلب أداء العمرة عن المرضى والعاجزين والمتوفين والشهداء من خلال مقدمي عمرة معتمدين تم التحقق من بياناتهم واعتمادهم من قبل إدارة التطبيق.\n\nيوفر التطبيق تجربة موثوقة وشفافة تمكن طالب العمرة من متابعة جميع توثيقات تنفيذ العمرة خطوة بخطوة، مع الاطلاع على كل توثيق من خلال الصور والفيديوهات والموقع المباشر أثناء التنفيذ.\n\nمنيب... تجربة موثقة وشفافة لمتابعة العمرة بالنيابة بكل ثقة واطمئنان.';
  }

  @override
  String get repeatTheseAzkarWithHumilityAndSincerityToGod =>
      'كرر هذه الأذكار واحفظ بالخشوع والنية الخالصة لله';

  @override
  String toBeSaidAtLeast(String count) {
    return 'يُقال $count مرة على الأقل';
  }

  @override
  String get underReview => 'قيد المراجعة';

  @override
  String get profileChangesUnderReview => 'طلبك قيد المراجعة';

  @override
  String get profileChangesUnderReviewDescription =>
      'تم إرسال تعديلاتك بنجاح، وهي الآن قيد المراجعة من قِبل الإدارة.\nسيصلك إشعار فور الموافقة على التعديل أو رفضه.';

  @override
  String get umrahRequestAccepted => 'تم قبول الطلب العمرة';

  @override
  String get umrahRequestRejected => 'تم رفض طلب العمرة';

  @override
  String get orderDetails => 'تفاصيل';

  @override
  String umrahFor(Object type) {
    return 'عمره عن $type';
  }

  @override
  String get serialNumber => 'رقم التسلسلي';

  @override
  String get beneficiaryImage => 'صورة المعتمر له';

  @override
  String get notes => 'الملاحظات';

  @override
  String get pilgrimName => 'أسم المعتمر';

  @override
  String get pilgrimImage => 'صورة المعتمر';

  @override
  String get autoAssignPilgrim => 'اختيار معتمر بشكل آلي';

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
  String get menu => 'الاعدادات';

  @override
  String get light => 'فاتح';

  @override
  String get dark => 'داكن';

  @override
  String get useSystemSetting => 'استخدام إعدادات النظام';

  @override
  String get deleting => 'جارٍ الحذف';

  @override
  String get deleteChat => 'حذف المحادثة';

  @override
  String get areYouSureYouWantToDeleteThisChat =>
      'هل أنت متأكد أنك تريد حذف هذه المحادثة؟';

  @override
  String get chatDeletedSuccessfully => 'تم حذف المحادثة بنجاح';

  @override
  String get contactToExpert => 'تواصل بالخبير';

  @override
  String get chatListTitle => 'الرسائل';

  @override
  String get youSent => 'لقد أرسلت';

  @override
  String get sent => 'تم إرسال';

  @override
  String get clearChat => 'مسح المحادثة';

  @override
  String get clearChatTitle => 'مسح المحادثة!';

  @override
  String get muteNotification => 'كتم الإشعارات';

  @override
  String viewProfile(String firstName) {
    return 'عرض ملف $firstName الشخصي';
  }

  @override
  String clearChatDescription(String chatUserName) {
    return 'هل أنت متأكد أنك تريد مسح المحادثة مع $chatUserName؟ إذا أكدت ذلك، فلن تتمكن من استعادة الرسائل مرة أخرى';
  }

  @override
  String deleteChatDescription(String chatUserName) {
    return 'هل أنت متأكد أنك تريد حذف الدردشة مع $chatUserName؟ إذا أكدت ذلك، فلن تتمكن من استعادة الرسائل مرة أخرى.';
  }

  @override
  String get caption => 'تعليق';

  @override
  String get clearChatWithMessage => 'مسح رسائل الدردشة من ناحيتك';

  @override
  String get chatCardName => 'الدردشة';

  @override
  String get messageCardName => 'الرسالة';

  @override
  String get anOffer => 'عرض';

  @override
  String get you => 'أنت';

  @override
  String get sendTo => 'إرسال إلى';

  @override
  String get sendFailed => 'فشل الإرسال';

  @override
  String get deletedMessage => 'رسالة محذوفة';

  @override
  String get preparingChatRoom => 'جارٍ تجهيز غرفة الدردشة ...';

  @override
  String get messageCopied => 'تم نسخ الرسالة!';

  @override
  String get unMute => 'إلغاء الكتم';

  @override
  String get message => 'رسالة';

  @override
  String get clearChatSuccess => 'تم مسح الدردشة بنجاح';

  @override
  String get chatMutedSuccessfully => 'تم كتم الدردشة بنجاح';

  @override
  String get chatUnMutedSuccessfully => 'تم إلغاء كتم الدردشة بنجاح';

  @override
  String get offline => 'غير متصل';

  @override
  String get online => 'متصل';

  @override
  String get isAvailable => 'متاح';

  @override
  String get isNotAvailable => 'غير متاح';

  @override
  String get offlineVisibilityWarning =>
      'عندما تكون غير متاح فلن تظهر لطالبي العمرة';

  @override
  String get activeNow => 'نشط الآن';

  @override
  String get activeSince => 'نشط منذ';

  @override
  String get minuteSince => 'دقيقة';

  @override
  String get hourSince => 'ساعة';

  @override
  String get exitWarning => 'هل أنت متأكد أنك تريد الخروج؟';

  @override
  String get exitWarningDescription => 'إذا غادرت، ستُحذف هذه السجلات';

  @override
  String get couldNotFindTheReply =>
      'لم يتم العثور على الرد، قد تكون الرسالة قد حُذفت';

  @override
  String get youHavenTAnyMessage => 'ليس لديك أي رسالة بعد، ابدأ الدردشة';

  @override
  String get youHavenTAnyMessageYet => 'ليس لديك أي رسائل حتى الآن';

  @override
  String get deleteText => 'حذف';

  @override
  String get deleteMessage => 'حذف الرسالة';

  @override
  String get areYouSureYouWantToDeleteThisMessage =>
      'هل أنت متأكد أنك تريد حذف هذه الرسالة؟';

  @override
  String get youBlockedDec =>
      'لقد قمت بحظر هذا المستخدم، لا يمكنكما التواصل مع بعضكما البعض ';

  @override
  String get language_settings => 'إعدادات اللغة';

  @override
  String get change_password_settings => 'تغيير كلمة المرور';

  @override
  String get orders_settings => 'إعدادات الطلبات';

  @override
  String get my_rate_settings => 'تقييماتي';

  @override
  String get verify_moneeb_settings => 'توثيق منيب';

  @override
  String get policy_settings => 'سياسة الخصوصية';

  @override
  String get terms_settings => 'الشروط والأحكام';

  @override
  String get about_settings => 'عن منيب';

  @override
  String get who_moneeb_settings => 'من هو منيب؟';

  @override
  String get tazkiyah_settings => 'التزكية';

  @override
  String get logout_settings => 'تسجيل الخروج';

  @override
  String get delete_account_settings => 'حذف الحساب';

  @override
  String get delete_account_dialog_title => 'حذف الحساب';

  @override
  String get delete_account_dialog_desc =>
      'هذا الإجراء لا يمكن التراجع عنه. سيتم تعطيل حسابك فوراً ويُحال طلبك للحذف النهائي إلى الإدارة.';

  @override
  String get delete_account_confirm_title => 'تأكيد الحذف النهائي';

  @override
  String get delete_account_confirm_desc =>
      'هل أنت متأكد تمامًا؟ لن تتمكن من الوصول إلى حسابك بعد هذا الإجراء.';

  @override
  String get delete_account_success => 'تم تقديم طلب حذف الحساب بنجاح';

  @override
  String get account_will_be_deleted => 'سيتم مراجعة طلبك وحذف الحساب نهائياً';

  @override
  String get i_understand_delete_my_account =>
      'أنا أفهم وأوافق على حذف حسابي نهائياً وبشكل كامل';

  @override
  String get trusted_platform_badge =>
      'منيب .. منصة سعودية موثوقة و تحمل سجل تجاري';

  @override
  String get follow_us => 'تابعونا على صفحتنا!';

  @override
  String get social_media_description =>
      'يسعدنا انضمامكم إلينا! تابعوا كل جديدنا عبر صفحتنا';

  @override
  String get app_version => 'إصدار التطبيق';

  @override
  String get select_language => 'اختر اللغة';

  @override
  String get select_your_language => 'اختر لغتك المفضلة';

  @override
  String get homeNav => 'الرئيسية';

  @override
  String get ordersNav => 'الطلبات';

  @override
  String get requestOmraNav => 'طلب عمرة';

  @override
  String get zadNav => 'زاد';

  @override
  String get settingsNav => 'الإعدادات';

  @override
  String get stories => 'القصص';

  @override
  String get no_stories_available => 'لا يوجد قصص الآن';

  @override
  String get banners => 'العروض';

  @override
  String get no_banners_available => 'لا توجد عروض حالياً';

  @override
  String get forgot_password => 'نسيت كلمة المرور';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get registered_email => 'البريد الإلكتروني المسجل';

  @override
  String get forgot_password_description =>
      'أدخل بريدك الإلكتروني لتلقي رمز التحقق وإعادة تعيين كلمة المرور الخاصة بك.';

  @override
  String get please_enter_email => 'يرجى إدخال البريد الإلكتروني';

  @override
  String get continue_label => 'متابعة';

  @override
  String get verified_successfully => 'تم التحقق بنجاح';

  @override
  String get code_resent_successfully => 'تم إعادة إرسال الرمز بنجاح';

  @override
  String get enter_verification_code => 'أدخل رمز التحقق';

  @override
  String get verify => 'تحقق';

  @override
  String get didnt_receive_code => 'لم يصلك الرمز؟ ';

  @override
  String get resend => 'إعادة إرسال';

  @override
  String get password_updated_successfully => 'تم تحديث كلمة المرور بنجاح';

  @override
  String get reset_password => 'إعادة تعيين كلمة المرور';

  @override
  String get set_new_password => 'تعيين كلمة مرور جديدة';

  @override
  String get reset_password_instruction => 'يرجى إدخال كلمة مرور جديدة قوية.';

  @override
  String get new_password => 'كلمة المرور الجديدة';

  @override
  String get password_too_short => 'كلمة المرور قصيرة جداً (8 أحرف على الأقل)';

  @override
  String get confirm_password => 'تأكيد كلمة المرور';

  @override
  String get passwords_do_not_match => 'كلمات المرور غير متطابقة';

  @override
  String get update_password => 'تحديث كلمة المرور';

  @override
  String get profile => 'البروفايل';

  @override
  String get yourRating => 'تقييمك';

  @override
  String get hisRating => 'تقييمه';

  @override
  String get myRating => 'تقييمي';

  @override
  String get myUmrahsExecuted => 'عمرات نفذتها';

  @override
  String get hisUmrahsExecuted => 'عمرات نفذها';

  @override
  String get providerImage => 'صورة المعتمر';

  @override
  String get yourProviderImage => 'صورتك كمعتمر';

  @override
  String get providerVideo => 'فيديو المعتمر';

  @override
  String get yourProviderVideo => 'فيديو كمعتمر';

  @override
  String get reviews => 'التقييمات';

  @override
  String get noReviewsYet => 'لا توجد تقييمات حتى الآن';

  @override
  String get loadingReview => 'جاري تحميل التقييم...';

  @override
  String get accountInfo => 'معلومات الحساب';

  @override
  String get name => 'الاسم';

  @override
  String get enterName => 'أدخل الاسم';

  @override
  String get enterEmail => 'أدخل البريد الالكتروني';

  @override
  String get phone => 'رقم الجوال';

  @override
  String get enterPhone => 'أدخل رقم الجوال';

  @override
  String get selectCountry => 'اختر الدولة';

  @override
  String get gender => 'النوع';

  @override
  String get providerInfo => 'معلومات مقدم الخدمة';

  @override
  String get idNumber => 'رقم الهوية / الإقامة';

  @override
  String get enterIdNumber => 'أدخل رقم الهوية أو الإقامة';

  @override
  String get previousUmrahCount => 'عدد العمرات السابقة';

  @override
  String get enterPreviousUmrahCount => 'أدخل عدد العمرات التي أديتها';

  @override
  String get bio => 'نبذة عنك';

  @override
  String get bioHint => 'اكتب نبذة مختصرة تظهر للمعتمرين';

  @override
  String get isQuranHafiz => 'حافظ للقرآن الكريم';

  @override
  String get updatedSuccessfully => 'تم التحديث بنجاح';

  @override
  String get saveChanges => 'حفظ التعديلات';

  @override
  String get editProfile => 'تعديل الحساب';

  @override
  String get omrahStepMeqat => 'الميقات';

  @override
  String get omrahStepTawaf => ' الطواف';

  @override
  String get omrahStepPrayingBehindMakam =>
      'الصلاة خلف مقام ابراهيم عليه السلام';

  @override
  String get omrahStepMakamIbrahim => 'مقام ابراهيم';

  @override
  String get omrahStepSafaAndMarwa => 'السعي بين الصفا و المروه';

  @override
  String get omrahStepSafaAndMarwaShort => 'السعي';

  @override
  String get omrahStepTahalol => 'التحلل';

  @override
  String get omrahStepFinishOmrah => 'أنتهاء العمرة';

  @override
  String get finish => 'انهاء';

  @override
  String get phaseOne => 'التوثيق الأول';

  @override
  String get phaseTwo => 'التوثيق الثاني';

  @override
  String get tawafInstructions => 'إرشادات الطواف';

  @override
  String get documentationTitle => 'التوثيق';

  @override
  String get tawafVerifyInsideHaram => 'توثيق انك داخل الحرم';

  @override
  String get tawafVerifyDuaa => 'توثيق فيديو تلبية الدعاء لصاحب العمره';

  @override
  String get phaseThree => 'التوثيق الثالث';

  @override
  String get makamInstructions => 'إرشادات المقام الإبراهيمي';

  @override
  String get makamInstructionDesc =>
      'يرجي قراءة الارشادات جيدا لتطبيق صلاة المقام الإبراهيمي بشكل السليم';

  @override
  String get makamVerifyFirst => 'توثيق صلاة المقام الإبراهيمي';

  @override
  String get makamVerifyImage =>
      'صورة للمكان من الخلف أو للقبّة الزجاجية للمقام.';

  @override
  String get phaseFour => 'التوثيق الرابع';

  @override
  String get safaMarwaInstructions => 'السعي بين الصفا والمروة';

  @override
  String get safaMarwaInstructionDesc =>
      'يرجي قراءة الارشادات جيدا لتطبيق السعي بين الصفا والمروة بشكل السليم';

  @override
  String get safaMarwaVerifyFirst => 'توثيق فيديو في الوقف علي جبل الصفا';

  @override
  String get safaMarwaVerifyMap => 'تتبع علي الخريطه ل سبع أشواط';

  @override
  String get safaMarwaVerifyInsideMasaa =>
      'توثيق انك داخل المسعى بين الصفا والمروة';

  @override
  String get mekatInstructions => 'إرشادات الإحرام';

  @override
  String get mekatInstructionDesc =>
      'يرجي قراءة الارشادات جيدا لتطبيق الاحرام بشكل السليم';

  @override
  String get mekatVerifyFirst =>
      'التوثيق الاول عن طريق الجوجل ماب لتحديد الميقات';

  @override
  String get mekatVerifySecond => 'التوثيق التاني عن طريق الفيديو';

  @override
  String get phaseFive => 'التوثيق الخامس';

  @override
  String get tahalolVideo => 'فيديو';

  @override
  String get tahalolVerifyVideo => 'يرجي أختيار فيديو او صورة للتحلل';

  @override
  String get tahalolVerifyTitle => 'توثيق التحلل';

  @override
  String get tahalolVerifyImageDesc => 'صورة للتحلل';

  @override
  String get tahalolVerifyVideoDesc => 'فيديو للتحلل';

  @override
  String get omrahJourneyFinishPrefix => 'أنتهاء رحلة ';

  @override
  String get omrahRituals => 'مناسك العمرة';

  @override
  String get providerStillDoingStep => 'المزود ما زال يقوم بهذه الخطوة';

  @override
  String get trackProviderOnMap => 'تتبع مكانه علي الخريطة';

  @override
  String get videoSavedSuccessfully => 'تم حفظ الفيديو في المعرض بنجاح';

  @override
  String get videoSaveFailed => 'فشل في حفظ الفيديو';

  @override
  String get omrahVideoTitle => 'فيديو العمرة';

  @override
  String get videoShareFailed => 'فشل في مشاركة الفيديو';

  @override
  String get waitProviderLocation =>
      'برجاء الانتظار قليلا الي ان يرسل المعتمر موقعه';

  @override
  String get loadingRoute => 'جاري تحميل المسار...';

  @override
  String get noRouteRecorded => 'لم يتم تسجيل مسار لهذه العمرة';

  @override
  String get grantPermission => 'اعطاء الاذن';

  @override
  String get readGuideConfirm =>
      'يرجى قراءة محتوى الدليل والالتزام اضغط \"تأكيد\"';

  @override
  String get verifyVideoInsideMosque => 'توثيق الفيديو عند دخول المسجد الحرام';

  @override
  String get prayDuaaTakbeer => 'لا تنس التكبير والدعاء لمن نويت له بالعمرة';

  @override
  String get imageTranslate => 'صورة';

  @override
  String get verifyImageTitle => 'توثيق صوره';

  @override
  String get pickFromGallery => 'Pick from gallery';

  @override
  String omrahVerifyStep(String stepName) {
    return 'توثيق $stepName';
  }

  @override
  String get notReachedYet => 'لم يصل اليها';

  @override
  String get executedSuccessfully => 'تم التنفيذ';

  @override
  String get inProgress => 'قيد التنفيذ';

  @override
  String get videoProofUploadedSuccessfully =>
      'Video proof uploaded successfully';

  @override
  String get ritualsList => 'المناسك';

  @override
  String get finishOmrah => 'انهاء العمرة';

  @override
  String get didYouFinishOmrah => 'هل انهيت العمره ؟';

  @override
  String get yesIFinishedOmrah => 'نعم لقد اديت العمرة';

  @override
  String get noNotYet => 'لا, ليس بعد';

  @override
  String get ordersHeader => 'الطلبات';

  @override
  String get noOrdersMessage => 'لا توجد طلبات';

  @override
  String get orderStatusWaiting => 'في الانتظار';

  @override
  String get orderStatusAcceptReject => 'قبول /رفض';

  @override
  String get orderStatusApproved => 'الموافق عليه';

  @override
  String get orderStatusRejected => 'المرفوض';

  @override
  String get orderStatusExecuting => 'قيد التنفيذ';

  @override
  String get orderStatusCompleted => 'المكتمل';

  @override
  String get orderStatusCanceled => 'الملغي';

  @override
  String get orderStatusUnderReview => 'قيد المراجعة';

  @override
  String get orderStatusAssigned => 'تم التكليف';

  @override
  String get orderStatusAccepted => 'تم القبول';

  @override
  String get orderStatusRefused => 'مرفوض';

  @override
  String get orderStatusCompletedFemale => 'مكتملة';

  @override
  String get orderStatusCanceledFemale => 'ملغية';

  @override
  String get cancelOrderBtn => 'الغاء الطلب';

  @override
  String get rejectBtn => 'رفض';

  @override
  String omrahForBeneficiary(String name) {
    return 'عمره عن $name';
  }

  @override
  String get orderNumber => 'رقم الطلب';

  @override
  String get continueOmrah => 'متابعه العمره';

  @override
  String get viewOmrah => 'عرض العمره';

  @override
  String get orderCanceledSuccess => 'تم الغاء الطلب بنجاح';

  @override
  String get mapTitle => 'الخريطه';

  @override
  String get findNearestMeqat => 'تحديد أقرب ميقات';

  @override
  String get verifyYourLocation => 'توثيق موقعك';

  @override
  String get yesAuth => 'نعم';

  @override
  String get noAuth => 'لا';

  @override
  String get someParts => 'بعض الاجزاء';

  @override
  String get emailHint => 'البريد الالكتروني';

  @override
  String get createAccount => 'انشاء حساب';

  @override
  String get mutamerName => 'اسم المعتمر';

  @override
  String get mobileNumberHint => 'رقم الجوال';

  @override
  String get countryHint => 'الدولة';

  @override
  String get searchHint => 'ابحث';

  @override
  String get passwordHint => 'كلمة المرور';

  @override
  String get confirmPasswordHint => 'تأكيد كلمة المرور';

  @override
  String get pleaseConfirmPassword => 'يرجى تأكيد كلمة المرور';

  @override
  String get passwordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String get registerBtn => 'تسجيل';

  @override
  String get welcomeAuth => 'أهلاً بك';

  @override
  String get loginToViewOrdersDesc =>
      'سجّل دخولك لعرض طلبات أصحاب العمرة وأداء العمرة عنهم بكل ثقة وأمان.';

  @override
  String get orAuth => 'أو';

  @override
  String get haveAccount => 'لديك حساب ؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب ؟';

  @override
  String get loginBtn => 'تسجيل دخول';

  @override
  String get pleaseSelectType => 'من فضلك اختار النوع';

  @override
  String get nameHint => 'الاسم';

  @override
  String get chooseType => 'أختار النوع';

  @override
  String get nextAuth => 'التالى';

  @override
  String get loginToViewMutamersDesc => 'سجل دخولك لعرض المعتمرين وطلب عمرة';

  @override
  String get createAccountAlt => 'إنشاء حساب';

  @override
  String get welcomeToMoneeb => 'أهلاً بك في منيب';

  @override
  String get omrahForYouOrLovedOne => 'عمرةٌ عنك او عمّن تحب ... الى بيت الله';

  @override
  String get docTrackComply => 'توثيق • تتبّع • امتثال';

  @override
  String get continueBtn => 'الاستمرار';

  @override
  String get continueAsGuest => 'الاستمرار كضيف';

  @override
  String get chooseAccountType => 'اختر نوع حسابك';

  @override
  String get selectServiceToContinue =>
      'قم بتحديد الخدمة المطلوبة للإستمرار في عملية التسجيل';

  @override
  String get requestOmrahTitle => 'طلب عمرة';

  @override
  String get providerServiceTitle => 'مقدم خدمة الإنابة';

  @override
  String get startBtnAuth => 'بدأ';

  @override
  String get completeProfileTitle => 'اكمال الملف الشخصى';

  @override
  String get logoutString => 'تسجيل الخروج';

  @override
  String get doYouWantToLogout => 'هل تريد تسجيل الخروج؟';

  @override
  String get cancelString => 'إلغاء';

  @override
  String get createMutamerProfile => 'أنشىء بروفايل المعتمر';

  @override
  String get enterDataToCompleteProfile =>
      'قم بإدخال البيانات الاتية لاكمال اعداد حسابك';

  @override
  String get uploadImageTitle => 'رفع الصورة';

  @override
  String get yourBioHint => 'سيرة الذاتية الخاصة بك';

  @override
  String get timesPerformedOmrah => 'عدد المرات أديت العمرة';

  @override
  String get uploadIdImage => 'رفع صورة الهوية';

  @override
  String get idNumberHint => 'رقم الهوية';

  @override
  String get continueAuth => 'استمرار';

  @override
  String get oneStepLeft => 'تبقى خطوة واحدة';

  @override
  String get uploadTrustedCertificates => 'أرفع بعض الشهادات لك من جهات موثوقه';

  @override
  String get certificateName => 'أسم الشهادة';

  @override
  String get backBtn => 'رجوع';

  @override
  String get finishBtnAuth => 'انهاء';

  @override
  String get kasamTitle => 'القسم';

  @override
  String get agreeAndPledge => 'أوافق وأتعهد بما ورد أعلاه';

  @override
  String get iSwearThat => 'اقسم على ذلك';

  @override
  String get thankYouFor => 'شكرًا لك على ';

  @override
  String get creatingYourAccount => 'إنشاء حسابك';

  @override
  String get orderReceivedSuccessfully =>
      'تم استلام طلبك بنجاح،\nوسيتم مراجعته من قبل إدارة التطبيق خلال وقت قصير.';

  @override
  String get returnToHome => 'العودة للرئيسية';

  @override
  String get loginTitleBtn => 'تسجيل الدخول';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get tazkiyahSuccess => 'تمت التزكية بنجاح';

  @override
  String get tazkiyahAlreadySubmitted => 'لقد قمت بتزكية هذا الشخص مسبقاً';

  @override
  String get noTazkiyahsYet => 'لم تقم بأي تزكية بعد';

  @override
  String get previousTazkiyahs => 'التزكيات السابقة';

  @override
  String get tazkiyahTitle => 'التزكيه';

  @override
  String get tazkiyahDesc =>
      'نُزكي هذا الشخص ونشهد له بالأمانة وحسن الخلق والالتزام، وهو محل ثقة بإذن الله.';

  @override
  String get changeTazkiyah => 'تغيير';

  @override
  String get tazkiyahReasons => 'أسباب التزكية';

  @override
  String get pleaseEnterTazkiyahReason => 'الرجاء إدخال سبب التزكية';

  @override
  String get oathText =>
      'أشهد، بحسب معرفتي الشخصية بالمتقدم، أنني أعرف عنه الأمانة وحسن السيرة، وأراه أهلاً لتحمل مسؤولية أداء العمرة عن الغير والالتزام بمتطلبات التوثيق المعتمدة لدى منصة منيب. وأقر بأن هذه الإفادة مبنية على معرفة حقيقية وليست مقابل منفعة مالية أو مصلحة شخصية.\n\nعزّز طلب انضمامك بالتزكية\nيمكن للمؤدين المعتمدين لدى منيب ممن يعرفونك معرفة شخصية تزكية أهليتك وأمانتك.\nتساعد التزكيات فريق منيب في تقييم طلبك، لكنها لا تعني القبول التلقائي؛ إذ يخضع كل طلب للمراجعة والتحقق وفق معايير المنصة.';

  @override
  String get reviewSentSuccessfully => 'تم ارسال التقييم بنجاح';

  @override
  String get evaluateOmrah => 'تقييم العمرة';

  @override
  String get addYourCommentHere => 'أضف تعليقك هنا...';

  @override
  String get confirmEvaluation => 'تأكيد التقييم';

  @override
  String get omrahCompletedSuccessfully => 'تم انهاء العمره بنجاح';

  @override
  String get omrahWord => 'العمرة';

  @override
  String get afterSpiritualJourneyDesc =>
      'بعد هذه الرحلة الروحية العميقة، نرجو أن يكون قلبك أكثر صفاءً، وأن تجد في كل خطوة قمت بها في مكة بركة ورحمة. تقبل الله منك وأحسن إليك';

  @override
  String get locationNotValidForMiqat => 'الموقع غير صالح للميقات';

  @override
  String get locationNotValidForTawaf => 'الموقع غير صالح للطواف';

  @override
  String get locationNotValidForSai => 'الموقع غير صالح للسعي';

  @override
  String get locationProofed => 'تم التحقق من الموقع';

  @override
  String get grantLocationPermissionPlease => 'برجاء اعطاء الاذن للموقع';

  @override
  String get grantLocationDesc =>
      'برجاء اعطاء الاذن لاستخدام الموقع حتي يتمكن صاحب الطلب من تتبع العمره';

  @override
  String get noVideoFound => 'لا يوجد فيديو';

  @override
  String get videoSavedToGallerySuccess => 'تم حفظ الفيديو في المعرض بنجاح';

  @override
  String get failedToSaveVideo => 'فشل في حفظ الفيديو';

  @override
  String get omrahVideoUrlShare => 'فيديو العمرة';

  @override
  String get failedToShareVideo => 'فشل في مشاركة الفيديو';

  @override
  String get imageSavedToGallerySuccess => 'تم حفظ الصورة في المعرض بنجاح';

  @override
  String get failedToSaveImage => 'فشل في حفظ الصورة';

  @override
  String get omrahImageUrlShare => 'صورة العمرة';

  @override
  String get failedToShareImage => 'فشل في مشاركة الصورة';

  @override
  String get proofAlreadySubmitted => 'لقد قمت بإرسال إثباتك بالفعل';

  @override
  String get omrahConclusion => 'الخاتمة';

  @override
  String get endOfJourney => 'انتهاء توثيق ';

  @override
  String get omrahCompletionConfirmed =>
      'قام المعتمر بتأكيد انتهائه من اداء العمرة';

  @override
  String get omrahCompletionConfirmedFor =>
      'قام المعتمر بتأكيد انتهائه من اداء العمرة عن';

  @override
  String get omrahAcceptedSupplication => 'تقبل الله منا ومنكم صالح الأعمال';

  @override
  String get evaluate => 'تقييم';

  @override
  String get omrahRequestReassignHintForUser =>
      'في حال عدم قبول طلبك خلال 12 ساعة، سيتم تحويله تلقائيًا إلى مزوّد آخر.';

  @override
  String get omrahRequestReassignHintForProvider =>
      'يرجى قبول الطلبات خلال 12 ساعة، وإلا سيتم تحويله إلى مزوّد آخر.';

  @override
  String get meeqatVideoDocumentation => 'توثيق فيديو الميقات';

  @override
  String get tawafVideoDocumentation => 'توثيق بدء الطواف';

  @override
  String get saiVideoDocumentation => 'توثيق فيديو السعي';

  @override
  String get ibrahimMakamPrayerVideo => 'فيديو صلاة المقام الابراهيمي';

  @override
  String get tahalulVideoDocumentation => 'توثيق فيديو التحلل';

  @override
  String get stepDocumentedSuccessfully => 'تم التوثيق بنجاح';

  @override
  String nextStepIs(String nextStep) {
    return 'التوثيق التالي هو $nextStep';
  }

  @override
  String get nextStep => 'التوثيق التالي';

  @override
  String get tapToCaptureImage => 'اضغط لالتقاط صورة';

  @override
  String get cantUploadEmptyFile =>
      'لا يمكن رفع ملف فارغ، تأكد من رفع ملف صالح';

  @override
  String get imageCompressFailed => 'فشل في ضغط الصورة';

  @override
  String get invalidPhoneNumber => 'رقم الهاتف غير صالح';

  @override
  String get sharedPost => 'منشور تمت مشاركته';

  @override
  String get couldNotDownloadFile => 'لم نتمكن من تنزيل الملف';

  @override
  String get couldNotFetchLocation => 'لم نتمكن من جلب الموقع';

  @override
  String get imageProofUploadedSuccessfully => 'تم رفع إثبات الصورة بنجاح';

  @override
  String get emailOrPhoneHint => 'البريد الإلكتروني أو رقم الجوال';

  @override
  String get emptyEmailOrPhoneError =>
      'يرجى إدخال البريد الإلكتروني أو رقم الجوال.';

  @override
  String get invalidSaudiPhoneError =>
      'رقم جوال غير صالح. يجب أن يبدأ بـ 05 أو 5 ويتكون من 9 أو 10 أرقام.';

  @override
  String get invalidSaudiPhonePrefixError =>
      'رقم الجوال يجب أن يبدأ بـ 05 أو 5';

  @override
  String get saudiPhoneNineDigitsError => 'رقم الجوال يجب أن يتكون من 9 أرقام';

  @override
  String get saudiPhoneTenDigitsError => 'رقم الجوال يجب أن يتكون من 10 أرقام';

  @override
  String get emailOrPhoneFieldError =>
      'يرجى إدخال بريد إلكتروني صالح أو رقم جوال .';

  @override
  String get homeLive => 'بث مباشر';

  @override
  String get emailTabLabel => 'البريد الإلكتروني';

  @override
  String get phoneTabLabel => 'الجوال';

  @override
  String get loginWithOtpDesc =>
      'أدخل بريدك الإلكتروني أو رقم جوالك لاستلام رمز التحقق.';

  @override
  String get registerAsServiceProvider => 'التسجيل كمقدّم خدمة';

  @override
  String get chooseVerificationMethod => 'اختر طريقة التحقق';

  @override
  String get chooseVerificationMethodDesc =>
      'اختر الطريقة التي تريد استلام الرمز بها.';

  @override
  String get otpChannelWhatsapp => 'واتساب';

  @override
  String get otpChannelSms => 'رسالة نصية';

  @override
  String get otpChannelCall => 'مكالمة هاتفية';

  @override
  String get otpChannelEmail => 'البريد الإلكتروني';

  @override
  String get verificationTitle => 'التحقق';

  @override
  String get codeSentTo => 'أرسلنا رمز التحقق إلى';

  @override
  String get changeVerificationMethod => 'تغيير طريقة التحقق';

  @override
  String get providerIdentityDesc =>
      'تحقق من بريدك الإلكتروني أو رقم جوالك للتسجيل كمقدّم خدمة.';

  @override
  String get passwordOptionalHint => 'كلمة المرور';

  @override
  String get providerNotFound => 'لم يتم العثور على مقدّم خدمة بهذه البيانات';

  @override
  String get searchByEmailOrPhone =>
      'ابحث عن مقدّم الخدمة بالبريد الإلكتروني أو رقم الجوال';

  @override
  String get omrahCertificate => 'شهادة أداء العمرة';

  @override
  String get myCertificates => 'شهاداتي';

  @override
  String get generateCertificate => 'إنشاء الشهادة';

  @override
  String get viewCertificate => 'عرض الشهادة';

  @override
  String get generatingCertificate => 'جارٍ تجهيز الشهادة…';

  @override
  String get certificateGeneratedSuccessfully => 'تم إنشاء الشهادة بنجاح';

  @override
  String get certificateHintForProvider =>
      'أنشئ شهادة تُثبت أداء العمرة، ثم حمّلها أو شاركها مع صاحب الطلب.';

  @override
  String get certificateHintForUser =>
      'أنشئ شهادة تُثبت أداء العمرة، ثم حمّلها أو شاركها مع من تحب.';

  @override
  String get loadingCertificate => 'جارٍ تحميل الشهادة…';

  @override
  String get certificatePreviewUnavailable =>
      'تعذّر عرض الشهادة، ويمكنك مشاركتها كملف PDF.';

  @override
  String get certificateSavedToGallery => 'تم حفظ الشهادة في معرض الصور';

  @override
  String get failedToSaveCertificate => 'تعذّر حفظ الشهادة';

  @override
  String get failedToShareCertificate => 'تعذّرت مشاركة الشهادة';

  @override
  String certificateShareMessage(String name) {
    return 'شهادة أداء العمرة عن $name';
  }

  @override
  String certificatePageIndicator(int current, int total) {
    return 'صفحة $current من $total';
  }

  @override
  String get charterPageTitle => 'ميثاق الأمانة والقَسَم';

  @override
  String get charterHeaderTitle => 'ميثاق الأمانة والقَسَم';

  @override
  String get charterHeaderSubtitle =>
      'اقرأ الميثاق كاملًا، فلا تُفعَّل الموافقة إلا بعد الوصول إلى نهايته.';

  @override
  String get charterNoticeTitle => 'تنبيه قبل المتابعة';

  @override
  String get charterNoticeBody =>
      'يتضمن هذا الميثاق قسمًا بالله العظيم وتعهدًا ملزمًا؛ لذا يجب قراءته كاملًا، ولا يجوز الموافقة عليه إلا بعد فهم جميع ما ورد فيه والقدرة على الالتزام به.';

  @override
  String charterSectionLabel(int index, int total) {
    return 'البند $index من $total';
  }

  @override
  String get charterS1Title => 'أولًا: صحة البيانات والأهلية';

  @override
  String get charterS1Intro => 'أقر بما يلي:';

  @override
  String get charterS1I1 =>
      'أن جميع البيانات والمستندات التي قدمتها صحيحة وكاملة وتخصني شخصيًا.';

  @override
  String get charterS1I2 =>
      'أنني لم أستخدم بيانات شخص آخر، ولم أسمح لغيري بالتسجيل أو استخدام الحساب نيابةً عني.';

  @override
  String get charterS1I3 => 'أنني سبق أن أديت العمرة عن نفسي.';

  @override
  String get charterS1I4 =>
      'أنني قادر صحيًا وبدنيًا على أداء مناسك العمرة كاملة.';

  @override
  String get charterS1I5 =>
      'أنني سأحدّث بياناتي فور حدوث أي تغيير يؤثر في أهليتي لأداء العمرة.';

  @override
  String get charterS1I6 =>
      'أنني سأفصح لمنيب عن أي مانع صحي أو نظامي أو شرعي قد يؤثر في قدرتي على تنفيذ الطلبات.';

  @override
  String get charterS2Title => 'ثانيًا: نزاهة التزكيات';

  @override
  String get charterS2Intro => 'أقر وأتعهد بما يلي:';

  @override
  String get charterS2I1 => 'ألا أطلب تزكية إلا ممن يعرفني معرفة شخصية حقيقية.';

  @override
  String get charterS2I2 => 'ألا أطلب أو أرتب أي تزكية صورية أو غير صحيحة.';

  @override
  String get charterS2I3 =>
      'ألا أستخدم بيانات أي مؤدٍّ معتمد للحصول على تزكية دون علمه وموافقته.';

  @override
  String get charterS2I4 =>
      'أنني مسؤول عن صحة ما أقدمه، ولا تعفيني التزكيات من المسؤولية ولا تضمن قبول طلبي.';

  @override
  String get charterS2I5 =>
      'أن لمنيب حق التحقق من التزكيات واستبعاد أي تزكية لا تستوفي معايير المنصة.';

  @override
  String get charterS3Title => 'ثالثًا: أداء العمرة';

  @override
  String get charterS3Intro =>
      'إذا قُبلت مؤديًا لدى منيب، فإنني أتعهد بما يلي:';

  @override
  String get charterS3I1 =>
      'ألا أقبل أي طلب إلا إذا كنت قادرًا على تنفيذه كاملًا في الوقت المحدد.';

  @override
  String get charterS3I2 =>
      'أن أؤدي العمرة بنفسي عن الشخص المحدد في الطلب، وألا أعهد بها إلى شخص آخر.';

  @override
  String get charterS3I3 =>
      'أن أنوي العمرة عن المؤدّى عنه المحدد في الطلب، وألا أغيّر الشخص أو أجمع أكثر من طلب في عمرة واحدة.';

  @override
  String get charterS3I4 =>
      'أن أُحرم من الميقات المعتبر، ثم أؤدي الطواف والسعي والحلق أو التقصير حتى اكتمال العمرة والتحلل منها.';

  @override
  String get charterS3I5 =>
      'أن ألتزم بالأحكام الشرعية المتعلقة بعمرة البدل، وبالتعليمات التشغيلية المعتمدة لدى منيب.';

  @override
  String get charterS3I6 => 'ألا أؤكد أي توثيق قبل أدائه فعليًا.';

  @override
  String get charterS3I7 =>
      'أن أتوقف عن التنفيذ وأبلغ منيب فورًا إذا طرأ ما يمنعني من إكمال العمرة، وألا أقرر اكتمالها وهي غير مكتملة.';

  @override
  String get charterS4Title => 'رابعًا: التوثيق والتحقق';

  @override
  String get charterS4Intro =>
      'أتعهد بأن يكون توثيق العمرة حقيقيًا ومعاصرًا لأدائها، وذلك على النحو الآتي:';

  @override
  String get charterS4I1 =>
      'أُجري التوثيقات المطلوبة من داخل تطبيق منيب حصرًا، ومن مواقعها الفعلية وفي أوقاتها الحقيقية.';

  @override
  String get charterS4I2 =>
      'ألتزم بتوثيق الإحرام والطواف والسعي والتحلل وفق التعليمات الظاهرة في التطبيق.';

  @override
  String get charterS4I3 =>
      'أذكر بيانات المؤدّى عنه في المواضع التي تطلبها المنصة لإثبات تخصيص العمرة له.';

  @override
  String get charterS4I4 =>
      'لا أستخدم تسجيلات سابقة أو صورًا أو مقاطع تخص عمرة أخرى أو شخصًا آخر.';

  @override
  String get charterS4I5 =>
      'لا أعدّل التوثيق أو أزوّره أو أعيد تمثيل أي توثيق بعد انتهائه على أنه توثيق مباشر.';

  @override
  String get charterS4I6 =>
      'لا أسمح لشخص آخر بحمل جهازي أو استخدام حسابي لتنفيذ التوثيق نيابةً عني.';

  @override
  String get charterS4I7 =>
      'لا أستخدم أي وسيلة للتحايل على الموقع الجغرافي أو الوقت أو الكاميرا أو أنظمة التحقق داخل التطبيق.';

  @override
  String get charterS4I8 =>
      'أوافق على استخدام الموقع الجغرافي والوقت والكاميرا داخل التطبيق للتحقق من توثيقات العمرة أثناء تنفيذ الطلب.';

  @override
  String get charterS5Title => 'خامسًا: الخصوصية والسلوك';

  @override
  String get charterS5Intro => 'أتعهد بما يلي:';

  @override
  String get charterS5I1 =>
      'المحافظة على سرية بيانات طالب العمرة والمؤدّى عنه، وعدم استخدامها أو مشاركتها خارج غرض تنفيذ الطلب.';

  @override
  String get charterS5I2 =>
      'احترام حرمة المسجد الحرام وخصوصية المعتمرين، وألا يكون التوثيق سببًا في إيذاء الآخرين أو تعطيلهم.';

  @override
  String get charterS5I3 =>
      'الالتزام بالأنظمة والتعليمات الصادرة عن الجهات المختصة داخل المملكة العربية السعودية.';

  @override
  String get charterS5I4 =>
      'التواصل بأمانة واحترام مع منيب، والإجابة بصدق عن أي استفسار يتعلق بالتنفيذ أو التوثيق.';

  @override
  String get charterS6Title => 'سادسًا: المسؤولية والإجراءات';

  @override
  String get charterS6Intro => 'أقر بأن:';

  @override
  String get charterS6I1 =>
      'تقديم طلب التسجيل أو الحصول على تزكيات لا يعني قبولي تلقائيًا كمؤدي عمرة.';

  @override
  String get charterS6I2 =>
      'لمنيب حق التحقق من بياناتي ومستنداتي وتزكياتي وسجل تنفيذ الطلبات.';

  @override
  String get charterS6I3 =>
      'أي بيانات غير صحيحة أو توثيق مزيف أو تحايل أو تنفيذ بواسطة شخص آخر يُعد مخالفة جوهرية.';

  @override
  String get charterS6I4 =>
      'يحق لمنيب عند ثبوت المخالفة رفض الطلب أو تعليق الحساب أو إلغاؤه، واتخاذ الإجراءات المنصوص عليها في شروط الاستخدام والاتفاقية.';

  @override
  String get charterS6I5 =>
      'لا أستحق المقابل المالي عن أي عمرة لم أنفذها كاملة، أو ثبت عدم صحة تنفيذها أو توثيقها.';

  @override
  String get charterS6I6 =>
      'أتحمل المسؤولية النظامية عن أي تزوير أو احتيال أو إساءة استخدام، مع حق منيب في إحالة المخالفة إلى الجهة المختصة متى استوجب الأمر ذلك.';

  @override
  String get charterOathTitle => 'القَسَم';

  @override
  String get charterOathBody =>
      'أقسم بالله العظيم أن جميع البيانات والمستندات والإقرارات التي قدمتها صحيحة، وأنني سبق أن أديت العمرة عن نفسي، وأنني إذا قُبلت مؤديًا لدى منصة منيب فسأؤدي كل عمرة أقبلها بنفسي، عن الشخص المحدد في الطلب، وسأتم مناسكها كاملة حتى التحلل، وأوثقها توثيقًا حقيقيًا من مواقعها الفعلية وفي أوقاتها الصحيحة، دون كذب أو تزوير أو تحايل أو استبدال أو إنابة شخص آخر، وأن ألتزم بجميع ما ورد في هذا الميثاق. والله على ما أقول شهيد.';

  @override
  String get charterEndOfDocument => 'نهاية الميثاق';

  @override
  String get charterScrollHint => 'اسحب لأسفل لقراءة بقية البنود';

  @override
  String charterReadPercent(int percent) {
    return '$percent٪';
  }

  @override
  String get charterAgreeCheckbox =>
      'أقر بأنني قرأت جميع بنود الميثاق وفهمتها وأوافق عليها';

  @override
  String get charterSwearButton => 'أقسم بالله على ذلك';

  @override
  String get charterGoToEnd => 'الانتقال إلى نهاية الميثاق';

  @override
  String get proofGeoFenceVerified =>
      'تم التحقق من وجود المعتمر داخل النطاق الجغرافي';

  @override
  String get omrahAlreadyRated => 'تم تقييم هذه العمرة';

  @override
  String get omrahRatingOnceOnly => 'التقييم متاح مرة واحدة فقط لكل عمرة';

  @override
  String get proofCapturedInsideAppOnly =>
      'هذا التوثيق قام بتصويره المعتمر حصراً ومباشرةً من داخل التطبيق';

  @override
  String get voiceDocumentationTitle => 'عبارة التوثيق الصوتي';

  @override
  String get voiceDocumentationHintMiqat =>
      'مع تسجيل الفيديو يمكنك ذكر التوثيق التالي';

  @override
  String get voiceDocumentationHintTawaf =>
      'أذكر العبارة التالية عند تسجيلك للفيديو';

  @override
  String get voiceDocumentationHintSai =>
      'مع تسجيل الفيديو اذكر العبارة التالية';

  @override
  String get voiceDocumentationHintTahalol =>
      'اذكر العبارة التالية عند تسجيل فيديو التحلل';

  @override
  String get voiceDocumentationActionMiqat => 'عند الميقات وعند الإحرام، قل:';

  @override
  String get voiceDocumentationActionTawaf => 'قبل بدء الطواف، قل:';

  @override
  String get voiceDocumentationActionSai =>
      'عند الوقوف على الصفا وقبل بدء السعي، قل:';

  @override
  String get voiceDocumentationActionTahalol => 'صوّر فعل التقصير';

  @override
  String voiceDocumentationPhraseMiqat(String beneficiary) {
    return 'لبيك اللهم لبيك عمرة عن $beneficiary';
  }

  @override
  String voiceDocumentationPhraseTawaf(String beneficiary) {
    return 'توثيق بداية طواف العمرة عن $beneficiary بسم الله الله أكبر';
  }

  @override
  String voiceDocumentationPhraseSai(String beneficiary) {
    return 'توثيق سعي عمرة عن $beneficiary';
  }

  @override
  String voiceDocumentationPhraseTahalol(String beneficiary) {
    return 'تم التقصير، وبه تمت العمرة عن $beneficiary';
  }

  @override
  String get voiceDocumentationNoteTawaf =>
      'ثم التكبير عند محاذاة الحجر الأسود.';

  @override
  String get stepProofRejected => 'رفضت الإدارة إثبات هذا التوثيق';

  @override
  String get rejectionReason => 'سبب الرفض';

  @override
  String get reuploadStepProofHint =>
      'يرجى إعادة هذا التوثيق ورفع الإثبات مرة أخرى.';

  @override
  String get proofRejectedStatus => 'تم رفض الإثبات';

  @override
  String get omrahStartsIn => 'تبدأ المناسك بعد';

  @override
  String get omrahStartsInUser => 'باقي على بدء مناسك العمرة';

  @override
  String get countdownDays => 'يوم';

  @override
  String get countdownHours => 'ساعة';

  @override
  String get countdownMinutes => 'دقيقة';

  @override
  String get countdownSeconds => 'ثانية';

  @override
  String omrahStartDate(String date) {
    return 'موعد البدء: $date';
  }

  @override
  String get omrahTimeArrivedProvider =>
      'حان موعد بدء المناسك، يمكنك البدء الآن';

  @override
  String get omrahTimeArrivedUser =>
      'حان موعد عمرتك، سيبدأ مقدم الخدمة المناسك قريبًا';

  @override
  String ritualsLockedUntil(String date) {
    return 'تبدأ المناسك في $date';
  }

  @override
  String omrahNotStartedYet(String date) {
    return 'لم يحن موعد الطلب بعد، تبدأ المناسك في $date';
  }

  @override
  String get upcomingOmrah => 'عمرة قادمة';

  @override
  String startsInDaysHours(int days, int hours) {
    return 'تبدأ بعد $days يوم و $hours ساعة';
  }

  @override
  String startsInClock(String time) {
    return 'تبدأ بعد $time';
  }
}
