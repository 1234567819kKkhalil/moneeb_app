part of zad;

class ZadState extends Equatable {
  final String htmlFile;
  final StateBox<List<AzkarSectionModel>> azkarSections;
  final StateBox<List<DuaModel>> duaList;
  final List<AzkarData> azkar;
  final bool isLoadingAzkar;

  const ZadState({
    required this.htmlFile,
    required this.azkarSections,
    required this.duaList,
    required this.azkar,
    this.isLoadingAzkar = false,
  });

  ZadState.initial() : this(
    htmlFile: '',
    azkarSections: const StateBox.initial(),
    duaList: const StateBox.initial(),
    azkar: const [],
    isLoadingAzkar: false,
  );

  ZadState reduce({
    String? htmlFile,
    StateBox<List<AzkarSectionModel>>? azkarSections,
    StateBox<List<DuaModel>>? duaList,
    List<AzkarData>? azkar,
    bool? isLoadingAzkar,
  }) {
    return ZadState(
      htmlFile: htmlFile ?? this.htmlFile,
      azkarSections: azkarSections ?? this.azkarSections,
      duaList: duaList ?? this.duaList,
      azkar: azkar ?? this.azkar,
      isLoadingAzkar: isLoadingAzkar ?? this.isLoadingAzkar,
    );
  }

  @override
  List<Object?> get props => [
        htmlFile,
        azkarSections,
        duaList,
        azkar,
        isLoadingAzkar,
      ];
}

