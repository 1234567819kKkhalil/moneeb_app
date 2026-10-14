part of user_orders;

class UserOrdersCubitState extends Equatable {
  final StateBox<List<UserOrderEntity>> orders;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  const UserOrdersCubitState({
    required this.orders,
    required this.currentPage,
    required this.hasMore,
    required this.isLoadingMore,
  });

  factory UserOrdersCubitState.initial() => const UserOrdersCubitState(
        orders: StateBox.initial(),
        currentPage: 1,
        hasMore: true,
        isLoadingMore: false,
      );

  UserOrdersCubitState reduce({
    StateBox<List<UserOrderEntity>>? orders,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return UserOrdersCubitState(
      orders: orders ?? this.orders,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [orders, currentPage, hasMore, isLoadingMore];
}
