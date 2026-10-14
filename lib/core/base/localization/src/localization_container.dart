part of localization;

AppLocalizations get appLocalizer =>
    injector<LocalizationContainer>().appLocalizations;

@Singleton(scope: 'persistent')
class LocalizationContainer {
  final SharedPreferencesHelper _shardPreferencesHelper;

  LocalizationContainer(this._shardPreferencesHelper);

  AppLangCodeEnum langCode = AppLangCodeEnum.ar;
  AppLocalizations appLocalizations = AppLocalizationsAr();

  @PostConstruct(preResolve: true)
  Future<Locale> init() async {
    Locale locale;

    try {
      langCode = _shardPreferencesHelper.getLanguage();
    } catch (e) {
      langCode = _getDeviceLangCode();
    }

    locale = Locale(langCode.name);
    _setHijriLocale(langCode);
    return locale;
  }

  Future<void> setLanguage(AppLangCodeEnum lang) async {
    _setHijriLocale(lang);
    langCode = lang;
  }

  void setLocalizer(BuildContext context) {
    appLocalizations = AppLocalizations.of(context);
  }

  AppLangCodeEnum _getDeviceLangCode() {
    final String? deviceLangCode = Platform.localeName.split("_").firstOrNull;
    return AppLangCodeEnum.fromName(deviceLangCode ?? 'ar');
  }

  void _setHijriLocale(AppLangCodeEnum langCode){
    try{
      HijriCalendar.setLocal(langCode.name);
    } catch(e){}
  }
}
