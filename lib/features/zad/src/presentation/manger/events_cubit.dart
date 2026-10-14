part of zad;

@injectable
class EventsCubit extends BaseCubit<EventsState> {
  final ZadRepository _zadRepository;

  EventsCubit(this._zadRepository) : super(EventsState.initial());

  Future<void> fetchIslamicEvents() async {
    emit(state.reduce(events: const StateBox.loading()));

    await collect(
      task: () async {
        final data = await _zadRepository.getIslamicEvents();
        emit(state.reduce(events: StateBox.success(data)));
      },
      onError: (failure) {
        emit(state.reduce(events: StateBox.failure(failure)));
      },
    );
  }
}
