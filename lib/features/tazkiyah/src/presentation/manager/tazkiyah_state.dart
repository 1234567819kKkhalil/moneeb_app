part of tazkiyah;

class TazkiyahState extends Equatable {
  final StateBox<LookupProviderEntity> searchResult;
  final StateBox<void> submitResult;
  final LookupProviderEntity? selectedProvider;
  final StateBox<List<MyTazkiyahEntity>> myTazkiyahsResult;

  const TazkiyahState({
    required this.searchResult,
    required this.submitResult,
    required this.myTazkiyahsResult,
    this.selectedProvider,
  });

  factory TazkiyahState.initial() => const TazkiyahState(
        searchResult: StateBox.initial(),
        submitResult: StateBox.initial(),
        myTazkiyahsResult: StateBox.initial(),
      );

  TazkiyahState reduce({
    StateBox<LookupProviderEntity>? searchResult,
    StateBox<void>? submitResult,
    StateBox<List<MyTazkiyahEntity>>? myTazkiyahsResult,
    LookupProviderEntity? selectedProvider,
  }) {
    return TazkiyahState(
      searchResult: searchResult ?? this.searchResult,
      submitResult: submitResult ?? this.submitResult,
      myTazkiyahsResult: myTazkiyahsResult ?? this.myTazkiyahsResult,
      selectedProvider: selectedProvider ?? this.selectedProvider,
    );
  }

  TazkiyahState clearSelectedProvider() {
    return TazkiyahState(
      searchResult: const StateBox.initial(),
      submitResult: const StateBox.initial(),
      myTazkiyahsResult: myTazkiyahsResult,
      selectedProvider: null,
    );
  }

  @override
  List<Object?> get props => [
        searchResult,
        submitResult,
        myTazkiyahsResult,
        selectedProvider,
      ];
}
