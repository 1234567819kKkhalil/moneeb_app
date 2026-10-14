part of app_material;

class AppBottomSheets {
  static Future<T?> showMediaPickerUtilsBottomSheet<T>({
    required BuildContext context,
    BottomSheetHeader? header,
    bool useCloseButton = false,
    bool hasBorder = false,
    String? titleHeader,

    PickedSingleMediaCallback? onPickMedia,
    PickedMultipleMediaCallback? onPickMultiMedia,
    required List<MediaPickItemConfig> pickConfigs,
    Function()? onPickStart,
    Function()? onPickEnd,
  }) async {
    return await showAppBottomSheet<T?>(
      context,
      header: header,
      useCloseButton: useCloseButton,
      builder: (_) {
        return MediaPickerBottomSheet(
          pageContext: context,
          onPickMedia: onPickMedia,
          onPickMultiMedia: onPickMultiMedia,
          onPickEnd: onPickEnd,
          onPickStart: onPickStart,
          picksConfig: pickConfigs,
        );
      },
    );
  }

  // static void showPlaybackSpeedBottomSheet(BuildContext context, {
  //   List<double> speeds = const [0.25, 0.5, 0.75, 1, 1.25, 1.5, 1.75, 2],
  //   double? currentPlaybackSpeed,
  //   required Function(BuildContext context, double speed) onTap,
  // }) {
  //   AppBottomSheets.showMenuBottomSheet(context,
  //     menuModels: List.generate(
  //       speeds.length, (index) {
  //         return MenuBottomSheetModel(
  //           onTap: (context) {
  //             onTap(context, speeds[index]);
  //           },
  //           icon: Icons.speed_rounded,
  //           title: "${speeds[index]}x",
  //           isSelected: currentPlaybackSpeed == speeds[index],
  //         );
  //       },
  //     ),
  //   );
  // }

  // static Future<void> showMenuBottomSheet(
  //   BuildContext context, {
  //   required List<MenuBottomSheetModel> menuModels,
  //   bool isShowDivider = false,
  //   String? title,
  //   bool addMenuCubit = false,
  //   MenuOptionsCubit? menuCubitRef
  // }) async {
  //   await showAppBottomSheet(
  //     context,
  //     useCloseButton: false,
  //     hasBorder: false,
  //     padding: EdgeInsets.zero,
  //     builder: (context) {
  //       return MenuBottomSheet(
  //         isShowDivider: isShowDivider,
  //         menuModels: menuModels,
  //         title: title,
  //         addMenuCubit: addMenuCubit,
  //         menuCubitRef: menuCubitRef,
  //       );
  //     },
  //   );
  // }

  // static Future<void> showMenuOptionsBottomSheetWithItsCubit(
  //     BuildContext context, {
  //       required List<MenuBottomSheetModel> menuModels,
  //       bool isShowDivider = false,
  //       final MenuOptionsCubit? menuCubitRef
  //     }) async {
  //   if (menuModels.isEmpty) return;
  //
  //   await showAppBottomSheet(
  //     context,
  //     useCloseButton: false,
  //     hasBorder: false,
  //     padding: EdgeInsets.zero,
  //     builder: (context) {
  //       return MenuBottomSheet(
  //         isShowDivider: isShowDivider,
  //         menuModels: menuModels,
  //         addMenuCubit: true,
  //         menuCubitRef: menuCubitRef,
  //       );
  //     },
  //   );
  // }

  static Future<T?> showAppBottomSheet<T>(
    BuildContext context, {
    required Widget Function(BuildContext context) builder,
    bool useCloseButton = true,
    String? routeName,
    bool showContainerColor = false,
    EdgeInsetsGeometry? padding,
    bool hasBorder = false,
    BottomSheetHeader? header,
    VoidCallback? onCloseTaped,
    bool useSafeArea = false,
    Color? titleColor,
    Color? svgIconColor,
    Color? backgroundColor,
    bool enableDrag = true,
    bool isDismissible = true,
    AnimationController? transitionController,
    BorderRadiusGeometry? borderRadius,
  }) async {
    FocusScope.of(context).requestFocus(FocusNode());

    return await showModalBottomSheet<T>(
      routeSettings: routeName != null
          ? RouteSettings(
              name: AppRouteNavigator.bottomSheetRoutePrefix + routeName,
            )
          : null,
      backgroundColor: backgroundColor,
      clipBehavior: Clip.antiAlias,
      isScrollControlled: true,
      context: context,
      useRootNavigator: true,
      enableDrag: enableDrag,
      useSafeArea: useSafeArea,
      isDismissible: isDismissible,
      transitionAnimationController: transitionController,
      constraints: const BoxConstraints(
        maxWidth: double.infinity,
        minWidth: double.infinity,
        //if added height constraints test the bottom sheets that have columns or lists because it will lead to unwanted behaviour
      ),
      shape: RoundedRectangleBorder(
        borderRadius:
            borderRadius ??
            const BorderRadius.only(
              topRight: Radius.circular(Dimensions.largeRadius),
              topLeft: Radius.circular(Dimensions.largeRadius),
            ),
        side: hasBorder
            ? BorderSide(color: context.appColors.primary.shade500, width: 1)
            : BorderSide.none,
      ),
      builder: (context) {
        return AppResponsiveScaledBox(
          useDynamicHeight: true,
          child: Builder(
            builder: (context) {
              return Center(
                child: Padding(
                  padding:
                      padding ??
                      const EdgeInsets.symmetric(
                        horizontal: PaddingDimensions.large,
                        vertical: PaddingDimensions.large,
                      ),
                  // showModalBottomSheet's useSafeArea only guards the top
                  // (SafeArea(bottom: false)), so the bottom inset is ours.
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (showContainerColor) ...[
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 50,
                              height: 6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(99),
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: PaddingDimensions.large),
                        ],

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (header?.title != null)
                              Expanded(
                                child: Row(
                                  children: [
                                    if (header?.prefix != null) header!.prefix!,

                                    Expanded(
                                      child: Text(
                                        header!.title!,
                                        style: context.semiBold.copyWith(
                                          fontSize: Dimensions.xxLarge,
                                          color:
                                              titleColor ??
                                              AppColors.neutral900,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            if (header?.trailing != null) header!.trailing!,

                            if (useCloseButton)
                              Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: AppIconButton(
                                  iconData: Icons.close,
                                  color:
                                      svgIconColor ??
                                      context.appColors.neutral.shade900,
                                  size: IconDimensions.normal,
                                  topPadding: 0,
                                  startPadding: 0,
                                  onPressed: () {
                                    if (onCloseTaped != null) {
                                      onCloseTaped();
                                    } else {
                                      AppRouteNavigator.pop(context);
                                    }
                                  },
                                ),
                              ),
                          ],
                        ),

                        if (header?.showDivider ?? false)
                          AppDivider(
                            start: 0,
                            end: 0,
                            thickness: 0.5,
                            color: context.appColors.neutral.shade500,
                          ),
                        builder(context),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
