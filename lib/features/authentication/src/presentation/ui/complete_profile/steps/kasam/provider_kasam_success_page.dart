part of auth;

class ProviderRegisterSuccessPage extends StatelessWidget {
  static const String routeName = '/ProviderRegisterSuccessPage';

  const ProviderRegisterSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.defaultBar(context, useCloseButton: true,),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              
              // Success Icon Circle
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.appColors.primary.shade500.withOpacity(0.1),
                ),
                child: Center(
                  child: Icon(
                    Icons.check_rounded,
                    color: context.appColors.primary.shade500,
                    size: 60,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Title
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: context.extraBold.copyWith(
                    fontSize: 20,
                    color: context.appColors.neutral.shade700,
                  ),
                  children: [
                    TextSpan(text: appLocalizer.thankYouFor), 
                    TextSpan(
                      text: appLocalizer.creatingYourAccount,
                      style: TextStyle(
                        color: context.appColors.secondary.shade500,
                      )
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Subtitle
              Text(
                appLocalizer.orderReceivedSuccessfully,
                textAlign: TextAlign.center,
                style: context.medium.copyWith(
                  height: 1.6,
                  color: context.appColors.neutral.shade700,
                ),
              ),
              
              const Spacer(),
              
              // Bottom Button
              AppPrimaryButton(
                isExpanded: true,
                onPressed: () {
                  // Usually route back to home or login based on user flow.
                  // E.g. AppRouteNavigator.pushNamedAndRemoveUntil(context, AppRoutes.home)
                  AppRouteNavigator.popUntil(context); // Go back to root which is decider or login
                },
                text: appLocalizer.returnToHome,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
