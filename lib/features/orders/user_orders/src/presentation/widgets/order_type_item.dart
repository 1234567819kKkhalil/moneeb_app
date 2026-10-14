// part of user_orders;
//
// class OrdersTypeItem extends StatelessWidget {
//   final OrderSetting type;
//
//   const OrdersTypeItem({super.key, required this.type});
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(8),
//         onTap: () {
//           context.read<OrdersCubit>().selectTab(type);
//         },
//         child: Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: type.isSelected
//                 ? context.appColors.primary.shade400
//                 : context.appColors.neutral.shade900,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(
//               color: type.isSelected
//                   ? context.appColors.primary.shade400
//                   : context.appColors.neutral.shade900,
//             ),
//           ),
//           alignment: Alignment.center,
//           child: Text(
//             type.title,
//             style: context.theme.textTheme.bodyMedium?.copyWith(
//               fontSize: type.isSelected ? 12 : 11,
//               fontWeight: FontWeight.w500,
//               color: type.isSelected
//                   ? context.appColors.neutral.shade900
//                   : context.appColors.primary.shade400,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
