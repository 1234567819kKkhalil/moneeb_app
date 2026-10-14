part of edit_provider_profile;

class UpdateProfileRequest {
  final String? fullName;
  final String? email;

  /// Dial code including the leading `+`, e.g. `+966`.
  final String? phoneCountryCode;

  /// National number without the dial code, e.g. `500000000`.
  final String? phoneNumber;
  final GenderEnum? gender;
  final String? country;

  UpdateProfileRequest({
    this.fullName,
    this.email,
    this.phoneCountryCode,
    this.phoneNumber,
    this.gender,
    this.country,
  });

  Map<String, dynamic> toJson() {
    return {
      if (fullName != null) "fullName": fullName,
      if (email != null) "email": email,
      if (phoneCountryCode != null) "phoneCountryCode": phoneCountryCode,
      if (phoneNumber != null) "phoneNumber": phoneNumber,
      if (gender != null) "gender": gender!.toApi(),
      if (country != null) "country": country,
    };
  }
}

class UpdateProviderDataRequest {
  final String? bio;
  final int? umrahCount;
  final String? identificationNumber;
  final bool? isHafiz;
  final bool? isOnline;

  UpdateProviderDataRequest({
    this.bio,
    this.umrahCount,
    this.identificationNumber,
    this.isHafiz,
    this.isOnline,
  });

  Map<String, dynamic> toJson() {
    return {
      if (bio != null) "bio": bio,
      if (umrahCount != null) "umrahCount": umrahCount,
      if (identificationNumber != null)
        "identificationNumber": identificationNumber,
      if (isHafiz != null) "isHafiz": isHafiz,
      if (isOnline != null) "isOnline": isOnline,
    };
  }
}
