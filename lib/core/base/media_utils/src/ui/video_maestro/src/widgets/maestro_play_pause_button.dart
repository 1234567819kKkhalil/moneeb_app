part of video_maestro;

class MaestroPlayPauseButton extends StatefulWidget {
  final VideoPlayerController videoPlayerController;
  const MaestroPlayPauseButton({super.key, required this.videoPlayerController});

  @override
  State<MaestroPlayPauseButton> createState() => _MaestroPlayPauseButtonState();
}

class _MaestroPlayPauseButtonState extends State<MaestroPlayPauseButton> {
  late bool isPlaying = widget.videoPlayerController.value.isPlaying;

  @override
  void initState() {
    widget.videoPlayerController.addListener(listener);
    super.initState();
  }

  @override
  dispose() {
    widget.videoPlayerController.removeListener(listener);
    super.dispose();
  }

  void listener() {
    if(isPlaying != widget.videoPlayerController.value.isPlaying){
      setState(() {
        isPlaying = widget.videoPlayerController.value.isPlaying;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        if(isPlaying){
          widget.videoPlayerController.pause();
        } else {
          widget.videoPlayerController.play();
        }
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.only(bottom: 12, end: 4.0),
        child: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow_rounded,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }
}
