part of media_utils;

class AllHorizontalAttachmentsPage extends StatefulWidget {
  final List<Attachment> attachments;
  final bool? setImageIdAsCacheName;
  final int? initialPage;
  final PageController? pageController;

  const AllHorizontalAttachmentsPage({
    super.key,
    required this.attachments,
    this.initialPage,
    this.pageController,
    this.setImageIdAsCacheName,
  });

  static const String routeName = "AllHorizontalAttachmentsPage";

  @override
  State<AllHorizontalAttachmentsPage> createState() =>
      _AllHorizontalAttachmentsState();
}

class _AllHorizontalAttachmentsState extends State<AllHorizontalAttachmentsPage> {
  late final PageController pageController;
  late final int attachmentsLength;

  @override
  void initState() {
    pageController = PageController(initialPage: widget.initialPage ?? 0);
    attachmentsLength = widget.attachments.length;

    if(widget.pageController != null && widget.pageController!.hasClients) {
      pageController.addListener(() {
        final page = pageController.page?.round() ?? 0;
        widget.pageController!.jumpToPage(page);
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  final Set<String> saveImagesQueue = {};

  Future<void> saveImageToGallery(String url) async {
    if(saveImagesQueue.contains(url)) return;

    saveImagesQueue.add(url);

    try{
      var imageBytes = await getNetworkImageData(url, useCache: true);

      if(imageBytes == null){
        throw Exception();
      }

      await Gal.putImageBytes(imageBytes);

      if (mounted) {
        AppToasts.success(context, message: appLocalizer.imageSavedToGallery);
      }
    } catch (e) {
      if (mounted) {
        AppToasts.error(context, message: appLocalizer.couldNotSaveImage);
      }
    }

    saveImagesQueue.remove(url);
  }

  Widget _buildAttachmentView(Attachment attachment){
    return GestureDetector(
      onLongPress: () {
        // if(attachment.type == AttachmentTypeEnum.photo){
        //   AppBottomSheets.showMenuBottomSheet(
        //       context,
        //       menuModels: [
        //         MenuBottomSheetModel(
        //           icon: Iconsax.download,
        //           title: appLocalizer.saveToGallery,
        //           onTap: (context) {
        //             saveImageToGallery(attachment.url);
        //             AppRouteNavigator.pop(context);
        //           },
        //         )
        //       ]
        //   );
        // }
      },
      child: AttachmentDecider(
          attachments: [attachment],
          isInFullPreviewMode: true,
          setImageIdAsCacheName: widget.setImageIdAsCacheName,
          imageLoadingPlaceHolder: () => const AppProgressIndicator(),
          isSingleView: true,
          autoPlay: true
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: widget.attachments.length == 1
            ? Center(child: _buildAttachmentView(widget.attachments[0]))
            : Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                scrollDirection: Axis.horizontal,
                itemCount: widget.attachments.length,
                physics: const FastScrollPhysics(),
                itemBuilder: (context, index) {
                  return _buildAttachmentView(widget.attachments[index]);
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SmoothPageIndicator(
                count: attachmentsLength,
                controller: pageController,
                effect: ScrollingDotsEffect(
                    activeDotColor: context.appColors.primary.shade900,
                    dotColor: context.appColors.neutral.shade500,
                    dotHeight: 9,
                    dotWidth: 9,
                    spacing: 6,
                    maxVisibleDots: 5 //Care about this, it must be an odd value
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}