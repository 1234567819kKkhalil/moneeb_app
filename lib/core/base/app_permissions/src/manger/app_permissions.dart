part of app_permissions;

class AppPermissions with AppPermissionsMixin {
  AppPermissions._();
  static final instance = AppPermissions._();

  Future<void> requestNotificationPermission() async {
    final permission = Permission.notification;

    final granted = await arePermissionsGrantedOrLimited([permission]);
    if (granted) return;

    final results = await requestPermissions([permission]);
    final allGranted = isAllGrantedOrLimited(results);
    if (allGranted) return;

    await showSettingsDialogIfNeeded([permission]);

    throw UnExpectedFailure(appLocalizer.permissionNotGrantedError);
  }

  Future<void> requestVideoRecordPermissions() async {
    final permissions = [Permission.microphone, Permission.camera];

    final granted = await arePermissionsGrantedOrLimited(permissions);
    if (granted) return;

    final results = await requestPermissions(permissions);

    final allGranted = isAllGrantedOrLimited(results);
    if (allGranted) return;

    await showSettingsDialogIfNeeded(permissions);

    throw UnExpectedFailure(appLocalizer.permissionNotGrantedError);
  }

  Future<void> requestCameraPermission() async {
    const permission = Permission.camera;
    final granted = await arePermissionsGrantedOrLimited([permission]);
    if (granted) return;

    final results = await requestPermissions([permission]);
    final allGranted = isAllGrantedOrLimited(results);
    if (allGranted) return;

    await showSettingsDialogIfNeeded([permission]);

    throw UnExpectedFailure(appLocalizer.permissionNotGrantedError);
  }

  Future<void> requestMediaLibraryPermission() async {
    final permission = Permission.photos;

    if (Platform.isAndroid) return;

    final granted = await arePermissionsGrantedOrLimited([permission]);
    if (granted) return;

    final results = await requestPermissions([permission]);
    final allGranted = isAllGrantedOrLimited(results);
    if (allGranted) return;

    await showSettingsDialogIfNeeded([permission]);

    throw UnExpectedFailure(appLocalizer.permissionNotGrantedError);
  }

  Future<void> requestPhotosAndVideosPermissions() async {
    final permissions = [Permission.photos, Permission.videos];

    final granted = await arePermissionsGrantedOrLimited(permissions);
    if (granted) return;

    final results = await requestPermissions(permissions);

    final allGranted = isAllGrantedOrLimited(results);
    if (allGranted) return;

    await showSettingsDialogIfNeeded(permissions);

    throw UnExpectedFailure(appLocalizer.permissionNotGrantedError);
  }

  Future<void> requestLocationPermissions() async {
    final permissionStatus = await Geolocator.checkPermission();

    if (permissionStatus == LocationPermission.denied) {
      final requested = await Geolocator.requestPermission();

      if (requested == LocationPermission.denied) {
        throw UnExpectedFailure(appLocalizer.permissionNotGrantedError);
      }

      if (requested == LocationPermission.deniedForever) {
        await handleLocationDeniedForever();
        throw UnExpectedFailure(appLocalizer.permissionNotGrantedError);
      }
    }

    if (permissionStatus == LocationPermission.deniedForever) {
      await handleLocationDeniedForever();
      throw UnExpectedFailure(appLocalizer.permissionNotGrantedError);
    }

    return;
  }

  Future<void> openNotificationAppSettings() async {
    try {
      if (Platform.isAndroid) {
        await AppSettings.openAppSettings(type: AppSettingsType.notification);
      } else {
        await AppSettings.openAppSettings();
      }
    } on PlatformException catch (e) {
      debugPrint("Error opening app settings: $e");
    }
  }
}

