part of helper_widgets;

class ExecuteCancelRowButtons extends StatelessWidget {
  final String textPrimaryButton;
  final String textOutlineButton;
  final VoidCallback? onPrimaryButtonPressed;

  const ExecuteCancelRowButtons({
    super.key,
    required this.textPrimaryButton,
    required this.textOutlineButton,
    this.onPrimaryButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: PaddingDimensions.large),
        child: Row(
          children: [
            Expanded(
              child: AppPrimaryButton(
                text: textPrimaryButton,
                onPressed:  (onPrimaryButtonPressed != null)
                    ? onPrimaryButtonPressed
                    : null,
              ),
            ),
            const SizedBox(
              width: PaddingDimensions.large,
            ),
            Expanded(
              child: AppPrimaryButton.outline(
                text: textOutlineButton,
              //  textColor: context.appColors.primary.shade900,
                onPressed: () {
                  AppRouteNavigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
