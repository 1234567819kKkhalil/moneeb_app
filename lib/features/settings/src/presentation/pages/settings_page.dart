part of settings;

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<SettingsCubit>()..init(),
      child: Scaffold(
        backgroundColor: context.appColors.appBackgroundColor,
        appBar: AppBars.defaultBar(
          context,
          text: appLocalizer.settingsNav,
          centerTitle: true,
          showDivider: false,
        ),
        body: BlocBuilder<AuthenticationBloc, AuthState>(
          builder: (context, authState) {
            return BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                final cubit = context.read<SettingsCubit>();
                final isArabic =
                    context.read<AppLanguageCubit>().state.langCode ==
                    AppLangCodeEnum.ar;
                return ListView(
                  padding: EdgeInsets.only(
                    right: 20,
                    left: 20,
                    top: 24,
                    bottom: Dimensions.bottomNavBarSafePadding(context),
                  ),
                  children: [
                    const _SettingsUserCard(),
                    const SizedBox(height: 32),

                    ...cubit
                        .getListSettings(
                          authState.userData.data?.role ?? UserRoleEnum.guest,
                          authState: authState,
                        )
                        .map(
                          (setting) => _SettingsListItem(
                            setting: setting,
                            onTap: () =>
                                _handleAction(context, setting.name, authState),
                            authState: authState,
                          ),
                        ),
                    _SettingsListItem(
                      setting: SettingItem(
                        icon: AssetPaths.iconLogout,
                        title: (l) => l.logout_settings,
                        name: 'logout',

                        // iconColor: context.appColors.neutral.shade900,
                        trailingColor: context.appColors.danger.shade500,
                      ),
                      onTap: () => _handleAction(context, 'logout', authState),
                      authState: authState,
                    ),

                    const SizedBox(height: 24),
                    Text(
                      appLocalizer.trusted_platform_badge,
                      style: context.semiBold.copyWith(
                        color: context.appColors.neutral.shade900,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    // SizedBox(height: 20),
                    Text(
                      appLocalizer.follow_us,
                      style: context.semiBold.copyWith(
                        // fontWeight: FontWeight.bold,
                        color: context.appColors.neutral.shade900,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),

                    Center(
                      child: Text(
                        appLocalizer.social_media_description,
                        style: context.medium.copyWith(
                          color: context.appColors.neutral.shade500,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 20),
                    const _SocialMediaRow(),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        '${appLocalizer.app_version} ${state.appVersion}',
                        style: context.theme.textTheme.bodySmall?.copyWith(
                          color: context.appColors.neutral.shade400,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _handleAction(BuildContext context, String action, AuthState authState) {
    switch (action) {
      case 'language':
        AppBottomSheets.showAppBottomSheet(
          context,
          backgroundColor: context.appColors.neutral.shade900,
          svgIconColor: context.appColors.neutral.shade50,
          useCloseButton: true,
          builder: (bottomSheetContext) {
            return BlocProvider.value(
              value: context.read<SettingsCubit>(),
              child: const _LanguageBottomSheet(),
            );
          },
        );
        break;
      case 'rate':
        if (authState.routingState.route == AuthRouteEnum.authenticated) {
          AppRouteNavigator.push(
            context,
            MyReviewsPage.routeName,
            const MyReviewsPage(),
          );
        } else {
          AppAlerts.showGuestDialog(context);
        }
        break;
      case 'tazkiah':
        if (authState.routingState.route == AuthRouteEnum.authenticated) {
          AppRouteNavigator.push(
            context,
            MyTazkiyahsPage.routeName,
            const MyTazkiyahsPage(),
          );
        } else {
          AppAlerts.showGuestDialog(context);
        }
        break;
      case 'user_orders':
        if (authState.routingState.route == AuthRouteEnum.authenticated) {
          NavObserver.instance.changeTab(MainHostPageTabsEnum.orders);
        } else {
          AppAlerts.showGuestDialog(context);
        }
        break;
      case 'logout':
        if (authState.routingState.route == AuthRouteEnum.authenticated) {
          AppAlerts.showCustomDialog(
            context,
            widget: _LogoutDialog(
              onConfirm: () {
                context.read<AuthenticationBloc>().add(LoggedOutEvent());
              },
            ),
          );
        } else {
          context.read<AuthenticationBloc>().add(LoggedOutEvent());
        }
        break;
      case 'delete_account':
        if (authState.routingState.route == AuthRouteEnum.authenticated) {
          AppAlerts.showCustomDialog(
            context,
            widget: BlocProvider.value(
              value: context.read<SettingsCubit>(),
              child: const _DeleteAccountDialog(),
            ),
          );
        } else {
          AppAlerts.showGuestDialog(context);
        }
        break;
      case 'verify':
      case 'policy':
      case 'terms':
      case 'about':
        AppBottomSheets.showAppBottomSheet(
          context,
          backgroundColor: context.appColors.primary.shade300,
          useCloseButton: false, // Custom close button in the bottom sheet
          builder: (bottomSheetContext) {
            return BlocProvider.value(
              value: context.read<SettingsCubit>(),
              child: AppSettingsBottomSheet(
                slug: action == 'policy'
                    ? 'privacy'
                    : action == 'verify'
                    ? 'verified'
                    : action,
                title: _getSettingsTitle(context, action),
              ),
            );
          },
        );
        break;
      default:
        break;
    }
  }

  String _getSettingsTitle(BuildContext context, String action) {
    switch (action) {
      case 'verify':
        return appLocalizer.verify_moneeb_settings;
      case 'policy':
        return appLocalizer.policy_settings;
      case 'terms':
        return appLocalizer.terms_settings;
      case 'about':
        return appLocalizer.about_settings;
      default:
        return '';
    }
  }
}
