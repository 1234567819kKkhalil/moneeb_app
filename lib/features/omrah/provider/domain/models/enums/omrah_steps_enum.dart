import 'package:moneeb/core/base/localization/localization.dart';
import 'package:moneeb/core/utils/utils_imports.dart';

// DO NOT change their user_orders, if you did it will be changed in omrah page too
enum OmrahStepsEnum {
  finished,
  tahalol,
  safa_and_marwa,
  // TODO(User): makam step is disabled for now, uncomment when needed.
  // makam,
  tawaf,
  mekat;

  String getLocalizedName() {
    switch (this) {
      case OmrahStepsEnum.mekat:
        return appLocalizer.miqat;
      case OmrahStepsEnum.tawaf:
        return appLocalizer.tawaf;
      // case OmrahStepsEnum.makam:
      //   return appLocalizer.prayerBehindMakam;
      case OmrahStepsEnum.safa_and_marwa:
        return appLocalizer.saiMinimized;
      case OmrahStepsEnum.tahalol:
        return appLocalizer.tahalol;
      case OmrahStepsEnum.finished:
        return appLocalizer.finishedUmrah;
    }
  }

  String getMinimizedLocalizedName() {
    switch (this) {
      case OmrahStepsEnum.mekat:
        return appLocalizer.miqat;
      case OmrahStepsEnum.tawaf:
        return appLocalizer.tawaf;
      // case OmrahStepsEnum.makam:
      //   return appLocalizer.makamIbrahim;
      case OmrahStepsEnum.safa_and_marwa:
        return appLocalizer.saiMinimized;
      case OmrahStepsEnum.tahalol:
        return appLocalizer.tahalol;
      case OmrahStepsEnum.finished:
        return appLocalizer.finishedUmrah;
    }
  }

  String videoVerificationText() {
    switch (this) {
      case OmrahStepsEnum.mekat:
        return appLocalizer.meeqatVideoDocumentation;
      case OmrahStepsEnum.tawaf:
        return appLocalizer.tawafVideoDocumentation;
      // case OmrahStepsEnum.makam:
      //   return appLocalizer.ibrahimMakamPrayerVideo;
      case OmrahStepsEnum.safa_and_marwa:
        return appLocalizer.saiVideoDocumentation;
      case OmrahStepsEnum.tahalol:
        return appLocalizer.tahalulVideoDocumentation;
      case OmrahStepsEnum.finished:
        return '';
    }
  }

  /// Wording of the "say this while you record" line, worded per step.
  String voiceDocumentationHint() {
    switch (this) {
      case OmrahStepsEnum.mekat:
        return appLocalizer.voiceDocumentationHintMiqat;
      case OmrahStepsEnum.tawaf:
        return appLocalizer.voiceDocumentationHintTawaf;
      // case OmrahStepsEnum.makam:
      //   return appLocalizer.voiceDocumentationHintMakam;
      case OmrahStepsEnum.safa_and_marwa:
        return appLocalizer.voiceDocumentationHintSai;
      case OmrahStepsEnum.tahalol:
        return appLocalizer.voiceDocumentationHintTahalol;
      case OmrahStepsEnum.finished:
        return '';
    }
  }

  /// Short line telling the provider when to say the voice phrase, shown
  /// right above [voiceDocumentationPhrase] on the video recording screen.
  String voiceDocumentationAction() {
    switch (this) {
      case OmrahStepsEnum.mekat:
        return appLocalizer.voiceDocumentationActionMiqat;
      case OmrahStepsEnum.tawaf:
        return appLocalizer.voiceDocumentationActionTawaf;
      // case OmrahStepsEnum.makam:
      //   return appLocalizer.voiceDocumentationActionMakam;
      case OmrahStepsEnum.safa_and_marwa:
        return appLocalizer.voiceDocumentationActionSai;
      case OmrahStepsEnum.tahalol:
        return appLocalizer.voiceDocumentationActionTahalol;
      case OmrahStepsEnum.finished:
        return '';
    }
  }

