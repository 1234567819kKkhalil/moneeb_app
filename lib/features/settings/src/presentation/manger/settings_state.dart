part of settings;

class SettingsState extends Equatable {
  final String appVersion;
  final String settingsHtml;
  final bool isVisibleOldPass;
  final bool isVisibleNewPass;
  final bool isVisibleConfirmPass;
  final String selectedLangCode;
  final StateBox<AppSettingsModel> appSettingsData;
  final StateBox<void> deletionRequest;
  final StateBox<SocialLinksModel> socialLinks;

  const SettingsState({
    this.appVersion = '',
    this.settingsHtml = '',
    this.isVisibleOldPass = true,
    this.isVisibleNewPass = true,
    this.isVisibleConfirmPass = true,
    this.selectedLangCode = '',
    this.appSettingsData = const StateBox.initial(),
    this.deletionRequest = const StateBox.initial(),
    this.socialLinks = const StateBox.initial(),
  });

  SettingsState reduce({
    String? appVersion,
    String? settingsHtml,
    bool? isVisibleOldPass,
    bool? isVisibleNewPass,
    bool? isVisibleConfirmPass,
    String? selectedLangCode,
    StateBox<AppSettingsModel>? appSettingsData,
    StateBox<void>? deletionRequest,
    StateBox<SocialLinksModel>? socialLinks,
  }) {
    return SettingsState(
      appVersion: appVersion ?? this.appVersion,
      settingsHtml: settingsHtml ?? this.settingsHtml,
      isVisibleOldPass: isVisibleOldPass ?? this.isVisibleOldPass,
      isVisibleNewPass: isVisibleNewPass ?? this.isVisibleNewPass,
      isVisibleConfirmPass: isVisibleConfirmPass ?? this.isVisibleConfirmPass,
      selectedLangCode: selectedLangCode ?? this.selectedLangCode,
      appSettingsData: appSettingsData ?? this.appSettingsData,
      deletionRequest: deletionRequest ?? this.deletionRequest,
      socialLinks: socialLinks ?? this.socialLinks,
    );
  }

  @override
  List<Object?> get props => [
        appVersion,
        settingsHtml,
        isVisibleOldPass,
        isVisibleNewPass,
        isVisibleConfirmPass,
        selectedLangCode,
        appSettingsData,
        deletionRequest,
        socialLinks,
      ];
}
