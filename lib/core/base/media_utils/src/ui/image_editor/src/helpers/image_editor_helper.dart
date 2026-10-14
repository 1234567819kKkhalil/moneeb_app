part of image_editor;

class ImageEditorHelper{
  Future<EditImageInfo> applyEditsOnImage(
      ImageEditorController imageEditorController, String attachmentFilePath) async {

    ///crop rect base on raw image
    Rect cropRect = imageEditorController.getCropRect()!;
    final ExtendedImageEditorState state = imageEditorController.state!;


    if (state.widget.extendedImageState.imageProvider is ExtendedResizeImage) {
      //Read image bytes
      final ImmutableBuffer buffer = await ImmutableBuffer.fromUint8List(state.rawImageData);

      //Get image metadata
      final ImageDescriptor descriptor = await ImageDescriptor.encoded(buffer);

      final double widthRatio = descriptor.width / state.image!.width;
      final double heightRatio = descriptor.height / state.image!.height;

      cropRect = Rect.fromLTRB(
        cropRect.left * widthRatio,
        cropRect.top * heightRatio,
        cropRect.right * widthRatio,
        cropRect.bottom * heightRatio,
      );
    }

    final EditActionDetails editAction = state.editAction!;

    final DateTime time1 = DateTime.now();

    //Decode source to Animation. It can holds multi frame.
    img.Image? src = await compute(img.decodeImage, state.rawImageData);

    if (src != null) {
      //handle every frame.
      src.frames = src.frames.map((img.Image image) {
        final DateTime time2 = DateTime.now();
        //clear orientation
        image = img.bakeOrientation(image);
        if (editAction.hasRotateDegrees) {
          image = img.copyRotate(image, angle: editAction.rotateDegrees);
        }

        if (editAction.flipY) {
          image = img.flip(image, direction: img.FlipDirection.horizontal);
        }

        if (editAction.needCrop) {
          image = img.copyCrop(
            image,
            x: cropRect.left.toInt(),
            y: cropRect.top.toInt(),
            width: cropRect.width.toInt(),
            height: cropRect.height.toInt(),
          );
        }

        final DateTime time3 = DateTime.now();
        return image;
      }).toList();
    }

    assert(src != null);

    EditImageType imageType = EditImageType.fromExtension(attachmentFilePath.split('.').lastOrNull?.toLowerCase());


    List<int>? fileData;
    final DateTime time4 = DateTime.now();
    final bool onlyOneFrame = src!.numFrames == 1;

    fileData = (onlyOneFrame
        ? await compute(
          imageType == EditImageType.png ? img.encodePng : img.encodeJpg,
        img.Image.from(src.frames.first)
        )
        : await compute(img.encodeGif, src)
    );


    final DateTime time5 = DateTime.now();

    return EditImageInfo(
      Uint8List.fromList(fileData!),
      imageType
    );
  }

  //it is faster but have an issue in transparent image, it Produces ov-white background instead of transparent bg
  /*static Future<EditImageInfo> cropImageDataWithNativeLibrary(
      ImageEditorController imageEditorController) async {

    final EditActionDetails action = imageEditorController.editActionDetails!;

    final Uint8List img = imageEditorController.state!.rawImageData;

    final ImageEditorOption option = ImageEditorOption();

    if (action.hasRotateDegrees) {
      final int rotateDegrees = action.rotateDegrees.toInt();
      option.addOption(RotateOption(rotateDegrees));
    }
    if (action.flipY) {
      option.addOption(const FlipOption(horizontal: true, vertical: false));
    }

    if (action.needCrop) {
      Rect cropRect = imageEditorController.getCropRect()!;
      if (imageEditorController.state!.widget.extendedImageState.imageProvider
      is ExtendedResizeImage) {
        final ImmutableBuffer buffer = await ImmutableBuffer.fromUint8List(img);
        final ImageDescriptor descriptor = await ImageDescriptor.encoded(buffer);

        final double widthRatio =
            descriptor.width / imageEditorController.state!.image!.width;
        final double heightRatio =
            descriptor.height / imageEditorController.state!.image!.height;
        cropRect = Rect.fromLTRB(
          cropRect.left * widthRatio,
          cropRect.top * heightRatio,
          cropRect.right * widthRatio,
          cropRect.bottom * heightRatio,
        );
      }
      option.addOption(ClipOption.fromRect(cropRect));
    }

    final DateTime start = DateTime.now();
    final Uint8List? result = await ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );

    return EditImageInfo(result, EditImageType.jpg);
  }*/

}


