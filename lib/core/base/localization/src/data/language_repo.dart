part of localization;

@lazySingleton
class LanguageRepo {
  final DioHelper _dioHelper;
  LanguageRepo(this._dioHelper);

  void changeLanguage(AppLangCodeEnum lang) async {
    await _dioHelper.patch('users/me/language', data: {
      "languageCode" : lang.name
    });
  }

}