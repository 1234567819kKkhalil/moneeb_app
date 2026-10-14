part of image_editor;

class ImageEditorCubit extends Cubit<ImageEditorState> {
  ImageEditorCubit() : super(const ImageEditorState.initial());
  
  final ImageEditorHelper imageEditorHelper = ImageEditorHelper();

  Future<void> editImage({
    bool isSavingToGallery = false,
    required String filePath,
    required ImageEditorController editorController
  }) async {
    bool isNeedToEdit = editorController.canUndo;
    
    //if there is no change made on this image, just return the path
    if(!isNeedToEdit && !isSavingToGallery){
      emit(state.reduce(editImage: StateBox.success(filePath), isSavingToGallery: isSavingToGallery));
    }else{
      emit(state.reduce(editImage: const StateBox.loading(), isSavingToGallery: isSavingToGallery));

      //if there is no change made on this image, save the image then return the path
      if(!isNeedToEdit && isSavingToGallery){
        try{
          await _saveImageFileToGallery(filePath);
          emit(state.reduce(editImage: StateBox.success(filePath), isSavingToGallery: isSavingToGallery));
        }catch(e){
          emit(state.reduce(editImage: StateBox.failure(UnExpectedFailure(appLocalizer.couldNotSaveImage)), isSavingToGallery: isSavingToGallery));
        }
      }else{
        try {
          EditImageInfo imageInfo = await imageEditorHelper.applyEditsOnImage(editorController, filePath);
          final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.${imageInfo.imageType.name}';
          String? savedFilePath;

          if (isSavingToGallery) {
            savedFilePath = await _saveImageBytesToGallery(
              fileName,
              imageInfo.data!,
            );
          } else {
            savedFilePath = await _saveEditedImageToAppFiles(
              fileName,
              imageInfo.data!,
            );
          }

          if(savedFilePath?.isEmpty ?? true){
            throw UnExpectedFailure(appLocalizer.couldNotSaveImage);
          }else{
            emit(state.reduce(editImage: StateBox.success(savedFilePath!), isSavingToGallery: isSavingToGallery));
          }
        } catch (e) {
          log('save edited image failed: $e');
          emit(state.reduce(editImage: StateBox.failure(e is Failure ? e :UnExpectedFailure(appLocalizer.couldNotSaveImage)), isSavingToGallery: isSavingToGallery));
        }
      }
    }

    emit(state.reduce(editImage: const StateBox.initial(), isSavingToGallery: null));
  }

  Future<String?> _saveImageBytesToGallery(String name, Uint8List fileData) async {
    final AssetEntity? imageEntity = await PhotoManager.editor.saveImage(
      fileData,
      filename: name,
    );

    return (await imageEntity?.file)?.path;
  }

  Future<void> _saveImageFileToGallery(String filePath) async {
    await PhotoManager.editor.saveImageWithPath(filePath,);
  }

  Future<String?> _saveEditedImageToAppFiles(
      String name, Uint8List fileData) async {
    final String filePath =
    await AppUtilsDirectoriesPaths.getEditedImagesDirPath(joinWithFileName: name);

    final File file = File(filePath);

    try {
      await file.writeAsBytes(fileData);
      return filePath; // Return the file path if successful
    } catch (e) {
      debugPrint('Error saving image to app files: $e');
      return null; // Return null in case of an error
    }
  }
}
