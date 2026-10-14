part of 'provider_omrah_cubit.dart';

class ProviderOmrahState extends Equatable {
  final StateBox<List<OmrahStepEntity>> omrahStepsData;
  final StateBox<OmrahStepsEnum> currentStep;
  final StateBox<void> submitProof;
  final StateBox<bool> validateMapLocation;

  /// Name of the miqat the backend matched the provider's GPS position to.
  /// Empty until [ProviderOmrahCubit.validateMiqat] confirms the location.
  final String miqatName;

  const ProviderOmrahState({
    required this.omrahStepsData,
    required this.currentStep,
    required this.submitProof,
    required this.validateMapLocation,
    this.miqatName = '',
  });

  const ProviderOmrahState.initial() : this(
    omrahStepsData : const StateBox.initial(),
    currentStep : const StateBox.initial(),
    submitProof : const StateBox.initial(),
    validateMapLocation : const StateBox.initial(),
  );

  OmrahStepEntity getOmrahStepData(OmrahStepsEnum type){
    return omrahStepsData.data?.firstWhereOrNull((e) => e.stepType == type) ?? OmrahStepEntity(stepType: type, status: OmrahStepStatusEnum.pending);
  }

  /// Whether the provider has proven being at the miqat. Location tracking is
  /// only allowed from then on. Either this session's location check passed,
  /// or the miqat proof was already submitted earlier — which the flow only
  /// allows after that check.
  bool get isMiqatVerified {
    final mekat = getOmrahStepData(OmrahStepsEnum.mekat);
    return mekat.isMapLocationProofed ||
        (omrahStepsData.isSuccess && !mekat.status.needsProof);
  }

  ProviderOmrahState copyWith({
    StateBox<List<OmrahStepEntity>>? omrahStepsData,
    StateBox<OmrahStepsEnum>? currentStep,
    StateBox<void>? submitProof,
    StateBox<bool>? validateMapLocation,
    String? miqatName,
  }){
    return ProviderOmrahState(
      omrahStepsData: omrahStepsData ?? this.omrahStepsData,
      currentStep: currentStep ?? this.currentStep,
      submitProof: submitProof ?? this.submitProof,
      validateMapLocation: validateMapLocation ?? this.validateMapLocation,
      miqatName: miqatName ?? this.miqatName,
    );
  }

  @override
  List<Object> get props => [omrahStepsData,currentStep, submitProof, validateMapLocation, miqatName];
}

// class ProofState{
//   final bool isMekatVideoUploaded;
//   final bool isMekatMapVerified;
//
// }