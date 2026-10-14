part of app_utils;

/// xSmall = 6;
///
/// small = 8;
///
/// normal = 10;
///
/// large = 12;
///
/// xLarge = 14 ;
///
/// xxLarge =  16;
///
/// xxxLarge = 18;
///
/// xxxxLarge = 20;
///
/// xxxxxLarge = 22;
///
/// smallDisplay = 24;
///
/// mediumDisplay = 30;
///
/// largeDisplay = 48;

class Dimensions {
  Dimensions._();

  static const double xSmall = 6;
  static const double small = 8;
  static const double normal = 10;
  static const double large = 12;
  static const double xLarge = 14;
  static const double xxLarge = 16;
  static const double xxxLarge = 18;
  static const double xxxxLarge = 20;
  static const double xxxxxLarge = 22;
  static const double smallDisplay = 24;
  static const double mediumDisplay = 32;
  static const double largeDisplay = 48;

  static const double buttonHeight = 56;
  static const double buttonMediumHeight = 48;
  static const double buttonMinHeight = 32;

  static const double pickerItemHeight = 30;

  static const double toolbarHeight = kToolbarHeight;

  static const double xSmallRadius = 2.0;
  static const double smallRadius = 4.0;
  static const double regularRadius = 8.0;
  static const double mediumRadius = 12.0;
  static const double largeRadius = 16.0;
  static const double xLargeRadius = 24.0;
  static const double xxLargeRadius = 48.0;

  /// Height of the floating bottom nav bar's own content (card height + its
  /// top gap), not counting the device's bottom safe-area inset. Must match
  /// the container height + top padding in MainHostBottomNavBar. Use with
  /// `MediaQuery.of(context).viewPadding.bottom` to get the full space a
  /// screen needs to reserve so its scrollable content never sits behind the
  /// nav bar.
  static const double bottomNavBarReservedHeight = 80;

  /// Full bottom padding a screen needs to reserve so its scrollable content
  /// never sits behind the floating bottom nav bar: [bottomNavBarReservedHeight]
  /// + the device's bottom safe-area inset + [extra] breathing room.
  static double bottomNavBarSafePadding(
    BuildContext context, {
    double extra = 40,
  }) {
    return bottomNavBarReservedHeight +
        MediaQuery.of(context).viewPadding.bottom +
        extra;
  }
}

class IconDimensions {
  IconDimensions._();

  static const double xxxSmall = 12;
  static const double xxSmall = 14;
  static const double xSmall = 16;
  static const double small = 18;
  static const double normal = 20;
  static const double medium = 24;
  static const double large = 32;
  static const double xLarge = 40;
  static const double xxLarge = 50;
}

/// xSmall = 4 ;
///
/// small = 6;
///
/// normal =  8;
///
/// regular = 10;
///
/// medium = 12;
///
/// large = 16;
///
/// xLarge = 24;
///
/// xxLarge = 32;
///
/// xxxLarge = 40;
///
/// xxxxLarge = 48;
///
class PaddingDimensions {
  PaddingDimensions._();

  static const double xSmall = 4;
  static const double small = 6;
  static const double normal = 8;
  static const double regular = 10;
  static const double medium = 12;
  static const double large = 16;
  static const double mLarge = 18;
  static const double xLarge = 24;
  static const double xxLarge = 32;
  static const double xxxLarge = 40;
  static const double xxxxLarge = 48;

  //Page Padding
  static EdgeInsetsDirectional pageMargins =
      const EdgeInsetsDirectional.symmetric(
    horizontal: PaddingDimensions.pageHorizontalPadding,
    vertical: PaddingDimensions.pageVerticalPadding,
  );

  static const double pageHorizontalPadding = large;
  static const double pageVerticalPadding = large;
}
