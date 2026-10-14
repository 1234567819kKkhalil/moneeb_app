part of core;

/// The only splash the user actually sees.
///
/// The native splash (flutter_native_splash.yaml) is intentionally blank with
/// the same background color, so this page fades in on top of it without any
/// visible hand-off between two different splashes.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  static const double _logoSize = 225;

  /// The welcome text sits above the visible artwork, inside the transparent
  /// top margin of the logo image.
  static const double _welcomeBottomOffset = _logoSize - 30;

  @override
  Widget build(BuildContext context) {
    // Always dark, regardless of the user's theme, like the native splash.
    final colors = AppColors.dark();

    return Scaffold(
      backgroundColor: colors.appBackgroundColor,
      body: _FadeIn(
        child: SizedBox.expand(
          child: Stack(
            children: [
              Center(
                child: SizedBox(
                  width: _logoSize,
                  height: _logoSize,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          AssetPaths.splashLogo,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                      Positioned(
                        left: -60,
                        right: -60,
                        bottom: _welcomeBottomOffset,
                        child: Text(
                          appLocalizer.welcomeSplash,
                          textAlign: TextAlign.center,
                          style: context.extraBold.copyWith(
                            color: colors.secondary.shade500,
                            fontSize: 26,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: PaddingDimensions.large,
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CustomAnimationLoading(),
                        const SizedBox(height: 18),
                        Text(
                          appLocalizer.allRightsReserved,
                          style: context.regular.copyWith(
                            color: colors.neutral.shade400,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FadeIn extends StatelessWidget {
  const _FadeIn({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      builder: (context, value, child) => Opacity(opacity: value, child: child),
      child: child,
    );
  }
}
