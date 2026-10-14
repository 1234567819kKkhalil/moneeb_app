part of app_material;

class ExitAppAlertView extends StatelessWidget {
  const ExitAppAlertView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          appLocalizer.exitDescription,
          style: context.medium,
        ),
        const Gap(PaddingDimensions.medium),
        Row(
          children: [
            AppTextButton(
              text: appLocalizer.leave,
              textStyle: context.medium.copyWith(color: context.appColors.neutral.shade500),
              onPressed: () {
                Navigator.pop(context);
                SystemNavigator.pop();
              },
            ),
            const Gap(PaddingDimensions.large),
            AppTextButton(
              text: appLocalizer.stay,
              textStyle: context.medium,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        )
      ],
    );
  }
}
