part of edit_provider_profile;

class EditProviderProfileState extends Equatable {
  final StateBox<void> updateProfileState;
  final StateBox<void> uploadAvatarState;
  final StateBox<void> toggleOnlineState;

  final Attachment? selectedAvatar;
  final GenderEnum? selectedGender;
  final String? uploadedAvatarUrl;
  final bool? isHafiz;
  final bool? isOnline;

  const EditProviderProfileState({
    this.updateProfileState = const StateBox.initial(),
    this.uploadAvatarState = const StateBox.initial(),
    this.toggleOnlineState = const StateBox.initial(),
    this.selectedAvatar,
    this.selectedGender,
    this.uploadedAvatarUrl,
    this.isHafiz,
    this.isOnline,
  });

  EditProviderProfileState reduce({
    StateBox<void>? updateProfileState,
    StateBox<void>? uploadAvatarState,
    StateBox<void>? toggleOnlineState,
    Attachment? selectedAvatar,
    bool clearAvatar = false,
    GenderEnum? selectedGender,
    String? uploadedAvatarUrl,
    bool? isHafiz,
    bool? isOnline,
  }) {
    return EditProviderProfileState(
      updateProfileState: updateProfileState ?? this.updateProfileState,
      uploadAvatarState: uploadAvatarState ?? this.uploadAvatarState,
      toggleOnlineState: toggleOnlineState ?? this.toggleOnlineState,
      selectedAvatar: clearAvatar
          ? null
          : (selectedAvatar ?? this.selectedAvatar),
      selectedGender: selectedGender ?? this.selectedGender,
      uploadedAvatarUrl: uploadedAvatarUrl ?? this.uploadedAvatarUrl,
      isHafiz: isHafiz ?? this.isHafiz,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  @override
  List<Object?> get props => [
    updateProfileState,
    uploadAvatarState,
    toggleOnlineState,
    selectedAvatar,
    selectedGender,
    uploadedAvatarUrl,
    isHafiz,
    isOnline,
  ];
}
