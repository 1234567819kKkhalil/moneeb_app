part of edit_user_profile;

class EditUserProfileState extends Equatable {
  final StateBox<void> updateProfileState;
  final StateBox<void> uploadAvatarState;

  final Attachment? selectedAvatar;
  final GenderEnum? selectedGender;
  final String? uploadedAvatarUrl;

  const EditUserProfileState({
    this.updateProfileState = const StateBox.initial(),
    this.uploadAvatarState = const StateBox.initial(),
    this.selectedAvatar,
    this.selectedGender,
    this.uploadedAvatarUrl,
  });

  EditUserProfileState reduce({
    StateBox<void>? updateProfileState,
    StateBox<void>? uploadAvatarState,
    Attachment? selectedAvatar,
    bool clearAvatar = false,
    GenderEnum? selectedGender,
    String? uploadedAvatarUrl,
  }) {
    return EditUserProfileState(
      updateProfileState: updateProfileState ?? this.updateProfileState,
      uploadAvatarState: uploadAvatarState ?? this.uploadAvatarState,
      selectedAvatar: clearAvatar ? null : (selectedAvatar ?? this.selectedAvatar),
      selectedGender: selectedGender ?? this.selectedGender,
      uploadedAvatarUrl: uploadedAvatarUrl ?? this.uploadedAvatarUrl,
    );
  }

  @override
  List<Object?> get props => [
        updateProfileState,
        uploadAvatarState,
        selectedAvatar,
        selectedGender,
        uploadedAvatarUrl,
      ];
}
