import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:iconsax/iconsax.dart';
import 'package:moneeb/common/domain/models/enums/user_role_enum.dart';
import 'package:moneeb/core/app_material/material.dart';
import 'package:moneeb/core/app_material/src/app_loader/ui/custom_loading_widget.dart';
import 'package:moneeb/core/base/di/data_injector.dart';
import 'package:moneeb/core/base/helpers/helpers.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/ui/helper_widgets/helper_widgets.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/features/authentication/authentication_imports.dart';
import 'package:moneeb/features/home/home_imports.dart';
import 'package:moneeb/features/home/src/domain/entities/omrah_stepper_entity.dart';
import 'package:moneeb/features/home/src/presentation/widgets/provider_omrah_floating_steps/floating_omrah_manager.dart';
import 'package:moneeb/features/omrah/common/widgets/omrah_start_countdown.dart';
import 'package:moneeb/features/omrah/common/widgets/omrah_steps_view.dart';
import 'package:moneeb/features/omrah/provider/domain/models/enums/omrah_steps_enum.dart';
import 'package:moneeb/features/omrah/provider/presentation/manager/provider_omrah_cubit/provider_omrah_cubit.dart';
import 'package:moneeb/features/omrah/provider/presentation/steps/finish/finish_omrah_page.dart';
// TODO(User): makam step is disabled for now, uncomment when needed.
// import 'package:moneeb/features/omrah/provider/presentation/steps/makam/makam_page.dart';
import 'package:moneeb/features/omrah/provider/presentation/steps/mekat/mekat_page.dart';
import 'package:moneeb/features/omrah/provider/presentation/steps/safa_and_marwa/safa_and_marwa_page.dart';
import 'package:moneeb/features/omrah/provider/presentation/steps/tahalol/tahalol_page.dart';
import 'package:moneeb/features/omrah/provider/presentation/steps/tawaf/tawaf_page.dart';

import 'package:moneeb/core/base/fire_base/src/fcm_notification/utils/notification_actions_observer/mixins/notification_actions_mixin.dart';
import 'package:moneeb/core/base/fire_base/src/fcm_notification/utils/notification_actions_observer/notification_actions_updater.dart';
import 'package:moneeb/features/omrah/provider/domain/models/omrah/omrah_step_entity.dart';
import 'package:moneeb/features/omrah/provider/presentation/veritifcation_pages/provider_image_verification_upload_page.dart';
import 'package:moneeb/features/omrah/provider/presentation/veritifcation_pages/provider_video_verification_upload_page.dart';
import 'package:moneeb/features/orders/provider_orders/provider_orders_imports.dart';
import 'package:moneeb/features/orders/provider_orders/src/domain/entities/enums/provider_order_status_enum.dart';

import 'manager/provider_tracking_service.dart';

class ProviderOmrahPage extends StatelessWidget {
  final String orderId;
  final ForWhomEntity forWhom;

  /// Step page to open once the steps are loaded, e.g. a step the admin rejected.
  final OmrahStepsEnum? openStep;

  /// The day the requester wants the umrah done; the rituals stay locked until it.
  final DateTime? targetDate;

  const ProviderOmrahPage({
    super.key,
    required this.orderId,
    required this.forWhom,
    this.openStep,
    this.targetDate,
  });