mixin AppPermissionsMixin {

  // Helper method to get permission status //
  Future<bool> arePermissionsGrantedOrLimited(List<Permission> permissions) async {
    for (final permission in permissions) {
      final status = await permission.status;
      if (status.isGranted && status.isLimited) return true;
    }
    return false;
  }

  Future<Map<Permission, PermissionStatus>> requestPermissions(List<Permission> permissions) async {
    return await permissions.request();
  }

  bool isAllGrantedOrLimited(Map<Permission, PermissionStatus> results) {
    return results.values.every((status) => status.isGranted || status.isLimited);
  }

  Future<bool> shouldSuggestOpeningSettings(List<Permission> permissions) async {
    for (var permission in permissions) {
      final status = await permission.status;
      if (status.isDenied || status.isPermanentlyDenied || status.isRestricted) {
        return true;
      }
    }
    return false;
  }

  Future<void> showSettingsDialogIfNeeded(List<Permission> permissions) async {
    final shouldOpen = await shouldSuggestOpeningSettings(permissions);
    if (shouldOpen) {
      await showPermissionDialog(permissions);
    }
  }

  Future<void> handleLocationDeniedForever() async {
    const locationPermission = Permission.location;
    final shouldOpen = await shouldSuggestOpeningSettings([locationPermission]);

    if (shouldOpen) {
      await showPermissionDialog([locationPermission]);
    }
  }

  //------------------------

  // If user refuse to give permission and he intended to use feature again a dialog will be shown to navigate to settings
  Future<bool?> showPermissionDialog(List<Permission> permissions,{VoidCallback? onCancelTap}) async {
    final context = await AppRouteNavigator.getAppContextWhenAvailable();
    if (!context.mounted) return false;

    final lang = context.read<AppLanguageCubit>().state.langCode.name;

    return AppAlerts.showCustomDialog(
      context,
      canPop: true,
      // borderRadius: Dimensions.xxLargeRadius,
      widget: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Gap(12),
          Text(
            appLocalizer.permissionRequired(_getPermissionsDescription(permissions, lang: lang).join('')),
            style: context.bold.copyWith(fontSize: Dimensions.xxLarge,height: 1.4),
            textAlign: TextAlign.center,
          ),
          const Gap(PaddingDimensions.normal),
          Text(
            appLocalizer.permissionRequiredDesc(_getPermissionsDescription(permissions, lang: lang).join('')),
            textAlign: TextAlign.center,
            softWrap: true,
            style: context.regular.copyWith(
              fontSize: Dimensions.large,
              height: 1.4,
            ),
          ),
          const SizedBox(height: PaddingDimensions.xLarge),

          const Gap(12),
          AppPrimaryButton(
            text: appLocalizer.openSettings,
            buttonHeight: Dimensions.buttonMediumHeight,
            onPressed: () async {
              AppRouteNavigator.pop(context);
              await _openAppSettings();
            },
            isExpanded: true,
          ),
          const Gap(PaddingDimensions.medium),
          AppPrimaryButton.outline(
            buttonHeight: Dimensions.buttonMediumHeight,
            isExpanded: true,
            text: appLocalizer.cancel,
            onPressed: onCancelTap ?? () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  List<String> _getPermissionsDescription(List<Permission> permissions, {String lang = 'en'}) {
    final Map<Permission, Map<String, String>> permissionNames = {
      Permission.camera: {'en': 'Camera', 'ar': 'الكاميرا'},
      Permission.mediaLibrary: {'en': 'Media Library', 'ar': 'مكتبة الوسائط'},
      Permission.microphone: {'en': 'Microphone', 'ar': 'الميكروفون'},
      Permission.photos: {'en': 'Photos', 'ar': 'الصور'},
      Permission.photosAddOnly: {'en': 'Photos', 'ar': 'الصور'},
      Permission.storage: {'en': 'Storage', 'ar': 'الذاكرة الداخلية'},
      Permission.notification: {'en': 'Notifications', 'ar': 'الإشعارات'},
      Permission.videos: {'en': 'Videos', 'ar': 'مقاطع الفيديو'},
      Permission.calendarWriteOnly: {'en': 'Calendar', 'ar': 'التقويم'},
      Permission.calendarFullAccess: {'en': 'Calendar', 'ar': 'التقويم'},
    };

    return permissions.map((permission) {
      return permissionNames[permission]?[lang] ??
          permission.toString().split('.').last;
    }).toList();
  }

  Future<void> _openAppSettings() async {
    try {
      await openAppSettings();
    } on PlatformException catch (e) {
      debugPrint("Error opening app settings: $e");
    }
  }
}