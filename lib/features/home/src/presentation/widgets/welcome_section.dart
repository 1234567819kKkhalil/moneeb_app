part of home;

class WelcomeSection extends StatelessWidget {
  const WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthenticationBloc>().state;
    final isAuthenticated =
        authState.routingState.route == AuthRouteEnum.authenticated;
    final userName = isAuthenticated
        ? (authState.userData.data?.fullName ?? appLocalizer.guest)
        : null;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            // height: 100,
            padding: EdgeInsetsDirectional.only(end: 8),
            alignment:
                context.read<AppLanguageCubit>().state.langCode ==
                    AppLangCodeEnum.ar
                ? Alignment.topRight
                : Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  isAuthenticated && userName != null
                      ? appLocalizer.welcome(userName)
                      : appLocalizer.welcomeGuest,
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    color: context.appColors.secondary.shade500,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),
                Text(
                  appLocalizer.journeyStartDesc,
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    color: context.appColors.neutral.shade900,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      appLocalizer.moneebSaudiDesc,
                      style: context.theme.textTheme.bodyMedium?.copyWith(
                        color: context.appColors.neutral.shade900,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 4),
                    SvgPicture.asset(
                      AssetPaths.iconFlagSaudi,
                      width: 17,
                      height: 11,
                    ),
                  ],
                ),

                const SizedBox(height: 14),
                const HomeLocationButton(),
              ],
            ),
          ),
        ),
        const CountdownCard(),
      ],
    );
  }
}
