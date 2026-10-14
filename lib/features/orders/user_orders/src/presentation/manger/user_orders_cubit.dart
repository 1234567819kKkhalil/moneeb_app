part of user_orders;

class UserOrdersCubit extends BaseCubit<UserOrdersCubitState> {
  static const int _pageSize = 20;

  late final UserOrdersRepository _repository;

  UserOrdersCubit() : super(UserOrdersCubitState.initial()) {
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
        final result = await _repository.getUserOrders(
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
        final result = await _repository.getUserOrders(
          page: nextPage,
          limit: _pageSize,
        );
        final updatedOrders = <UserOrderEntity>[
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

  Future<void> cancelOrder(String id, {required VoidCallback onSuccess}) async {
    final currentOrders =
        state.orders.data; // Save current list before emitting loading

    emit(
      state.reduce(orders: const StateBox.loading()),
    ); // Can use statebox or just show loading in UI
    await collect(
      task: () async {
        await _repository.cancelOrder(id);

        // Remove the cancelled order locally without a new fetch
        if (currentOrders != null) {
          final updatedOrders = currentOrders
              .where((order) => order.id != id)
              .toList();
          emit(state.reduce(orders: StateBox.success(updatedOrders)));
        } else {
          emit(state.reduce(orders: const StateBox.success([])));
        }

        onSuccess();
      },
      onError: (failure) {
        // Restore old data if we want, or just emit failure
        emit(state.reduce(orders: StateBox.failure(failure)));
      },
    );
  }
}
