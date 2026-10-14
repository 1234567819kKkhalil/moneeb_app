import 'package:flutter/material.dart';
import 'package:moneeb/features/home/src/domain/entities/omrah_stepper_entity.dart';
import 'package:moneeb/features/home/src/presentation/widgets/user_omrah_floating_steps/user_omrah_overlay_view.dart';

class UserOmrahOverlayManager {
  static OverlayEntry? entry;
  static OmrahStepperEntity? _stepper;
  static bool isHidden = false;

  static void showOverlay(BuildContext context, {
    required OmrahStepperEntity stepper,
  }) {
    if (entry != null || isHidden) {
      return;
    } else {
      removeOverlay();
    }

    _stepper = stepper;

    entry = OverlayEntry(
      builder: (context) => UserOmrahOverlayView(omrahData: stepper),
    );

    Overlay.of(context, rootOverlay: true).insert(entry!);
  }

  static void changeStep(BuildContext context, {
    required OmrahStepperEntity stepper,
  }) {
    if (_stepper == null) return;

    if (_stepper?.currentStep != stepper.currentStep ||
        _stepper?.orderId != stepper.orderId) {
      _stepper = stepper;

      if (entry != null) {
        removeOverlay();
        showOverlay(context, stepper: stepper);
      }
    }
  }

  static void hide() {
    isHidden = true;
    entry?.remove();
    entry = null;
  }

  static void unHide(BuildContext context) {
    isHidden = false;

    if (_stepper == null) return;

    entry = OverlayEntry(
      builder: (context) => UserOmrahOverlayView(omrahData: _stepper!),
    );

    Overlay.of(context, rootOverlay: true).insert(entry!);
  }

  static void removeOverlay() {
    entry?.remove();
    entry = null;

    _stepper = null;
  }
}
