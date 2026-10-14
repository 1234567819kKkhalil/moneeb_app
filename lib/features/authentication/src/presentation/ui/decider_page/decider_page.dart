part of core;

bool isFirstEnteredTheApp = true;

class DeciderPage extends StatefulWidget {
  const DeciderPage({super.key});

  @override
  State<DeciderPage> createState() => _DeciderPageState();
}

class _DeciderPageState extends State<DeciderPage> {
  @override
  void initState() {
    initialize();

    if(isFirstEnteredTheApp){
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (context.mounted) {
          precacheImage(AppImage.getImageProvider(
              path: AssetPaths.kaabaBg,
              width: context.width
          ), context);
        }
      },);
    }

    super.initState();
  }

  void initialize() async {
    final authBloc = context.read<AuthenticationBloc>();

    final isAuthenticated = authBloc.isUserAuthenticated();

    // No artificial delay, but Firebase / timezones are initialized after the
    // first frame (see initializeAppConfig), so wait for them here.
    await appConfigReady;

    if (!mounted) return;

    if (isAuthenticated) {
      //is there is a token, then get user data
      authBloc.add(FetchUserDataEvent());
    } else {
      if (await authBloc.isGuest()) {
        //if user continued as a guest before, then set the role and push to main host page
        authBloc.add(GuestEvent());
      } else {
        authBloc.add(
            const AuthRouteChangeEvent(route: AuthRouteEnum.getStartedPage));
      }
    }
  }

  @override
  void dispose() {
    isFirstEnteredTheApp = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthState>(
      builder: (context, state) {
        final Widget child;

        if (state.userData.isFailure) {
          child = FailureWidget(
            failure: state.userData.failure,
            onRetryPressed: () async => _onRetry(),
          );
        } else if (isFirstEnteredTheApp) {
          // The native splash is just a blank screen with the same background
          // color, so this is the only splash the user actually sees.
          return const SplashPage();
        } else {
          child = const CustomAnimationLoading();
        }

        return Scaffold(
          backgroundColor: context.appColors.appBackgroundColor,
          appBar: AppBars.defaultBar(
            context,
            useCloseButton: state.userData.isFailure,
            onBackPressed: () {
              AppAlerts.showDecisionDialog(
                context,
                title: appLocalizer.logoutString,
                description: appLocalizer.doYouWantToLogout,
                actionButtons: [
                  DecisionButtonModel(
                    title: appLocalizer.logoutString,
                    isPrimary: true,
                    onTap: (_) {
                      AuthenticationBloc.of(context).add(LoggedOutEvent());
                      AppRouteNavigator.pop(context);
                    },
                  ),
                  DecisionButtonModel(
                    title: appLocalizer.cancelString,
                    onTap: (context) {
                      AppRouteNavigator.pop(context);
                    },
                  )
                ]
              );
            },
          ),
          body: SafeArea(
            child: Padding(
              padding: PaddingDimensions.pageMargins,
              child: Center(
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onRetry() async {
    BlocProvider.of<AuthenticationBloc>(context).add(FetchUserDataEvent());
  }
}
