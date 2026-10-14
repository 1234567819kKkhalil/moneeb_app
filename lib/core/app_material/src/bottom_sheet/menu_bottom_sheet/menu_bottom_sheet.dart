// part of app_material;
//
// class MenuBottomSheet extends StatelessWidget {
//   final List<MenuBottomSheetModel> menuModels;
//   final String? title;
//   final bool isShowDivider;
//   final bool addMenuCubit;
//   final MenuOptionsCubit? menuCubitRef;
//
//   const MenuBottomSheet({
//     required this.menuModels,
//     super.key,
//     this.isShowDivider = false,
//     this.title,
//     this.addMenuCubit = false,
//     this.menuCubitRef,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     Widget child = SingleChildScrollView(
//       padding: EdgeInsets.only(
//         top: PaddingDimensions.medium,
//         bottom: PaddingDimensions.large + MediaQuery.paddingOf(context).bottom,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (title != null) ...[
//             Padding(
//               padding: const EdgeInsets.only(
//                 top: PaddingDimensions.small,
//                 right: PaddingDimensions.large,
//                 left: PaddingDimensions.large,
//               ),
//               child: Text(
//                 title!,
//                 style: context.medium.copyWith(fontSize: Dimensions.xxLarge),
//               ),
//             ),
//             const AppDivider(
//               bottom: PaddingDimensions.small,
//             ),
//           ],
//           ...List.generate(
//             menuModels.length,
//             (index) {
//               return _BottomSheetMenuItem(
//                 isLast: index == menuModels.length - 1,
//                 showDivider: !isShowDivider
//                     ? isShowDivider
//                     : index < menuModels.length - 1,
//                 bottomSheetModel: menuModels[index],
//               );
//             },
//           )
//         ],
//       ),
//     );
//
//     if (menuCubitRef != null) {
//       return BlocProvider.value(
//         value: menuCubitRef!,
//         child: child,
//       );
//     } else if (addMenuCubit) {
//       return BlocProvider(
//         create: (context) => MenuOptionsCubit(),
//         child: BlocListener<MenuOptionsCubit, MenuOptionsState>(
//           listener: (context, state) {
//             _handleOptionsState(context, state.saveState,
//                 successMsg: "Saved successfully");
//
//             //todo: add more conditions
//           },
//           child: child,
//         ),
//       );
//     }
//
//     return child;
//   }
//
//   void _handleOptionsState(BuildContext context, Async state, {required String? successMsg}) {
//     if (state.isLoading) {
//       AppBlockerLoader.showLoader(context);
//     } else if (state.isFailure) {
//       AppToasts.error(context,
//           message: state.failure?.errorMessage ?? 'Operation failed');
//
//       AppBlockerLoader.removeLoader();
//     } else if (state.isSuccess) {
//       AppToasts.success(context, message: successMsg ?? "Operation success");
//       AppRouteNavigator.pop(context);
//
//       AppBlockerLoader.removeLoader();
//     }
//   }
// }
//
// class _BottomSheetMenuItem extends StatelessWidget {
//   final bool showDivider;
//   final MenuBottomSheetModel bottomSheetModel;
//   final bool isLast;
//
//   const _BottomSheetMenuItem({
//     required this.bottomSheetModel,
//     required this.showDivider,
//     required this.isLast,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         InkWell(
//           onTap: () {
//             bottomSheetModel.onTap?.call(context);
//           },
//           splashColor: context.appColors.neutral.shade500,
//           borderRadius: BorderRadius.circular(4),
//           overlayColor: MaterialStatePropertyAll(context.appColors.neutral.shade500),
//           child: ColoredBox(
//             color: bottomSheetModel.isSelected == true
//                 ? context.appColors.neutral.shade500
//                 : Colors.transparent,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(
//                 vertical: PaddingDimensions.medium,
//                 horizontal: PaddingDimensions.large,
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   bottomSheetModel.icon != null
//                       ? Icon(
//                           bottomSheetModel.icon,
//                           color: bottomSheetModel.iconColor ??
//                               context.appColors.neutral.shade500,
//                           size: IconDimensions.normal,
//                         )
//                       : const SizedBox.shrink(),
//                   const SizedBox(
//                     width: PaddingDimensions.medium,
//                   ),
//                   Expanded(
//                     child: Row(
//                       children: [
//                         Flexible(
//                           child: Text(
//                             bottomSheetModel.title,
//                             style: context.medium.copyWith(
//                               color: bottomSheetModel.titleColor ??
//                                   context.appColors.neutral.shade900,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         Text(
//                           bottomSheetModel.subTitle ?? '',
//                           style: context.medium.copyWith(
//                             color: context.appColors.neutral.shade500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         if (showDivider) ...[
//           const AppDivider(
//             top: 0,
//             bottom: 0,
//           )
//         ]
//       ],
//     );
//   }
// }
