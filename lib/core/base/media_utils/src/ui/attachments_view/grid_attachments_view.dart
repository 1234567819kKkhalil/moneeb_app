part of media_utils;

class GridAttachmentsView extends StatelessWidget {
  final List<Attachment> attachments;
  final bool ignoreAttachmentTap;
  final double? singleImageMaxHeight;
  final bool isSingleView;
  const GridAttachmentsView({
    super.key,
    required this.attachments,
    this.ignoreAttachmentTap = false,
    this.singleImageMaxHeight,
    this.isSingleView = false,
  });

  @override
  Widget build(BuildContext context) {
    if (attachments.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: attachments.length > 1 ? 280 : null,
      width: context.width,
      child: FittedGridView(
        maxItemDisplay: 4,
        itemCount: attachments.length,
        itemBuilder: (context, index) {
          return AttachmentDecider(
            index: index,
            attachments: attachments,
            ignoreAttachmentTap: ignoreAttachmentTap,
            isInFullPreviewMode: false,
            imageMaxHeight: singleImageMaxHeight,
            isSingleView: isSingleView,
          );
        },
        remainingItemsOverlay: (remaining) {
          return GestureDetector(
            onTap: (){
              _openAllAttachmentPage(context, attachments, initialIndex: attachments.length >= 4 ? 3 : 0);
            },
            child: Container(
              alignment: Alignment.center,
              color: Colors.black54,
              child: Text(
                '+$remaining',
                style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }

  void _openAllAttachmentPage(BuildContext context,List<Attachment> attachments,{int initialIndex = 0}){
    if (ignoreAttachmentTap) return;

    AppRouteNavigator.pushWithDragToPopTransition(
      context,
      AllHorizontalAttachmentsPage.routeName,
      AllHorizontalAttachmentsPage(
          attachments: attachments,
          initialPage: initialIndex
      ),
    );
  }
}
