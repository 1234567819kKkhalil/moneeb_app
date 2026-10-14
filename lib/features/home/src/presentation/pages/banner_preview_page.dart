part of home;

class BannerPreviewPage extends StatefulWidget {
  final BannerModel banner;
  static const String routeName = '/banner_preview';

  const BannerPreviewPage({super.key, required this.banner});

  @override
  State<BannerPreviewPage> createState() => _BannerPreviewPageState();
}

class _BannerPreviewPageState extends State<BannerPreviewPage> {
  VideoPlayerController? _videoController;
  bool _isPlaying = true;
  bool _showControls = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _initializeMedia();
  }

  void _initializeMedia() {
    if (widget.banner.mediaType == 'VIDEO') {
      final url = widget.banner.mediaUrl.startsWith('http')
          ? widget.banner.mediaUrl
          : '${Constants.baseUrl}${widget.banner.mediaUrl}';

      _videoController = VideoPlayerController.networkUrl(Uri.parse(url))
        ..initialize().then((_) {
          if (mounted) {
            setState(() {});
            _videoController?.play();
            _videoController?.addListener(() {
              if (mounted) setState(() {});
            });
          }
        });

      _startHideControlsTimer();
    }
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showControls = false);
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _startHideControlsTimer();
    }
  }

  void _togglePlayPause() {
    if (_videoController != null) {
      setState(() {
        if (_videoController!.value.isPlaying) {
          _videoController!.pause();
          _isPlaying = false;
        } else {
          _videoController!.play();
          _isPlaying = true;
        }
      });
      _startHideControlsTimer();
    }
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            // Content
            if (widget.banner.mediaType == 'VIDEO')
              _buildVideoContent()
            else
              _buildImageContent(),

            // Top Header
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: topPadding + 80,
              child: Container(
                padding: EdgeInsets.only(top: topPadding, left: 16, right: 16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black54, Colors.transparent],
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const Gap(12),
                    Expanded(
                      child: Text(
                        widget.banner.title,
                        style: context.semiBold.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoContent() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      return Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            ),
          ),

          // Controls
          AnimatedOpacity(
            opacity: _showControls ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Center(
              child: GestureDetector(
                onTap: _togglePlayPause,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.4),
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
              ),
            ),
          ),

        ],
      );
    }

    return Center(
      child: CircularProgressIndicator(
        color: context.appColors.primary.shade500,
      ),
    );
  }

  Widget _buildImageContent() {
    final imageUrl = widget.banner.mediaUrl.startsWith('http')
        ? widget.banner.mediaUrl
        : '${Constants.baseUrl}${widget.banner.mediaUrl}';

    return Center(
      child: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: AppImage(
          path: imageUrl,
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
