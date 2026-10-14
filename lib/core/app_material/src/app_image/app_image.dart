part of app_material;

class AppImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final bool autoMemCacheCalculate;
  final BorderRadius? borderRadius;
  final bool isCircle;
  final bool showDefultImage;
  final BoxFit? fit;
  final Widget Function()? errorPlaceHolder;
  final Widget Function()? loadingPlaceHolder;
  final BoxBorder? border;
  final String? avatarPlaceholder;
  final String? imageCacheName;
  final bool _isProfileImage;

  const AppImage({
    super.key,
    required this.path,
    this.width,
    this.height,
    this.borderRadius,
    this.fit,
    this.border,
    this.errorPlaceHolder,
    this.loadingPlaceHolder,
    this.avatarPlaceholder,
    this.memCacheWidth,
    this.memCacheHeight,
    this.imageCacheName,
    this.showDefultImage = false,
    this.autoMemCacheCalculate = true,
  }) : isCircle = false,
       _isProfileImage = false;

  const AppImage.profileImage({
    super.key,
    required this.path,
    this.width = 40,
    this.height = 40,
    this.borderRadius,
    this.isCircle = true,
    this.fit,
    this.errorPlaceHolder,
    this.loadingPlaceHolder,
    this.border,
    this.avatarPlaceholder,
    this.memCacheWidth,
    this.memCacheHeight,
    this.imageCacheName,
    this.showDefultImage = false,
    this.autoMemCacheCalculate = true,
  }) : _isProfileImage = true;

  static ImageProvider getImageProvider({
    required String path,
    bool autoMemCacheCalculate = true,
    double? width,
    bool cacheRawData = false,
  }) {
    final context = AppRouteNavigator.navigatorKey.currentContext!;

    final imgProvider = ImagePathIdentifier<ImageProvider>(
      path: path,
      onAsset: ExtendedAssetImageProvider(path, cacheRawData: cacheRawData),
      onFile: ExtendedFileImageProvider(File(path), cacheRawData: cacheRawData),

      //Use this instead of ExtendedNetworkProvider because ExtendedImage.network sets initial values for some parameters and these parameters are used in Provider Key, So we must match that provider key so the cache can work for this image
      onNetwork: ExtendedImage.network(
        path,
        cacheRawData: cacheRawData,
        retries: 2,
        cacheWidth: width != null
            ? (width * context.devicePixelRatio).toInt()
            : context.getPhysicalScreenWidth().toInt(),
      ).image,
    ).build();

    return imgProvider;
  }

  @override
  Widget build(BuildContext context) {
    // dev.log("path:$path");
    int? calculatedMemCache = memCacheWidth;

    if (calculatedMemCache == null && autoMemCacheCalculate) {
      if (width != null && width != double.infinity) {
        calculatedMemCache = (width! * context.devicePixelRatio).toInt();
      } else {
        calculatedMemCache = context.getPhysicalScreenWidth().toInt();
      }
    }

    final radius = isCircle || borderRadius == null
        ? null
        : borderRadius ?? BorderRadius.circular(12);

    return Container(
      width: width,
      height: height,
      clipBehavior: _isProfileImage ? Clip.antiAlias : Clip.hardEdge,
      // This foregroundDecoration is used to add border to the image, because if you only used decoration, the border will be cut off
      foregroundDecoration: BoxDecoration(
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: radius,
        border: border,
      ),
      decoration: BoxDecoration(
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: radius,
      ),
      child: ImagePathIdentifier<Widget>(
        path: path,
        onNetwork: AppNetworkImage(
          path: path,
          errorBuilder: _errorBuilder,
          isProfileImage: _isProfileImage,
          width: width,
          height: height,
          fit: fit ?? BoxFit.cover,
          loadingPlaceHolder: loadingPlaceHolder,
          imageCacheName: imageCacheName,
          memCacheWidth: calculatedMemCache,
          memCacheHeight: memCacheHeight,
        ),
        onAsset: Image.asset(
          path,
          fit: fit ?? BoxFit.cover,
          width: width,
          height: height,
          errorBuilder: _errorBuilder,
          cacheWidth: calculatedMemCache,
          cacheHeight: memCacheHeight,
        ),
        onFile: Image.file(
          File(path),
          fit: fit ?? BoxFit.cover,
          width: width,
          height: height,
          errorBuilder: _errorBuilder,
          cacheWidth: calculatedMemCache,
          cacheHeight: memCacheHeight,
        ),
      ).build(),
    );
  }

  Widget _errorBuilder(BuildContext context, error, stackTrace) {
    if (errorPlaceHolder != null) return errorPlaceHolder!.call();

    if (_isProfileImage) {
      return ColoredBox(
        // color: context.appColors.neutral.shade900,
        color: Colors.black,

        child: FractionallySizedBox(
          heightFactor: 0.45,
          widthFactor: 0.45,
          child: AppSvg(svgPath: avatarPlaceholder ?? ''),
        ),
      );
    } else {
      return const _BuildErrorWidget();
    }
  }
}

class ImagePathIdentifier<T> {
  final String path;
  final T onAsset;
  final T onFile;
  final T onNetwork;

  const ImagePathIdentifier({
    required this.path,
    required this.onAsset,
    required this.onFile,
    required this.onNetwork,
  });

  T build() {
    if (path.isNetwork) {
      return onNetwork;
    } else if (path.isAssetFile) {
      return onAsset;
    }
    return onFile;
  }
}

class _BuildErrorWidget extends StatelessWidget {
  const _BuildErrorWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1,
        child: FractionallySizedBox(
          widthFactor: 0.4,
          heightFactor: 0.4,
          child: FittedBox(
            child: Icon(
              Icons.broken_image_rounded,
              color: context.appColors.neutral.shade400,
            ),
          ),
        ),
      ),
    );
  }
}
