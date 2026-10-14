part of provider_orders;

class MyCertificatesState extends Equatable {
  final StateBox<List<OrderCertificateEntity>> certificates;

  const MyCertificatesState({required this.certificates});

  factory MyCertificatesState.initial() =>
      const MyCertificatesState(certificates: StateBox.initial());

  MyCertificatesState reduce({
    StateBox<List<OrderCertificateEntity>>? certificates,
  }) {
    return MyCertificatesState(
      certificates: certificates ?? this.certificates,
    );
  }

  @override
  List<Object?> get props => [certificates];
}

class MyCertificatesCubit extends BaseCubit<MyCertificatesState> {
  late final ProviderOrdersRepository _repository;

  MyCertificatesCubit() : super(MyCertificatesState.initial()) {
    _repository = injector();
  }

  Future<void> fetchCertificates() async {
    if (state.certificates.isLoading) return;

    emit(state.reduce(certificates: const StateBox.loading()));

    await collect(
      task: () async {
        final certificates = await _repository.getMyCertificates();
        emit(state.reduce(certificates: StateBox.success(certificates)));
      },
      onError: (failure) {
        emit(state.reduce(certificates: StateBox.failure(failure)));
      },
    );
  }
}
