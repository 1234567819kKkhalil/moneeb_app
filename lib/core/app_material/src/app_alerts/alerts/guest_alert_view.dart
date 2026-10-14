part of app_material;

class GuestAlertView extends StatelessWidget {
  const GuestAlertView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(appLocalizer.youAreGuestLogin, style: context.medium),

        const Gap(PaddingDimensions.large),

        AppPrimaryButton(
          isExpanded: true,
          onPressed: () {
            AppRouteNavigator.pop(context);
            AuthenticationBloc.of(context).add(const AuthRestartEvent());
          },
          text: appLocalizer.logIn,
        ),
      ],
    );
  }
}
