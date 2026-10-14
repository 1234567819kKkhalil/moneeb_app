part of app_material;

class DecisionDialog extends StatelessWidget {
  final String? title;
  final String? imageSvgPath;
  final IconData? icon;
  final String? description;
  final List<DecisionButtonModel>? actionButtons;
  final bool isButtonInVertical;

  const DecisionDialog({
    super.key,
    this.title,
    this.imageSvgPath,
    this.icon,
    this.description,
    this.actionButtons,
    this.isButtonInVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (imageSvgPath != null)
          Padding(
            padding: const EdgeInsets.only(bottom: PaddingDimensions.large),
            child: AppSvg(
              svgPath: imageSvgPath!,
              width: 50,
              height: 40,
              // color: AppColors.secondary500,
            ),
          ),
        if (icon != null)
          Padding(
            padding: const EdgeInsets.only(bottom: PaddingDimensions.large),
            child: Icon(icon),
          ),
        if (title != null || description != null)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: PaddingDimensions.medium,
                  ),
                  child: Text(
                    title!,
                    textAlign: TextAlign.center,
                    style: context.bold.copyWith(
                      fontSize: Dimensions.xxLarge,
                      color: context.appColors.neutral.shade900,
                    ),
                  ),
                ),
              if (description != null)
                Text(
                  description!,
                  textAlign: TextAlign.center,
                  style: context.regular.copyWith(
                    color: context.appColors.neutral.shade500,
                  ),
                ),
            ],
          ),
        if (actionButtons != null) ...[
          const SizedBox(height: PaddingDimensions.large),
          ..._buildButtons(context),
        ],
      ],
    );
  }

  List<Widget> _buildButtons(BuildContext context) {
    if (isButtonInVertical) {
      return [
        ...List.generate(actionButtons!.length, (index) {
          return _buildButton(context, index);
        }),
      ];
    } else {
      return [
        Row(
          children: List.generate(actionButtons!.length, (index) {
            return Expanded(child: _buildButton(context, index));
          }),
        ),
      ];
    }
  }

  Widget _buildButton(BuildContext context, int index) {
    final actionButton = actionButtons![index];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PaddingDimensions.small,
            vertical: PaddingDimensions.xSmall,
          ),
          child: AppPrimaryButton(
            isExpanded: actionButton.isExpanded,
            text: actionButton.title,
            buttonHeight: Dimensions.buttonMediumHeight,
            onPressed: () => actionButton.onTap(context),
            isOutlined: !actionButton.isPrimary,
            buttonStyle: !actionButton.isPrimary
                ? (style) => style?.copyWith(
                    backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
