part of app_material;

class AppAlerts {
  static Future<T?> showDecisionDialog<T>(
    BuildContext context, {
    bool canPop = true,
    bool showCloseButton = true,
    List<DecisionButtonModel>? actionButtons,
    String? title,
    String? svgImagePath,
    IconData? icon,
    String? description,
    bool isButtonInVertical = false,
    double? borderRadius,
  }) async {
    return await showDialog<T?>(
      context: context,
      barrierDismissible: canPop,
      useRootNavigator: true,
      routeSettings: const RouteSettings(name: '${AppRouteNavigator.dialogRoutePrefix}decisionDialog'),
      builder: (context) {
        return _AppDialogContainer(
          canPop: canPop,
          showCloseButton: showCloseButton,
          borderRadius: borderRadius,
          child: DecisionDialog(
            isButtonInVertical: isButtonInVertical,
            actionButtons: actionButtons,
            title: title,
            imageSvgPath: svgImagePath,
            icon: icon,
            description: description,
          ),
        );
      },
    );
  }

  static Future<void> showMediaPickerFailureDialog(
      BuildContext context, Object failure) async {
    if (failure is NoAttachmentPickedFailure) {
      return;
    } else if (failure is FileSizeFailure) {
      await showDecisionDialog(
        context,
        title: appLocalizer.errorFileSize,
        description: failure.errorMessage,
        actionButtons: [
          DecisionButtonModel(
            title: appLocalizer.ok,
            onTap: (ctx) {
              AppRouteNavigator.pop(ctx);
            },
            isPrimary: true,
          ),
        ],
      );
    } else if (failure is PermissionFailure && failure.shouldOpenSettings) {
      showOpenPermissionsSettingsDialog(context);
    }
    // else if (failure is MultiImagePickFailure) {
    //   //todo:
    //   // showCustomDialog(
    //   //   context,
    //   //   widget: MultiImagePickFailureAlert(
    //   //       pickedMultiImagesEntity: failure.pickedMultiImagesEntity),
    //   // );
    // }
    else if (failure is Failure) {
      await showDecisionDialog(
        context,
        title: appLocalizer.errorPickingMedia,
        description: failure.errorMessage,
        actionButtons: [
          DecisionButtonModel(
            title: appLocalizer.ok,
            onTap: (ctx) {
              AppRouteNavigator.pop(ctx);
            },
            isPrimary: true,
          ),
        ],
      );
    }
  }

  static Future<void> showOpenPermissionsSettingsDialog(
    BuildContext context,
    { void Function()? onOpenSettingsPressed}
  ) async {
    return await AppAlerts.showDecisionDialog(context,
        title: appLocalizer.permissionNotGranted,
        description: appLocalizer.givePermissionsManually,
        actionButtons: [
          DecisionButtonModel(
            title: appLocalizer.openSettings,
            isPrimary: true,
            onTap: (context) async {
              AppRouteNavigator.pop(context);
              if(onOpenSettingsPressed != null){
                onOpenSettingsPressed.call();
              } else {
                openAppSettings();
              }
            },
          ),
          DecisionButtonModel(
            title: appLocalizer.cancel,
            isPrimary: false,
            onTap: (context) {
              AppRouteNavigator.pop(
                context,
              );
            },
          ),
        ]);
  }

  static void showGuestDialog(BuildContext context) {
    showDialog(
      context: context,
      routeSettings: const RouteSettings(name: 'GuestDialog'),
      useRootNavigator: true,
      builder: (context) {
        return const _AppDialogContainer(
          canPop: true,
          showCloseButton: true,
          child: GuestAlertView(),
        );
      },
    );
  }

  static void showOtpDialog(BuildContext context,
      {bool canPop = true, bool showCloseButton = true, required OTP otp}) {
    showDialog(
      context: context,
      routeSettings: const RouteSettings(name: 'otpDialog'),
      barrierDismissible: canPop,
      useRootNavigator: true,
      builder: (context) {
        return _AppDialogContainer(
          canPop: canPop,
          showCloseButton: showCloseButton,
          child: OtpDialog(
            otp: otp,
          ),
        );
      },
    );
  }

  static void showExitAppDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return const _AppDialogContainer(
            canPop: true, showCloseButton: true, child: ExitAppAlertView());
      },
    );
  }

  static void showCancelRegisterAppDialog(BuildContext context) {
    showDecisionDialog(
      context,
      title: appLocalizer.areYouSure,
      description: appLocalizer.exitDescription,
      actionButtons: [
        DecisionButtonModel(
          title: appLocalizer.yes,
          isPrimary: true,
          onTap: (context) {
            AppRouteNavigator.pop(context);
            context.read<AuthenticationBloc>().add(const AuthRestartEvent(
                route: AuthRouteEnum.getStartedPage));
          },
        ),
        DecisionButtonModel(
          title: appLocalizer.no,
          onTap: (context) {
            AppRouteNavigator.pop(context);
          },
        ),
      ],
    );
  }

  static Future<bool?> showCustomDialog(
    BuildContext context, {
    required Widget widget,
    bool canPop = true,
    bool showCloseButton = true,
    double? borderRadius,
  }) async {
    return await showDialog(
      context: context,
      barrierDismissible: canPop,
      useRootNavigator: true,
      routeSettings: const RouteSettings(name: 'customDialog'),
      builder: (context) {
        return _AppDialogContainer(
          canPop: canPop,
          showCloseButton: showCloseButton,
          child: widget,
        );
      },
    );
  }

  static void showNoInternetDialog(BuildContext context) {
    AppAlerts.showDecisionDialog(
      borderRadius: 48,
      context,
      title: appLocalizer.seemTobeOffline,
      description: appLocalizer.hangWeReconnecting,
      canPop: true,
      showCloseButton: false,
      icon: Iconsax.wifi,
    );
  }
}

class _AppDialogContainer extends StatelessWidget {
  final bool? canPop;
  final Widget child;
  final bool showCloseButton;
  final double? borderRadius;

  const _AppDialogContainer({
    required this.canPop,
    required this.child,
    required this.showCloseButton,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return AppResponsiveScaledBox(
      child: PopScope(
        canPop: canPop ?? true,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          surfaceTintColor: context.appColors.appBackgroundColor,
         // backgroundColor:context.appColors.appBackgroundColor,
          contentPadding: const EdgeInsets.all(
            PaddingDimensions.xLarge,
          ),
          // insetPadding: const EdgeInsets.all(59),
          insetPadding:
              const EdgeInsets.symmetric(horizontal: PaddingDimensions.xLarge),
          content: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveBreakpoints.of(context).screenWidth * 0.9,
                minWidth: ResponsiveBreakpoints.of(context).screenWidth * 0.9,
                maxHeight: ResponsiveBreakpoints.of(context).screenHeight * 0.9,
                minHeight: 0,
              ),
              child: child),
        ),
      ),
    );
  }
}
