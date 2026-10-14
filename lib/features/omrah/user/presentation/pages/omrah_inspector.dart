import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:injectable/injectable.dart';
import 'package:moneeb/core/app_material/material.dart';
import 'package:moneeb/core/base/fire_base/src/fcm_notification/utils/notification_actions_observer/mixins/notification_actions_mixin.dart';
import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/core/app_material/src/app_loader/ui/custom_loading_widget.dart';
import 'package:moneeb/core/ui/helper_widgets/helper_widgets.dart';
import 'package:moneeb/features/omrah/common/widgets/omrah_steps_view.dart';
import 'package:moneeb/features/omrah/provider/domain/models/enums/omrah_steps_enum.dart';
import 'package:moneeb/features/omrah/user/presentation/manager/omrah_inspector_cubit.dart';
import 'package:moneeb/features/omrah/user/presentation/pages/omarh_add_review_page.dart';
import 'package:moneeb/features/omrah/user/presentation/pages/omrah_media_inspector_page.dart';
import 'package:moneeb/features/omrah/user/presentation/pages/user_omrah_map_inspector_page.dart';

class UserOmrahInspectorPage extends StatelessWidget {
  final String orderId;

  /// Name of the person the omrah is performed for, when the entry point
  /// already has the order at hand. Passed down to the conclusion page.
  final String? beneficiaryName;

  const UserOmrahInspectorPage({
    super.key,
    required this.orderId,
    this.beneficiaryName,
  });

  static const String absoluteRouteName = "UserOmrahInspectorPage";
  static String routeName(String orderId) => AppRouteNavigator.formatRouteWithId(
    absoluteRouteName,
    orderId
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OmrahInspectorCubit(orderId)..getOmrahStepsStatus(),
      child: _UserOmrahInspectorPageBody(
        orderId: orderId,
        beneficiaryName: beneficiaryName,
      )
    );
  }
}

class _UserOmrahInspectorPageBody extends StatefulWidget {
  final String orderId;
  final String? beneficiaryName;
  const _UserOmrahInspectorPageBody({
    super.key,
    required this.orderId,
    this.beneficiaryName,
  });

  @override
  State<_UserOmrahInspectorPageBody> createState() => _UserOmrahInspectorPageBodyState();
}

class _UserOmrahInspectorPageBodyState extends State<_UserOmrahInspectorPageBody> with NotificationActionsObserverMixin{

  @override
  void initState() {
    initNotificationActionsObserver(
      refreshOmrahPage: (orderId) {
        context.read<OmrahInspectorCubit>().getOmrahStepsStatus();
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.defaultBar(
        context,
        useCloseButton: true,
        centerTitle: true,
        text: appLocalizer.omrahRituals,
        actions: [
          BlocBuilder<OmrahInspectorCubit, OmrahInspectorState>(
            buildWhen: (previous, current) => previous.currentStep != current.currentStep,
            builder: (context, state) {
              // if(state.currentStep.data == OmrahStepsEnum.finished){
              //   return SizedBox.shrink();
              // }

              return AppIconButton(
                endPadding: 16,
                onPressed: () {
                  AppRouteNavigator.push(
                      context,
                      UserOmrahMapInspectorPage.routeName,
                      UserOmrahMapInspectorPage(
                        orderId: widget.orderId,
                        currentStep: state.currentStep.data,
                      )
                  );
                },
                iconData: Icons.share_location_outlined,
                color: context.appColors.neutral.shade900,
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: BlocBuilder<OmrahInspectorCubit, OmrahInspectorState>(
          buildWhen: (previous, current) => previous.currentStep != current.currentStep,
          builder: (context, state) {
            if(state.currentStep.isLoading){
              return Center(
                child: CustomAnimationLoading(),
              );
            } else if(state.currentStep.isFailure){
              return Center(
                child: FailureWidget(
                  onRetryPressed: () {
                    context.read<OmrahInspectorCubit>().getOmrahStepsStatus();
                  },
                  failure: state.currentStep.failure
                ),
              );
            }

            final currentStep = state.currentStep.data ?? OmrahStepsEnum.mekat;

            return OmrahStepsView(
              currentStep: currentStep,
              onTap: (step) {
                if (step.index < currentStep.index) return;

                if(step == OmrahStepsEnum.finished){
                  AppRouteNavigator.push(
                    context,
                    OmrahAddReviewPage.routeName,
                    OmrahAddReviewPage(
                      orderId: widget.orderId,
                      beneficiaryName: widget.beneficiaryName,
                    )
                  );
                } else {
                  AppRouteNavigator.push(
                      context,
                      OmrahMediaInspectorPage.routeName,
                      OmrahMediaInspectorPage(
                        step: state.getOmrahStepData(step),
                        orderId: widget.orderId,
                      )
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
