part of app_utils;

//todo: just use shared preferences
class AppThemeCubit extends HydratedCubit<ThemeMode> {
  AppThemeCubit()
    : super(ThemeMode.dark); //todo: return this => ThemeMode.system

  void updateTheme(ThemeMode newMode) {
    emit(newMode);
  }

  final String _jsonKey = 'themeMode';

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) {
    final savedMode = json[_jsonKey];
    if (savedMode == 'light') {
      return ThemeMode.light;
    } else if (savedMode == 'dark') {
      return ThemeMode.dark;
    }
    return ThemeMode.dark;
    // return ThemeMode.system; //todo: return this
  }

  @override
  Map<String, dynamic>? toJson(ThemeMode state) {
    if (state == ThemeMode.light) {
      return {_jsonKey: 'light'};
    } else if (state == ThemeMode.dark) {
      return {_jsonKey: 'dark'};
    } else {
      return {_jsonKey: 'dark'};
      // return {_jsonKey: 'system'}; //todo: return this
    }
  }
}