  /// The exact phrase the provider has to say out loud before recording the
  /// proof video of this step, with the beneficiary name filled in.
  String voiceDocumentationPhrase(String beneficiaryName) {
    switch (this) {
      case OmrahStepsEnum.mekat:
        return appLocalizer.voiceDocumentationPhraseMiqat(beneficiaryName);
      case OmrahStepsEnum.tawaf:
        return appLocalizer.voiceDocumentationPhraseTawaf(beneficiaryName);
      // case OmrahStepsEnum.makam:
      //   return appLocalizer.voiceDocumentationPhraseMakam(beneficiaryName);
      case OmrahStepsEnum.safa_and_marwa:
        return appLocalizer.voiceDocumentationPhraseSai(beneficiaryName);
      case OmrahStepsEnum.tahalol:
        return appLocalizer.voiceDocumentationPhraseTahalol(beneficiaryName);
      case OmrahStepsEnum.finished:
        return '';
    }
  }

  /// Extra reminder shown under the phrase, when the step has one.
  String? voiceDocumentationNote() {
    switch (this) {
      case OmrahStepsEnum.tawaf:
        return appLocalizer.voiceDocumentationNoteTawaf;
      case OmrahStepsEnum.mekat:
      // case OmrahStepsEnum.makam:
      case OmrahStepsEnum.safa_and_marwa:
      case OmrahStepsEnum.tahalol:
      case OmrahStepsEnum.finished:
        return null;
    }
  }

  String getSvgIcon() {
    switch (this) {
      case OmrahStepsEnum.mekat:
        return SvgPaths.man_with_ehram_clothe;
      case OmrahStepsEnum.tawaf:
        return SvgPaths.kaaba;
      // case OmrahStepsEnum.makam:
      //   return SvgPaths.makam;
      case OmrahStepsEnum.safa_and_marwa:
        return SvgPaths.sai;
      case OmrahStepsEnum.tahalol:
        return SvgPaths.scissors;
      case OmrahStepsEnum.finished:
        return SvgPaths.muslim_man;
    }
  }

  String toApi() {
    switch (this) {
      case OmrahStepsEnum.mekat:
        return "MIQAT";
      case OmrahStepsEnum.tawaf:
        return "TAWAF";
      // case OmrahStepsEnum.makam:
      //   return "MAQAM_IBRAHIM";
      case OmrahStepsEnum.safa_and_marwa:
        return "SAI";
      case OmrahStepsEnum.tahalol:
        return "TAHALLUL";
      case OmrahStepsEnum.finished:
        return "FINISHED";
    }
  }

  factory OmrahStepsEnum.fromApi(String? val) {
    switch (val) {
      case "MIQAT":
        return OmrahStepsEnum.mekat;
      case "TAWAF":
        return OmrahStepsEnum.tawaf;
      // case "MAQAM_IBRAHIM":
      //   return OmrahStepsEnum.makam;
      case "SAI":
        return OmrahStepsEnum.safa_and_marwa;
      case "TAHALLUL":
        return OmrahStepsEnum.tahalol;

      default:
        return OmrahStepsEnum.finished;
    }
  }

  /// The ritual steps in the order they are performed. Phase numbering is
  /// derived from it, so disabling a step renumbers the ones after it.
  static const List<OmrahStepsEnum> ritualOrder = [
    OmrahStepsEnum.mekat,
    OmrahStepsEnum.tawaf,
    // TODO(User): makam step is disabled for now, uncomment when needed.
    // OmrahStepsEnum.makam,
    OmrahStepsEnum.safa_and_marwa,
    OmrahStepsEnum.tahalol,
  ];

  /// Localized "Phase N" title matching this step's position in [ritualOrder].
  String getPhaseTitle() {
    switch (ritualOrder.indexOf(this) + 1) {
      case 1:
        return appLocalizer.phaseOne;
      case 2:
        return appLocalizer.phaseTwo;
      case 3:
        return appLocalizer.phaseThree;
      case 4:
        return appLocalizer.phaseFour;
      case 5:
        return appLocalizer.phaseFive;
      default:
        return '';
    }
  }
}
