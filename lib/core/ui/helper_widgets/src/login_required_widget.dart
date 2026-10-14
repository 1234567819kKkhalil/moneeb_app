part of helper_widgets;

class LoginRequiredWidget extends StatelessWidget {
  const LoginRequiredWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingDimensions.pageMargins,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppSvg(
              svgPath: '',
              color: context.appColors.primary.shade900),
          const SizedBox(
            height: PaddingDimensions.large,
          ),
          Text(
            appLocalizer.loginRequired,
            style: context.regular,
          ),
          const SizedBox(
            height: PaddingDimensions.xxLarge,
          ),
          AppPrimaryButton(
            onPressed: () {
              AuthenticationBloc.of(context).add(const AuthRestartEvent());
            },
            buttonStyle: (currentStyle) => currentStyle?.copyWith(
              textStyle: WidgetStatePropertyAll(context.bold)
            ),
            text: appLocalizer.logIn,
            isExpanded: true,
          )
        ],
      ),
    );
  }
}
