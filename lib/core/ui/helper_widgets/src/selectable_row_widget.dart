part of helper_widgets;

class SelectableRowWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String? selectedValue;
  final bool withRoundedBackground;
  final bool showCompleteSelectedIcon;
  final Color? backgroundColor;
  final Color? borderColor;

  const SelectableRowWidget({
    super.key,
    required this.onTap,
    required this.title,
    this.showCompleteSelectedIcon = true,
    this.withRoundedBackground = false,
    this.selectedValue,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: (withRoundedBackground)
          ? _buildWidget(context).roundedRectangleBorder(
              context,
              horizontalMargin: 0,
              verticalPadding: PaddingDimensions.large,
              radius: 4,
              borderWidth: .5,
              backgroundColor: backgroundColor,
              borderColor: borderColor,
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                vertical: PaddingDimensions.normal,
              ),
              child: _buildWidget(context),
            ),
    );
  }

  Widget _buildWidget(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (selectedValue != null && showCompleteSelectedIcon) ...[
          Icon(
            Icons.search,
            size: IconDimensions.small,
            color: context.appColors.success.shade300,
          ),
          const SizedBox(width: PaddingDimensions.normal),
          Expanded(flex: 3, child: Text(title, style: context.regular)),
        ] else ...[
          Expanded(
            child: Text(
              title,
              style: context.regular.copyWith(fontSize: Dimensions.xxLarge),
            ),
          ),
        ],
        if (selectedValue != null) ...[
          Expanded(
            child: Text(
              selectedValue ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: context.regular.copyWith(
                color: context.appColors.neutral.shade600,
                fontSize: Dimensions.large,
              ),
            ),
          ),
        ] else ...[
          Text(appLocalizer.tapToSelect, style: context.regular),
        ],
        const SizedBox(width: PaddingDimensions.normal),
        const LangAdaptiveWidget(
          child: AppShader(
            child: Icon(Icons.arrow_left, size: IconDimensions.small),
          ),
        ),
      ],
    );
  }
}
