part of localization;

class AppLanguageState extends Equatable {
  final AppLangCodeEnum langCode;
  const AppLanguageState(this.langCode);

  const AppLanguageState.initial() : this(AppLangCodeEnum.ar);

  AppLanguageState reduce({
    AppLangCodeEnum? langCode,
  }) {
    return AppLanguageState(
      langCode ?? this.langCode,
    );
  }

  @override
  List<Object> get props => [langCode];
}
