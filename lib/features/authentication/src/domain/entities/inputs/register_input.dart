part of auth;

class RegisterInput {
  final UserRoleEnum role;
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber;
  final String countryCode;
  final String languageCode;
  final bool? isHafiz;

  RegisterInput({
    required this.role,
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.countryCode,
    required this.languageCode,
    required this.isHafiz,
  });

  Map<String, dynamic> toJson() => {
    "role": role.toApi(),
    "fullName": fullName,
    "email": email,
    "password": password,
    "phone": phoneNumber,
    "countryCode": countryCode,
    "languageCode": languageCode,

    if(isHafiz != null)
    "isHafiz" : isHafiz
  };
}
