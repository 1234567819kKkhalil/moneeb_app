part of zad;

@injectable
class AzkarContentCubit extends BaseCubit<AzkarContentState> {
  final ZadRepository _zadRepository;

  AzkarContentCubit(this._zadRepository) : super(AzkarContentState.initial());

  Future<void> fetchAzkarContent(String slug) async {
    emit(state.reduce(azkarContent: const StateBox.loading()));

    final data = await collect<AzkarContentModel>(
      task: () => _zadRepository.getAzkarContent(slug),
      onError: (failure) {
        emit(state.reduce(azkarContent: StateBox.failure(failure)));
      },
    );

    if (data != null) {
      emit(state.reduce(azkarContent: StateBox.success(data)));
    }
  }
}
