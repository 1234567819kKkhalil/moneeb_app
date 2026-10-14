part of user_orders;

abstract class UserOrdersRepository {
  Future<PaginatedData<UserOrderEntity>> getUserOrders({
    UserOrderStatus? status,
    int page = 1,
    int limit = 20,
  });

  Future<void> cancelOrder(String id);
}
