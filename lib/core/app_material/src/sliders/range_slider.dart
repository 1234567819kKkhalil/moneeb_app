// ignore_for_file: unused_element

part of app_material;

class AppRangeSlider extends StatelessWidget {
  const AppRangeSlider({
    super.key,
    required this.rangeValues,
    required this.onchange,
    required this.min,
    required this.max,
    this.labelText,
    this.gradient,
    this.thumpRadius = 12,
    this.inactiveColor,
    this.rangeLabels,
  });

  final String? labelText;
  final RangeLabels? rangeLabels;
  final RangeValues rangeValues;
  final void Function(RangeValues) onchange;
  final double min;
  final double max;
  final LinearGradient? gradient;
  final double thumpRadius;
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
        data: SliderThemeData(
            showValueIndicator: ShowValueIndicator.always,
            trackHeight: Dimensions.xSmall,
            rangeTrackShape: gradient != null
                ? _GradientRectRangeSliderTrackShape(
                    gradient: gradient ??
                        const LinearGradient(
                            colors: [Colors.blue, Colors.blueAccent]),
                    thumpR: thumpRadius)
                : null,
            disabledThumbColor: Colors.white,
            thumbColor: Colors.white,
            overlayColor: Colors.transparent,
            activeTrackColor: context.appColors.primary.shade500,
            inactiveTrackColor: context.appColors.primary.shade500,
            rangeThumbShape: RoundRangeSliderThumbShape(
                elevation: 1.5,
                pressedElevation: 3,
                enabledThumbRadius: thumpRadius,
                disabledThumbRadius: thumpRadius),
            overlayShape: const RoundSliderOverlayShape(
              overlayRadius: 15,
            ),
            rangeValueIndicatorShape:
                const PaddleRangeSliderValueIndicatorShape(),
            valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: Colors.transparent,
            valueIndicatorTextStyle: context.bold.copyWith(fontSize: Dimensions.normal),
            inactiveTickMarkColor: context.appColors.primary.shade900,
            activeTickMarkColor: context.appColors.primary.shade900,
            minThumbSeparation: 0,
            rangeTickMarkShape: const RoundRangeSliderTickMarkShape(
              tickMarkRadius: 0,
            )),
        child: RangeSlider(
          onChanged: onchange,
          values: rangeValues,
          min: min,
          max: max,
          labels: rangeLabels ??  RangeLabels(
            '${rangeValues.start.round()} $labelText',
            '${rangeValues.end.round()} $labelText',
          ),
        ));
  }
}

class _GradientRectRangeSliderTrackShape extends RangeSliderTrackShape {
  const _GradientRectRangeSliderTrackShape(
      {this.gradient = const LinearGradient(
        colors: [
          Colors.blue,
          Colors.blueAccent,
        ],
      ),
      this.darkenInactive = true,
      this.thumpR = 12});

  final LinearGradient gradient;
  final bool darkenInactive;
  final double thumpR;

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    assert(sliderTheme.overlayShape != null,
        'sliderTheme.overlayShape is required');
    assert(
        sliderTheme.trackHeight != null, 'sliderTheme.trackHeight is required');

    final double overlayWidth =
        sliderTheme.overlayShape!.getPreferredSize(isEnabled, isDiscrete).width;
    final double trackHeight = sliderTheme.trackHeight!;
    assert(overlayWidth >= 0);
    assert(trackHeight >= 0);

    final double trackLeft = offset.dx + overlayWidth / 2;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackRight = trackLeft + parentBox.size.width - overlayWidth;
    final double trackBottom = trackTop + trackHeight;
    return Rect.fromLTRB(math.min(trackLeft, trackRight), trackTop,
        math.max(trackLeft, trackRight), trackBottom);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset startThumbCenter,
    required Offset endThumbCenter,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
    double additionalActiveTrackHeight = 2,
  }) {
    assert(sliderTheme.disabledActiveTrackColor != null,
        'sliderTheme.disabledActiveTrackColor is required');
    assert(sliderTheme.disabledInactiveTrackColor != null,
        'sliderTheme.disabledInactiveTrackColor is required');
    assert(sliderTheme.activeTrackColor != null,
        'sliderTheme.activeTrackColor is required');
    assert(sliderTheme.inactiveTrackColor != null,
        'sliderTheme.inactiveTrackColor is required');
    assert(sliderTheme.rangeThumbShape != null,
        'sliderTheme.rangeThumbShape iss required');
    assert(
        sliderTheme.trackHeight != null && sliderTheme.trackHeight! > 0,
        'sliderTheme.trackHeight != null and sliderTheme.trackHeight! > 0'
        'are required');

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final ColorTween activeTrackColorTween = ColorTween(
      begin: sliderTheme.disabledActiveTrackColor,
      end: sliderTheme.activeTrackColor,
    );
    final ColorTween inactiveTrackColorTween = darkenInactive
        ? ColorTween(
            begin: sliderTheme.disabledInactiveTrackColor,
            end: sliderTheme.inactiveTrackColor,
          )
        : activeTrackColorTween;
    final Paint activePaint = Paint()
      ..shader = gradient.createShader(trackRect)
      ..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()
      ..color = inactiveTrackColorTween.evaluate(enableAnimation)!;

    final Offset leftThumbOffset;
    final Offset rightThumbOffset;
    switch (textDirection) {
      case TextDirection.ltr:
        leftThumbOffset = startThumbCenter;
        rightThumbOffset = endThumbCenter;
        break;
      case TextDirection.rtl:
        leftThumbOffset = endThumbCenter;
        rightThumbOffset = startThumbCenter;
        break;
    }
    final Size thumbSize =
        sliderTheme.rangeThumbShape!.getPreferredSize(isEnabled, isDiscrete);
    final double thumbRadius = thumbSize.width / 2;
    assert(thumbRadius > 0);

    final Radius trackRadius = Radius.circular(trackRect.height / 2);

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left,
        trackRect.top,
        leftThumbOffset.dx,
        trackRect.bottom,
        topLeft: trackRadius,
        bottomLeft: trackRadius,
      ),
      inactivePaint,
    );
    context.canvas.drawRect(
      Rect.fromLTRB(
        leftThumbOffset.dx,
        trackRect.top - (additionalActiveTrackHeight),
        rightThumbOffset.dx,
        trackRect.bottom + (additionalActiveTrackHeight),
      ),
      activePaint,
    );
    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        rightThumbOffset.dx,
        trackRect.top,
        trackRect.right,
        trackRect.bottom,
        topRight: trackRadius,
        bottomRight: trackRadius,
      ),
      inactivePaint,
    );

    // draw left ThumbOff circle
    context.canvas.drawCircle(leftThumbOffset, thumpR, activePaint);
    // draw right ThumbOff circle
    context.canvas.drawCircle(rightThumbOffset, thumpR, activePaint);
  }
}
