part of media_utils;

class VideoThumbnailPreview extends StatelessWidget {
  final Attachment item;
  final VoidCallback? onTap;
  final BoxFit? thumbnailBoxFit;
  final double? width;
  final double? height;
  const VideoThumbnailPreview({super.key, required this.item, required this.onTap, this.thumbnailBoxFit, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Positioned.fill(
            child: AppImage(
              path: item.thumbnail?.url ?? "",
              fit: thumbnailBoxFit,
              width: width,
              height: height,
              errorPlaceHolder: () {
                return SizedBox();
              },
            ),
          ),

          if(item.durationInSec != null)
            PositionedDirectional(
              bottom: PaddingDimensions.large,
              end: PaddingDimensions.large,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: PaddingDimensions.normal, vertical: PaddingDimensions.xSmall),
                decoration: ShapeDecoration(
                  color: const Color(0x99121212),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  Duration(seconds: item.durationInSec!).formatToMinutesAndSeconds,
                  textAlign: TextAlign.right,
                  style: context.semiBold.copyWith(
                    color: Colors.white,
                    fontSize: Dimensions.large,
                  ),
                ),
              ),

            ),

          Center(
            child: AppSvg(
              svgPath: SvgPaths.playButton,
              width: 50,
              height: 50,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
