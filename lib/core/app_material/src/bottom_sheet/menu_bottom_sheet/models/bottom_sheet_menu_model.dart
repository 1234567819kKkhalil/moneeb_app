part of app_material;

class MenuBottomSheetModel extends Equatable {
  final Function(BuildContext context)? onTap;
  final IconData? icon;
  final String title;
  final String? subTitle;
  final Color? activeColor;
  final bool? isSelected;
  final Color? titleColor;
  final Color? iconColor;

  const MenuBottomSheetModel({
    this.onTap,
    this.icon,
    required this.title,
    this.subTitle,
    this.isSelected,
    this.activeColor,
    this.titleColor,
    this.iconColor,
  });

  MenuBottomSheetModel reduce({
    IconData? icon,
    String? title,
    Color? activeColor,
    Function(BuildContext context)? onTap,
  }) {
    return MenuBottomSheetModel(
      onTap: onTap ?? this.onTap,
      icon: icon ?? this.icon,
      title: title ?? this.title,
      activeColor: activeColor ?? this.activeColor,
      iconColor: iconColor,
      isSelected: isSelected,
      subTitle: subTitle,
      titleColor: titleColor
    );
  }

  @override
  List<Object?> get props => [
    icon,
    title,
    subTitle,
    activeColor,
    onTap,
  ];
}
