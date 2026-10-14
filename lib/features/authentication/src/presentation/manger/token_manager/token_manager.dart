part of auth;

@singleton
class TokenManager {
  final SharedPreferences _sharedPreferences;
  TokenManager(this._sharedPreferences);

  final _refreshTokenClient = Dio(
    BaseOptions(
      baseUrl: Constants.endpoint,
    ),
  );

  Completer<TokenEntity>? _refreshTokenCompleter;

  Future<TokenEntity?> get token async {
    TokenEntity? token = getTokenFromStorage();

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
    //عشان لو فيه كذا ريكويست اتعملوا في نفس الوقت يستنوا لما اول refresh يحصل عشان ميفيلوش
    try {
      final refreshedToken = await _refreshTokenCompleter?.future;

      if (refreshedToken != null) {
        return refreshedToken;
      } else {
        _refreshTokenCompleter = Completer();
      }
    } catch (e) {
      rethrow;
    }

    TokenEntity? token = await collect(
      // disableUnAuthorizedDialogs: true,
      disableUnAuthorizedDialogs: true,
      task: () async {
        try {
          final response = await _refreshTokenClient.post(
            'auth/refresh',
            //re-read the token from device storage, to sync with background service
            data: {'refreshToken': (await _readTokenFromDeviceStorage())?.refreshToken},
          );

          if (response.statusCode != 200 && response.statusCode != 201) {
            logDebug(response.toString());

            throw ApiRequestFailure(response.statusCode ?? 0, '');
          }

          final newToken = TokenEntity.fromJson(response.data?["data"]);

          if(!(_refreshTokenCompleter?.isCompleted ?? false)){
            _refreshTokenCompleter?.complete(newToken);
          }

          _refreshTokenCompleter = null;

          return newToken;
        } on DioException catch (e) {
          throw ApiRequestFailure(
            e.response?.statusCode ?? 0,
            e.response?.data?['error'] ?? 'Invalid or expired refresh token',
          );
        }
      },
      onError: (Failure failure) {
        _refreshTokenCompleter?.completeError(failure);
        _refreshTokenCompleter = null;

        throw failure;
      },
    );

    return token!;
  }

  // Local Storage
  void setTokenToLocalStorage(TokenEntity token) async {
    _sharedPreferences.setString("token", token.toLocalStorage().encrypt);
  }

  TokenEntity? getTokenFromStorage() {
    final tokenData = _sharedPreferences.getString("token");
    if (tokenData == null || tokenData.isEmpty) {
      return null;
    }

    final token = TokenEntity.fromLocalStorage(json.decode(tokenData.decrypt));
    return token;
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

  void deleteTokenFromLocalStorage() {
    _sharedPreferences.remove("token");
  }

  @disposeMethod
  FutureOr<void> dispose() {
    //
  }
}
