part of settings;

@injectable
class SettingsCubit extends BaseCubit<SettingsState> {
  final GetAppSettingsUseCase _getAppSettingsUseCase;
  final RequestAccountDeletionUseCase _requestAccountDeletionUseCase;
  final GetSocialLinksUseCase _getSocialLinksUseCase;

  SettingsCubit(
    this._getAppSettingsUseCase,
    this._requestAccountDeletionUseCase,
    this._getSocialLinksUseCase,
  ) : super(const SettingsState());

  List<SettingItem> getListSettings(UserRoleEnum role, {AuthState? authState}) {
    print(authState?.userData?.data?.role);
    final settings = [
      SettingItem(
        title: (l) => l.language_settings,
        name: 'language',
        icon: AssetPaths.iconLanguage,
      ),
      /*    SettingItem(
        title: (l) => l.change_password_settings,
        name: 'change_password',
        icon: AssetPaths.iconChangePassword,
      ), */
      // if (authState?.routingState.route == AuthRouteEnum.authenticated) ...[
      /*  SettingItem(
        title: (l) => l.orders_settings,
        name: 'user_orders',
        icon: AssetPaths.iconOrdersSettings,
      ), */
      // ],
      if (authState?.userData.data?.role == UserRoleEnum.user ||
          authState?.routingState.route == AuthRouteEnum.guest)
        SettingItem(
          title: (l) => l.my_rate_settings,
          name: 'rate',
          icon: AssetPaths.iconMyRate,
        ),
      // ],
      // if (authState?.routingState.route == AuthRouteEnum.authenticated) ...[
      if (authState?.userData.data?.role == UserRoleEnum.provider)
        SettingItem(
          title: (l) => l.tazkiyah_settings,
          name: 'tazkiah',
          icon: AssetPaths.iconDoaa,
        ),

      // ],
      SettingItem(
        title: (l) => l.policy_settings,
        name: 'policy',
        icon: AssetPaths.iconPrivacyPolicy,
      ),
      SettingItem(
        title: (l) => l.terms_settings,
        name: 'terms',
        icon: AssetPaths.iconTerms,
      ),
      SettingItem(
        title: (l) => l.about_settings,
        name: 'about',
        icon: AssetPaths.iconAbout,
      ),

      /*  SettingItem(
        title: (l) => l.verify_moneeb_settings,
        name: 'verify',
        icon: AssetPaths.iconVerifyMoneeb,
      ), */
      if (authState?.routingState.route == AuthRouteEnum.authenticated)
        SettingItem(
          title: (l) => l.delete_account_settings,
          name: 'delete_account',
          icon: AssetPaths.deleteAccount,
        ),
      /*  SettingItem(
        title: (l) => l.logout_settings,
        name: 'logout',
        icon: AssetPaths.iconArrowLogoutAr,
      ), */
    ];
    return settings;
  }

  List<AppSettingsLang> get listLanguage => [
    AppSettingsLang(title: 'العربية', data: 'ar'),
    AppSettingsLang(title: 'English', data: 'en'),
  ];

  Future<void> init() async {
    await getAppVersion();
    await loadSettingsFile();
    await fetchSocialLinks();
  }

  Future<void> fetchSocialLinks() async {
    emit(state.reduce(socialLinks: const StateBox.loading()));
    await collect(
      task: () async {
        final data = await _getSocialLinksUseCase();
        emit(state.reduce(socialLinks: StateBox.success(data)));
      },
      onError: (failure) {
        emit(state.reduce(socialLinks: StateBox.failure(failure)));
      },
    );
  }

  Future<void> getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      emit(state.reduce(appVersion: packageInfo.version));
    } catch (e) {
      debugPrint('Error getting app version: $e');
    }
  }

  Future<void> loadSettingsFile() async {
    try {
      // Use standard asset loading if AppConfig.loadAsset is not available or follow its implementation
      final content = await rootBundle.loadString('assets/settings.html');
      emit(state.reduce(settingsHtml: content));
    } catch (e) {
      debugPrint('Error loading settings file: $e');
    }
  }

  void toggleOldPasswordVisibility() {
    emit(state.reduce(isVisibleOldPass: !state.isVisibleOldPass));
  }

  void toggleNewPasswordVisibility() {
    emit(state.reduce(isVisibleNewPass: !state.isVisibleNewPass));
  }

  void toggleConfirmPasswordVisibility() {
    emit(state.reduce(isVisibleConfirmPass: !state.isVisibleConfirmPass));
  }

  void onLanguageSelected(String langCode) {
    emit(state.reduce(selectedLangCode: langCode));
  }

  Future<void> saveLanguage(BuildContext context, String langCode) async {
    // Use AppLanguageCubit to change language
    final appLangCode = AppLangCodeEnum.values.firstWhere(
      (e) => e.name == langCode,
      orElse: () => AppLangCodeEnum.ar,
    );
    await AppLanguageCubit.of(context).changeLanguage(appLangCode);
  }

  Future<void> fetchAppSettings(String slug) async {
    emit(state.reduce(appSettingsData: const StateBox.loading()));
    await collect(
      task: () async {
        final data = await _getAppSettingsUseCase(slug);
        emit(state.reduce(appSettingsData: StateBox.success(data)));
      },
      onError: (failure) {
        emit(state.reduce(appSettingsData: StateBox.failure(failure)));
      },
    );
  }

  Future<void> requestAccountDeletion() async {
    emit(state.reduce(deletionRequest: const StateBox.loading()));
    await collect(
      task: () async {
        await _requestAccountDeletionUseCase();
        emit(state.reduce(deletionRequest: const StateBox.success(null)));
      },
      onError: (failure) {
        emit(state.reduce(deletionRequest: StateBox.failure(failure)));
      },
    );
  }
}
