import 'package:flutter/material.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/features/home/home_imports.dart';
import 'package:moneeb/features/home/src/domain/entities/omrah_stepper_entity.dart';
import 'package:moneeb/features/home/src/presentation/widgets/provider_omrah_floating_steps/draggable_mixin.dart';
import 'package:moneeb/features/home/src/presentation/widgets/user_omrah_floating_steps/user_omrah_overlay_manager.dart';
import 'package:moneeb/features/omrah/user/presentation/pages/omrah_inspector.dart';

class UserOmrahOverlayView extends StatefulWidget {
  final OmrahStepperEntity omrahData;
  const UserOmrahOverlayView({super.key, required this.omrahData});

  @override
  State<UserOmrahOverlayView> createState() => _UserOmrahOverlayViewState();
}

class _UserOmrahOverlayViewState extends State<UserOmrahOverlayView>
    with DraggableOverlayMixin {
  @override
  double get defaultHeight => context.adaptiveHeight * 0.4;

  @override
  double get defaultWidth => context.adaptiveWidth - 8;

  @override
  void onRemoveOverlay() {
    UserOmrahOverlayManager.removeOverlay();
  }

  @override
  Widget get children => GestureDetector(
    onTap: () {
      AppRouteNavigator.push(
        context,
        UserOmrahInspectorPage.routeName(widget.omrahData.orderId),
        UserOmrahInspectorPage(
          orderId: widget.omrahData.orderId,
          beneficiaryName: widget.omrahData.forWhom.beneficiaryName,
        ),
      );
    },
    child: SizedBox(
      width: width,
      child: UmrahStepperWidget(
        currentStep: widget.omrahData.currentStep,
        forWhom: widget.omrahData.forWhom,
      ),
    ),
  );
}
