part of main_host_page;

class MainHostPage extends StatefulWidget {
  const MainHostPage({super.key});

  static const routeName = "mainHostPage";

  @override
  State<MainHostPage> createState() => _MainHostPageState();
}

class _MainHostPageState extends State<MainHostPage> {
  late List<MainHostPageTabsEnum> _tabs;
  int currentIndex = 0;

  MainHostPageTabsEnum _currentTab = MainHostPageTabsEnum.home;
  final List<MainHostPageTabsEnum> loadedPages = [];

  @override
  void initState() {
    final userRole = context.read<AuthenticationBloc>().getUserRole;

    _tabs = [
      MainHostPageTabsEnum.home,

      if (userRole != UserRoleEnum.guest) MainHostPageTabsEnum.orders,

      if (userRole == UserRoleEnum.user) MainHostPageTabsEnum.requestOmra,

      MainHostPageTabsEnum.zad,
      MainHostPageTabsEnum.profile,
    ];

    loadedPages.add(_currentTab);
    NavObserver.instance.changeTab(_currentTab);

    //Listener to change main host page tabs from anywhere in the app
    NavObserver.instance.addListener(_changeTabListener);

    // DeepLinks().initDeepLink();

    super.initState();
  }

  @override
  void dispose() {
    NavObserver.instance.removeListener(_changeTabListener);
    NavObserver.instance.changeTab(null);

    DeepLinks().dispose();

    FloatingOmrahOverlayManager.removeOverlay();
    UserOmrahOverlayManager.removeOverlay();
    ProviderTrackingService.instance.dispose();

    super.dispose();
  }

  void _onTabClicked(MainHostPageTabsEnum tab) {
    NavObserver.instance.changeTab(tab);
  }

  void _changeTabListener() {
    MainHostPageTabsEnum? newTab = NavObserver.instance.currentTab;

    if (newTab != null && newTab != _currentTab) {
      if (!loadedPages.contains(newTab)) {
        loadedPages.add(newTab);
      }

      _currentTab = newTab;
      currentIndex = _tabs.indexOf(newTab);

      if (newTab == MainHostPageTabsEnum.home) {
        UserOmrahOverlayManager.unHide(context);
      } else {
        UserOmrahOverlayManager.hide();
      }

      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userRole = context.read<AuthenticationBloc>().getUserRole;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          return;
        }
        AppAlerts.showExitAppDialog(context);
      },
      child: Scaffold(
        backgroundColor: _currentTab.getBackgroundColor(context),
        drawerEnableOpenDragGesture: false,
        resizeToAvoidBottomInset: true,
        // lets the body draw behind the floating nav bar while Flutter still
        // reports the nav bar's real height as bottom padding to the body's
        // MediaQuery, so any SafeArea(bottom: true) inside a tab page
        // automatically reserves the correct space for it.
        extendBody: true,

        body: IndexedStack(
          index: currentIndex,
          children: _tabs.map((e) {
            switch (e) {
              case MainHostPageTabsEnum.home:
                return OffStage(
                  isActive: loadedPages.contains(MainHostPageTabsEnum.home),
                  child: HomePage(),
                );
              case MainHostPageTabsEnum.orders:
                return OffStage(
                  isActive: loadedPages.contains(MainHostPageTabsEnum.orders),
                  child: userRole == UserRoleEnum.user
                      ? UserOrdersPage()
                      : ProviderOrdersPage(),
                );
              case MainHostPageTabsEnum.requestOmra:
                return OffStage(
                  isActive: loadedPages.contains(
                    MainHostPageTabsEnum.requestOmra,
                  ),
                  child: OmraRequestPage(),
                );
              case MainHostPageTabsEnum.zad:
                return OffStage(
                  isActive: loadedPages.contains(MainHostPageTabsEnum.zad),
                  child: ZadPage(),
                );
              case MainHostPageTabsEnum.profile:
                return OffStage(
                  isActive: loadedPages.contains(MainHostPageTabsEnum.profile),
                  child: SettingsPage(),
                );
            }
          }).toList(),
        ),

        bottomNavigationBar: MediaQuery.of(context).viewInsets.bottom == 0
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: MainHostBottomNavBar(
                  currentTab: _currentTab,
                  onTap: _onTabClicked,
                ),
              )
            : null,
      ),
    );
  }
}
