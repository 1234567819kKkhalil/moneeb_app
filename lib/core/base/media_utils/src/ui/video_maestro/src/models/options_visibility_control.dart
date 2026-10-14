part of video_maestro;

class OptionsVisibilityControl extends Equatable{
  final bool showSpeedButton;
  final bool showFullScreenButton;
  final bool showOverlayButton;
  final bool doubleTapToSeek;
  final bool holdToDoubleSpeed;
  final bool showCaptions;
  const OptionsVisibilityControl({
    this.showSpeedButton = true,
    this.showFullScreenButton = true,
    this.showOverlayButton = true,
    this.doubleTapToSeek = true,
    this.holdToDoubleSpeed = true,
    this.showCaptions = true,
  });

  factory OptionsVisibilityControl.forMiniOverlay(){
    return const OptionsVisibilityControl(
      doubleTapToSeek: true,
      holdToDoubleSpeed: false,
      showFullScreenButton: false,
      showOverlayButton: false,
      showSpeedButton: false,
      showCaptions: false
    );
  }

  @override
  List<Object?> get props => [
    showSpeedButton,
    showFullScreenButton,
    showOverlayButton,
    doubleTapToSeek,
    holdToDoubleSpeed,
    showCaptions,
  ];
}