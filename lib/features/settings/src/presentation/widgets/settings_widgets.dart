part of settings;

class _SettingsUserCard extends StatelessWidget {
  const _SettingsUserCard();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthState>(
      builder: (context, state) {
        final userModel = state.userData.data ?? AppUserModel.initial();
        return GestureDetector(
          onTap: () {
            _viewUserProfile(context, state);
            /* if (state.routingState.route == AuthRouteEnum.authenticated) {
              if (userModel.role == UserRoleEnum.provider) {
                AppRouteNavigator.push(
                  context,
                  MyProviderProfilePage.routeName,
                  const MyProviderProfilePage(),
                );
              } else {
                AppRouteNavigator.push(
                  context,
                  EditUserProfilePage.routeName,
                  const EditUserProfilePage(),
                );
              }
            } else {
              AppRouteNavigator.push(
                context,
                LoginPage.routeName,
                const LoginPage(),
              );
            } */
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.appColors.neutral.shade900,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                AppImage(
                  path: state.routingState.route == AuthRouteEnum.authenticated
                      ? userModel.avatarUrl
                      : AssetPaths.moneebLogo,
                  height: 48,
                  width: 48,
                  border: Border.all(
                    color: context.appColors.primary.shade400,
                    width: 1,
                  ),
                  errorPlaceHolder: () => Container(
                    decoration: BoxDecoration(
                      color: context.appColors.primary.shade500,
                    ),
                    padding: const EdgeInsets.all(4),

                    child: Image.asset(
                      AssetPaths.moneebLogo,
                      fit: BoxFit.contain,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                /* Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: context.appColors.primary.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 32,
                    color: context.appColors.primary.shade500,
                  ),
                ), */
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.routingState.route == AuthRouteEnum.authenticated
                            ? userModel.fullName
                            : appLocalizer.guest,
                        style: context.theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.appColors.neutral.shade100,
                        ),
                      ),
                      if (state.routingState.route ==
                          AuthRouteEnum.authenticated)
                        Text(
                          userModel.email,
                          style: context.theme.textTheme.bodySmall?.copyWith(
                            color: context.appColors.neutral.shade500,
                          ),
                        ),
                    ],
                  ),
                ),
                RotatedBox(
                  quarterTurns: AppLanguageCubit.isArabic() ? 0 : 2,
                  child: AppIconButton.fromSvg(
                    size: 24,
                    svgIconPath: AssetPaths.iconArrowBlack,
                    onPressed: () => _viewUserProfile(context, state),
                    color: context.appColors.primary.shade500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _viewUserProfile(BuildContext context, AuthState authState) {
    if (authState.routingState.route == AuthRouteEnum.authenticated) {
      if (authState.userData.data?.role == UserRoleEnum.provider) {
        AppRouteNavigator.push(
          context,
          MyProviderProfilePage.routeName,
          const MyProviderProfilePage(),
        );
      } else {
        AppRouteNavigator.push(
          context,
          EditUserProfilePage.routeName,
          const EditUserProfilePage(),
        );
      }
    } else {
      AppRouteNavigator.push(context, LoginPage.routeName, const LoginPage());
    }
  }
}

class _SettingsListItem extends StatelessWidget {
  final SettingItem setting;
  final VoidCallback onTap;
  final AuthState? authState;

  const _SettingsListItem({
    required this.setting,
    required this.onTap,
    this.authState,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic =
        context.read<AppLanguageCubit>().state.langCode == AppLangCodeEnum.ar;
    final isLogout = setting.name == 'logout';
    final isDelete = setting.name == 'delete_account';
    final isDangerous = isLogout || isDelete;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color:
            //  context.appColors.danger.shade50,
            context.appColors.neutral.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isLogout
                ? context.appColors.danger.shade100
                : context.appColors.primary.shade400,
            borderRadius: BorderRadius.circular(100),
          ),
          child: SvgPicture.asset(
            setting.icon,
            width: 24,
            height: 24,
            colorFilter: setting.iconColor != null
                ? ColorFilter.mode(setting.iconColor as Color, BlendMode.srcIn)
                : null,
          ),
        ),
        title: Text(
          isLogout
              ? (authState?.routingState.route == AuthRouteEnum.authenticated
                    ? appLocalizer.logOut
                    : appLocalizer.logIn)
              : setting.title(appLocalizer),
          style: context.semiBold.copyWith(
            color: isLogout
                ? context.appColors.danger.shade500
                : context.appColors.neutral.shade100,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        trailing: SvgPicture.asset(
          /* isDangerous
              ? (isArabic
                    ? AssetPaths.iconArrowLogoutAr
                    : AssetPaths.iconArrowLogoutEn)
              : */
          (isArabic
              ? AssetPaths.iconArrowSettingAr
              : AssetPaths.iconArrowSettingEn),
          colorFilter: setting.trailingColor != null
              ? ColorFilter.mode(
                  setting.trailingColor as Color,
                  BlendMode.srcIn,
                )
              : ColorFilter.mode(
                  isLogout
                      ? context.appColors.danger.shade500
                      : context.appColors.neutral.shade50,
                  BlendMode.srcIn,
                ),
          width: 20,
          height: 20,
        ),
      ),
    );
  }
}

class _LanguageBottomSheet extends StatelessWidget {
  const _LanguageBottomSheet();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Text(
              appLocalizer.select_language,
              style: context.theme.textTheme.titleLarge?.copyWith(
                color: context.appColors.neutral.shade50,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              appLocalizer.select_your_language,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: context.appColors.neutral.shade500,
              ),
            ),
            const SizedBox(height: 24),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cubit.listLanguage.length,
              itemBuilder: (context, index) {
                final language = cubit.listLanguage[index];
                final isSelected =
                    state.selectedLangCode == language.data ||
                    (state.selectedLangCode.isEmpty &&
                        context.read<AppLanguageCubit>().state.langCode.name ==
                            language.data);

                return GestureDetector(
                  onTap: () => cubit.onLanguageSelected(language.data),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: context.appColors.primary.shade900,
                      ),
                      color: isSelected
                          ? context.appColors.primary.shade400
                          : context.appColors.neutral.shade900,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Text(
                          language.title,
                          style: context.theme.textTheme.bodyLarge?.copyWith(
                            color: isSelected
                                ? context.appColors.primary.shade900
                                : context.appColors.primary.shade400,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        if (isSelected)
                          AppSvg(
                            svgPath: AssetPaths.iconCheck,
                            size: 24,
                            // color: context.appColors.primary.shade400,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            AppPrimaryButton(
              onPressed: () {
                if (state.selectedLangCode.isNotEmpty) {
                  cubit.saveLanguage(context, state.selectedLangCode);
                }
                Navigator.pop(context);
              },
              text: appLocalizer.save,
              isExpanded: true,
            ),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }
}

class _SocialLinkItem {
  final String icon;
  final String url;

  const _SocialLinkItem({required this.icon, required this.url});
}

class _SocialMediaRow extends StatelessWidget {
  const _SocialMediaRow();

  static const double _iconSize = 44;
  static const double _spacing = 16;

  static const _placeholderItems = [
    _SocialLinkItem(icon: AssetPaths.iconInstagram, url: ''),
    _SocialLinkItem(icon: AssetPaths.iconTiktok, url: ''),
    _SocialLinkItem(icon: AssetPaths.iconSnapchat, url: ''),
    _SocialLinkItem(icon: AssetPaths.iconFacebook, url: ''),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) =>
          previous.socialLinks != current.socialLinks,
      builder: (context, state) {
        final isLoading =
            state.socialLinks.isLoading || state.socialLinks.isInitial;
        final items = isLoading
            ? _placeholderItems
            : _buildItems(state.socialLinks.data);

        if (items.isEmpty) return const SizedBox.shrink();

        final contentWidth =
            items.length * _iconSize + (items.length - 1) * _spacing;

        return AppSkeletonizer(
          isEnabled: isLoading,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final children = <Widget>[
                for (var i = 0; i < items.length; i++) ...[
                  if (i > 0) const SizedBox(width: _spacing),
                  _socialIcon(
                    context,
                    items[i].icon,
                    () => isLoading
                        ? null
                        : LaunchUrlUtils.openUrl(context, url: items[i].url),
                  ),
                ],
              ];

              if (contentWidth <= constraints.maxWidth) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                );
              }

              return SizedBox(
                height: _iconSize,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: children,
                ),
              );
            },
          ),
        );
      },
    );
  }

  List<_SocialLinkItem> _buildItems(SocialLinksModel? links) {
    if (links == null) return [];
    return [
      if (links.facebook.isNotEmpty)
        _SocialLinkItem(icon: AssetPaths.iconFacebook, url: links.facebook),
      if (links.instagram.isNotEmpty)
        _SocialLinkItem(icon: AssetPaths.iconInstagram, url: links.instagram),
      if (links.x.isNotEmpty)
        _SocialLinkItem(icon: AssetPaths.iconX, url: links.x),
      if (links.tiktok.isNotEmpty)
        _SocialLinkItem(icon: AssetPaths.iconTiktok, url: links.tiktok),
      if (links.snapchat.isNotEmpty)
        _SocialLinkItem(icon: AssetPaths.iconSnapchat, url: links.snapchat),
      if (links.whatsapp.isNotEmpty)
        _SocialLinkItem(
          icon: AssetPaths.iconWhatsappInput,
          url: links.whatsapp,
        ),
      if (links.telegram.isNotEmpty)
        _SocialLinkItem(icon: AssetPaths.iconTelegram, url: links.telegram),
      if (links.youtube.isNotEmpty)
        _SocialLinkItem(icon: AssetPaths.iconYoutube, url: links.youtube),
      if (links.website.isNotEmpty)
        _SocialLinkItem(icon: AssetPaths.iconWebSite, url: links.website),
      if (links.linkedin.isNotEmpty)
        _SocialLinkItem(icon: AssetPaths.iconLinkedIn, url: links.linkedin),
    ];
  }

  Widget _socialIcon(BuildContext context, String path, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          // color: context.appColors.neutral.shade,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: AppColors.neutral200, width: 0.2),
          boxShadow: [
            /*  BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ), */
          ],
        ),
        child: AppSvg(svgPath: path, size: 24, color: AppColors.neutral200),
      ),
    );
  }
}

