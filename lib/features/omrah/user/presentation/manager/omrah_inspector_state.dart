part of 'omrah_inspector_cubit.dart';

class OmrahInspectorState extends Equatable {
  final StateBox<List<OmrahStepEntity>> omrahStepsData;
  final StateBox<OmrahStepsEnum> currentStep;

  const OmrahInspectorState({
    required this.omrahStepsData,
    required this.currentStep,
  });

  OmrahStepEntity getOmrahStepData(OmrahStepsEnum type){
    return omrahStepsData.data?.firstWhereOrNull((e) => e.stepType == type) ?? OmrahStepEntity(stepType: type, status: OmrahStepStatusEnum.pending);
  }

  const OmrahInspectorState.initial() : this(
    omrahStepsData : const StateBox.initial(),
    currentStep : const StateBox.initial(),
  );

  OmrahInspectorState copyWith({
    StateBox<List<OmrahStepEntity>>? omrahStepsData,
    StateBox<OmrahStepsEnum>? currentStep,
  }){
    return OmrahInspectorState(
      omrahStepsData: omrahStepsData ?? this.omrahStepsData,
      currentStep: currentStep ?? this.currentStep,
    );
  }

  @override
  List<Object> get props => [omrahStepsData, currentStep];
}
