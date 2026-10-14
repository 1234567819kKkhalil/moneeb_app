part of app_material;

class AppExpansionTile extends StatelessWidget {
  final String title;
  final List<Widget> expansionListOfWidget;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Color? iconColor;
  final Decoration? decoration;
  final ShapeBorder? shape;
  final Widget? leading;
  final Widget? trailing;
  final TextStyle? style;
  final bool initiallyExpanded;

  const AppExpansionTile({
    super.key,
    required this.title,
    required this.expansionListOfWidget,
    this.margin,
    this.color,
    this.decoration,
    this.shape,
    this.leading,
    this.trailing,
    this.style,
    this.iconColor,
    this.initiallyExpanded = false,
  });

  static AppExpansionTile defaultExpansionTile({
    required String title,
    required List<Widget> expansionListOfWidget,
  }) {
    return AppExpansionTile(
      title: title,
      expansionListOfWidget: expansionListOfWidget,
    );
  }

  static AppExpansionTile expansionTileWithoutBackground({
    required BuildContext context,
    required String title,
    required List<Widget> expansionListOfWidget,
    Widget? leading,
    Widget? trailing,
    Color? iconColor,
    TextStyle? style,
    bool initiallyExpanded = false,
  }) {
    return AppExpansionTile(
      iconColor: iconColor,
      trailing: trailing,
      leading: leading,
      style: style,
      initiallyExpanded: initiallyExpanded,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.appColors.neutral.shade50,
            width: 1.5,
          ),
        ),
        color:context.appColors.appBackgroundColor,
      ),
      color:context.appColors.appBackgroundColor,
      title: title,
      expansionListOfWidget: expansionListOfWidget,
    );
  }

  static AppExpansionTile leadingAndTrailingExpansionTile({
    required String title,
    required List<Widget> expansionListOfWidget,
    double? marginHorizontalPadding,
    double? marginVerticalPadding,
    Widget? leading,
    Widget? trailing,
    TextStyle? style,
    required BuildContext context
  }) {
    return AppExpansionTile(
      trailing: trailing,
      style: style,
      leading: leading,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.appColors.neutral.shade900,
            width: 1.5,
          ),
        ),
        color:context.appColors.appBackgroundColor,
      ),
      color:context.appColors.appBackgroundColor,
      title: title,
      expansionListOfWidget: expansionListOfWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      clipBehavior: Clip.hardEdge,
      decoration: decoration ??
          BoxDecoration(
            //color: color ?? context.appColors.neutral.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: context.appColors.neutral.shade900, width: 0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha:0.1),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
      child: ExpansionTile(
        leading: leading,
        backgroundColor: color,
        trailing: trailing,
        initiallyExpanded: initiallyExpanded,
        shape: shape ?? InputBorder.none,
        iconColor: context.appColors.neutral.shade500,
        title: Text(
          title,
          style: style ??
              context.medium.copyWith(
                fontSize: Dimensions.large,
              ),
        ),
        children: expansionListOfWidget,
      ),
    );
  }
}
