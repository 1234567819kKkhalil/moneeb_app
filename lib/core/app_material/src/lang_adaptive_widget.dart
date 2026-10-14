part of app_material;

class LangAdaptiveWidget extends StatelessWidget {
  final Widget child;
  final int? degreeInAr;

  const LangAdaptiveWidget({super.key, required this.child, this.degreeInAr});

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: context.read<AppLanguageCubit>().state.langCode.isArabic
          ? degreeInAr ?? 90
          : 0,
      child: child,
    );
  }
}
