part of image_editor;

class ImageEditorState extends Equatable {
  final StateBox<String> editImage;
  final bool? isSavingToGallery;

    const ImageEditorState({
      required this.editImage,
      required this.isSavingToGallery,
    });

    const ImageEditorState.initial() : this(
      editImage: const StateBox.initial(),
      isSavingToGallery: null
    );

  ImageEditorState reduce({
    StateBox<String>? editImage,
    bool? isSavingToGallery,
  }){
    return ImageEditorState(
      editImage: editImage ?? this.editImage,
      isSavingToGallery: isSavingToGallery ?? this.isSavingToGallery,
    );
  }

    @override
    List<Object?> get props => [
      editImage,
      isSavingToGallery,
    ];
}
