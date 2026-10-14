part of app_material;

class MultiImagePickFailureAlert extends StatelessWidget {
  final PickedMultiMediaLimitHandler pickedMultiImagesEntity;
  const MultiImagePickFailureAlert({super.key, required this.pickedMultiImagesEntity});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //todo: return this if you needed
        // const Padding(
        //   padding: EdgeInsets.only(bottom: PaddingDimensions.large),
        //   child: AppSvg(
        //     path: SvgPaths.warning_illustration,
        //     width: 56,
        //     height: 40,
        //   ),
        // ),

        if(pickedMultiImagesEntity.unSupportedFormatAttachments.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: PaddingDimensions.normal),
            child: Text(
              pickedMultiImagesEntity.getUnsupportedFormatErrorMsg,
              style: context.regular
            ),
          ),

          _BuildImagesList(attachments: pickedMultiImagesEntity.unSupportedFormatAttachments,),

          const SizedBox(height: PaddingDimensions.large,)
        ],

        if(pickedMultiImagesEntity.exceededSizeLimitAttachments.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: PaddingDimensions.normal),
            child: Text(
              pickedMultiImagesEntity.getExceededSizeLimitErrorMsg,
              style: context.regular,
            ),
          ),

          _BuildImagesList(attachments: pickedMultiImagesEntity.exceededSizeLimitAttachments,),

          const SizedBox(height: PaddingDimensions.large,)
        ],

        if(pickedMultiImagesEntity.exceededCountLength > 0) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: PaddingDimensions.normal),
            child: Text(
              pickedMultiImagesEntity.getExceededMaxCountErrorMsg,
              style: context.regular,
            ),
          ),
        ],

        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: PaddingDimensions.normal,
            vertical: PaddingDimensions.xSmall,
          ),
          child: AppPrimaryButton.outline(
            buttonHeight: Dimensions.buttonMediumHeight,
            onPressed: () => AppRouteNavigator.pop(context),
            text: appLocalizer.ok,
          ),
        ),
      ],
    );
  }
}

class _BuildImagesList extends StatelessWidget {
  final List<Attachment> attachments;
  const _BuildImagesList({super.key, required this.attachments});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: context.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: attachments.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: PaddingDimensions.xSmall),
            child: AppImage(
             width: 50,
             height: 50,
             borderRadius: BorderRadius.circular(4),
             path: attachments[index].url
            ),
          );
        },
      ),
    );
  }
}
