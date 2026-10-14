part of auth;

@LazySingleton(as: AuthRepository)
class AuthenticationRepositoryImpl implements AuthRepository {
  final DioHelper _dioHelper;
  AuthenticationRepositoryImpl(this._dioHelper);

  @override
  Future<TokenEntity> login(LoginInput input) async {
    final results = await _dioHelper.post(
      AuthEndpoint.login,
      data: input.toJson()
    );

    return ApiTokenModel.fromJson(
      results.data?["data"],
    ).toEntity();
  }

  @override
  Future<TokenEntity> register(RegisterInput input) async {
    final results = await _dioHelper.post(
      AuthEndpoint.register,
      data: input.toJson()
    );

    return ApiTokenModel.fromJson(
       results.data?["data"],
    ).toEntity();
  }

  @override
  Future<void> completeProviderProfile(CompleteProviderProfileInput input) async {
    await _dioHelper.patch(
      AuthEndpoint.provideCompleteProfile,
      data: input.toJson(),
    );
  }

  @override
  Future<void> setFcmToken(String fcm) async {
    await _dioHelper.post(
      AuthEndpoint.setFcmToken,
      data: {
        "fcmToken" : fcm
      }
    );
  }

  @override
  Future<AppUserModel> getUserData() async {
    final results = await _dioHelper.get(AuthEndpoint.getUserData);
    final userModel = ApiAppUserModel.fromJson(
        userMap: results.data?["data"]??{},
        tokenMap: null,
        providerMap: null,
        certificatesList: null
    ).mapToAppUser();

    if(userModel.role == UserRoleEnum.provider){
      final results = await _dioHelper.get(AuthEndpoint.getProviderData);
      final data = results.data?["data"]??{};

      return userModel.copyWith(
        providerData: ApiProviderData.fromJson(
          providerMap : data['provider'],
          certificatesList: data['certificates'],
        ).toEntity()
      );
    }

    return userModel;
  }

  @override
  Future<void> sendOTP() async {
    //todo:
    return;
  }

  @override
  Future<void> logout() async {
    //todo:
  }

  @override
  Future<void> updateFcmToken(String fcmToken) async {
    //todo:
  }

  @override
  Future<void> deleteAccount() async {
    //todo:
  }

  @override
  Future<String> forgotPassword(String emailOrPhone) async {
    final results = await _dioHelper.post(
      AuthEndpoint.forgotPassword,
      data: {"emailOrPhone": emailOrPhone},
    );
    return results.data?["data"]?["sessionToken"] ?? "";
  }

  @override
  Future<String> verifyForgotPassword(String sessionToken, String code) async {
    final results = await _dioHelper.post(
      AuthEndpoint.verifyForgotPassword,
      data: {
        "sessionToken": sessionToken,
        "code": code,
      },
    );
    return results.data?["data"]?["resetToken"] ?? "";
  }

  @override
  Future<void> resetPassword(String token, String password) async {
    await _dioHelper.post(
      AuthEndpoint.resetPassword,
      data: {
        "token": token,
        "password": password,
      },
    );
  }

  // Unified passwordless OTP auth (/auth/otp/*)

  Map<String, dynamic> _root(Response response) {
    final data = response.data;
    if (data is Map && data["data"] is Map) {
      return (data["data"] as Map).cast<String, dynamic>();
    }
    if (data is Map) return data.cast<String, dynamic>();
    return {};
  }

  @override
  Future<OtpConfig> getOtpConfig() async {
    final response = await _dioHelper.get(AuthEndpoint.otpConfig);
    return OtpConfig.fromJson(_root(response));
  }

  @override
  Future<OtpStartResult> otpStart(OtpStartInput input) async {
    final response = await _dioHelper.post(
      AuthEndpoint.otpStart,
      data: input.toJson(),
    );
    return OtpStartResult.fromJson(_root(response));
  }

  @override
  Future<OtpVerifyResult> otpVerify(OtpVerifyInput input) async {
    final response = await _dioHelper.post(
      AuthEndpoint.otpVerify,
      data: input.toJson(),
    );
    return OtpVerifyResult.fromJson(_root(response));
  }

  @override
  Future<TokenEntity> otpRegister(OtpRegisterInput input) async {
    final response = await _dioHelper.post(
      AuthEndpoint.otpRegister,
      data: input.toJson(),
    );
    final root = _root(response);
    final tokenMap = (root['tokens'] as Map?)?.cast<String, dynamic>() ?? root;
    return ApiTokenModel.fromJson(tokenMap).toEntity();
  }

  @override
  Future<OtpChannel?> otpResend(String otpToken) async {
    final response = await _dioHelper.post(
      AuthEndpoint.otpResend,
      data: {"otpToken": otpToken},
    );
    return OtpChannel.fromApi(_root(response)['channel']);
  }
}
