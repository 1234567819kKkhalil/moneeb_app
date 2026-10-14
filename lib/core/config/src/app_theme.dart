part of config;

class AppThemes {
  // =========================
  // Public API
  // =========================

  static ThemeData get light {
    final colors = AppColors.light();
    return _baseTheme(
      colors,
      isDark: false,
    ).copyWith(colorScheme: _colorScheme(appColors: colors));
  }

  static ThemeData get dark {
    final colors = AppColors.dark();
    return _baseTheme(
      colors,
      isDark: true,
    ).copyWith(colorScheme: _colorScheme(appColors: colors, isDark: true));
  }

  // =========================
  // Base Theme
  // =========================

  static ThemeData _baseTheme(AppColors c, {required bool isDark}) {
    return ThemeData(
      useMaterial3: true,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: c.primary.shade500,
        selectionColor: c.primary.shade500.withOpacity(0.3),
        selectionHandleColor: c.primary.shade500,
      ),
      // pageTransitionsTheme: PageTransitionsTheme(
      //   builders: {
      //     TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
      //     TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      //     TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
      //     TargetPlatform.windows: ZoomPageTransitionsBuilder(),
      //     TargetPlatform.linux: ZoomPageTransitionsBuilder(),
      //   },
      // ),
      datePickerTheme: _datePickerTheme(c),
      canvasColor: c.appBackgroundColor,
      scaffoldBackgroundColor: c.appBackgroundColor,
      fontFamily: _getAppFont(),
      textTheme: _textTheme(c),

      appBarTheme: _appBarTheme(c),
      progressIndicatorTheme: _progressIndicatorTheme(c),

      elevatedButtonTheme: _elevatedButtonTheme(c, isDark),
      outlinedButtonTheme: _outlinedButtonTheme(c),
      textButtonTheme: _textButtonTheme(c, isDark),

      sliderTheme: _sliderTheme(c),
      inputDecorationTheme: _inputDecorationTheme(c),
      radioTheme: _radioTheme(c),
      checkboxTheme: _checkboxTheme(c),
      switchTheme: _switchTheme(c, isDark),
      toggleButtonsTheme: _toggleButtonsTheme(c, isDark),

      chipTheme: _chipTheme(c, isDark),
      listTileTheme: _listTileTheme(c),
      expansionTileTheme: _expansionTileTheme(c),

      bottomSheetTheme: _bottomSheetTheme(c, isDark),
      dialogTheme: _dialogTheme(c, isDark),
      popupMenuTheme: _popupMenuTheme(c),
      menuTheme: _menuTheme(c),

      cardTheme: _cardTheme(c, isDark),
      dividerTheme: DividerThemeData(
        color: isDark ? c.neutral.shade700 : c.neutral.shade300,
      ),
      iconTheme: IconThemeData(color: c.neutral.shade900),
      floatingActionButtonTheme: _fabTheme(c, isDark),

      extensions: _extensions(c),
    );
  }

  // =========================
  // Color Scheme
  // =========================

  static ColorScheme _colorScheme({
    required AppColors appColors,
    bool isDark = false,
  }) => ColorScheme.light(
    primary: appColors.primary.shade500,
    secondary: appColors.secondary.shade500,
    surface: appColors.neutral.shade50,
    error: appColors.danger.shade500,
    onPrimary: isDark ? appColors.neutral.shade900 : appColors.neutral.shade50,
    onSecondary: isDark ? appColors.neutral.shade50 : appColors.neutral.shade900,
    onSurface: appColors.neutral.shade900,
    onError: isDark ? appColors.neutral.shade900 : appColors.neutral.shade50,
  );

  // =========================
  // Typography
  // =========================

  static String _getAppFont() {
    return "LamaSans";
  }

  static TextTheme _textTheme(AppColors c) {
    const size = Dimensions.xLarge;
    return TextTheme(
      bodySmall: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w300,
        color: c.neutral.shade900,
      ),
      bodyMedium: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w400,
        color: c.neutral.shade900,
      ),
      bodyLarge: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w500,
        color: c.neutral.shade900,
      ),
      titleMedium: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: c.neutral.shade900,
      ),
      titleLarge: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: c.neutral.shade900,
      ),
      displaySmall: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w900,
        color: c.neutral.shade900,
      ),
    );
  }

  // =========================
  // Components
  // =========================

  static AppBarTheme _appBarTheme(AppColors c) => AppBarTheme(
    backgroundColor: c.appBackgroundColor,
    foregroundColor: c.neutral.shade50,
    surfaceTintColor: c.appBackgroundColor,
    elevation: 0,
  );

  static ProgressIndicatorThemeData _progressIndicatorTheme(AppColors c) =>
      ProgressIndicatorThemeData(
        linearTrackColor: c.neutral.shade200,
        color: c.secondary.shade500,
      );

  static ElevatedButtonThemeData _elevatedButtonTheme(
    AppColors c,
    bool isDark,
  ) => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: c.primary.shade400,
      foregroundColor: isDark ? c.neutral.shade900 : c.neutral.shade50,
      padding: _buttonPadding,
      shape: _buttonShape,
      disabledBackgroundColor: isDark ? c.neutral.shade400 : c.neutral.shade100,
      elevation: 0,
    ),
  );

  static OutlinedButtonThemeData _outlinedButtonTheme(AppColors c) =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: c.neutral.shade400),
          padding: _buttonPadding,
          shape: _buttonShape,
          foregroundColor: c.neutral.shade700,
        ),
      );

  static TextButtonThemeData _textButtonTheme(AppColors c, bool isDark) =>
      TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: isDark ? c.primary.shade900 : c.primary.shade500,
          shape: _buttonShape,
          padding: const EdgeInsets.all(8),
        ),
      );

  static SliderThemeData _sliderTheme(AppColors c) => SliderThemeData(
    trackHeight: 6,
    activeTrackColor: c.primary.shade500,
    inactiveTrackColor: c.neutral.shade300,
    thumbColor: c.primary.shade500,
  );

  static InputDecorationTheme _inputDecorationTheme(AppColors c) {
    final radius = BorderRadius.circular(12);
    return InputDecorationTheme(
      filled: true,
      fillColor: c.neutral.shade800,
      border: OutlineInputBorder(borderRadius: radius),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide(color: c.primary.shade500, width: 1.2),
      ),
      hintStyle: TextStyle(
        color: c.primary.shade300,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: PaddingDimensions.medium + 2,
      ),
    );
  }

  static RadioThemeData _radioTheme(AppColors c) =>
      RadioThemeData(fillColor: WidgetStatePropertyAll(c.secondary.shade500));

  static CheckboxThemeData _checkboxTheme(AppColors c) => CheckboxThemeData(
    fillColor: WidgetStatePropertyAll(c.neutral.shade500),
    checkColor: WidgetStatePropertyAll(c.primary.shade50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4)),
    ),
  );

  static SwitchThemeData _switchTheme(AppColors c, bool isDark) =>
      SwitchThemeData(
        thumbColor: WidgetStatePropertyAll(
          isDark ? c.secondary.shade500 : c.secondary.shade500,
        ),
        trackColor: WidgetStatePropertyAll(
          isDark ? c.neutral.shade900 : c.neutral.shade900,
        ),
      );

  static ToggleButtonsThemeData _toggleButtonsTheme(AppColors c, bool isDark) =>
      ToggleButtonsThemeData(
        borderColor: c.neutral.shade500,
        selectedBorderColor: c.primary.shade500,
        selectedColor: c.primary.shade500,
        borderWidth: 2,
      );

  static ChipThemeData _chipTheme(AppColors c, bool isDark) => ChipThemeData(
    backgroundColor: c.primary.shade100,
    selectedColor: c.primary.shade500,
    labelStyle: TextStyle(
      color: isDark ? c.neutral.shade900 : c.neutral.shade50,
    ),
  );

  static ExpansionTileThemeData _expansionTileTheme(AppColors c) =>
      ExpansionTileThemeData(
        backgroundColor: c.neutral.shade100,
        collapsedBackgroundColor: c.neutral.shade50,
        iconColor: c.primary.shade500,
      );

  static BottomSheetThemeData _bottomSheetTheme(AppColors c, bool isDark) =>
      BottomSheetThemeData(
        backgroundColor: isDark ? c.neutral.shade800 : c.appBackgroundColor,
      );

  static DialogThemeData _dialogTheme(AppColors c, bool isDark) =>
      DialogThemeData(
        backgroundColor: isDark ? c.neutral.shade100 : c.appBackgroundColor,
      );

  static PopupMenuThemeData _popupMenuTheme(AppColors c) => PopupMenuThemeData(
    color: c.neutral.shade50,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  static MenuThemeData _menuTheme(AppColors c) => MenuThemeData(
    style: MenuStyle(
      backgroundColor: WidgetStatePropertyAll(c.neutral.shade200),
    ),
  );

  static ListTileThemeData _listTileTheme(AppColors c) => ListTileThemeData(
    iconColor: c.primary.shade500,
    textColor: c.neutral.shade900,
  );

  static CardThemeData _cardTheme(AppColors c, bool isDark) => CardThemeData(
    color: isDark ? c.neutral.shade800 : c.neutral.shade50,
    elevation: 2,
    margin: const EdgeInsets.all(8),
  );

  static FloatingActionButtonThemeData _fabTheme(AppColors c, bool isDark) =>
      FloatingActionButtonThemeData(
        backgroundColor: c.primary.shade500,
        foregroundColor: isDark ? c.neutral.shade800 : c.neutral.shade50,
      );

  // =========================
  // Shared
  // =========================

  static const _buttonPadding = EdgeInsets.symmetric(
    horizontal: PaddingDimensions.regular,
    vertical: 14,
  );

  static final _buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(Dimensions.large),
  );

  static DatePickerThemeData _datePickerTheme(AppColors c) {
    return DatePickerThemeData(
      // ─────────────────────────────────────────────
      // Base surfaces
      // ─────────────────────────────────────────────
      backgroundColor: c.neutral.shade100,
      surfaceTintColor: c.neutral.shade200,
      shadowColor: c.neutral.shade300,
      elevation: 1,

      // ─────────────────────────────────────────────
      // Header (month / year / navigation)
      // ─────────────────────────────────────────────
      headerBackgroundColor: c.neutral.shade100,
      headerForegroundColor: c.neutral.shade900,
      subHeaderForegroundColor: c.neutral.shade900,
      headerHelpStyle: TextStyle(
        color: c.neutral.shade600,
        fontWeight: FontWeight.w400,
      ),
      headerHeadlineStyle: TextStyle(
        color: c.neutral.shade900,
        fontWeight: FontWeight.w600,
      ),

      // Range picker header
      rangePickerHeaderForegroundColor: c.neutral.shade900,
      rangePickerHeaderBackgroundColor: c.appBackgroundColor,
      rangePickerHeaderHeadlineStyle: TextStyle(
        color: c.neutral.shade900,
        fontWeight: FontWeight.w600,
      ),
      rangePickerHeaderHelpStyle: TextStyle(color: c.neutral.shade600),

      // ─────────────────────────────────────────────
      // Weekday labels (Mon, Tue, …)
      // ─────────────────────────────────────────────
      weekdayStyle: TextStyle(
        color: c.neutral.shade600,
        fontWeight: FontWeight.w500,
      ),

      // ─────────────────────────────────────────────
      // Day cells
      // ─────────────────────────────────────────────
      dayStyle: TextStyle(
        color: c.neutral.shade900,
        fontWeight: FontWeight.w400,
      ),
      dayForegroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return c.neutral.shade400;
        }
        if (states.contains(MaterialState.selected)) {
          return c.neutral.shade50;
        }
        return c.neutral.shade900;
      }),
      dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return c.primary.shade800;
        }
        return Colors.transparent;
      }),
      dayOverlayColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.hovered) ||
            states.contains(MaterialState.pressed)) {
          return c.primary.shade500.withOpacity(0.08);
        }
        return null;
      }),

      // ─────────────────────────────────────────────
      // Today
      // ─────────────────────────────────────────────
      todayForegroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return c.neutral.shade800;
        }

        return c.primary.shade700;
      }),
      todayBackgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return c.primary.shade500;
        }
        return c.primary.shade500.withOpacity(0.12);
      }),
      todayBorder: BorderSide(color: c.primary.shade500, width: 1.5),

      // ─────────────────────────────────────────────
      // Year picker
      // ─────────────────────────────────────────────
      yearStyle: TextStyle(
        color: c.neutral.shade900,
        fontWeight: FontWeight.w500,
      ),
      yearForegroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return c.neutral.shade50;
        }
        if (states.contains(MaterialState.disabled)) {
          return c.neutral.shade400;
        }
        return c.neutral.shade900;
      }),
      yearBackgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return c.primary.shade500;
        }
        return Colors.transparent;
      }),
      yearOverlayColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.hovered) ||
            states.contains(MaterialState.pressed)) {
          return c.primary.shade500.withOpacity(0.08);
        }
        return null;
      }),

      // ─────────────────────────────────────────────
      // Range selection
      // ─────────────────────────────────────────────
      rangeSelectionBackgroundColor: c.primary.shade500.withOpacity(0.12),
      rangeSelectionOverlayColor: MaterialStateProperty.all(
        c.primary.shade500.withOpacity(0.08),
      ),

      // ─────────────────────────────────────────────
      // Toggle buttons (Year / Day switch)
      // ─────────────────────────────────────────────
      toggleButtonTextStyle: TextStyle(
        color: c.neutral.shade900,
        fontWeight: FontWeight.w500,
      ),
      // ─────────────────────────────────────────────
      // Dividers & shape
      // ─────────────────────────────────────────────
      dividerColor: c.neutral.shade200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  static List<ThemeExtension<dynamic>> _extensions(AppColors c) => [
    c,
    SkeletonizerConfigData(
      containersColor: c.neutral.shade50,
      effect: ShimmerEffect(
        baseColor: c.neutral.shade100,
        highlightColor: c.neutral.shade100,
        duration: const Duration(milliseconds: 6600),
      ),
    ),
  ];
}
