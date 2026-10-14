part of auth;

class ApiRegisterResult {
  final ApiTokenModel tokenModel;
  final ApiAppUserModel? registerUser;

  ApiRegisterResult({
    required this.tokenModel,
    required this.registerUser,
  });

  factory ApiRegisterResult.fromJson(Map<String, dynamic> json) => ApiRegisterResult(
    tokenModel: ApiTokenModel.fromJson(json),
    registerUser: json["user"] == null
        ? null
        : ApiAppUserModel.fromJson(
            tokenMap: json,
            userMap: json["user"],
            providerMap: json["provider"],
            certificatesList: json["certificates"],
        ),
  );
}