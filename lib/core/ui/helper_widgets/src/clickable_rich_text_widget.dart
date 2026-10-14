part of helper_widgets;

class ClickableRichTextWidget extends StatelessWidget {
  final String firstText;
  final String secondText;
  final TapGestureRecognizer? firstTextRecognizer;
  final TapGestureRecognizer? secondTextRecognizer;
  final TextStyle? firstTextStyle;
  final TextStyle? secondTextStyle;

  const ClickableRichTextWidget({
    super.key,
    required this.firstText,
    required this.secondText,
    this.firstTextStyle,
    this.secondTextStyle,
    this.firstTextRecognizer,
    this.secondTextRecognizer,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: firstTextStyle ??
            context.medium.copyWith(
              height: 1.3,
              fontSize: Dimensions.xxLarge,
            ),
        children: [
          TextSpan(text: firstText, recognizer: firstTextRecognizer),
          TextSpan(
              text: secondText,
              style: secondTextStyle ??
                  context.regular.copyWith(
                    color: context.appColors.neutral.shade600,
                    height: 1.3,
                    fontSize: Dimensions.xxLarge,
                  ),
              recognizer: secondTextRecognizer),
        ],
      ),
    );
  }
}
