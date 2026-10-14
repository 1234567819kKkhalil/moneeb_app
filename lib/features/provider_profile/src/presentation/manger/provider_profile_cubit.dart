part of provider_profile;

@injectable
class ProviderProfileCubit extends BaseCubit<ProviderProfileState> {
  final GetProviderProfileUseCase _getProviderProfileUseCase;
  final ProviderProfileRepository _repository; // Added for reviews

  ProviderProfileCubit(
      this._getProviderProfileUseCase,
      this._repository,
      ) : super(ProviderProfileState.initial());

  Future<void> fetchProfile(String providerId) async {
    emit(state.reduce(profile: const StateBox.loading()));

    // Fetch reviews concurrently or just fire it
    fetchReviews(providerId);

    await collect(
      task: () async {
        final data = await _getProviderProfileUseCase.call(providerId);
        emit(state.reduce(profile: StateBox.success(data)));
      },
      onError: (failure) {
        emit(state.reduce(profile: StateBox.failure(failure)));
      },
    );
  }

  Future<void> fetchReviews(String providerId) async {
    emit(state.reduce(reviews: const StateBox.loading()));

    await collect(
      task: () async {
        final data = await _repository.getReviews(providerId);
        emit(state.reduce(reviews: StateBox.success(data)));
      },
      onError: (failure) {
        emit(state.reduce(reviews: StateBox.failure(failure)));
      },
    );
  }
}
