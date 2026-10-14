part of auth;

class LoginInput {
  final String email;
  final String password;
  final String? fcmToken;

  LoginInput({
    required this.email,
    required this.password,
    this.fcmToken,
  });

  LoginInput copyWith({
    String? email,
    String? password,
    String? fcmToken,
  }){
    return LoginInput(
      email: email ?? this.email,
      password: password ?? this.password,
      fcmToken: fcmToken ?? this.fcmToken,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "emailOrPhone": email,
      "password": password,
      //"fcmToken": fcmToken //todo: return this
    };
  }
}