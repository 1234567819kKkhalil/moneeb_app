part of provider_orders;

class ProviderOrdersCubit extends BaseCubit<ProviderOrdersState> {
  static const int _pageSize = 20;

  late final ProviderOrdersRepository _repository;

  ProviderOrdersCubit() : super(ProviderOrdersState.initial()){
    _repository = injector();
  }

  Future<void> fetchOrders() async {
    emit(
      state.reduce(
        orders: const StateBox.loading(),
        currentPage: 1,
        hasMore: true,
      ),
    );
    await collect(
      task: () async {
        final result = await _repository.getProviderOrders(
          page: 1,
          limit: _pageSize,
        );
        emit(
          state.reduce(
            orders: StateBox.success(result.items),
            currentPage: 1,
            hasMore: result.pageInfo.hasNext,
          ),
        );
      },
      onError: (failure) {
        emit(state.reduce(orders: StateBox.failure(failure)));
      },
    );
  }

  Future<void> fetchMoreOrders() async {
    if (state.isLoadingMore || !state.hasMore || !state.orders.isSuccess) {
      return;
    }

    final nextPage = state.currentPage + 1;
    emit(state.reduce(isLoadingMore: true));
    await collect(
      task: () async {
        final result = await _repository.getProviderOrders(
          page: nextPage,
          limit: _pageSize,
        );
        final updatedOrders = <ProviderOrderEntity>[
          ...(state.orders.data ?? []),
          ...result.items,
        ];
        emit(
          state.reduce(
            orders: StateBox.success(updatedOrders),
            currentPage: nextPage,
            hasMore: result.pageInfo.hasNext,
            isLoadingMore: false,
          ),
        );
      },
      onError: (failure) {
        emit(state.reduce(isLoadingMore: false));
      },
    );
  }
}
