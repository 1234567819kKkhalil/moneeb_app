part of auth;

@injectable
class IsAuthenticatedUseCase {
  final TokenManager _tokenManager;
  IsAuthenticatedUseCase(this._tokenManager);

  bool execute() {
    final TokenEntity? token = _tokenManager.getTokenFromStorage();

    if (token == null) return false;

    if (token.accessToken.isNotEmpty) {
      return true;
    } else {
      // _preferencesHelper.deleteToken();
      return false;
    }
  }
}