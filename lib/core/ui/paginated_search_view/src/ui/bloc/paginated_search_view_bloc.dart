part of paginated_search_view;

class PaginatedSearchViewBloc<T> extends Bloc<PaginatedSearchViewEvents, PaginatedSearchViewState<T>> {

  final FutureOr<PaginatedData<T>?> Function(String searchTerm, int pageKey) requestData;

  PaginatedSearchViewBloc({
    required this.requestData,
  }) : super(PaginatedSearchViewState.initial()) {
    on<GetPaginatedSearchResultsEvent>((event, emit) async {
      await collect(
        task: () async {
          final PaginatedData<T>? searchResults = await requestData(event.searchTerm, event.pageKey);
          emit(state.reduce(searchResults: StateBox<PaginatedData<T>>.success(searchResults ?? PaginatedData<T>(items: const [], pageInfo: const PageInfo.initial()))));
        },
        onError: (failure) {
          emit(state.reduce(searchResults: StateBox<PaginatedData<T>>.failure(failure)));
        },
      );

      emit(state.reduce(searchResults: StateBox<PaginatedData<T>>.initial()));
    }, transformer: droppable());
  }
}

