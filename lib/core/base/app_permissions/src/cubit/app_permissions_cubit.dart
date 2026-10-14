part of app_permissions;

class AppPermissionsCubit extends BaseCubit<AppPermissionsState> {
  AppPermissionsCubit() : super(const AppPermissionsState.initial());

  final AppPermissions appPermissions = AppPermissions.instance;

  Future<void> requestCameraPermission() async {
    emit(state.reduce(cameraPermission: const StateBox.loading()));

    try {
      await appPermissions.requestCameraPermission();
      emit(state.reduce(cameraPermission: const StateBox.successWithoutData()));
    } catch (e) {
      emit(state.reduce(
          cameraPermission: StateBox.failure(UnExpectedFailure(appLocalizer.cameraPermissionError))));
    }
  }


  Future<void> requestMediaLibraryPermission() async {
    emit(state.reduce(mediaLibraryPermission: const StateBox.loading()));

    try {
      await appPermissions.requestMediaLibraryPermission();
      emit(state.reduce(
          mediaLibraryPermission: const StateBox.successWithoutData()));
    } catch (e) {
      emit(state.reduce(
          mediaLibraryPermission:
              StateBox.failure(UnExpectedFailure(appLocalizer.mediaPermissionError))));
    }
  }

  Future<void> requestNotificationPermission() async {
    emit(state.reduce(notificationPermissions: const StateBox.loading()));

    try {
      await appPermissions.requestNotificationPermission();
      emit(state.reduce(
          notificationPermissions: const StateBox.successWithoutData()));
    } catch (e) {
      emit(state.reduce(
          notificationPermissions:
              StateBox.failure(UnExpectedFailure(appLocalizer.notificationPermissionError))));
    }
  }

  Future<void> requestPhotosAndVideosPermissions() async {
    emit(state.reduce(photosAndVideosPermissions: const StateBox.loading()));

    try {
      await appPermissions.requestPhotosAndVideosPermissions();
      emit(state.reduce(
          photosAndVideosPermissions: const StateBox.successWithoutData()));
    } catch (e) {
      emit(state.reduce(
          photosAndVideosPermissions:
              StateBox.failure(UnExpectedFailure(appLocalizer.photoVideoPermissionError))));
    }
  }

  Future<void> requestVideoRecordPermissions() async {
    emit(state.reduce(recordingPermissions: const StateBox.loading()));

    try {
      await appPermissions.requestVideoRecordPermissions();
      await Future.delayed(const Duration(
          seconds:
              1)); //necessary, because camera controller could not detect the permission changes immediately
      emit(
          state.reduce(recordingPermissions: const StateBox.successWithoutData()));
    } catch (e) {
      emit(state.reduce(
          recordingPermissions:
              StateBox.failure(UnExpectedFailure(appLocalizer.videosPermissionError))));
    }
  }

  Future<void> requestLocationPermissions() async {
    emit(state.reduce(locationPermissions: const StateBox.loading()));

    try {
      await appPermissions.requestLocationPermissions();
      emit(state.reduce(locationPermissions: const StateBox.successWithoutData()));
    } catch (e) {
      emit(state.reduce(
          locationPermissions:
          StateBox.failure(UnExpectedFailure(appLocalizer.locationPermissionError))));
    }
  }

  Future<void> requestMicPermissions() {
    // TODO: implement requestMicPermissions
    throw UnimplementedError();
  }
}
