part of provider_orders;

class ProviderActionsState extends Equatable {
  final StateBox<OmrahStepperEntity> acceptState;
  final StateBox<String> rejectState;
  final StateBox<String> cancelState;
  final StateBox<String> completeState;

  const ProviderActionsState({
    required this.acceptState,
    required this.rejectState,
    required this.cancelState,
    required this.completeState,
  });

  factory ProviderActionsState.initial() => const ProviderActionsState(
    acceptState: StateBox.initial(),
    rejectState: StateBox.initial(),
    cancelState: StateBox.initial(),
    completeState: StateBox.initial(),
  );

  ProviderActionsState reduce({
    StateBox<OmrahStepperEntity>? acceptState,
    StateBox<String>? rejectState,
    StateBox<String>? cancelState,
    StateBox<String>? completeState,
  }) {
    return ProviderActionsState(
      acceptState: acceptState ?? this.acceptState,
      rejectState: rejectState ?? this.rejectState,
      cancelState: cancelState ?? this.cancelState,
      completeState: completeState ?? this.completeState,
    );
  }

  @override
  List<Object?> get props => [acceptState,rejectState,cancelState,completeState];
}