  static const String routeName = "ProviderOmrahPage";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProviderOmrahCubit(
        orderId: orderId,
        forWhom: forWhom,
        targetDate: targetDate,
      )..getOmrahStepsStatus(),
      lazy: false,
      child: _ProviderOmrahBody(
        orderId: orderId,
        forWhom: forWhom,
        openStep: openStep,
        targetDate: targetDate,
      ),
    );
  }

  /// Takes the provider to [step] of [orderId] after the admin rejected its proof.
  ///
  /// Reuses the rituals page of that order when it is already open, otherwise
  /// opens a new one. With [interruptUpload] false (notification received while
  /// the app is in use) a provider in the middle of uploading a proof is not
  /// pulled away, his open pages just get the rejection.
  static Future<void> openRejectedStep(
    BuildContext context, {
    required String orderId,
    required OmrahStepsEnum step,
    bool interruptUpload = true,
  }) async {
    final bool isUploading =
        NavObserver.instance.isCurrentPage(
          ProviderVideoVerificationUploadPage.routeName,
        ) ||
        NavObserver.instance.isCurrentPage(
          ProviderImageVerificationUploadPage.routeName,
        );
    final bool shouldNavigate = interruptUpload || !isUploading;

    final bool isHandled = injector<NotificationActionsUpdater>()
        .providerStepRejected(orderId, shouldNavigate ? step : null);
    if (isHandled || !shouldNavigate) return;

    try {
      final activeOrders = await injector<ProviderOrdersRepository>()
          .getProviderOrders(status: ProviderOrderStatus.inProgress, limit: 50);
      final order = activeOrders.items.firstWhereOrNull((e) => e.id == orderId);

      if (!context.mounted) return;

      if (order == null) {
        NavObserver.instance.changeTab(MainHostPageTabsEnum.orders);
        return;
      }

      AppRouteNavigator.push(
        context,
        ProviderOmrahPage.routeName,
        ProviderOmrahPage(
          orderId: orderId,
          forWhom: ForWhomEntity(
            beneficiaryName: order.beneficiaryName,
            beneficiaryType: order.beneficiaryType,
          ),
          openStep: step,
          targetDate: order.targetDate,
        ),
      );
    } catch (e) {
      logDebug("ProviderOmrahPage.openRejectedStep: $e");
    }
  }

  static void pushToOmrahStep({
    required BuildContext context,
    required OmrahStepsEnum step,
  }) {
    switch (step) {
      case OmrahStepsEnum.mekat:
        AppRouteNavigator.push(
          context,
          MekatPage.routeName,
          MekatPage(omrahCubitRef: context.read<ProviderOmrahCubit>()),
        );
        break;
      case OmrahStepsEnum.tawaf:
        AppRouteNavigator.push(
          context,
          TawafPage.routeName,
          TawafPage(omrahCubitRef: context.read<ProviderOmrahCubit>()),
        );
        break;
      // TODO(User): makam step is disabled for now, uncomment when needed.
      // case OmrahStepsEnum.makam:
      //   AppRouteNavigator.push(
      //     context,
      //     MakamPage.routeName,
      //     MakamPage(omrahCubitRef: context.read<ProviderOmrahCubit>(),),
      //   );
      //   break;
      case OmrahStepsEnum.safa_and_marwa:
        AppRouteNavigator.push(
          context,
          SafaAndMarwaPage.routeName,
          SafaAndMarwaPage(omrahCubitRef: context.read<ProviderOmrahCubit>()),
        );
        break;
      case OmrahStepsEnum.tahalol:
        AppRouteNavigator.push(
          context,
          TahalolPage.routeName,
          TahalolPage(omrahCubitRef: context.read<ProviderOmrahCubit>()),
        );
        break;
      case OmrahStepsEnum.finished:
        AppRouteNavigator.push(
          context,
          FinishOmrahPage.routeName,
          FinishOmrahPage(orderId: context.read<ProviderOmrahCubit>().orderId),
        );

        break;
    }
  }
}

class _ProviderOmrahBody extends StatefulWidget {
  final String orderId;
  final ForWhomEntity forWhom;
  final OmrahStepsEnum? openStep;
  final DateTime? targetDate;
  const _ProviderOmrahBody({
    super.key,
    required this.orderId,
    required this.forWhom,
    this.openStep,
    this.targetDate,
  });

  @override
  State<_ProviderOmrahBody> createState() => _ProviderOmrahBodyState();
}

