part of notifications;

/// Routes the user to the appropriate screen when they tap a notification
/// from the in-app list.
///
/// Logic mirrors [ExternalForwardingHandler._handleNotification] so both
/// FCM-tap and in-app-list-tap behave identically.
class NotificationRouter {
  NotificationRouter._();

  static void route(BuildContext context, NotificationItemEntity item) {
    final notifContext = item.context;

    // No structured context → nothing to route
    if (notifContext == null) return;

    final referenceOrderId = item.referenceOrderId;
    final bool hasOrderId =
        referenceOrderId != null && referenceOrderId.isNotEmpty;

    final userModel = context.read<AuthenticationBloc>().getUserModel;
    final bool isUser = userModel.role == UserRoleEnum.user;

    // ── Ritual step events ────────────────────────────────────────────────
    // ritualStep != null means an active omrah ritual event (proof uploaded,
    // GPS verified, video ready, etc.). Only the user (requester) has an
    // inspector page for this; providers get their UI via the floating overlay.
    final ritualStep = notifContext.ritualStep;

    if (ritualStep != null && hasOrderId) {
      if (isUser) {
        _navigateToStepProof(context, referenceOrderId, ritualStep);
      } else if (notifContext.eventType ==
          NotificationEventType.ritualProofRejectedProvider) {
        // Provider: back to the rejected step to upload its proof again.
        ProviderOmrahPage.openRejectedStep(
          context,
          orderId: referenceOrderId,
          step: ritualStep,
        );
      }
      // Provider: other ritual events have no dedicated page yet.
      return;
    }

    // ── ORDER_* events (and ritual events without a ritualStep field) ──────
    // The backend targets these to the correct role automatically:
    //   • ORDER_CREATED / ORDER_COMPLETED / ORDER_CANCELLED → sent to user
    //   • ORDER_ACCEPT_DEADLINE_WARN / ORDER_RITUAL_DEADLINE_WARN → sent to provider
    //   • ORDER_RITUAL_DEADLINE_REQUESTER_WARN → sent to user
    // Both user and provider land on the Orders tab — which already shows
    // role-specific orders — so a single tab switch works for everyone.
    if (notifContext.eventType.isOrderEvent ||
        notifContext.eventType.isRitualEvent) {
      // Switch to Orders tab first.
      if (NavObserver.instance.currentTab != MainHostPageTabsEnum.orders) {
        NavObserver.instance.changeTab(MainHostPageTabsEnum.orders);
      }
      // Trigger a data refresh for the specific order if available.
      if (hasOrderId && notifContext.orderStatus != null) {
        injector<NotificationActionsUpdater>().orderUpdated(
          referenceOrderId!,
          notifContext.orderStatus!,
        );
      }
      // Close the notifications page so the Orders tab is visible.
      AppRouteNavigator.pop(context);
      return;
    }

    // ── Wallet / Payment events ───────────────────────────────────────────
    if (notifContext.eventType == NotificationEventType.paymentConfirmed ||
        notifContext.eventType == NotificationEventType.paymentAdminReceived ||
        notifContext.eventType == NotificationEventType.walletCredit ||
        notifContext.eventType == NotificationEventType.walletTransferOut ||
        notifContext.eventType ==
            NotificationEventType.walletWithdrawalRejected) {
      if (NavObserver.instance.currentTab != MainHostPageTabsEnum.profile) {
        NavObserver.instance.changeTab(MainHostPageTabsEnum.profile);
      }
      AppRouteNavigator.pop(context);
      return;
    }

    // ── All other events (tasbeeh, provider registration, admin broadcast)
    // Already on the notifications screen — no extra navigation needed.
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Opens the step's proof page directly — it fetches the step itself from the
  /// order id, so there is no need to stop by the omrah steps list on the way.
  /// A step still in progress shows the "track provider" action there.
  static void _navigateToStepProof(
    BuildContext context,
    String orderId,
    OmrahStepsEnum ritualStep,
  ) {
    if (NavObserver.instance.isCurrentPage(OmrahMediaInspectorPage.routeName)) {
      return;
    }

    AppRouteNavigator.push(
      context,
      OmrahMediaInspectorPage.routeName,
      OmrahMediaInspectorPage.byStepType(
        stepType: ritualStep,
        orderId: orderId,
      ),
    );
  }
}
