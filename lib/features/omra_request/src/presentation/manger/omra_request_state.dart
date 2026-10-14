part of omra_request;

class OmraRequestState extends Equatable {
  final bool isCheck;
  final String omraTypeSelected;
  final List<OmraSetting> omraTypes;
  final String dateStarted;
  final DateTime date;
  final String genderSelected;
  final List<OmraSetting> gender;
  final ProviderEntity? selectedPilgrim;
  final StateBox<void> submitStatus;
  final String beneficiaryName;
  final String customDua;
  final int resetKey;
  final StateBox<void> validationStatus;

  const OmraRequestState({
    required this.isCheck,
    required this.omraTypeSelected,
    required this.omraTypes,
    required this.dateStarted,
    required this.date,
    required this.genderSelected,
    required this.gender,
    this.selectedPilgrim,
    this.submitStatus = const StateBox.initial(),
    this.beneficiaryName = '',
    this.customDua = '',
    this.resetKey = 0,
    this.validationStatus = const StateBox.initial(),
  });

  OmraRequestState copyWith({
    bool? isCheck,
    String? omraTypeSelected,
    List<OmraSetting>? omraTypes,
    String? dateStarted,
    DateTime? date,
    String? genderSelected,
    List<OmraSetting>? gender,
    ProviderEntity? selectedPilgrim,
    bool clearSelectedPilgrim = false,
    StateBox<void>? submitStatus,
    String? beneficiaryName,
    String? customDua,
    int? resetKey,
    StateBox<void>? validationStatus,
  }) {
    return OmraRequestState(
      isCheck: isCheck ?? this.isCheck,
      omraTypeSelected: omraTypeSelected ?? this.omraTypeSelected,
      omraTypes: omraTypes ?? this.omraTypes,
      dateStarted: dateStarted ?? this.dateStarted,
      date: date ?? this.date,
      genderSelected: genderSelected ?? this.genderSelected,
      gender: gender ?? this.gender,
      selectedPilgrim: clearSelectedPilgrim
          ? null
          : (selectedPilgrim ?? this.selectedPilgrim),
      submitStatus: submitStatus ?? this.submitStatus,
      beneficiaryName: beneficiaryName ?? this.beneficiaryName,
      customDua: customDua ?? this.customDua,
      resetKey: resetKey ?? this.resetKey,
      validationStatus: validationStatus ?? this.validationStatus,
    );
  }

  @override
  List<Object?> get props => [
    isCheck,
    omraTypeSelected,
    omraTypes,
    dateStarted,
    date,
    genderSelected,
    gender,
    selectedPilgrim,
    submitStatus,
    beneficiaryName,
    customDua,
    resetKey,
    validationStatus,
  ];
}
