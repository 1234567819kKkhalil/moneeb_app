part of localization;

class AppLanguageCubit extends BaseCubit<AppLanguageState> {
  late final SharedPreferencesHelper _shardPreferencesHelper;
  late final LocalizationContainer localizationContainer;
  late final LanguageRepo _languageRepo;

  AppLanguageCubit() : super(const AppLanguageState.initial()) {
    _shardPreferencesHelper = injector();
    localizationContainer = injector();
    _languageRepo = injector();
  }

  static AppLanguageCubit of(BuildContext context) => BlocProvider.of(context);

  Future<void> changeLanguage(AppLangCodeEnum langCode) async {
    _shardPreferencesHelper.setLanguage(langCode);
    injector<LocalizationContainer>().setLanguage(
      langCode,
    ); //we put this before resetDependenciesScope, because it will not get reset cause it is in different scope

    try{
      _languageRepo.changeLanguage(langCode);
    } catch(e){}

    await resetDependenciesScope();
    emit(state.reduce(langCode: langCode));
  }

  Future<void> init() async {
    emit(state.reduce(langCode: localizationContainer.langCode));
  }

  static bool isArabic() {
    return injector<LocalizationContainer>().langCode.isArabic;
  }
}
