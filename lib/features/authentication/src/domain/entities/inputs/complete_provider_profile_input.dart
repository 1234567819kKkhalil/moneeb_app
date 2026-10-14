part of auth;

class CompleteProviderProfileInput extends Equatable{
  final String bio;
  final int umrahCount;
  final String nationalId;

  const CompleteProviderProfileInput({
    required this.bio,
    required this.umrahCount,
    required this.nationalId,
  });

  Map<String, dynamic> toJson() => {
    "bio": bio,
    "umrahCount": umrahCount,
    "identificationNumber": nationalId,
  };

  @override
  List<Object?> get props => [bio, umrahCount, nationalId];
}

