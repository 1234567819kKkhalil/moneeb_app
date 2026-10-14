part of auth;

class ProviderCompleteProfileCubit
    extends BaseCubit<ProviderCompleteProfileState> {
  late final CompleteProviderProfileUseCase _completeProviderProfileUseCase;
  late final UploadProviderAvatarUseCase _uploadAvatarUseCase;
  late final UploadCertificatesUseCase _uploadCertificatesUseCase;
  late final UploadIdentificationUseCase _uploadIdentificationUseCase;

  ProviderCompleteProfileCubit()
    : super(const ProviderCompleteProfileState.initial()) {
    _completeProviderProfileUseCase = injector();
    _uploadAvatarUseCase = injector();
    _uploadCertificatesUseCase = injector();
    _uploadIdentificationUseCase = injector();
  }

  CompleteProviderProfileInput? _submittedInput;
  Attachment? _submittedNationalId;
  Attachment? _submittedCertificate;
  String? _submittedCertificateName;
  Attachment? _submittedAvatarPicture;

  Future<void> sendProviderInfo(
    CompleteProviderProfileInput input,
    Attachment nationalIdPicture,
    Attachment? avatar,
  ) async {
    emit(state.reduce(sendProfileInfoState: const StateBox.loading()));

    await collect(
      task: () async {
        if (input != _submittedInput) {
          await _completeProviderProfileUseCase.execute(input);
          _submittedInput = input;
        }

        if (avatar != null) await uploadAvatar(avatar);
        await uploadIdentification(nationalIdPicture);

        emit(
          state.reduce(
            sendProfileInfoState: const StateBox.successWithoutData(),
          ),
        );
      },
      onError: (failure) {
        emit(state.reduce(sendProfileInfoState: StateBox.failure(failure)));
      },
    );

    emit(state.reduce(sendProfileInfoState: const StateBox.initial()));
  }

  Future<void> uploadIdentification(Attachment attachment) async {
    if (attachment != _submittedNationalId) {
      final url = await _uploadIdentificationUseCase.execute(attachment);
      print(url);
    }
  }

  Future<void> uploadAvatar(Attachment attachment) async {
    if (attachment != _submittedAvatarPicture) {
      final url = await _uploadAvatarUseCase.execute(attachment);

      print(url);
    }
  }

  Future<void> uploadCertificate(
    Attachment attachment,
    String nameOfCertificate,
  ) async {
    emit(state.reduce(sendCertificationsState: const StateBox.loading()));

    await collect(
      task: () async {
        if (attachment != _submittedCertificate ||
            nameOfCertificate != _submittedCertificateName) {
          final url = await _uploadCertificatesUseCase.execute(
            attachment,
            nameOfCertificate,
          );
          print(url);
        }

        emit(
          state.reduce(
            sendCertificationsState: const StateBox.successWithoutData(),
          ),
        );
      },
      onError: (failure) {
        emit(state.reduce(sendCertificationsState: StateBox.failure(failure)));
      },
    );

    emit(state.reduce(sendCertificationsState: const StateBox.initial()));
  }

  /// Called when the user skips the certifications step (both fields left empty).
  void skipCertifications() {
    emit(
      state.reduce(
        sendCertificationsState: const StateBox.successWithoutData(),
      ),
    );
    emit(state.reduce(sendCertificationsState: const StateBox.initial()));
  }
}
