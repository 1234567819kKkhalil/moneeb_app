part of edit_provider_profile;

@LazySingleton(as: EditProviderProfileRepository)
class EditProviderProfileRepositoryImpl implements EditProviderProfileRepository {
  final DioHelper _dioHelper;

  EditProviderProfileRepositoryImpl(this._dioHelper);

  @override
  Future<void> updateProfile(UpdateProfileRequest request) async {
    await _dioHelper.put(
      EditProviderProfileEndpoint.updateProfile,
      data: request.toJson(),
    );
  }

  @override
  Future<void> updateProviderData(UpdateProviderDataRequest request) async {
    await _dioHelper.patch(
      EditProviderProfileEndpoint.updateProviderData,
      data: request.toJson(),
    );
  }
}
