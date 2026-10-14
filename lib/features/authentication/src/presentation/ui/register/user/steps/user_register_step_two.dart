// part of auth;
//
// class UserRegisterStepTwo extends StatefulWidget {
//   final VoidCallback onNext;
//   final VoidCallback onBack;
//
//   const UserRegisterStepTwo({
//     super.key,
//     required this.onNext,
//     required this.onBack,
//   });
//
//   @override
//   State<UserRegisterStepTwo> createState() => _UserRegisterStepTwoState();
// }
//
// class _UserRegisterStepTwoState extends State<UserRegisterStepTwo> {
//   RegisterInputProvider get inputProvider => context.read<RegisterInputProvider>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(
//         horizontal: PaddingDimensions.pageHorizontalPadding,
//         vertical: PaddingDimensions.large,
//       ),
//       child: SingleChildScrollView(
//         physics: const ClampingScrollPhysics(),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "صورتك الشخصية", 
//               style: context.extraBold.copyWith(
//                 color: context.appColors.secondary.shade500
//               ),
//             ),
//
//             const SizedBox(height: 8),
//
//             Text(
//               'قم برفع صورتك الشخصية او الرمزية لملفك الشخصي', 
//               style: context.regular,
//             ),
//
//             const SizedBox(height: 24),
//
//             Center(
//               child: GestureDetector(
//                 onTap: () {
//                   Feedback.forTap(context);
//
//                   AppBottomSheets.showMediaPickerUtilsBottomSheet(
//                     context: context,
//                     pickConfigs: [
//                       MediaPickImageConfig.single(
//                         canModifyImage: true,
//                       ),
//
//                       MediaPickImageConfig.single(
//                         canModifyImage: true,
//                         isCamera: true
//                       )
//                     ],
//                     onPickMedia: (media) {
//                       inputProvider.profilePicture = media;
//                       setState(() {});
//                     },
//                   );
//                 },
//                 child: Container(
//                   width: 250,
//                   height: 250,
//                   clipBehavior: Clip.antiAlias,
//                   decoration: BoxDecoration(
//                     color: AppColors.neutral100,
//                     shape: BoxShape.circle,
//                   ),
//                   alignment: Alignment.center,
//                   child: inputProvider.profilePicture == null
//                     ? Column(
//                     spacing: 10,
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(
//                         Iconsax.export,
//                         color: AppColors.neutral700,
//                         size: 24,
//                       ),
//
//                       Text(
//                         "رفع الصورة",
//                         style: context.bold.copyWith(
//                           color: AppColors.neutral700,
//                           fontSize: 12
//                         ),
//                       )
//
//                     ],
//                   )
//                     : AppImage(
//                       path: inputProvider.profilePicture?.url ?? '',
//                       fit: BoxFit.cover,
//                       width: 250,
//                       height: 250,
//                     )
//                 ),
//               ),
//             ),
//
//             if(inputProvider.profilePicture != null)
//               Center(
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 12.0),
//                   child: AppPrimaryButton(
//                     text: "حذف الصورة",
//                     textStyle: context.bold.copyWith(
//                       fontSize: 12
//                     ),
//                     buttonStyle: (currentStyle) {
//                       return currentStyle?.copyWith(
//                         backgroundColor: WidgetStatePropertyAll(AppColors.danger700)
//                       );
//                     },
//                     onPressed: () {
//                       setState(() {
//                         inputProvider.profilePicture = null;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//
//             const SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }
// }
