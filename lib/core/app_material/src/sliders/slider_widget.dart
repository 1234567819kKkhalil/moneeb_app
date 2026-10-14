part of app_material;

class SliderWidget extends StatefulWidget {
  final double max;
  final double sliderValue;
  final void Function(double value) onChange;
  final FutureOr<void> Function(double value)? onChangeEnd;
  final void Function(double value)? onChangeStart;
  final int? divisions;

  const SliderWidget({
    super.key,
    required this.max,
    required this.onChange,
    required this.sliderValue,
    this.divisions,
    this.onChangeEnd,
    this.onChangeStart,
  });

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  double? sliderTempValue;

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: sliderTempValue ?? widget.sliderValue.clamp(0, widget.max.toDouble()),
      max: widget.max.toDouble(),
      min: 0.0,
      onChanged: (value) {
        setState(() {
          sliderTempValue = value;
        });

        widget.onChange(value);
      },
      onChangeEnd: (value) async{
        if (widget.onChangeEnd != null) {
          await widget.onChangeEnd!(value);
        }

        sliderTempValue = null;
      },
      divisions: widget.divisions,
      onChangeStart: (value) {
        if (widget.onChangeStart != null) {
          widget.onChangeStart!(value);
        }
      },
    );
  }
}

