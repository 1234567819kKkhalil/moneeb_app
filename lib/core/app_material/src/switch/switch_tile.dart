part of app_material;

class SwitchTile extends StatelessWidget {
  final String? title;
  final bool value;
  final void Function(bool) onChanged;

  const SwitchTile({
    this.title,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (title != null)
            Text(
              title!,
              style: context.medium.copyWith(
                fontSize: Dimensions.xxLarge,
              ),
            ),
          AppSwitcher(
            value: value,
            onChange: onChanged,
            applySwitchOffColor: true,
          ),
        ],
      ),
    );
  }
}
