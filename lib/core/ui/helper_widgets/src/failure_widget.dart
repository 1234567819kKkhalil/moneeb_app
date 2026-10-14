part of helper_widgets;

class FailureWidget extends StatelessWidget {
  final String? retryButtonTitle;
  final VoidCallback? onRetryPressed;
  final EdgeInsetsGeometry? padding;
  final Failure? failure;
  final String? title;
  final Color? textColor;
  final bool addRefreshSupport;
  final String? svgIllustrator;

  const FailureWidget({
    super.key,
    this.retryButtonTitle,
    required this.onRetryPressed,
    this.padding,
    required this.failure,
    this.title,
    this.textColor,
    this.svgIllustrator,
    this.addRefreshSupport = false,
  });

  @override
  Widget build(BuildContext context) {
    String message = failure?.errorMessage ?? appLocalizer.unexpectedError;

    final content = Center(
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // AppSvg(
              //   svgPath: svgIllustrator ?? '', //todo: put default illustrator
              //   size: 50,
              // ),
              // const SizedBox(
              //   height: PaddingDimensions.large,
              // ),

              if (title != null) ...[
                Text(
                  title!,
                  style: context.semiBold.copyWith(
                    color: textColor,
                    fontSize: Dimensions.xxxLarge,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Gap(PaddingDimensions.normal),
              ],

              Text(
                message,
                style: context.regular.copyWith(
                  color: textColor ?? context.appColors.neutral.shade700,
                ),
                textAlign: TextAlign.center,
              ),

              if (onRetryPressed != null)
                Padding(
                  padding: const EdgeInsets.only(
                    top: PaddingDimensions.xLarge,
                  ),
                  child: AppPrimaryButton(
                    text: retryButtonTitle ?? appLocalizer.retry,
                    onPressed: onRetryPressed,
                    isExpanded: false,
                    buttonHeight: Dimensions.buttonMediumHeight,
                  ),
                )
            ],
          ),
        ),
      ),
    );

    if(addRefreshSupport){
      return LayoutBuilder(
          builder: (context, constraints) {
            if(constraints.hasInfiniteHeight){
              return content;
            }else{
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth,
                      minHeight: constraints.maxHeight,
                    ),
                    child: content
                ),
              );
            }
          }
      );
    }else{
      return content;
    }

  }
}
