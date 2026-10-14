part of edit_user_profile;

abstract class EditUserProfileRepository {
  Future<void> updateProfile(UpdateProfileRequest request);
}
