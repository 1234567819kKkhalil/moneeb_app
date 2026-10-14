part of video_maestro;

class VideoMaestroFullScreen extends StatefulWidget {
  final MaestroController controller;
  const VideoMaestroFullScreen({super.key, required this.controller});

  static const String routeName = '/videoMaestroFullScreen';

  @override
  State<VideoMaestroFullScreen> createState() => _VideoMaestroFullScreenState();
}

class _VideoMaestroFullScreenState extends State<VideoMaestroFullScreen> {
  @override
  initState() {
    super.initState();
    widget.controller.isInFullScreen = true;
  }

  @override
  void dispose() {
    widget.controller.isInFullScreen = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: VideoMaestro(
            controller: widget.controller,
            isFullScreen: true,
            optionsVisibility: const OptionsVisibilityControl()
          ),
        ),
      ),
    );
  }
}
