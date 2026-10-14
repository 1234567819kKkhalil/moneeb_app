part of app_utils;

extension ContextExt on BuildContext{
  double get width => MediaQuery.sizeOf(this).width;
  double get height => MediaQuery.sizeOf(this).height;
  EdgeInsets get safeAreaPadding => MediaQuery.paddingOf(this);
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);
  double get devicePixelRatio => MediaQuery.devicePixelRatioOf(this);

  double get adaptiveWidth => isLandscape ? MediaQuery.sizeOf(this).height : MediaQuery.sizeOf(this).width;
  double get adaptiveHeight =>  isLandscape ? MediaQuery.sizeOf(this).width : MediaQuery.sizeOf(this).height;

  bool get isLandscape => MediaQuery.orientationOf(this) == Orientation.landscape;

  double getPhysicalScreenWidth() => width * devicePixelRatio;

  bool get isDarkMode {
    return Theme.of(this).brightness == Brightness.dark;
  }

  ThemeData get theme {
    return Theme.of(this);
  }

  AppColors get appColors {
    return Theme.of(this).extension<AppColors>() ?? AppColors.light();
  }

  Color colorDecider({required Color Function(AppColors appColors) onLight, required Color Function(AppColors appColors) onDark}) {
    return isDarkMode ? onDark(appColors) : onLight(appColors);
  }

  TextStyle get light => Theme.of(this).textTheme.bodySmall!;
  TextStyle get regular => Theme.of(this).textTheme.bodyMedium!;
  TextStyle get medium => Theme.of(this).textTheme.bodyLarge!;
  TextStyle get semiBold => Theme.of(this).textTheme.titleMedium!;
  TextStyle get bold => Theme.of(this).textTheme.titleLarge!;
  TextStyle get extraBold => Theme.of(this).textTheme.displaySmall!;
}