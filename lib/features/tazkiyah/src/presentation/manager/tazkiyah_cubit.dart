part of tazkiyah;

@injectable
class TazkiyahCubit extends BaseCubit<TazkiyahState> {
  final SearchProviderUseCase _searchProviderUseCase;
  final PostTazkiyahUseCase _postTazkiyahUseCase;
  final GetMyTazkiyahsUseCase _getMyTazkiyahsUseCase;

  TazkiyahCubit(
    this._searchProviderUseCase,
    this._postTazkiyahUseCase,
    this._getMyTazkiyahsUseCase,
  ) : super(TazkiyahState.initial());

  Future<void> getMyTazkiyahs() async {
    emit(state.reduce(myTazkiyahsResult: const StateBox.loading()));
    await collect(
      task: () async {
        final list = await _getMyTazkiyahsUseCase();
        emit(state.reduce(myTazkiyahsResult: StateBox.success(list)));
      },
      onError: (failure) {
        emit(state.reduce(myTazkiyahsResult: StateBox.failure(failure)));
      },
    );
  }

  /// Looks a provider up by email, or by [phone] — sent in full international
  /// form (`+201028762009`), with any leading trunk zero dropped.
  Future<void> searchProvider({String? email, PhoneNumber? phone}) async {
    emit(state.reduce(searchResult: const StateBox.loading()));
    await collect(
      task: () async {
        final provider = await _searchProviderUseCase(
          email: email,
          phone: phone?.internationalNumber,
        );
        if (provider != null) {
          emit(
            state.reduce(
              searchResult: StateBox.success(provider),
              selectedProvider: provider,
            ),
          );
        } else {
          emit(
            state.reduce(
              searchResult: StateBox.failure(
                ApiRequestFailure(422, appLocalizer.providerNotFound),
              ),
            ),
          );
        }
      },
      onError: (failure) {
        emit(state.reduce(searchResult: StateBox.failure(failure)));
      },
    );
  }

  void clearProvider() {
    emit(state.clearSelectedProvider());
  }

  void addTazkiyahLocally(MyTazkiyahEntity tazkiyah) {
    final current = state.myTazkiyahsResult.data ?? [];
    emit(
      state.reduce(
        myTazkiyahsResult: StateBox.success([tazkiyah, ...current]),
      ),
    );
  }

  Future<void> submitTazkiyah({
    required String providerId,
    required String reason,
    required bool agreedToOath,
  }) async {
    emit(state.reduce(submitResult: const StateBox.loading()));
    await collect(
      task: () async {
        await _postTazkiyahUseCase(
          providerId: providerId,
          reason: reason,
          agreedToOath: agreedToOath,
        );
        emit(state.reduce(submitResult: const StateBox.success(null)));
      },
      onError: (failure) {
        emit(state.reduce(submitResult: StateBox.failure(failure)));
      },
    );
  }
}
