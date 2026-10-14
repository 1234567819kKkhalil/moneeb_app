part of app_material;

class AppCheckBoxTile extends StatelessWidget {
  final bool value;
  final void Function(bool? value)? onChanged;
  final Widget? child;
  final String? title;
  final Widget? subTitle;
  final EdgeInsetsGeometry? paddingInsets;
  final Color? unselectedColor;
  final bool? enabled;
  final double titleHorizontalGap;
  final double checkboxScaleFactor;

  const AppCheckBoxTile({
    super.key,
    required this.value,
    this.onChanged,
    this.child,
    this.paddingInsets,
    this.unselectedColor,
    this.subTitle,
    this.title,
    this.enabled,
    this.titleHorizontalGap = 1,
    this.checkboxScaleFactor = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        unselectedWidgetColor: unselectedColor ?? context.appColors.primary.shade500,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        disabledColor: context.appColors.primary.shade500,
        useMaterial3: false,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        listTileTheme: ListTileThemeData(horizontalTitleGap: titleHorizontalGap),
        checkboxTheme: const CheckboxThemeData(materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
      ),
      child: CheckboxListTile(
        visualDensity: const VisualDensity(horizontal: -3, vertical: -4),
        subtitle: subTitle,
        dense: true,
        value: value,
        checkboxScaleFactor: checkboxScaleFactor,
        enabled: enabled,
        onChanged: onChanged,
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: context.appColors.primary.shade500,
        side: BorderSide(
          color: enabled == false
              ? context.appColors.neutral.shade600
              : context.appColors.neutral.shade300,
          width: 1.1,
        ),
        contentPadding: paddingInsets ?? EdgeInsets.zero,

        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
        title: title != null
            ? Text(
          title ?? '',
          style: value
              ? context.bold.copyWith(
            fontSize: Dimensions.large,
          )
              : context.medium.copyWith(
            fontSize: Dimensions.large,
          ),
        )
            : child,
      ),
    );
  }
}
