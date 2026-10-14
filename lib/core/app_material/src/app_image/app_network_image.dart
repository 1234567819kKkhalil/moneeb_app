part of app_material;

class AppNetworkImage extends StatefulWidget {
  final String path;
  final double? width;
  final double? height;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final BoxFit? fit;
  final Widget Function()? loadingPlaceHolder;
  final UserRoleEnum? userRole;
  final bool isProfileImage;
  final String? imageCacheName;
  final Widget Function(BuildContext context, dynamic error, dynamic stackTrace)
      errorBuilder;

  const AppNetworkImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    required this.memCacheWidth,
    this.memCacheHeight,
    this.fit,
    this.loadingPlaceHolder,
    this.userRole,
    required this.isProfileImage,
    required this.errorBuilder,
    this.imageCacheName,
  });

  @override
  State<AppNetworkImage> createState() => _AppNetworkImageState();
}

class _AppNetworkImageState extends State<AppNetworkImage>
    with SingleTickerProviderStateMixin, ConnectivityMonitorMixin {
  late AnimationController _controller;
  String key = DateTime.now().toString();
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void onConnectivityChanges(bool isHasInternet) {
    if (isHasInternet && mounted && hasError) {
      debugPrint("RETRYING ${widget.path}");

      setState(() {
        key = DateTime.now().toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //final bool isLowSpecs = DeviceSpecsUtils.instance.getMemoryCategory()?.isLowSpec ?? false;

    return ExtendedImage.network(
      widget.path,
      key: ValueKey(key),
      width: widget.width,
      height: widget.height,
      retries: 2,
      fit: widget.fit ?? BoxFit.cover,
      cacheWidth: widget.memCacheWidth,
      cacheHeight: widget.memCacheHeight,
      //clearMemoryCacheWhenDispose: isLowSpecs,
      gaplessPlayback: true,
      clearMemoryCacheIfFailed: true,
      cache: true,
      loadStateChanged: (state) {
        // print("Image width: ${state.extendedImageInfo?.image.width}");
        //  print("Image height: ${state.extendedImageInfo?.image.height}");
        switch (state.extendedImageLoadState) {
          case LoadState.failed:
            _controller.reset();
            state.imageProvider.evict();

            hasError = true;

            return widget.errorBuilder(
                context, state.lastException, state.lastStack);
          case LoadState.completed:
            hasError = false;

            if (state.wasSynchronouslyLoaded) {
              return state.completedWidget;
            }

            _controller.forward();

            return FadeTransition(
              opacity: _controller,
              child: state.completedWidget,
            );

          case LoadState.loading:
            hasError = false;
            _controller.reset();

            if (widget.loadingPlaceHolder != null) {
              return widget.loadingPlaceHolder!.call();
            } else if (widget.isProfileImage) {
              return FractionallySizedBox(
                  heightFactor: 0.45,
                  widthFactor: 0.45,
                  child: ShimmerLoadingEffect(
                    key: const ValueKey(1),
                    child: const AppSvg(
                      svgPath: '',
                    ),
                  ));
            } else {
              return const ColoredBox(
                color: Colors.grey,
              );
            }
        }
      },
    );
  }
}