class _LogoutDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const _LogoutDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: context.appColors.primary.shade100.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: SvgPicture.asset(
            AssetPaths.iconLogout,
            width: 56,
            height: 56,

            // size: 48,
            // color: context.appColors.neutral.shade900,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          appLocalizer.logout_settings,
          style: context.bold.copyWith(
            color: context.appColors.neutral.shade700,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          appLocalizer.sureYouWantToExit,
          style: context.medium.copyWith(
            color: context.appColors.neutral.shade600,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: AppPrimaryButton.outline(
                borderColor: context.appColors.primary.shade400,
                textColor: context.appColors.neutral.shade900,
                onPressed: () => Navigator.pop(context),
                text: appLocalizer.cancel,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppPrimaryButton.outline(
                borderColor: context.appColors.danger.shade500,
                textColor: context.appColors.danger.shade500,
                buttonStyle: (style) => style?.copyWith(
                  backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  onConfirm();
                },
                text: appLocalizer.logOut,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _DeleteAccountDialog extends StatefulWidget {
  const _DeleteAccountDialog();

  @override
  State<_DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  int _currentStage = 1;
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (state.deletionRequest.isSuccess) {
          Navigator.pop(context); // Close the dialog
          // Trigger logout
          context.read<AuthenticationBloc>().add(LoggedOutEvent());
          // Show success message
          AppAlerts.showDecisionDialog(
            context,
            title: appLocalizer.success,
            description: appLocalizer.delete_account_success,
            actionButtons: [
              DecisionButtonModel(
                title: appLocalizer.ok,
                onTap: (ctx) => AppRouteNavigator.pop(ctx),
                isPrimary: true,
              ),
            ],
          );
        } else if (state.deletionRequest.isFailure) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.deletionRequest.failure?.errorMessage ??
                    appLocalizer.somethingWentWrong,
              ),
              backgroundColor: context.appColors.danger.shade500,
            ),
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();
        final isLoading = state.deletionRequest.isLoading;

        if (_currentStage == 1) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.appColors.danger.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_rounded,
                  size: 48,
                  color: context.appColors.danger.shade500,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                appLocalizer.delete_account_dialog_title,
                style: context.bold.copyWith(
                  color: context.appColors.danger.shade500,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                appLocalizer.delete_account_dialog_desc,
                style: context.medium.copyWith(
                  color: context.appColors.neutral.shade600,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: AppPrimaryButton.outline(
                      borderColor: context.appColors.primary.shade400,
                      textColor: context.appColors.neutral.shade900,
                      onPressed: () => Navigator.pop(context),
                      text: appLocalizer.cancel,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppPrimaryButton.outline(
                      borderColor: context.appColors.danger.shade500,
                      textColor: context.appColors.danger.shade500,
                      buttonStyle: (style) => style?.copyWith(
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.transparent,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _currentStage = 2;
                        });
                      },
                      text: appLocalizer.delete_account_settings,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          );
        }

        // Stage 2: Final confirmation with checkbox
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.appColors.danger.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.report_problem_rounded,
                size: 48,
                color: context.appColors.danger.shade500,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              appLocalizer.delete_account_confirm_title,
              style: context.bold.copyWith(
                color: context.appColors.danger.shade500,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              appLocalizer.delete_account_confirm_desc,
              style: context.medium.copyWith(
                color: context.appColors.neutral.shade300,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: () {
                setState(() {
                  _isChecked = !_isChecked;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _isChecked
                        ? context.appColors.danger.shade400
                        : context.appColors.neutral.shade700,
                  ),
                  color: _isChecked
                      ? context.appColors.danger.shade900.withValues(alpha: 0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _isChecked,
                        activeColor: context.appColors.danger.shade500,
                        checkColor: context.appColors.neutral.shade900,
                        onChanged: (val) {
                          setState(() {
                            _isChecked = val ?? false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        appLocalizer.i_understand_delete_my_account,
                        style: context.semiBold.copyWith(
                          color: context.appColors.neutral.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: AppPrimaryButton.outline(
                    borderColor: context.appColors.neutral.shade600,
                    textColor: context.appColors.neutral.shade300,
                    onPressed: () {
                      setState(() {
                        _currentStage = 1;
                      });
                    },
                    text: appLocalizer.back,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: AppPrimaryButton(
                    isLoading: isLoading,
                    textColor: _isChecked
                        ? context.appColors.neutral.shade900
                        : context.appColors.neutral.shade50,
                    buttonStyle: (style) => style?.copyWith(
                      backgroundColor: WidgetStatePropertyAll(
                        _isChecked
                            ? context.appColors.danger.shade500
                            : context.appColors.neutral.shade800,
                      ),
                    ),
                    onPressed: _isChecked
                        ? () {
                            cubit.requestAccountDeletion();
                          }
                        : null,
                    text: appLocalizer.confirm,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}
