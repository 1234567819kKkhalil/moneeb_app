part of auth;

class IsolatedTokenManager {
  final _refreshTokenClient = Dio(
    BaseOptions(
      baseUrl: Constants.endpoint,
    ),
  );

  Future<TokenEntity?> get token async {
    TokenEntity? token = await _readTokenFromDeviceStorage();

    if (token == null) {
      return null;
    }

    if (token.isAccessTokenExpired) {
      token = await refreshToken();
      setTokenToLocalStorage(token);
    }

    log("""
      token: ${token.accessToken}
      tokenExpiresAt: ${token.accessTokenExpirationDate}
      refreshToken: ${token.refreshToken}
    """);

    return token;
  }

  Future<TokenEntity> refreshToken() async {
    TokenEntity? token;

    try {
      final response = await _refreshTokenClient.post(
        'auth/refresh',
        data: {'refreshToken': (await _readTokenFromDeviceStorage())?.refreshToken},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        logDebug(response.toString());

        throw ApiRequestFailure(response.statusCode ?? 0, '');
      }

      return TokenEntity.fromJson(response.data?["data"]);
    } catch (e) {
      if (e is Failure) {
        rethrow;
      } else {
        throw UnExpectedFailure("Error refreshing the token");
      }
    }
  }

  // Local Storage
  void setTokenToLocalStorage(TokenEntity token) async {
    (await SharedPreferences.getInstance()).setString("token", token.toLocalStorage().encrypt);
  }

  Future<TokenEntity?> _readTokenFromDeviceStorage() async {
    SharedPreferences.resetStatic();
    final tokenData = (await SharedPreferences.getInstance()).getString("token");
    if (tokenData == null || tokenData.isEmpty) {
      return null;
    }

    final token = TokenEntity.fromLocalStorage(json.decode(tokenData.decrypt));
    return token;
  }
}
