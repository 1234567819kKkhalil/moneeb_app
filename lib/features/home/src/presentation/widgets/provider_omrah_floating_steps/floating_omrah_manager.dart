import 'package:flutter/material.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/features/home/home_imports.dart';
import 'package:moneeb/features/home/src/domain/entities/omrah_stepper_entity.dart';
import 'package:moneeb/features/home/src/presentation/widgets/provider_omrah_floating_steps/provider_omrah_overlay_view.dart';
import 'package:moneeb/features/omrah/provider/domain/models/enums/omrah_steps_enum.dart';

class FloatingOmrahOverlayManager{
  static OverlayEntry? entry;
  static OmrahStepperEntity? _stepper;
  static bool isHidden = false;

  static void showOverlay(BuildContext context, {
    required OmrahStepperEntity stepper,
  }){
    if(entry != null || isHidden){
      return;
    } else {
      removeOverlay();
    }

    // The rituals cannot begin before the day the requester picked, so there
    // is nothing ongoing to point the provider at yet.
    if(!OmrahSchedule.hasStarted(stepper.targetDate)){
      return;
    }

    _stepper = stepper;

    entry = OverlayEntry(builder: (context) => ProviderOmrahOverlayView(
       omrahData: stepper
      ),
    );

    Overlay.of(context,rootOverlay: true).insert(entry!, );
  }

  static void changeStep(BuildContext context, {
    required OmrahStepperEntity stepper,
  }){
    if(_stepper == null) return;

    if(_stepper?.currentStep != stepper.currentStep){
      _stepper = stepper;

      if(entry != null){
        removeOverlay();
        showOverlay(context, stepper: stepper);
      }
    }
  }

  static void hide(){
    isHidden = true;
    entry?.remove();
    entry = null;
  }

  static void unHide(BuildContext context){
    isHidden = false;

    if(_stepper == null ) return;

    entry = OverlayEntry(builder: (context) => ProviderOmrahOverlayView(
      omrahData: _stepper!,
    ),
    );

    Overlay.of(context,rootOverlay: true).insert(entry!, );
  }

  static void removeOverlay(){
    entry?.remove();
    entry = null;

    _stepper = null;
  }
}