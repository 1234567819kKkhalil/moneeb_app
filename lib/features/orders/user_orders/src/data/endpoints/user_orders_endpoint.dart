part of user_orders;

class UserOrdersEndpoint {
  UserOrdersEndpoint._();

  static const String orders = "orders";
  static String cancelOrder(String id) => "orders/$id/cancel";
}
