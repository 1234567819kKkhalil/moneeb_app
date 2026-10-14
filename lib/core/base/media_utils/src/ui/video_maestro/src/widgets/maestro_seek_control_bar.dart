part of video_maestro;

class MaestroSeekControlBar extends StatefulWidget {
  final MaestroController maestroController;
  final int orientation;
  const MaestroSeekControlBar({super.key, required this.maestroController, required this.orientation});

  @override
  State<MaestroSeekControlBar> createState() => _MaestroSeekControlBarState();
}

class _MaestroSeekControlBarState extends State<MaestroSeekControlBar> with SingleTickerProviderStateMixin{
  late final ValueNotifier<double?> _sliderTempValueNotifier = ValueNotifier(null);
  final GlobalKey _sliderKey = GlobalKey();

  @override
  void dispose() {
    _sliderTempValueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.maestroController.playerStateNotifier.stream,
      builder: (_, snapshot) {
        final state = snapshot.data;
        final videoController = widget.maestroController.videoPlayerController;

        if(state is VideoPlayerSuccessState){
          return ValueListenableBuilder(
              valueListenable: videoController,
              builder: (context,videoControls,child) {
                final videoLength = (videoControls.duration.inMilliseconds).toDouble();
                final double videoPosition = (videoControls.position.inMilliseconds.toDouble()).clamp(0, videoLength);

                final int duration = videoController.value.duration.inMilliseconds;

                int maxBuffering = 0;
                for (final DurationRange range in videoController.value.buffered) {
                  final int end = range.end.inMilliseconds;
                  if (end > maxBuffering) {
                    maxBuffering = end;
                  }
                }

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    //SLIDER
                    Transform.translate(
                      offset: const Offset(0, -5), //the height is thumbRadius
                      child: Stack(
                        fit: StackFit.passthrough,
                        alignment:  AlignmentDirectional.centerStart,
                        clipBehavior: Clip.none,

                        children: <Widget>[
                            const LinearProgressIndicator(
                              value: 1,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.black45),
                              borderRadius: BorderRadiusDirectional.only(topStart: Radius.circular(10), bottomStart: Radius.circular(10)), //BorderRadius.all(Radius.circular(10)),
                              backgroundColor: Colors.transparent,
                            ),

                          LinearProgressIndicator(
                            value: maxBuffering / duration,
                            borderRadius: const BorderRadiusDirectional.only(topStart: Radius.circular(10), bottomStart: Radius.circular(10)), //BorderRadius.all(Radius.circular(10)),
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.withAlpha(100)),
                            backgroundColor: Colors.transparent,
                          ),

                          MaestroSliderWidget(
                            key: _sliderKey,
                            overlayShape: SliderComponentShape.noOverlay,
                            trackHeight: 2.4,
                            thumbColor: context.appColors.primary.shade500,
                            sliderValue: videoPosition,
                            max: videoLength,
                            onChange: (value){
                              _sliderTempValueNotifier.value = value;
                            },
                            onChangeEnd: (value) async{
                              _sliderTempValueNotifier.value = null;

                              await videoController.seekTo(Duration(milliseconds: value.toInt()));

                              if(mounted){
                                await videoController.play();
                              }
                            },
                            onChangeStart: (value){
                              videoController.pause();
                            },
                          ),
                        ],
                      ),
                    ),

                    ValueListenableBuilder(
                      valueListenable: _sliderTempValueNotifier,
                      builder: (_, sliderTempValue, child) {
                        if(sliderTempValue == null){
                          return const SizedBox.shrink();
                        }

                        const double floatingTimeWidth = 50;

                        return PositionedDirectional(
                          top: -30,
                          start: (sliderTempValue * (_sliderKey.getSize().width / videoLength)).clamp(0, (widget.orientation == 0 ? context.width : context.height) - 40) - (floatingTimeWidth/2),
                          child: Container(
                            width: floatingTimeWidth,
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 4, blurRadius: 4)],
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2
                            ),
                            child: FittedBox(
                              child: Text(
                                formatDuration(sliderTempValue),
                                style: context.medium.copyWith(
                                  color: context.appColors.neutral.shade50,
                                  fontSize: Dimensions.large
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                );
              }
          );
        }

        return const SizedBox(height: 6,);
      },
    );
  }

  String formatDuration(double milliseconds) {
    final totalSeconds = (milliseconds / 1000).round();
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

class MaestroSliderWidget extends StatefulWidget {
  final double max;
  final double sliderValue;
  final Color? inActiveColor;
  final Color? thumbColor;
  final double trackHeight;
  final SliderComponentShape? thumbShape;
  final SliderTrackShape? trackShape;
  final void Function(double value) onChange;
  final FutureOr<void> Function(double value)? onChangeEnd;
  final void Function(double value)? onChangeStart;
  final SliderComponentShape? overlayShape;
  final int? divisions;
  final double? thumbElevation;

  const MaestroSliderWidget({
    super.key,
    required this.max,
    required this.onChange,
    required this.sliderValue,
    this.inActiveColor,
    this.trackHeight = 4,
    this.thumbShape,
    this.thumbColor,
    this.onChangeEnd,
    this.onChangeStart,
    this.trackShape,
    this.overlayShape, this.divisions, this.thumbElevation,
  });

  @override
  State<MaestroSliderWidget> createState() => _MaestroSliderWidgetState();
}

class _MaestroSliderWidgetState extends State<MaestroSliderWidget> {
  double? sliderTempValue;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: widget.trackHeight,
        overlayColor: Colors.transparent,
        thumbColor: widget.thumbColor ?? context.appColors.primary.shade500,
        activeTrackColor: context.appColors.primary.shade500,
        inactiveTrackColor: Colors.transparent,
        padding: EdgeInsets.zero,
        thumbShape: const FlatThumbShape(thumbRadius: 8),
        // thumbShape: widget.thumbShape ?? RoundSliderThumbShape(
        //   enabledThumbRadius: 6,
        //   elevation: widget.thumbElevation ?? 3,
        // ),
        overlayShape: widget.overlayShape,
      ),
      child: Slider(
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
      ),
    );
  }
}

class FlatThumbShape extends SliderComponentShape {
  final double thumbRadius;

  const FlatThumbShape({this.thumbRadius = 6.0});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    // This defines how much vertical space the thumb takes
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter? labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    final Canvas canvas = context.canvas;
    final Paint paint = Paint()
      ..color = sliderTheme.thumbColor ?? Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, thumbRadius, paint);
  }
}