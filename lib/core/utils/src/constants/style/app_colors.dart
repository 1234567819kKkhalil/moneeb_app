part of app_utils;

class AppColors extends ThemeExtension<AppColors> {
  static const oliveGreen = Color(0xFF545A44);

  // =========================
  // PRIMARY
  // =========================
  static const primary50 = Color(0xFFE3E8E7);
  static const primary100 = Color(0xFFBAC6C3);
  static const primary200 = Color(0xFF8D9F9B);
  static const primary300 = Color(0xFF607973);
  static const primary400 = Color(0xFF3E5C56);
  static const primary500 = Color(0xFF172A24);
  static const primary600 = Color(0xFF14251F);
  static const primary700 = Color(0xFF111F1B);
  static const primary800 = Color(0xFF0D1916);
  static const primary900 = Color(0xFF070D0B);

  // =========================
  // SECONDARY
  // =========================
  static const secondary50 = Color(0xFFFBF8EE);
  static const secondary100 = Color(0xFFF5EDD5);
  static const secondary200 = Color(0xFFEFE2BA);
  static const secondary300 = Color(0xFFE9D79F);
  static const secondary400 = Color(0xFFE5CF88);
  static const secondary500 = Color(0xFFE2CA91);
  static const secondary600 = Color(0xFFE0C589);
  static const secondary700 = Color(0xFFDDBF7E);
  static const secondary800 = Color(0xFFDBB974);
  static const secondary900 = Color(0xFFD7AF62);

  // =========================
  // NEUTRAL
  // =========================
  static const neutral50 = Color(0xFFFFFFFF);
  static const neutral100 = Color(0xFFF8F8F8);
  static const neutral200 = Color(0xFFF1F1F1);
  static const neutral300 = Color(0xFFE0E0E0);
  static const neutral400 = Color(0xFFCDCDCD);
  static const neutral500 = Color(0xFF9C9D9E);
  static const neutral600 = Color(0xFF707070);
  static const neutral700 = Color(0xFF5A5A5A);
  static const neutral800 = Color(0xFF3D3B3F);
  static const neutral900 = Color(0xFF000000);

  // =========================
  // SUCCESS
  // =========================
  static const success50 = Color(0xFFE0F2F1);
  static const success100 = Color(0xFFB2DFDB);
  static const success200 = Color(0xFF80CBC4);
  static const success300 = Color(0xFF4DB6AC);
  static const success400 = Color(0xFF26A69A);
  static const success500 = Color(0xFF2DC9A4);
  static const success600 = Color(0xFF178C71);
  static const success700 = Color(0xFF027961);
  static const success800 = Color(0xFF00695C);
  static const success900 = Color(0xFF004D40);

  // =========================
  // DANGER
  // =========================
  static const danger50 = Color(0xFFFFE8E8);
  static const danger100 = Color(0xFFFFCDD2);
  static const danger200 = Color(0xFFEF9A9A);
  static const danger300 = Color(0xFFE57373);
  static const danger400 = Color(0xFFEF5350);
  static const danger500 = Color(0xFFFF0A0E);
  static const danger600 = Color(0xFFC72C41);
  static const danger700 = Color(0xFFAF2D2D);
  static const danger800 = Color(0xFFB71C1C);
  static const danger900 = Color(0xFF9B0000);

  // =========================
  //  WARNING
  // =========================
  static const warning50 = Color(0xFFFFFDE7);
  static const warning100 = Color(0xFFFFF9C4);
  static const warning200 = Color(0xFFFFF59D);
  static const warning300 = Color(0xFFFFF176);
  static const warning400 = Color(0xFFFFEE58);
  static const warning500 = Color(0xFFFFE500);
  static const warning600 = Color(0xFFFBC02D);
  static const warning700 = Color(0xFFF9A825);
  static const warning800 = Color(0xFFF57F17);
  static const warning900 = Color(0xFFE65100);

  const AppColors._({
    required this.appBackgroundColor,
    required this.backgroundColorForProviderCard,
    required this.appBorderColor,
    required this.primary,
    required this.secondary,
    required this.neutral,
    required this.success,
    required this.danger,
    required this.warning,
  });

  final Color appBackgroundColor;
  final Color backgroundColorForProviderCard;
  final Color appBorderColor;

  final ColorShades primary;
  final ColorShades secondary;

  final ColorShades neutral;

  final ColorShades success;
  final ColorShades danger;
  final ColorShades warning;

  factory AppColors.light() {
    return AppColors._(
      appBackgroundColor: Colors.white,
      backgroundColorForProviderCard: Color(0xFF2F2F2F),
      appBorderColor: Color(0xffAFB0B0),
      primary: _PrimaryColors(),
      danger: _DangerColors(),
      neutral: _NeutralColors(),
      secondary: _SecondaryColors(),
      success: _SuccessColors(),
      warning: _WarningColors(),
    );
  }

