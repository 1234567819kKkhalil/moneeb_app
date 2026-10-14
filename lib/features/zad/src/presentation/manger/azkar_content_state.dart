part of zad;

class AzkarContentState extends Equatable {
  final StateBox<AzkarContentModel> azkarContent;

  const AzkarContentState({
    required this.azkarContent,
  });

  factory AzkarContentState.initial() => AzkarContentState(
        azkarContent: StateBox.success(AzkarContentModel.initial()),
      );

  AzkarContentState reduce({
    StateBox<AzkarContentModel>? azkarContent,
  }) {
    return AzkarContentState(
      azkarContent: azkarContent ?? this.azkarContent,
    );
  }

  @override
  List<Object?> get props => [azkarContent];
}
