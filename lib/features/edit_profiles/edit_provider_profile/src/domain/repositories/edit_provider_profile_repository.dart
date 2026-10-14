part of edit_provider_profile;

abstract class EditProviderProfileRepository {
  Future<void> updateProfile(UpdateProfileRequest request);
  Future<void> updateProviderData(UpdateProviderDataRequest request);
}
