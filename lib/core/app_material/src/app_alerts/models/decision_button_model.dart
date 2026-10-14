part of app_material;

class DecisionButtonModel {
  final String title;
  final Function(BuildContext context) onTap;
  final bool isPrimary;
  final bool isExpanded;

  DecisionButtonModel({
    required this.title,
    required this.onTap,
    this.isPrimary = false,
    this.isExpanded = true,
  });
}
