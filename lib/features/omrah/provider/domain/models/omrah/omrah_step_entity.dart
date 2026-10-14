import 'package:equatable/equatable.dart';
import 'package:moneeb/core/utils/utils_imports.dart';
import 'package:moneeb/features/omrah/provider/domain/models/enums/omrah_steps_enum.dart';

enum OmrahStepStatusEnum {
  pending,
  proofUploaded,

  /// The admin rejected the uploaded proof, so the step has to be proofed again.
  failed;

  /// The step still waits for a (new) proof from the provider.
  bool get needsProof =>
      this == OmrahStepStatusEnum.pending || this == OmrahStepStatusEnum.failed;

  factory OmrahStepStatusEnum.fromApi(String? val) {
    //todo: add other status
    switch (val) {
      case "PENDING":
        return OmrahStepStatusEnum.pending;
      case "PROOF_UPLOADED":
        return OmrahStepStatusEnum.proofUploaded;
      case "VALIDATED":
        return OmrahStepStatusEnum.proofUploaded;
      case "FAILED":
        return OmrahStepStatusEnum.failed;
      default:
        return OmrahStepStatusEnum.pending;
    }
  }
}

class OmrahStepEntity extends Equatable {
  final OmrahStepsEnum stepType;
  final OmrahStepStatusEnum status;
  final String? proofVideoUrl;
  final String? proofImageUrl;
  final bool isMapLocationProofed;

  /// Why the admin rejected the proof, only meaningful while [status] is failed.
  final String? rejectionReason;

  const OmrahStepEntity({
    required this.stepType,
    required this.status,
    this.proofVideoUrl,
    this.proofImageUrl,
    this.isMapLocationProofed = false,
    this.rejectionReason,
  });

  bool get isRejected => status == OmrahStepStatusEnum.failed;

  /// A proof only counts as submitted while the admin has not rejected it.
  bool get hasAcceptedVideoProof => proofVideoUrl != null && !isRejected;

  factory OmrahStepEntity.fromJson(Map<String, dynamic> json) {
    return OmrahStepEntity(
      stepType: OmrahStepsEnum.fromApi(json['stepName']),
      status: OmrahStepStatusEnum.fromApi(json['status']),
      proofVideoUrl: ((json["proofVideoUrl"]) as String?)?.addBaseUrl,
      proofImageUrl: ((json["proofImageUrl"]) as String?)?.addBaseUrl,
      rejectionReason: json["rejectionReason"] as String?,
    );
  }

  OmrahStepEntity copyWith({
    OmrahStepsEnum? stepType,
    OmrahStepStatusEnum? status,
    String? proofVideoUrl,
    String? proofImageUrl,
    bool? isMapLocationProofed,
    String? rejectionReason,
    bool clearRejectionReason = false,
  }) {
    return OmrahStepEntity(
      stepType: stepType ?? this.stepType,
      status: status ?? this.status,
      proofVideoUrl: proofVideoUrl ?? this.proofVideoUrl,
      proofImageUrl: proofImageUrl ?? this.proofImageUrl,
      isMapLocationProofed: isMapLocationProofed ?? this.isMapLocationProofed,
      rejectionReason: clearRejectionReason
          ? null
          : rejectionReason ?? this.rejectionReason,
    );
  }

  @override
  List<Object?> get props => [
    stepType,
    status,
    proofVideoUrl,
    proofImageUrl,
    isMapLocationProofed,
    rejectionReason,
  ];
}

extension OmrahStepsEnumExt on List<OmrahStepEntity> {
  /// The earliest step, in ritual order, that still needs a proof. A rejected
  /// step pulls the flow back to it even when later steps were already proofed.
  OmrahStepsEnum getCurrentStep() {
    final ordered = [...this]
      ..sort((a, b) => OmrahStepsEnum.ritualOrder
          .indexOf(a.stepType)
          .compareTo(OmrahStepsEnum.ritualOrder.indexOf(b.stepType)));

    return ordered.firstWhereOrNull((e) => e.status.needsProof)?.stepType ??
        OmrahStepsEnum.finished;
  }

  Set<OmrahStepsEnum> get rejectedSteps =>
      where((e) => e.isRejected).map((e) => e.stepType).toSet();
}
