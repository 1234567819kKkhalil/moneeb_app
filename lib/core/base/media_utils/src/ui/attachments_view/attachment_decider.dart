part of media_utils;

class AttachmentDecider extends StatelessWidget {
  final int index;
  final List<Attachment> attachments;
  final bool isInFullPreviewMode;
  final bool ignoreAttachmentTap;
  final Widget Function()? imageLoadingPlaceHolder;
  final PageController? fullPreviewPageController;
  final bool isSingleView;
  final double? imageMaxHeight;
  final bool? setImageIdAsCacheName;
  final double? height;
  final bool autoPlay;

  const AttachmentDecider({
    super.key,
    this.index = 0,
    required this.attachments,
    this.isInFullPreviewMode = false,
    this.ignoreAttachmentTap = false,
    this.isSingleView = false,
    this.imageLoadingPlaceHolder,
    this.fullPreviewPageController,
    this.height = 280,
    this.imageMaxHeight,
    this.setImageIdAsCacheName,
    this.autoPlay = false,
  });

  @override
  Widget build(BuildContext context) {
    final attachment = attachments[index];
    final double width = context.width;

    if (attachment.type == AttachmentTypeEnum.photo) {
      final image = GestureDetector(
        onTap: () {
          _openAllAttachmentPage(
            context,
            attachments,
            initialIndex: index,
          );
        },
        child: AppImage(
          height: isInFullPreviewMode || imageMaxHeight != null ? null : height,
          width: isInFullPreviewMode ? null : width,
          path: attachment.url,
          fit: isInFullPreviewMode ? BoxFit.contain : null,
          loadingPlaceHolder: imageLoadingPlaceHolder,
          imageCacheName: setImageIdAsCacheName == true ? attachment.id : null,
        ),
      );

      if (isInFullPreviewMode) {
        return SizedBox(
            height: context.height,
            width: context.width,
            child: InteractiveViewer(child: image));
      } else {
        if (imageMaxHeight != null) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: imageMaxHeight!,
              minHeight: imageMaxHeight! * 0.75,
            ),
            child: image,
          );
        }

        return image;
      }
    } else if (attachment.type == AttachmentTypeEnum.video) {
      return GestureDetector(
        onTap: () {
          if (attachments.length > 1) {
            _openAllAttachmentPage(context, attachments, initialIndex: index);
          }
        },
        child: AbsorbPointer(
          absorbing: attachments.length > 1,
          //to ignore the inner tap from VideoView widget
          child: VideoView(
            item: attachment,
            isSingleViewPlay: isSingleView,
            thumbnailBoxFit: isInFullPreviewMode ? BoxFit.contain : BoxFit.cover,
            width: width,
            autoPlay: autoPlay,
            height: isInFullPreviewMode ? context.height : height ?? 280,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void _openAllAttachmentPage(
      BuildContext context, List<Attachment> attachments,
      {int initialIndex = 0}) {
    if (ignoreAttachmentTap || isInFullPreviewMode) return;

    AppRouteNavigator.pushWithDragToPopTransition(
      context,
      AllHorizontalAttachmentsPage.routeName,
      AllHorizontalAttachmentsPage(
        attachments: attachments,
        initialPage: initialIndex,
        pageController: fullPreviewPageController,
        setImageIdAsCacheName: setImageIdAsCacheName,
      ),
    );
  }
}

const List<String> videosUrl = [
  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
  "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",
  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4",
  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4",
  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/VolkswagenGTIReview.mp4",
  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4",
  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4",
];
