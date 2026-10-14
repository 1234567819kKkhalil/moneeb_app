part of fire_base;

class ExternalForwardingHandler {
  ExternalForwardingHandler.handleNotificationFromEntity(ReceivedNotificationEntity notificationEntity, {bool? isFromBackground}) {
    _handleNotification(notificationEntity,);
  }

  static ReceivedNotificationEntity? decodeNotificationPayload(String payload) {
    Map<String, dynamic>? decodedPayload;

    try {
      decodedPayload = json.decode(payload);

      if (decodedPayload != null) {
        return ReceivedNotificationEntity.fromJson(decodedPayload);
      }
    } catch (e) {
      log(e.toString(), name: "Error Decoding Notification Payload");
    }

    return null;
  }

  ExternalForwardingHandler.handleNotificationFromPayload(NotificationResponse? response) {
    ReceivedNotificationEntity? notificationEntity = decodeNotificationPayload(response?.payload ?? "");

    if (notificationEntity != null) {
      _handleNotification(notificationEntity);
    }
  }

  void _handleNotification(ReceivedNotificationEntity notificationEntity) async {
    log(notificationEntity.toString(), name: "Handle Notification Received Payload");

    final BuildContext appContext = await AppRouteNavigator.getAppContextWhenAvailable();
    if (!appContext.mounted) return;

    //wait for user data to be fetched
    //because if we pushed the page immediately and this page is depending on AppUserModel then we will face unExpected behaviors
    if (!appContext.read<AuthenticationBloc>().state.userData.isSuccess) {
      final Completer<void> waitForUserDataToGetFetchedCompleter = Completer();

      StreamSubscription authBlocStreamSub = appContext.read<AuthenticationBloc>().stream.listen((event) {
          if (event.userData.isSuccess) {
            waitForUserDataToGetFetchedCompleter.complete();
          } else if (event.userData.isFailure) {
            waitForUserDataToGetFetchedCompleter.completeError("err");
          }
        },
      );

      try {
        await waitForUserDataToGetFetchedCompleter.future;
        authBlocStreamSub.cancel();
      } catch (e) {
        authBlocStreamSub.cancel();
        return;
      }
    }

    if (!appContext.mounted || notificationEntity.referenceOrderId.isEmpty) return;

    final userModel = appContext.read<AuthenticationBloc>().getUserModel;
    final bool isUser = userModel.role == UserRoleEnum.user;

    final ritualStep = notificationEntity.ritualStep;

    if(ritualStep != null){
      if(isUser){
        //land on the step proof itself, it fetches its own data from the order id
        if(!NavObserver.instance.isCurrentPage(OmrahMediaInspectorPage.routeName)){
          AppRouteNavigator.push(
              appContext,
              OmrahMediaInspectorPage.routeName,
              OmrahMediaInspectorPage.byStepType(
                stepType: ritualStep,
                orderId: notificationEntity.referenceOrderId,
              )
          );
        }
      } else if(notificationEntity.isProviderProofRejected){
        //take the provider back to the rejected step so he can upload its proof again
        ProviderOmrahPage.openRejectedStep(
          appContext,
          orderId: notificationEntity.referenceOrderId,
          step: ritualStep,
        );
      }
    } else if(notificationEntity.orderStatus != null){
      if(NavObserver.instance.currentTab != MainHostPageTabsEnum.orders){
        NavObserver.instance.changeTab(MainHostPageTabsEnum.orders);
      }

      injector<NotificationActionsUpdater>().orderUpdated(
        notificationEntity.referenceOrderId,
        notificationEntity.orderStatus!
      );
    }
  }
}