class _ProviderOmrahBodyState extends State<_ProviderOmrahBody>
    with NotificationActionsObserverMixin {
  /// Step page to push as soon as the next steps load finishes.
  OmrahStepsEnum? _stepToOpen;

  @override
  void initState() {
    _stepToOpen = widget.openStep;
    _askForLocationPermission();
    FloatingOmrahOverlayManager.hide();
    initNotificationActionsObserver(
      providerStepRejected: (orderId, step) {
        if (orderId != widget.orderId || !mounted) return false;

        if (step != null) {
          // Drop the step / upload page on top, the rejected step is pushed after the reload.
          _stepToOpen = step;
          AppRouteNavigator.popUntil(
            context,
            removeUntil: ProviderOmrahPage.routeName,
          );
        }
        context.read<ProviderOmrahCubit>().getOmrahStepsStatus();
        return true;
      },
    );
    super.initState();
  }

  void _askForLocationPermission() async {
    try {
      await LocationService.instance.checkAndRequestPermission();
    } catch (e) {
      if (e is LocationFailure) {
        AppAlerts.showDecisionDialog(
          context,
          title: appLocalizer.grantLocationPermissionPlease,

          description: appLocalizer.grantLocationDesc,

          actionButtons: [
            DecisionButtonModel(
              title: appLocalizer.grantPermission,
              isPrimary: true,
              onTap: (context) async {
                AppRouteNavigator.pop(context);

                if (e.isDeniedForEver) {
                  LocationService.instance.openAppLocationSettings();
                } else {
                  LocationService.instance.checkAndRequestPermission();
                }
              },
            ),
            DecisionButtonModel(
              title: appLocalizer.cancel,
              isPrimary: false,
              onTap: (context) {
                AppRouteNavigator.pop(context);
              },
            ),
          ],
        );
      }
    }
  }

  /// Location is only sent once the provider has proven being at the miqat,
  /// and never before the day the requester picked. Never stopped from here
  /// when unverified, so a rejected miqat proof does not cut a running trail.
  void _syncTracking(ProviderOmrahState state) {
    final currentStep = state.currentStep.data;
    if (currentStep == null) return;

    if (currentStep == OmrahStepsEnum.finished) {
      ProviderTrackingService.instance.dispose();
    } else if (state.isMiqatVerified &&
        OmrahSchedule.hasStarted(widget.targetDate)) {
      ProviderTrackingService.instance.startTracking(widget.orderId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          FloatingOmrahOverlayManager.unHide(context);
        }
      },
      child: BlocListener<ProviderOmrahCubit, ProviderOmrahState>(
        listenWhen: (previous, current) =>
            previous.currentStep != current.currentStep ||
            previous.isMiqatVerified != current.isMiqatVerified,
        listener: (context, state) => _syncTracking(state),
        child: Scaffold(
          appBar: AppBars.defaultBar(
            context,
            useCloseButton: true,
            centerTitle: true,
            text: appLocalizer.omrahRituals,
          ),
          body: OmrahStartGate(
            targetDate: widget.targetDate,
            child: SafeArea(
              child: BlocConsumer<ProviderOmrahCubit, ProviderOmrahState>(
                buildWhen: (previous, current) =>
                    previous.currentStep != current.currentStep ||
                    previous.omrahStepsData != current.omrahStepsData,
                listenWhen: (previous, current) =>
                    previous.currentStep != current.currentStep,
                listener: (context, state) {
                  final currentStep = state.currentStep.data;

                  // A notification points at one rejected step, but when an earlier
                  // step is rejected too the provider starts from that one.
                  if (state.currentStep.isSuccess &&
                      _stepToOpen != null &&
                      currentStep != null) {
                    _stepToOpen = null;
                    ProviderOmrahPage.pushToOmrahStep(
                      context: context,
                      step: currentStep,
                    );
                  }

                  if (currentStep != null) {
                    injector<OmrahUpdater>().omrahStepChanged(
                      OmrahStepperEntity(
                        currentStep: currentStep,
                        orderId: widget.orderId,
                        forWhom: widget.forWhom,
                        targetDate: widget.targetDate,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state.currentStep.isLoading) {
                    return Center(child: CustomAnimationLoading());
                  } else if (state.currentStep.isFailure) {
                    return Center(
                      child: FailureWidget(
                        onRetryPressed: () {
                          context
                              .read<ProviderOmrahCubit>()
                              .getOmrahStepsStatus();
                        },
                        failure: state.currentStep.failure,
                      ),
                    );
                  }

                  final currentStep =
                      state.currentStep.data ?? OmrahStepsEnum.mekat;
                  final stepsData = state.omrahStepsData.data ?? [];
                  final rejectedSteps = stepsData.rejectedSteps;

                  return OmrahStepsView(
                    currentStep: currentStep,
                    rejectedSteps: rejectedSteps,
                    proofedSteps: stepsData
                        .where(
                          (e) => e.status == OmrahStepStatusEnum.proofUploaded,
                        )
                        .map((e) => e.stepType)
                        .toSet(),
                    onTap: (step) {
                      // Only the step whose turn it is opens, even when later steps
                      // were rejected too — those come back in order.
                      if (step != currentStep) return;

                      //todo: remove this
                      // if (step.index < currentStep.index) return;

                      ProviderOmrahPage.pushToOmrahStep(
                        context: context,
                        step: step,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
