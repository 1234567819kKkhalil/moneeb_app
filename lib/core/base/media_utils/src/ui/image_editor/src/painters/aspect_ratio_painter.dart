part of image_editor;

class AspectRatioPainter extends CustomPainter {
  AspectRatioPainter({
    this.aspectRatioText,
    this.aspectRatio,
    this.isSelected = false,
    required this.selectedColor,
  });
  final String? aspectRatioText;
  final double? aspectRatio;
  final bool isSelected;
  final Color selectedColor;
  @override
  void paint(Canvas canvas, Size size) {
    final Color color = isSelected ? selectedColor : Colors.grey;
    final Rect rect = Offset.zero & size;

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(10)), paint);

    paint.color = Colors.white;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2.0;
    final double aspectRatioResult =
    (aspectRatio != null && aspectRatio! > 0.0) ? aspectRatio! : 1.0;
    canvas.drawRect(
      getDestinationRect(
          rect: const EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 5)
              .deflateRect(rect),
          inputSize: Size(
            aspectRatioResult * size.width / 2,
            size.width / 2,
          ),
          fit: BoxFit.contain),
      paint,
    );

    final TextPainter textPainter = TextPainter(
        text: TextSpan(
            text: aspectRatioText,
            style: AppRouteNavigator.navigatorKey.currentContext?.regular.copyWith(
              color:
              color.computeLuminance() < 0.5 ? Colors.white : Colors.black,
              fontSize: 11.0,
            )),
        textDirection: TextDirection.ltr,
        maxLines: 1);
    textPainter.layout(maxWidth: rect.width);

    textPainter.paint(
      canvas,
      rect.bottomCenter -
          Offset(
            textPainter.width / 2.0,
            textPainter.height * 1.1,
          ),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate is AspectRatioPainter &&
        (oldDelegate.isSelected != isSelected ||
            oldDelegate.aspectRatioText != aspectRatioText ||
            oldDelegate.aspectRatio != aspectRatio ||
            oldDelegate.selectedColor != selectedColor);
  }
}