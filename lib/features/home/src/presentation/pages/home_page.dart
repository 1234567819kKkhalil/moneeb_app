part of home;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => injector<HomeCubit>()..init(context)),
        BlocProvider(
          create: (context) => injector<PrayerTimesCubit>()..fetchPrayerTimes(),
        ),
        BlocProvider(
          create: (context) {
            final cubit = NotificationsCubit();
            final authBloc = context.read<AuthenticationBloc>();
            if (authBloc.state.routingState.route ==
                AuthRouteEnum.authenticated) {
              cubit.fetchNotificationCount();
            }
            return cubit;
          },
        ),
      ],
      child: const _HomeBody(),
    );
  }
}

class _HomeBody extends StatefulWidget {
  const _HomeBody({super.key});

  @override
  State<_HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<_HomeBody>
    with OmrahObserverMixin, NotificationActionsObserverMixin {
  NotificationObserver? _notificationObserver;

  // Lets the user flip between multiple simultaneously-active Omrahs with
  // real PageView swipe physics. Each Omrah gets its own measured height
  // (they can differ — longer names wrap to 2 lines) instead of one shared
  // fixed height, so the card never permanently over- or under-sizes.
  final PageController _omrahPageController = PageController();
  int _currentOmrahPage = 0;
  final Map<String, double> _omrahCardHeights = {};
  final Map<String, GlobalKey> _omrahCardKeys = {};

  // Fallback used only until a card's real height is measured, and as the
  // scroll-clearance estimate below — doesn't constrain the card itself.
  static const double _estimatedOmrahCardHeight = 160;

  GlobalKey _omrahCardKey(String orderId) =>
      _omrahCardKeys.putIfAbsent(orderId, () => GlobalKey());

  void _measureOmrahCardHeight(String orderId) {
    final renderBox =
        _omrahCardKeys[orderId]?.currentContext?.findRenderObject()
            as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final height = renderBox.size.height;
    if (mounted && _omrahCardHeights[orderId] != height) {
      setState(() => _omrahCardHeights[orderId] = height);
    }
  }

  @override
  void initState() {
    bool isProvider =
        context.read<AuthenticationBloc>().getUserRole == UserRoleEnum.provider;

    if (isProvider) {
      initOmrahObserver(
        omrahStepUpdated: (stepper) {
          context.read<HomeCubit>().modifyOmrahStepChanged(stepper);
          FloatingOmrahOverlayManager.changeStep(context, stepper: stepper);
        },
        omrahCompleted: (orderId) {
          context.read<HomeCubit>().modifyOmrahCompleted(orderId);
          FloatingOmrahOverlayManager.removeOverlay();
          ProviderTrackingService.instance.dispose();
        },
      );
    }

    initNotificationActionsObserver(
      refreshOmrahPage: (orderId) {
        if (!isProvider) {
          context.read<HomeCubit>().fetchActiveOmrah();
        }
      },
    );

    _notificationObserver = NotificationObserver(
      onNotificationUpdates: (newCount, reset) {
        if (mounted) {
          final authBloc = context.read<AuthenticationBloc>();
          if (authBloc.state.routingState.route ==
              AuthRouteEnum.authenticated) {
            context.read<NotificationsCubit>().fetchNotificationCount();
          }
        }
      },
    );

    // An order accepted (or started) on another tab must show up here without
    // a manual pull-to-refresh.
    NavObserver.instance.addListener(_onTabChanged);

    super.initState();
  }

  MainHostPageTabsEnum? _lastTab = NavObserver.instance.currentTab;

  // NavObserver also notifies on every page push/pop, so only react when the
  // tab itself changed back to home.
  void _onTabChanged() {
    final tab = NavObserver.instance.currentTab;
    if (tab == _lastTab) return;
    _lastTab = tab;

    if (mounted && tab == MainHostPageTabsEnum.home) {
      context.read<HomeCubit>().fetchUpcomingOmrah();
    }
  }

  @override
  void dispose() {
    NavObserver.instance.removeListener(_onTabChanged);
    _notificationObserver?.dispose();
    _omrahPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.appBackgroundColor,
      /* appBar: AppBars.defaultBar(
        context,
        text: 'Home',
        centerTitle: true,
        showDivider: true,
      ), */
      body: BlocListener<HomeCubit, HomeState>(
        listenWhen: (previous, current) =>
            previous.activeOmrah != current.activeOmrah,
        listener: (context, state) {
          if (state.activeOmrah.isSuccess) {
            final activeOmrahs = state.activeOmrah.data ?? [];
            final isProvider =
                context.read<AuthenticationBloc>().getUserRole ==
                UserRoleEnum.provider;

            if (activeOmrahs.isNotEmpty && isProvider) {
              FloatingOmrahOverlayManager.showOverlay(
                context,
                stepper: activeOmrahs.first,
              );
            }
          }
        },
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            final isProvider =
                context.read<AuthenticationBloc>().getUserRole ==
                UserRoleEnum.provider;
            final activeOmrahs = state.activeOmrah.data ?? [];
            final showActiveOmrahBar =
                !isProvider &&
                state.activeOmrah.isSuccess &&
                activeOmrahs.isNotEmpty;

            // Clamp in case the list shrank (e.g. an Omrah just completed)
            // while the user was viewing a later page.
            if (showActiveOmrahBar &&
                _currentOmrahPage >= activeOmrahs.length) {
              _currentOmrahPage = activeOmrahs.length - 1;
            }

            if (showActiveOmrahBar) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Measured from the offstage copies below, not from inside
                // the PageView: PageView force-fills every page to whatever
                // height it's given, so measuring in there just echoes the
                // container's current height back instead of the content's
                // real size.
                for (final omrah in activeOmrahs) {
                  _measureOmrahCardHeight(omrah.orderId);
                }
              });
            }

