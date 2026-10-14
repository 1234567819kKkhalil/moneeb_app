part of home;

// import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: BlocBuilder<AuthenticationBloc, AuthState>(
              builder: (context, state) {
                final userModel = state.userData.data ?? AppUserModel.initial();
                print(userModel.avatarUrl);
                return GestureDetector(
                  onTap: () {
                    /* HomeController home = Get.find();
                    if(AppConfig.getUserType() == Const.KEY_USER_UMRAH_OWNER){
                      home.getCurrentNavIndex(navIndex: 4);
                    }else {
                      home.getCurrentNavIndex(navIndex: 3);
                    } */
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (state.routingState.route ==
                              AuthRouteEnum.authenticated) {
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
                          }
                        },
                        child: AppImage(
                          path:
                              state.routingState.route ==
                                  AuthRouteEnum.authenticated
                              ? userModel.avatarUrl
                              : AssetPaths.moneebLogo,
                          height: 48,
                          width: 48,
                          border: Border.all(
                            color: context.appColors.secondary.shade500,
                            width: 1,
                          ),
                          errorPlaceHolder: () => Padding(
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              AssetPaths.moneebLogo,
                              fit: BoxFit.contain,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.routingState.route ==
                                      AuthRouteEnum.authenticated
                                  ? userModel.fullName
                                  : appLocalizer.guest,
                              style: context.theme.textTheme.bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: context.appColors.secondary.shade500,
                                  ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            if (state.routingState.route ==
                                AuthRouteEnum.authenticated)
                              Text(
                                "@${userModel.username}",
                                style: context.theme.textTheme.bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 10,
                                      color: context.appColors.neutral.shade900,
                                    ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          Center(
            child: AppImage(path: AssetPaths.moneebLogo, width: 56, height: 56),
          ),

          // SizedBox(width: 20),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(child: const _ProviderOnlineStatusToggle()),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: BlocBuilder<AuthenticationBloc, AuthState>(
                    builder: (context, state) {
                      final isAuthenticated =
                          state.routingState.route ==
                          AuthRouteEnum.authenticated;
                      return GestureDetector(
                        onTap: () {
                          if (isAuthenticated) {
                            AppRouteNavigator.push(
                              context,
                              NotificationsPage.routeName,
                              NotificationsPage(),
                              onPoppedWithData: (_) {
                                context
                                    .read<NotificationsCubit>()
                                    .fetchNotificationCount();
                              },
                            );
                          } else {
                            AppAlerts.showGuestDialog(context);
                          }
                        },
                        child: isAuthenticated
                            ? BlocBuilder<
                                NotificationsCubit,
                                NotificationsCubitState
                              >(
                                builder: (context, notificationsState) {
                                  final count =
                                      notificationsState.notificationCount;
                                  if (count > 0) {
                                    return Badge(
                                      backgroundColor:
                                          context.appColors.danger.shade500,
                                      label: Text(
                                        count.toString(),
                                        style: context.regular.copyWith(
                                          color: Colors.white,
                                          fontSize: 8,
                                          // fontWeight: FontWeight.s,
                                        ),
                                      ),
                                      child: AppSvg(
                                        svgPath:
                                            AssetPaths.iconNotificationsHome,
                                      ),
                                    );
                                  }
                                  return AppSvg(
                                    svgPath: AssetPaths.iconNotificationsHome,
                                  );
                                },
                              )
                            : AppSvg(svgPath: AssetPaths.iconNotificationsHome),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderOnlineStatusToggle extends StatefulWidget {
  const _ProviderOnlineStatusToggle();

  @override
  State<_ProviderOnlineStatusToggle> createState() =>
      _ProviderOnlineStatusToggleState();
}

class _ProviderOnlineStatusToggleState
    extends State<_ProviderOnlineStatusToggle> {
  late final EditProviderProfileCubit _cubit =
      injector<EditProviderProfileCubit>();

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthState>(
      builder: (context, authState) {
        final userModel = authState.userData.data;
        final isAuthenticatedProvider =
            authState.routingState.route == AuthRouteEnum.authenticated &&
            userModel?.role == UserRoleEnum.provider;

        if (!isAuthenticatedProvider) return const SizedBox.shrink();

        return BlocConsumer<EditProviderProfileCubit, EditProviderProfileState>(
          bloc: _cubit,
          listener: (context, state) {
            if (state.toggleOnlineState.isSuccess) {
              context.read<AuthenticationBloc>().modifyUserModel((user) {
                return user.copyWith(
                  providerData: user.providerData?.copyWith(
                    isOnline: state.isOnline,
                  ),
                );
              });
            } else if (state.toggleOnlineState.isFailure) {
              AppToasts.error(
                context,
                message: state.toggleOnlineState.failure?.errorMessage ?? '',
              );
            }
          },
          builder: (context, state) {
            final isOnline =
                state.isOnline ?? userModel?.providerData?.isOnline ?? false;
            final isLoading = state.toggleOnlineState.isLoading;
            final statusColor = isOnline
                ? Colors.green
                : Colors.red; // Red color for offline status

            return AnimatedContainer(
              margin: EdgeInsetsDirectional.only(end: 8),
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsetsDirectional.only(
                top: 4,
                bottom: 4,
                start: 6,
                end: 4,
              ),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: statusColor, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: isLoading
                        ? SizedBox(
                            key: const ValueKey('loading'),
                            width: 10,
                            height: 10,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                              color: statusColor,
                            ),
                          )
                        : Container(
                            key: const ValueKey('dot'),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: statusColor,
                            ),
                          ),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: SizedBox(
                      width: 36,
                      child: Text(
                        isOnline
                            ? appLocalizer.isAvailable
                            : appLocalizer.isNotAvailable,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: context.theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  SizedBox(
                    width: 30,
                    height: 20,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Switch(
                        value: isOnline,
                        onChanged: isLoading
                            ? null
                            : (value) => _cubit.toggleOnlineStatus(value),
                        activeColor: Colors.green,
                        inactiveThumbColor: Colors.red,
                        inactiveTrackColor: Colors.red.withOpacity(0.3),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
