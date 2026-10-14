part of app_permissions;

class AppPermissionsState extends Equatable {
  final StateBox<void> cameraPermission;
  final StateBox<void> mediaLibraryPermission;
  final StateBox<void> notificationPermissions;
  final StateBox<void> photosAndVideosPermissions;
  final StateBox<void> recordingPermissions;
  final StateBox<void> voicePermissions;
  final StateBox<void> locationPermissions;
  final StateBox<void> isLocationPermissionsEnabled;

  const AppPermissionsState({
    required this.cameraPermission,
    required this.mediaLibraryPermission,
    required this.notificationPermissions,
    required this.photosAndVideosPermissions,
    required this.recordingPermissions,
    required this.voicePermissions,
    required this.locationPermissions,
    required this.isLocationPermissionsEnabled,
  });

  const AppPermissionsState.initial()
      : this(
          cameraPermission: const StateBox.initial(),
          mediaLibraryPermission: const StateBox.initial(),
          notificationPermissions: const StateBox.initial(),
          photosAndVideosPermissions: const StateBox.initial(),
          recordingPermissions: const StateBox.initial(),
          voicePermissions: const StateBox.initial(),
          locationPermissions: const StateBox.initial(),
          isLocationPermissionsEnabled: const StateBox.initial(),
        );

  AppPermissionsState reduce({
    StateBox<void>? cameraPermission,
    StateBox<void>? mediaLibraryPermission,
    StateBox<void>? notificationPermissions,
    StateBox<void>? photosAndVideosPermissions,
    StateBox<void>? recordingPermissions,
    StateBox<void>? voicePermissions,
    StateBox<void>? locationPermissions,
    StateBox<void>? isLocationPermissionsEnabled,
  }) {
    return AppPermissionsState(
      cameraPermission: cameraPermission ?? this.cameraPermission,
      mediaLibraryPermission:
          mediaLibraryPermission ?? this.mediaLibraryPermission,
      notificationPermissions:
          notificationPermissions ?? this.notificationPermissions,
      photosAndVideosPermissions:
          photosAndVideosPermissions ?? this.photosAndVideosPermissions,
      recordingPermissions: recordingPermissions ?? this.recordingPermissions,
      voicePermissions: voicePermissions ?? this.voicePermissions,
      locationPermissions: locationPermissions ?? this.locationPermissions,
      isLocationPermissionsEnabled:
          isLocationPermissionsEnabled ?? this.isLocationPermissionsEnabled,
    );
  }

  @override
  List<Object?> get props => [
        cameraPermission,
        mediaLibraryPermission,
        notificationPermissions,
        photosAndVideosPermissions,
        recordingPermissions,
        voicePermissions,
        locationPermissions,
        isLocationPermissionsEnabled,
      ];
}
