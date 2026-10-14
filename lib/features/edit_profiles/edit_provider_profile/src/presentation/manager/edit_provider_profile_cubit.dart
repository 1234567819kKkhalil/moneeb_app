part of edit_provider_profile;

@injectable
class EditProviderProfileCubit extends BaseCubit<EditProviderProfileState> {
  final EditProviderProfileRepository _repository;
  final UploadProviderAvatarUseCase _uploadProviderAvatarUseCase;

  EditProviderProfileCubit(this._repository, this._uploadProviderAvatarUseCase)
    : super(const EditProviderProfileState());

  void setAvatar(Attachment avatar) {
    emit(state.reduce(selectedAvatar: avatar));
  }

  void removeAvatar() {
    emit(state.reduce(clearAvatar: true));
  }

  void setGender(GenderEnum gender) {
    emit(state.reduce(selectedGender: gender));
  }

  void setIsHafiz(bool isHafiz) {
    emit(state.reduce(isHafiz: isHafiz));
  }

  void setIsOnline(bool isOnline) {
    emit(state.reduce(isOnline: isOnline));
  }

  Future<void> toggleOnlineStatus(bool isOnline) async {
    emit(
      state.reduce(
        isOnline: isOnline,
        toggleOnlineState: const StateBox.loading(),
      ),
    );

    await collect(
      task: () async {
        await _repository.updateProviderData(
          UpdateProviderDataRequest(isOnline: isOnline),
        );
        emit(state.reduce(toggleOnlineState: const StateBox.success(null)));
      },
      onError: (failure) {
        emit(
          state.reduce(
            isOnline: !isOnline,
            toggleOnlineState: StateBox.failure(failure),
          ),
        );
      },
    );
  }

  Future<void> saveProfile({
    required String name,
    required String email,
    required PhoneNumber phone,
    GenderEnum? gender,
    String? countryCode,
    String? bio,
    int? umrahCount,
    String? identificationNumber,
    bool? isHafiz,
    bool? isOnline,
  }) async {
    emit(state.reduce(updateProfileState: const StateBox.loading()));

    await collect(
      task: () async {
        String? newAvatarUrl;
        // Upload avatar first if selected
        if (state.selectedAvatar != null &&
            !state.selectedAvatar!.url.isNetwork) {
          newAvatarUrl = await _uploadProviderAvatarUseCase.execute(
            state.selectedAvatar!,
          );
        }

        // Update profile data (users/me)
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

        // Update provider specific data (providers/me/profile)
        await _repository.updateProviderData(
          UpdateProviderDataRequest(
            bio: bio,
            umrahCount: umrahCount,
            identificationNumber: identificationNumber,
            isHafiz: isHafiz,
            isOnline: isOnline,
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
