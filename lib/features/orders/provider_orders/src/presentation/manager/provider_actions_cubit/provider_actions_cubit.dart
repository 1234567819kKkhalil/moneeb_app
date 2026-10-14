part of provider_orders;

class ProviderActionsCubit extends BaseCubit<ProviderActionsState> {
  late final ProviderOrdersRepository _repository;

  ProviderActionsCubit() : super(ProviderActionsState.initial()){
    _repository = injector();
  }

  Future<void> acceptOrder(String id, ForWhomEntity forWhom, DateTime? targetDate) async {
    emit(state.reduce(acceptState: const StateBox.loading()));
    await collect(
      task: () async {
        await _repository.acceptOrder(id);
        emit(state.reduce(acceptState: StateBox.success(
          OmrahStepperEntity(
            orderId: id,
            forWhom: forWhom,
            targetDate: targetDate,
            currentStep: OmrahStepsEnum.mekat,
          )
        )));
      },
      onError: (failure) {
        emit(state.reduce(acceptState: StateBox.failure(failure)));
      },
    );
    emit(state.reduce(acceptState: const StateBox.initial()));
  }

  Future<void> rejectOrder(String id, String reason) async {
    emit(state.reduce(rejectState: const StateBox.loading()));
    await collect(
      task: () async {
        await _repository.rejectOrder(id, reason);
        emit(state.reduce(rejectState: StateBox.success(id)));
      },
      onError: (failure) {
        emit(state.reduce(rejectState: StateBox.failure(failure)));
      },
    );
    emit(state.reduce(rejectState: const StateBox.initial()));
  }

  Future<void> cancelOrder(String id, {required VoidCallback onSuccess}) async {
    emit(state.reduce(cancelState: const StateBox.loading()));
    await collect(
      task: () async {
        await _repository.cancelOrder(id);
        emit(state.reduce(cancelState: StateBox.success(id)));
        onSuccess();
      },
      onError: (failure) {
        emit(state.reduce(cancelState: StateBox.failure(failure)));
      },
    );
    emit(state.reduce(cancelState: const StateBox.initial()));
  }

  Future<void> completeOrder(String id, ) async {
    emit(state.reduce(completeState: const StateBox.loading()));
    await collect(
      task: () async {
        await _repository.completeOrder(id);
        emit(state.reduce(completeState: StateBox.success(id)));

        injector<OmrahUpdater>().omrahCompleted(id);
      },
      onError: (failure) {
        emit(state.reduce(completeState: StateBox.failure(failure)));
      },
    );
    emit(state.reduce(completeState: const StateBox.initial()));
  }
}