  factory AppColors.dark() {
    return AppColors._(
      appBackgroundColor: Color(0xFF1B1E23),
      backgroundColorForProviderCard: Color(0xFF2F2F2F),
      appBorderColor: Color(0xffAFB0B0),
      primary: _PrimaryColors().dark(),
      danger: _DangerColors().dark(),
      neutral: _NeutralColors().dark(),
      secondary: _SecondaryColors().dark(),
      success: _SuccessColors().dark(),
      warning: _WarningColors().dark(),
    );
  }

  @override
  AppColors copyWith() {
    return AppColors._(
      appBackgroundColor: appBackgroundColor,
      backgroundColorForProviderCard: backgroundColorForProviderCard,
      appBorderColor: appBorderColor,
      warning: warning,
      success: success,
      secondary: secondary,
      neutral: neutral,
      danger: danger,
      primary: primary,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;

    return AppColors._(
      appBackgroundColor: Color.lerp(
        appBackgroundColor,
        other.appBackgroundColor,
        t,
      )!,
      backgroundColorForProviderCard: Color.lerp(
        backgroundColorForProviderCard,
        other.backgroundColorForProviderCard,
        t,
      )!,
      appBorderColor: Color.lerp(appBorderColor, other.appBorderColor, t)!,
      warning: warning.lerp(other.warning, t),
      success: success.lerp(other.success, t),
      secondary: secondary.lerp(other.secondary, t),
      primary: primary.lerp(other.primary, t),
      neutral: neutral.lerp(other.neutral, t),
      danger: danger.lerp(other.danger, t),
    );
  }
}

class ColorShades {
  final Color shade50;
  final Color shade100;
  final Color shade200;
  final Color shade300;
  final Color shade400;
  final Color shade500;
  final Color shade600;
  final Color shade700;
  final Color shade800;
  final Color shade900;
  ColorShades({
    required this.shade50,
    required this.shade100,
    required this.shade200,
    required this.shade300,
    required this.shade400,
    required this.shade500,
    required this.shade600,
    required this.shade700,
    required this.shade800,
    required this.shade900,
  });

  ColorShades copyWith({
    Color? shade50,
    Color? shade100,
    Color? shade200,
    Color? shade300,
    Color? shade400,
    Color? shade500,
    Color? shade600,
    Color? shade700,
    Color? shade800,
    Color? shade900,
  }) {
    return ColorShades(
      shade50: shade50 ?? this.shade50,
      shade100: shade100 ?? this.shade100,
      shade200: shade200 ?? this.shade200,
      shade300: shade300 ?? this.shade300,
      shade400: shade400 ?? this.shade400,
      shade500: shade500 ?? this.shade500,
      shade600: shade600 ?? this.shade600,
      shade700: shade700 ?? this.shade700,
      shade800: shade800 ?? this.shade800,
      shade900: shade900 ?? this.shade900,
    );
  }

  ColorShades lerp(ColorShades? other, double t) {
    if (other is! ColorShades) return this;

    return ColorShades(
      shade50: Color.lerp(shade50, other.shade50, t)!,
      shade100: Color.lerp(shade100, other.shade100, t)!,
      shade200: Color.lerp(shade200, other.shade200, t)!,
      shade300: Color.lerp(shade300, other.shade300, t)!,
      shade400: Color.lerp(shade400, other.shade400, t)!,
      shade500: Color.lerp(shade500, other.shade500, t)!,
      shade600: Color.lerp(shade600, other.shade600, t)!,
      shade700: Color.lerp(shade700, other.shade700, t)!,
      shade800: Color.lerp(shade800, other.shade800, t)!,
      shade900: Color.lerp(shade900, other.shade900, t)!,
    );
  }

  ColorShades reverse() {
    return ColorShades(
      shade50: shade900,
      shade100: shade800,
      shade200: shade700,
      shade300: shade600,
      shade400: shade500,
      shade500: shade400,
      shade600: shade300,
      shade700: shade200,
      shade800: shade100,
      shade900: shade50,
    );
  }
}

class _PrimaryColors extends ColorShades {
  _PrimaryColors({
    super.shade50 = AppColors.primary50,
    super.shade100 = AppColors.primary100,
    super.shade200 = AppColors.primary200,
    super.shade300 = AppColors.primary300,
    super.shade400 = AppColors.primary400,
    super.shade500 = AppColors.primary500,
    super.shade600 = AppColors.primary600,
    super.shade700 = AppColors.primary700,
    super.shade800 = AppColors.primary800,
    super.shade900 = AppColors.primary900,
  });

