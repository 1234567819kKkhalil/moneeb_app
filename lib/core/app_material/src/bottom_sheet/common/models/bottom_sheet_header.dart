part of app_material;

class BottomSheetHeader {
  final String? title;
  final bool showDivider;
  final Widget? trailing;
  final Widget? prefix;

  const BottomSheetHeader({
    required this.title,
    this.trailing,
    this.prefix,
    this.showDivider = true,
  });
}
