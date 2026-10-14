part of helper_widgets;

class NoItemsFoundWidget extends StatelessWidget {
  final bool enableRefreshSupport;
  final String? svgImagePath;
  final String? text;
  final Color? color;

  const NoItemsFoundWidget(
      {super.key,
      this.enableRefreshSupport = true,
      this.svgImagePath,
      this.text,
      this.color});

  @override
  Widget build(BuildContext context) {
    final styleColor = color ?? context.appColors.neutral.shade900;

    if (enableRefreshSupport) {
      return Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            _BuildNoItemWidget(
                imagePath: svgImagePath, text: text, color: styleColor),
            const SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
            ),
          ]);
    }

    return _BuildNoItemWidget(
        imagePath: svgImagePath, text: text, color: styleColor);
  }
}

class _BuildNoItemWidget extends StatelessWidget {
  final String? imagePath;
  final String? text;
  final Color color;

  const _BuildNoItemWidget({this.imagePath, this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (imagePath != null)
            Padding(
              padding: const EdgeInsets.only(bottom: PaddingDimensions.xLarge),
              child: SvgPicture.asset(
                imagePath!,
                theme: SvgTheme(currentColor: color),
              ),
            ),
          Text(
            text ?? appLocalizer.noItemFoundError,
            style: context.bold.copyWith(fontSize: Dimensions.xxLarge, color: color),
          ),
        ],
      ),
    );
  }
}
