// part of user_orders;
//
// class OrdersCubit extends Cubit<OrdersState> {
//   OrdersCubit()
//       : super(
//           OrdersState(
//             orderTypeSelected: OrdersConst.KEY_ORDER_PENDING,
//             ordersTypes: [
//               OrderSetting(
//                 title: 'حالة الطلب',
//                 data: OrdersConst.KEY_ORDER_PENDING,
//                 isSelected: true,
//               ),
//               OrderSetting(
//                 title: 'قيد التنفيذ',
//                 data: OrdersConst.KEY_ORDER_CURRENT,
//                 isSelected: false,
//               ),
//               OrderSetting(
//                 title: 'مكتمله',
//                 data: OrdersConst.KEY_ORDER_COMPLETED,
//                 isSelected: false,
//               ),
//             ],
//             allOrders: [],
//             orders: [], // Will populate in init
//           ),
//         );
//
//   void init() {
//     final List<OrderTest> initialOrders = [
//       OrderTest(
//         type: 'متوفي',
//         orderNo: '15889485',
//         serialNo: '5648465',
//         umrahOwnerName: 'خليل ابن عماد ابن هتهت',
//         umrahOwnerImage: OrdersConst.imageUser4,
//         note: 'اللهم تقبل عنه يارب وارحمها وتقبل شهادته',
//         pilgrimName: 'أحمد أبو منديل',
//         pilgrimImage: OrdersConst.imageUser3,
//         date: '02/04/2026',
//         typeStatus: OrdersConst.KEY_ORDER_PENDING,
//         status: OrdersConst.KEY_ORDER_UNDER_REVIEW,
//       ),
//       OrderTest(
//         type: 'شهيد',
//         orderNo: '88956214',
//         serialNo: '25048564',
//         umrahOwnerName: 'سالم محمد الخالدي',
//         umrahOwnerImage: OrdersConst.imageUser1,
//         note: 'اللهم تقبل عنه يارب وارحمها وتقبل شهادته',
//         pilgrimName: 'وائل بلال النابلسي',
//         pilgrimImage: OrdersConst.imageUser2,
//         date: '04/08/2026',
//         typeStatus: OrdersConst.KEY_ORDER_PENDING,
//         status: OrdersConst.KEY_ORDER_ACCEPTED,
//       ),
//       OrderTest(
//         type: 'عاجز',
//         orderNo: '796541531',
//         serialNo: '665359884',
//         umrahOwnerName: 'محمد بن هلال غادي',
//         umrahOwnerImage: OrdersConst.imageUser5,
//         note: 'اللهم تقبل عنه يارب وارحمها وتقبل شهادته',
//         pilgrimName: 'زياد فادي الدوسري',
//         pilgrimImage: OrdersConst.imageUser6,
//         date: '14/10/2026',
//         typeStatus: OrdersConst.KEY_ORDER_PENDING,
//         status: OrdersConst.KEY_ORDER_REJECTED,
//       ),
//       OrderTest(
//         type: 'عاجز',
//         orderNo: '558896356',
//         serialNo: '447785212',
//         umrahOwnerName: 'خالد جلال محمدي',
//         umrahOwnerImage: OrdersConst.imageUser7,
//         note: 'اللهم تقبل عنه يارب وارحمها وتقبل شهادته',
//         pilgrimName: 'سائد زامل السالم',
//         pilgrimImage: OrdersConst.imageUser9,
//         date: '01/12/2026',
//         typeStatus: OrdersConst.KEY_ORDER_CURRENT,
//         status: OrdersConst.KEY_ORDER_CURRENT,
//       ),
//       OrderTest(
//         type: 'شهيد',
//         orderNo: '796541531',
//         serialNo: '665359884',
//         umrahOwnerName: 'محمد بن هلال غادي',
//         umrahOwnerImage: OrdersConst.imageUser7,
//         note: 'اللهم تقبل عنه يارب وارحمها وتقبل شهادته',
//         pilgrimName: 'زياد فادي الدوسري',
//         pilgrimImage: OrdersConst.imageUser8,
//         date: '14/10/2026',
//         typeStatus: OrdersConst.KEY_ORDER_COMPLETED,
//         status: OrdersConst.KEY_ORDER_COMPLETED,
//       ),
//       OrderTest(
//         type: 'عاجز',
//         orderNo: '88445564',
//         serialNo: '58956214',
//         umrahOwnerName: 'غادي الأحمدي',
//         umrahOwnerImage: OrdersConst.imageUser7,
//         note: 'اللهم تقبل عنه يارب وارحمها وتقبل شهادته',
//         pilgrimName: 'زياد فادي الدوسري',
//         pilgrimImage: OrdersConst.imageUser8,
//         date: '13/9/2026',
//         typeStatus: OrdersConst.KEY_ORDER_COMPLETED,
//         status: OrdersConst.KEY_ORDER_COMPLETED,
//       ),
//       OrderTest(
//         type: 'متوفى',
//         orderNo: '796541531',
//         serialNo: '665359884',
//         umrahOwnerName: 'سليمة علي الهلالي',
//         umrahOwnerImage: OrdersConst.imageUser7,
//         note: 'اللهم تقبل عنه يارب وارحمها وتقبل شهادته',
//         pilgrimName: 'زياد فادي الدوسري',
//         pilgrimImage: OrdersConst.imageUser8,
//         date: '14/10/2026',
//         typeStatus: OrdersConst.KEY_ORDER_COMPLETED,
//         status: OrdersConst.KEY_ORDER_COMPLETED,
//       ),
//       OrderTest(
//         type: 'متوفى',
//         orderNo: '796541531',
//         serialNo: '665359884',
//         umrahOwnerName: 'سارة باسم اليميني',
//         umrahOwnerImage: OrdersConst.imageUser7,
//         note: 'اللهم تقبل عنه يارب وارحمها وتقبل شهادته',
//         pilgrimName: 'زياد فادي الدوسري',
//         pilgrimImage: OrdersConst.imageUser8,
//         date: '14/8/2026',
//         typeStatus: OrdersConst.KEY_ORDER_COMPLETED,
//         status: OrdersConst.KEY_ORDER_COMPLETED,
//       ),
//     ];
//
//     final initialAllOrders = initialOrders
//         .where((order) => order.typeStatus == OrdersConst.KEY_ORDER_PENDING)
//         .toList();
//
//     emit(state.copyWith(
//       orders: initialOrders,
//       allOrders: initialAllOrders,
//     ));
//   }
//
//   void selectTab(OrderSetting type) {
//     final newOrdersTypes = state.ordersTypes.map((e) {
//       return OrderSetting(
//         title: e.title,
//         data: e.data,
//         icon: e.icon,
//         isSelected: e.data == type.data,
//       );
//     }).toList();
//
//     final filteredOrders = state.orders
//         .where((order) => order.typeStatus == type.data)
//         .toList();
//
//     emit(state.copyWith(
//       orderTypeSelected: type.data,
//       ordersTypes: newOrdersTypes,
//       allOrders: filteredOrders,
//     ));
//   }
// }
