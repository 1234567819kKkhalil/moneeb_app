part of zad;

class ZadCubit extends BaseCubit<ZadState> {
  late final ZadRepository _zadRepository;

  ZadCubit() : super(ZadState.initial()) {
    _loadItems();
  }

  void _loadItems() {
    _zadRepository = injector();
  }

  Future<void> init() async {
    // Mocking HTML file load for now
    emit(state.reduce(htmlFile: 'mock_asset_data'));
    await Future.wait([
      fetchAzkarSections(),
      fetchDua(),
    ]);
  }

  Future<void> fetchAzkarSections() async {
    emit(state.reduce(azkarSections: const StateBox.loading()));
    await collect(
      task: () async {
        final data = await _zadRepository.getAzkarSections();
        emit(state.reduce(azkarSections: StateBox.success(data)));
      },
      onError: (failure) {
        emit(state.reduce(azkarSections: StateBox.failure(failure)));
      },
    );
  }

  Future<void> fetchDua() async {
    emit(state.reduce(duaList: const StateBox.loading()));
    await collect(
      task: () async {
        final data = await _zadRepository.getDua();
        emit(state.reduce(duaList: StateBox.success(data)));
      },
      onError: (failure) {
        emit(state.reduce(duaList: StateBox.failure(failure)));
      },
    );
  }

  Future<void> getAzkar({required String type}) async {
    emit(state.reduce(isLoadingAzkar: true, azkar: []));

    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock Data
    final mockedAzkar = [
      AzkarData(text: 'سبحان الله وبحمده'),
      AzkarData(text: 'أستغفر الله العظيم'),
      AzkarData(text: 'لا إله إلا الله'),
    ];

    emit(state.reduce(isLoadingAzkar: false, azkar: mockedAzkar));
  }
}

