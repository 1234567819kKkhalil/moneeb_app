part of provider_orders;

class ProviderOrdersState extends Equatable {
  final StateBox<List<ProviderOrderEntity>> orders;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  const ProviderOrdersState({
    required this.orders,
    required this.currentPage,
    required this.hasMore,
    required this.isLoadingMore,
  });

  factory ProviderOrdersState.initial() => const ProviderOrdersState(
        orders: StateBox.initial(),
        currentPage: 1,
        hasMore: true,
        isLoadingMore: false,
      );

  ProviderOrdersState reduce({
    StateBox<List<ProviderOrderEntity>>? orders,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return ProviderOrdersState(
      orders: orders ?? this.orders,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [orders, currentPage, hasMore, isLoadingMore];
}
