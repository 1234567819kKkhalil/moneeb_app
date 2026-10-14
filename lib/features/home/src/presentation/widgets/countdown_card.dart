part of home;

class CountdownCard extends StatelessWidget {
  const CountdownCard({super.key});

  static const double _outerSize = 103.0;
  static const double _cardSize = 100.0;
  static const double _cardRadius = 20.0;
  static const double _outerRadius = 20.0;
  static const double _borderWidth = 2.0;
  static const double _arrowSize = 12.0;
  static const double _clockSize = 22.0;

  static Path _buildBorderPath() {
    final half = _borderWidth / 2;
    final r = _outerRadius;
    final s = _outerSize - _borderWidth;
    final path = Path();
    // Start at top-center, go clockwise
    path.moveTo(half + s / 2, half);
    path.lineTo(half + s - r, half);
    path.arcToPoint(
      Offset(half + s, half + r),
      radius: Radius.circular(r),
      clockwise: true,
    );
    path.lineTo(half + s, half + s - r);
    path.arcToPoint(
      Offset(half + s - r, half + s),
      radius: Radius.circular(r),
      clockwise: true,
    );
    path.lineTo(half + r, half + s);
    path.arcToPoint(
      Offset(half, half + s - r),
      radius: Radius.circular(r),
      clockwise: true,
    );
    path.lineTo(half, half + r);
    path.arcToPoint(
      Offset(half + r, half),
      radius: Radius.circular(r),
      clockwise: true,
    );
    path.lineTo(half + s / 2, half);
    return path;
  }

  static Widget _buildMovingClock(double progress) {
    final path = _buildBorderPath();
    final metricsList = path.computeMetrics().toList();
    if (metricsList.isEmpty) return const SizedBox.shrink();
    final metric = metricsList.first;
    final tangent = metric.getTangentForOffset(
      metric.length * progress.clamp(0.0, 1.0),
    );
    if (tangent == null) return const SizedBox.shrink();

    final pos = tangent.position;

    return Positioned(
      left: pos.dx - _clockSize / 2,
      top: pos.dy - _clockSize / 2,
      child: const AppSvg(
        svgPath: AssetPaths.iconTimeSala,
        width: _clockSize,
        height: _clockSize,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTimesCubit, PrayerTimesState>(
      buildWhen: (previous, current) =>
          previous.prayerData != current.prayerData ||
          previous.result != current.result,
      builder: (context, state) {
        final isLoading = state.prayerData.isLoading;
        final progress = state.result.progress;

        return AppSkeletonizer(
          isEnabled: isLoading,
          child: GestureDetector(
            onTap: () {
              AppRouteNavigator.push(
                context,
                PrayerTimesPage.routeName,
                PrayerTimesPage(),
              );
            },
            child: Center(
              child: SizedBox(
                width: _outerSize,
                height: _outerSize,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    // Two-color progress border
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _ProgressBorderPainter(
                          progress: progress,
                          elapsedColor: const Color.fromARGB(255, 59, 65, 61),
                          remainingColor: const Color(0xFFE6C27A),
                          borderWidth: _borderWidth,
                          borderRadius: _outerRadius,
                        ),
                      ),
                    ),

                    // Inner card
                    Container(
                      width: _cardSize,
                      height: _cardSize,
                      decoration: BoxDecoration(
                        color: context.appColors.primary.shade400,
                        borderRadius: BorderRadius.circular(_cardRadius),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              state.result.current.isNotEmpty
                                  ? state.result.current
                                  : state.result.next,
                              style: context.semiBold.copyWith(
                                fontSize: 12,
                                color: context.appColors.neutral.shade900,
                              ),
                            ),
                            Text(
                              appLocalizer.remaining,
                              style: context.medium.copyWith(
                                fontSize: 11,
                                color: context.appColors.neutral.shade900,
                              ),
                            ),
                            Text(
                              context.read<PrayerTimesCubit>().formatDuration(
                                state.result.remaining,
                              ),
                              style: context.semiBold.copyWith(
                                fontSize: 12,
                                color: context.appColors.neutral.shade900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Arrow fixed at top as start-marker
                    const Positioned(
                      top: -8,
                      child: AppSvg(
                        svgPath: AssetPaths.iconTimeSalaArrow,
                        width: _arrowSize,
                        height: _arrowSize,
                      ),
                    ),

                    // Clock icon moves clockwise along the border with progress
                    _buildMovingClock(progress),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProgressBorderPainter extends CustomPainter {
  final double progress;
  final Color elapsedColor;
  final Color remainingColor;
  final double borderWidth;
  final double borderRadius;

  _ProgressBorderPainter({
    required this.progress,
    required this.elapsedColor,
    required this.remainingColor,
    required this.borderWidth,
    required this.borderRadius,
  });

  Path _buildPath(Size size) {
    final half = borderWidth / 2;
    final r = borderRadius;
    final w = size.width - borderWidth;
    final h = size.height - borderWidth;

    final path = Path();
    path.moveTo(half + w / 2, half);
    path.lineTo(half + w - r, half);
    path.arcToPoint(
      Offset(half + w, half + r),
      radius: Radius.circular(r),
      clockwise: true,
    );
    path.lineTo(half + w, half + h - r);
    path.arcToPoint(
      Offset(half + w - r, half + h),
      radius: Radius.circular(r),
      clockwise: true,
    );
    path.lineTo(half + r, half + h);
    path.arcToPoint(
      Offset(half, half + h - r),
      radius: Radius.circular(r),
      clockwise: true,
    );
    path.lineTo(half, half + r);
    path.arcToPoint(
      Offset(half + r, half),
      radius: Radius.circular(r),
      clockwise: true,
    );
    path.lineTo(half + w / 2, half);
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = _buildPath(size);
    final metricsList = path.computeMetrics().toList();
    if (metricsList.isEmpty) return;
    final metric = metricsList.first;
    final totalLength = metric.length;
    if (totalLength <= 0) return;

    final clampedProgress = progress.clamp(0.0, 1.0);
    final elapsedLength = totalLength * clampedProgress;

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.butt;

    // Full border in remaining (gold)
    canvas.drawPath(path, strokePaint..color = remainingColor);

    // Overlay elapsed portion in muted color
    if (elapsedLength > 0) {
      canvas.drawPath(
        metric.extractPath(0, elapsedLength),
        strokePaint..color = elapsedColor,
      );
    }
  }

  @override
  bool shouldRepaint(_ProgressBorderPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.elapsedColor != elapsedColor ||
      oldDelegate.remainingColor != remainingColor ||
      oldDelegate.borderWidth != borderWidth ||
      oldDelegate.borderRadius != borderRadius;
}
