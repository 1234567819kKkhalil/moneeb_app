part of app_material;

class SwitcherThemeMode extends StatelessWidget {
  const SwitcherThemeMode({super.key});

  @override
  Widget build(BuildContext context) {
    final currentTheme = context.watch<AppThemeCubit>().state;

    return GroupRadioTile(
      value: currentTheme,
      values: ThemeMode.values,
      textColor: context.appColors.primary.shade900,
      selectedColor: context.appColors.primary.shade900,
      onChanged: (value) {
        if (value != null) {
          context.read<AppThemeCubit>().updateTheme(value);
        }
      },
      textList: ThemeMode.values.map((theme) {
        switch (theme) {
          case ThemeMode.system:
            return appLocalizer.useSystemSetting;
          case ThemeMode.light:
            return appLocalizer.light;
          case ThemeMode.dark:
            return appLocalizer.dark;
        }
      }).toList(),
    );
  }
}