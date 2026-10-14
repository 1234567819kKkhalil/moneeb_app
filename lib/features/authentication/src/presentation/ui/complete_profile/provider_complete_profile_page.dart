part of auth;

class ProviderCompleteProfilePage extends StatelessWidget {
  static const String routeName = '/ProviderCompleteProfilePage';

  const ProviderCompleteProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProviderCompleteProfileCubit()),
      ],
      child: const _ProviderCompleteProfilePageBody(),
    );
  }
}

class _ProviderCompleteProfilePageBody extends StatefulWidget {
  const _ProviderCompleteProfilePageBody();

  @override
  State<_ProviderCompleteProfilePageBody> createState() =>
      _ProviderCompleteProfilePageBodyState();
}

class _ProviderCompleteProfilePageBodyState
    extends State<_ProviderCompleteProfilePageBody> {
  late final PageController _pageController;
  int _currentStep = 0;

  static const int _totalSteps = 2;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    if (step < 0 || step >= _totalSteps) return;

    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );

    setState(() => _currentStep = step);
  }

  void _nextStep() {
    _goToStep(_currentStep + 1);
  }

  void _previousStep() => _goToStep(_currentStep - 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.defaultBar(
        context,
        text: appLocalizer.completeProfileTitle,
        useCloseButton: true,
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
        child: Column(
          children: [
            // Step Progress Indicator
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: PaddingDimensions.pageHorizontalPadding,
                vertical: PaddingDimensions.medium,
              ),
              child: AppPageProgress(
                count: _totalSteps,
                progressIndex: _currentStep,
              ),
            ),

            // Page View
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) {
                  setState(() => _currentStep = index);
                },
                children: [
                  CompleteProfileProviderInfoStep(onNext: _nextStep),
                  CompleteProfileCertificationsStep(
                    onBack: _previousStep,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