  _PrimaryColors dark() {
    return _PrimaryColors(
      shade50: shade900,
      shade100: shade800,
      shade200: shade700,
      shade300: shade600,
      shade400: shade500,
      shade500: shade400,
      shade600: shade300,
      shade700: shade200,
      shade800: shade100,
      shade900: shade50,
    );
  }
}

class _SecondaryColors extends ColorShades {
  _SecondaryColors({
    super.shade50 = AppColors.secondary50,
    super.shade100 = AppColors.secondary100,
    super.shade200 = AppColors.secondary200,
    super.shade300 = AppColors.secondary300,
    super.shade400 = AppColors.secondary400,
    super.shade500 = AppColors.secondary500,
    super.shade600 = AppColors.secondary600,
    super.shade700 = AppColors.secondary700,
    super.shade800 = AppColors.secondary800,
    super.shade900 = AppColors.secondary900,
  });

  _SecondaryColors dark() {
    return _SecondaryColors(
      shade50: shade900,
      shade100: shade800,
      shade200: shade700,
      shade300: shade600,
      shade400: shade500,
      shade500: shade400,
      shade600: shade300,
      shade700: shade200,
      shade800: shade100,
      shade900: shade50,
    );
  }
}

class _NeutralColors extends ColorShades {
  _NeutralColors({
    super.shade50 = AppColors.neutral50,
    super.shade100 = AppColors.neutral100,
    super.shade200 = AppColors.neutral200,
    super.shade300 = AppColors.neutral300,
    super.shade400 = AppColors.neutral400,
    super.shade500 = AppColors.neutral500,
    super.shade600 = AppColors.neutral600,
    super.shade700 = AppColors.neutral700,
    super.shade800 = AppColors.neutral800,
    super.shade900 = AppColors.neutral900,
  });

  _NeutralColors dark() {
    return _NeutralColors(
      shade50: shade900,
      shade100: shade800,
      shade200: shade700,
      shade300: shade600,
      shade400: shade500,
      shade500: shade400,
      shade600: shade300,
      shade700: shade200,
      shade800: shade100,
      shade900: shade50,
    );
  }
}

class _SuccessColors extends ColorShades {
  _SuccessColors({
    super.shade50 = AppColors.success50,
    super.shade100 = AppColors.success100,
    super.shade200 = AppColors.success200,
    super.shade300 = AppColors.success300,
    super.shade400 = AppColors.success400,
    super.shade500 = AppColors.success500,
    super.shade600 = AppColors.success600,
    super.shade700 = AppColors.success700,
    super.shade800 = AppColors.success800,
    super.shade900 = AppColors.success900,
  });

  _SuccessColors dark() {
    return _SuccessColors(
      shade50: shade900,
      shade100: shade800,
      shade200: shade700,
      shade300: shade600,
      shade400: shade500,
      shade500: shade400,
      shade600: shade300,
      shade700: shade200,
      shade800: shade100,
      shade900: shade50,
    );
  }
}

class _DangerColors extends ColorShades {
  _DangerColors({
    super.shade50 = AppColors.danger50,
    super.shade100 = AppColors.danger100,
    super.shade200 = AppColors.danger200,
    super.shade300 = AppColors.danger300,
    super.shade400 = AppColors.danger400,
    super.shade500 = AppColors.danger500,
    super.shade600 = AppColors.danger600,
    super.shade700 = AppColors.danger700,
    super.shade800 = AppColors.danger800,
    super.shade900 = AppColors.danger900,
  });

  _DangerColors dark() {
    return _DangerColors(
      shade50: shade900,
      shade100: shade800,
      shade200: shade700,
      shade300: shade600,
      shade400: shade500,
      shade500: shade400,
      shade600: shade300,
      shade700: shade200,
      shade800: shade100,
      shade900: shade50,
    );
  }
}

class _WarningColors extends ColorShades {
  _WarningColors({
    super.shade50 = AppColors.warning50,
    super.shade100 = AppColors.warning100,
    super.shade200 = AppColors.warning200,
    super.shade300 = AppColors.warning300,
    super.shade400 = AppColors.warning400,
    super.shade500 = AppColors.warning500,
    super.shade600 = AppColors.warning600,
    super.shade700 = AppColors.warning700,
    super.shade800 = AppColors.warning800,
    super.shade900 = AppColors.warning900,
  });

  _WarningColors dark() {
    return _WarningColors(
      shade50: shade900,
      shade100: shade800,
      shade200: shade700,
      shade300: shade600,
      shade400: shade500,
      shade500: shade400,
      shade600: shade300,
      shade700: shade200,
      shade800: shade100,
      shade900: shade50,
    );
  }
}
