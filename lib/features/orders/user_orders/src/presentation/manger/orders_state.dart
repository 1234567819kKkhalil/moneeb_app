// part of user_orders;
//
// class OrdersState extends Equatable {
//   final String orderTypeSelected;
//   final List<OrderSetting> ordersTypes;
//   final List<OrderTest> allOrders;
//   final List<OrderTest> orders;
//
//   const OrdersState({
//     required this.orderTypeSelected,
//     required this.ordersTypes,
//     required this.allOrders,
//     required this.orders,
//   });
//
//   OrdersState copyWith({
//     String? orderTypeSelected,
//     List<OrderSetting>? ordersTypes,
//     List<OrderTest>? allOrders,
//     List<OrderTest>? orders,
//   }) {
//     return OrdersState(
//       orderTypeSelected: orderTypeSelected ?? this.orderTypeSelected,
//       ordersTypes: ordersTypes ?? this.ordersTypes,
//       allOrders: allOrders ?? this.allOrders,
//       orders: orders ?? this.orders,
//     );
//   }
//
//   @override
//   List<Object?> get props => [
//         orderTypeSelected,
//         ordersTypes,
//         allOrders,
//         orders,
//       ];
// }
