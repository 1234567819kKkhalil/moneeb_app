part of auth;

class UserRegisterPage extends StatelessWidget {
  static const String routeName = '/RegisterPage';

  /// Signup session token from the verified OTP step.
  final String signupToken;

  /// The contact already verified via OTP (prefilled + locked).
  final OtpIdentifier verifiedIdentifier;

  const UserRegisterPage({
    super.key,
    required this.signupToken,
    required this.verifiedIdentifier,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserRegisterCubit()),
        RepositoryProvider(
          create: (context) => RegisterInputProvider(
            signupToken: signupToken,
            verifiedIdentifier: verifiedIdentifier,
          ),
          lazy: false,
          dispose: (value) {
            value.dispose();
          },
        ),
      ],
      child: const _RegisterPageBody(),
    );
  }
}

class _RegisterPageBody extends StatefulWidget {
  const _RegisterPageBody();

  @override
  State<_RegisterPageBody> createState() => _RegisterPageBodyState();
}

class _RegisterPageBodyState extends State<_RegisterPageBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.defaultBar(
        context,
        text: appLocalizer.createAccountAlt,
        useCloseButton: true,
      ),
      body: SafeArea(
        child: BlocListener<UserRegisterCubit, UserRegisterState>(
          listener: (context, state) {
            if(state.registerState.isLoading){
              AppBlockerLoader.showLoader(context);
            } else {
              AppBlockerLoader.removeLoader();
            }

            if(state.registerState.isSuccess){
              AppRouteNavigator.popUntil(context);
              context.read<AuthenticationBloc>().startDecider();
            } else if(state.registerState.isFailure){
              AppToasts.error(context, message: state.registerState.failure?.errorMessage??'');
            }
          },
          child: UserRegisterStepOne(
            onRegisterRequested: () {
              final input = context
                  .read<RegisterInputProvider>()
                  .collectOtp(context, role: UserRoleEnum.user);
              context.read<UserRegisterCubit>().registerViaOtp(input: input);
            },
          ),
        )
      ),
    );
  }
}


// class UserRegisterPage extends StatelessWidget {
//   static const String routeName = '/RegisterPage';
//
//   const UserRegisterPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(create: (context) => UserRegisterCubit()),
//         RepositoryProvider(
//           create: (context) => RegisterInputProvider(),
//           lazy: false,
//           dispose: (value) {
//             value.dispose();
//           },
//         ),
//       ],
//       child: const _RegisterPageBody(),
//     );
//   }
// }
//
// class _RegisterPageBody extends StatefulWidget {
//   const _RegisterPageBody();
//
//   @override
//   State<_RegisterPageBody> createState() => _RegisterPageBodyState();
// }
//
// class _RegisterPageBodyState extends State<_RegisterPageBody> {
//   late final PageController _pageController;
//   int _currentStep = 0;
//
//   static const int _totalSteps = 2;
//
//   @override
//   void initState() {
//     super.initState();
//     _pageController = PageController();
//   }
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   void _goToStep(int step) {
//     if (step < 0 || step >= _totalSteps) return;
//     _pageController.animateToPage(
//       step,
//       duration: const Duration(milliseconds: 350),
//       curve: Curves.easeInOut,
//     );
//     setState(() => _currentStep = step);
//   }
//
//   void _nextStep() => _goToStep(_currentStep + 1);
//
//   void _previousStep() => _goToStep(_currentStep - 1);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBars.defaultBar(
//         context,
//         text: appLocalizer.createAccountAlt,
//         useCloseButton: true,
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Step Progress Indicator
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: PaddingDimensions.pageHorizontalPadding,
//                 vertical: PaddingDimensions.medium,
//               ),
//               child: AppPageProgress(
//                 count: _totalSteps,
//                 progressIndex: _currentStep,
//               ),
//             ),
//
//             // Page View
//             Expanded(
//               child: PageView(
//                 controller: _pageController,
//                 physics: const NeverScrollableScrollPhysics(),
//                 onPageChanged: (index) {
//                   setState(() => _currentStep = index);
//                 },
//                 children: [
//                   // Personal Info
//                   UserRegisterStepOne(
//                     onNext: _nextStep,
//                   ),
//
//                   // Upload images
//                   UserRegisterStepTwo(
//                     onNext: _nextStep,
//                     onBack: _previousStep,
//                   ),
//
//                 ],
//               ),
//             ),
//
//             if(_currentStep == 1)
//               Padding(
//                 padding: const EdgeInsets.only(
//                   top: 8,
//                   bottom: 12.0,
//                   left: 16,
//                   right: 15
//                  ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: AppPrimaryButton.outline(
//                         onPressed: _previousStep,
//                         text: appLocalizer.backBtn,
//                         buttonStyle: (currentStyle) {
//                           return currentStyle?.copyWith(
//                               backgroundColor: WidgetStatePropertyAll(Colors.transparent)
//                           );
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: AppPrimaryButton(
//                         onPressed: _nextStep,
//                         isExpanded: true,
//                         text: 'انشاء الحساب', 
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
