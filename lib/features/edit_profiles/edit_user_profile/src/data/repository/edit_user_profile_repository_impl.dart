part of edit_user_profile;

@LazySingleton(as: EditUserProfileRepository)
class EditUserProfileRepositoryImpl implements EditUserProfileRepository {
  final DioHelper _dioHelper;

  EditUserProfileRepositoryImpl(this._dioHelper);

  @override
  Future<void> updateProfile(UpdateProfileRequest request) async {
    await _dioHelper.put(
      EditUserProfileEndpoint.updateProfile,
      data: request.toJson(),
    );
  }
}
