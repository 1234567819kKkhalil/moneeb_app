import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../utils/utils_imports.dart';

class CustomAnimationLoading extends StatefulWidget {
  final double size;
  // final Color color;

  const CustomAnimationLoading({super.key, this.size = 35});

  @override
  State<CustomAnimationLoading> createState() => _CustomAnimationLoadingState();
}

class _CustomAnimationLoadingState extends State<CustomAnimationLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: CustomPaint(
        size: Size(widget.size, widget.size),
        painter: _LoaderPainter(color: context.appColors.secondary.shade500),
      ),
    );
  }
}

class _LoaderPainter extends CustomPainter {
  final Color color;
  _LoaderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // 1. Draw the Solid Arc (The left half)
    canvas.drawArc(rect, math.pi / 2, math.pi, false, paint);

    // 2. Draw the Dashed Arc (The right half)
    final dashPaint = Paint()
      ..color = color.withOpacity(0.8)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double startAngle = -math.pi / 2;
    double sweepAngle = math.pi;
    int dashCount = 5;
    double dashSpace = sweepAngle / (dashCount * 2 - 1);

    for (int i = 0; i < dashCount; i++) {
      canvas.drawArc(
        rect,
        startAngle + (i * 2 * dashSpace),
        dashSpace,
        false,
        dashPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