            return Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top),
                    Padding(
                      padding: EdgeInsets.only(right: 16, left: 16),
                      child: HomeAppBar(),
                    ),

                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context.read<HomeCubit>().init(context);
                          final authBloc = context.read<AuthenticationBloc>();
                          if (authBloc.state.routingState.route ==
                              AuthRouteEnum.authenticated) {
                            context
                                .read<NotificationsCubit>()
                                .fetchNotificationCount();
                          }
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.only(
                            bottom:
                                Dimensions.bottomNavBarSafePadding(context) +
                                (showActiveOmrahBar
                                    ? (_omrahCardHeights[activeOmrahs[_currentOmrahPage]
                                                  .orderId] ??
                                              _estimatedOmrahCardHeight) +
                                          16
                                    : 0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // const AppDivider(thickness: 1),
                              const SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: const WelcomeSection(),
                              ),

                              const UpcomingOmrahSection(),

                              /* // TEMPORARY — debug-only shortcut into the
                              // charter screen so it can be reviewed without
                              // walking the whole registration flow.
                              // Delete once the screen is signed off.
                              if (kDebugMode) ...[
                                const SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: AppPrimaryButton(
                                    isExpanded: true,
                                    text: 'TEST · شاشة الميثاق والقَسَم',
                                    onPressed: () => AppRouteNavigator.push(
                                      context,
                                      ProviderKasamPage.routeName,
                                      const ProviderKasamPage(),
                                    ),
                                  ),
                                ),
                              ], */
                              const SizedBox(height: 8),
                              const AppDivider(
                                thickness: 0.3,
                                color: AppColors.neutral700,
                                start: 16,
                                end: 16,
                              ),

                              // STORIES
                              const StoriesSection(),

                              const SizedBox(height: 16),
                              const BannersSection(),
                              // VIDEOS
                              const SizedBox(height: 28),
                              /* Align(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    '﴿مَنْ خَشِيَ الرَّحْمَنَ بِالْغَيْبِ وَجَاءَ بِقَلْبٍ مُنِيبٍ﴾',
                                    style: context.theme.textTheme.bodyMedium
                                        ?.copyWith(
                                          fontSize: 16,
                                          fontFamily: 'KFGQPC',
                                          color: context
                                              .appColors
                                              .neutral
                                              .shade900,
                                        ),
                                  ),
                                ),
                              ), */
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    AssetPaths.homeAyahSvg,
                                    // width: 24,
                                    height: 40,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const StreamsSection(),
                              // const VideosSection(),

                              /* // AZKAR
                              const SizedBox(height: 8),
                              const AzkarSection(), */

                              /*  // LIVE
                              const SizedBox(height: 18),
                              const LiveSection(),
                   */
                              // BEST PROVIDERS
                              const SizedBox(height: 18),
                              const BestProvidersSection(),
                              // RITUALS WITH AUTHENTIC DOCUMENTATION
                              const SizedBox(height: 18),
                              const RitualsDocumentationSection(),

                              // VERIFIED PROVIDERS
                              const SizedBox(height: 18),
                              const VerifiedProvidersSection(),

                              // RitualsDocumentationSection

                              /* // UMRAH STAGE — TEST MODE
                                const SizedBox(height: 24),
                                const UmrahStepperWidget(
                                  currentStep: OmrahStepsEnum.tahalol,
                                ), */
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                if (showActiveOmrahBar)
                  Positioned(
                    left: 16,
                    right: 16,
                    // 8 above the floating bottom nav bar, on every screen.
                    bottom: Dimensions.bottomNavBarSafePadding(context),
                    // Real PageView swipe physics, height animates to match
                    // whichever Omrah is currently shown (each is measured
                    // and cached separately by orderId).
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,

                      height:
                          _omrahCardHeights[activeOmrahs[_currentOmrahPage]
                              .orderId] ??
                          _estimatedOmrahCardHeight,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          PageView.builder(
                            controller: _omrahPageController,
                            itemCount: activeOmrahs.length,
                            onPageChanged: (index) =>
                                setState(() => _currentOmrahPage = index),
                            itemBuilder: (context, index) {
                              final omrah = activeOmrahs[index];
                              return GestureDetector(
                                key: ValueKey(omrah.orderId),
                                onTap: () {
                                  AppRouteNavigator.push(
                                    context,
                                    UserOmrahInspectorPage.routeName(
                                      omrah.orderId,
                                    ),
                                    UserOmrahInspectorPage(
                                      orderId: omrah.orderId,
                                      beneficiaryName:
                                          omrah.forWhom.beneficiaryName,
                                    ),
                                  );
                                },
                                child: UmrahStepperWidget(
                                  currentStep: omrah.currentStep,
                                  forWhom: omrah.forWhom,
                                ),
                              );
                            },
                          ),
                          // Explicit "1/2" badge — clearer than dots that
                          // there's more than one active Omrah to swipe
                          // through, without adding extra height.
                          if (activeOmrahs.length > 1)
                            PositionedDirectional(
                              top: 10,
                              end: 14,
                              child: IgnorePointer(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: context.appColors.secondary.shade500,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${_currentOmrahPage + 1}/${activeOmrahs.length}',
                                    style: context.bold.copyWith(
                                      fontSize: 10,
                                      color: context.appColors.neutral.shade50,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                // Invisible copies laid out with the same width as the
                // visible card but no height constraint, purely so each
                // Omrah's true natural height can be measured — the
                // PageView above can't report that itself (see comment
                // near _measureOmrahCardHeight's call site).
                if (showActiveOmrahBar)
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 0,
                    child: Offstage(
                      child: Stack(
                        children: activeOmrahs
                            .map(
                              (omrah) => KeyedSubtree(
                                key: _omrahCardKey(omrah.orderId),
                                child: UmrahStepperWidget(
                                  currentStep: omrah.currentStep,
                                  forWhom: omrah.forWhom,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
