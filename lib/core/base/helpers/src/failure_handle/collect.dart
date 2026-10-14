part of helpers;

Future<T?> collect<T>({
  required Future<T> Function() task,
  void Function(Failure failure)? onError,
  bool ignoreInternetCheck = false,
  bool disableUnAuthorizedDialogs = false
}) async {
  try {
    if (!ignoreInternetCheck) {
      if (!(await injector<NetworkInfo>().hasConnection)) {
        await Future.delayed(
          const Duration(milliseconds: 200),
          () {
            throw NoInternetFailure();
          },
        );
      }
    }
    return await task();
  } catch (failure, s) {
    logDebug(failure);

    if (failure is FormatException) {
      log(failure.toString(), stackTrace: s);
    }

    if (failure is ApiRequestFailure) {

      final bool showUnAuthDialogs = !NavObserver.instance.isBeforeMainHostPage() && !disableUnAuthorizedDialogs;

      if (showUnAuthDialogs) {
        if (failure.statusCode == StatusCodes.blockedUser) {
          _showUnAuthorizeDialog(isBlocked: true);
        } else if (failure.statusCode == StatusCodes.unauthorizedCode) {
          _showUnAuthorizeDialog();
        }
      }
    }

    if (onError != null) {
      if (failure is Failure) {
        onError(failure);
      } else {
        onError(UnExpectedFailure(appLocalizer.unexpectedError));
      }
    }
  }

  return null;
}

Future<void> _showUnAuthorizeDialog({bool isBlocked = false}) async {
  final BuildContext context =  await AppRouteNavigator.getAppContextWhenAvailable();
  if (context.mounted) {
    AppAlerts.showDecisionDialog(
      context,
      title: isBlocked
          ? appLocalizer.blockedErrorTitleError
          : appLocalizer.unAuthorizedErrorTitleError,
      description: isBlocked
          ? appLocalizer.blockedErrorDescError
          : appLocalizer.unAuthorizedErrorDescError,
      canPop: false,
      showCloseButton: false,
      actionButtons: [
        DecisionButtonModel(
          title: appLocalizer.ok,
          onTap: (context) {
            AppRouteNavigator.popUntil(context);
            context.read<AuthenticationBloc>().add(UnAuthorizedEvent());
          },
          isPrimary: true,
        )
      ],
    );
  }
}
