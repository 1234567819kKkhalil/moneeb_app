part of edit_user_profile;

@injectable
class EditUserProfileCubit extends BaseCubit<EditUserProfileState> {
  final EditUserProfileRepository _repository;
  final UploadAvatarUseCase _uploadAvatarUseCase;

  EditUserProfileCubit(this._repository, this._uploadAvatarUseCase)
    : super(const EditUserProfileState());

  void setAvatar(Attachment avatar) {
    emit(state.reduce(selectedAvatar: avatar));
  }

  void removeAvatar() {
    emit(state.reduce(clearAvatar: true));
  }

  void setGender(GenderEnum gender) {
    emit(state.reduce(selectedGender: gender));
  }

  Future<void> saveProfile({
    required String name,
    required String email,
    required PhoneNumber phone,
    GenderEnum? gender,
    String? countryCode,
  }) async {
    emit(state.reduce(updateProfileState: const StateBox.loading()));

    await collect(
      task: () async {
        String? newAvatarUrl;
        // Upload avatar first if selected
        if (state.selectedAvatar != null &&
            !state.selectedAvatar!.url.isNetwork) {
          newAvatarUrl = await _uploadAvatarUseCase.execute(
            state.selectedAvatar!,
          );
        }

        // Update profile data
        await _repository.updateProfile(
          UpdateProfileRequest(
            fullName: name,
            email: email,
            phoneCountryCode: phone.dialCodeWithPlus,
            phoneNumber: phone.nationalNumber,
            gender: gender,
            country: countryCode,
          ),
        );

        emit(
          state.reduce(
            updateProfileState: const StateBox.success(null),
            uploadedAvatarUrl: newAvatarUrl,
          ),
        );
      },
      onError: (failure) {
        emit(state.reduce(updateProfileState: StateBox.failure(failure)));
      },
    );
  }
}
