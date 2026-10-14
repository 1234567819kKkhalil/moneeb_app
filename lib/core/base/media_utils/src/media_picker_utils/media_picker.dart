part of media_utils;

typedef PickedSingleMediaCallback = void Function(Attachment media);
typedef PickedMultipleMediaCallback = void Function(List<Attachment> mediaList);

class MediaPicker {
  static final _picker = ImagePicker();

  // --- PICK MEDIA ---
  static Future<void> pickMultipleMediaFromGallery({
    PickedMultipleMediaCallback? pickedMediaCallback,
    PickerVideoProperties videoProperties = const PickerVideoProperties(),
    PickerImagesProperty imagesProperties = const PickerImagesProperty(),
    int maxAllowedMediaCount = AppLimits.maxAllowedMediaCount,
  }) async {
    // Ask For Permissions, if error occurred, it will throw a Failure and will be handled later
    await AppPermissions.instance.requestMediaLibraryPermission();

    List<File> mediaFiles = [];

    final FilePickerResult? pickerResult = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.media,
    );

    if (pickerResult != null) {
      mediaFiles = pickerResult.paths.map((path) => File(path!)).toList();
    }

    if (mediaFiles.isEmpty) {
      throw NoAttachmentPickedFailure();
    }

    // todo: take the max allowed and ignore others
    if (mediaFiles.length > maxAllowedMediaCount) {
      throw FileSizeFailure(
          appLocalizer.maximumAttachmentLimitError(maxAllowedMediaCount));
    }

    List<File> videos = [];
    List<File> images = [];

    for (var media in mediaFiles) {
      if (media.path.isVideo) {
        videos.add(media);
      } else {
        images.add(media);
      }
    }

    final filteredVideos = await _handlePickedVideos(
      videos: videos,
      properties: videoProperties
    );

    final filteredImages = await _handlePickedImages(
      images: images,
      properties: imagesProperties,
    );

    pickedMediaCallback?.call([...filteredVideos.pickedVideos, ...filteredImages.pickedImages]);

    //todo: find a way to merge these two failures
    if(filteredImages.failure != null){
      throw filteredImages.failure!;
    } else if(filteredVideos.failure != null){
      throw filteredVideos.failure!;
    }
  }

  // --- PICK SINGLE IMAGE ---
  static Future<void> pickImage({
    required PickedSingleMediaCallback pickedMediaCallback,
    ImageSource source = ImageSource.gallery,
    int maxAllowedImageSizeInMB = AppLimits.maxAllowedImageSizeInMB,
  }) async {
    XFile? pickedImage;

    switch (source) {
      case ImageSource.camera:
        await AppPermissions.instance.requestCameraPermission();
      case ImageSource.gallery:
        await AppPermissions.instance.requestMediaLibraryPermission();

    }
    pickedImage = await _picker.pickImage(source: source,imageQuality: 100, requestFullMetadata: false);
    if (source == ImageSource.camera && pickedImage != null) {
      //Save the Image to the Gallery, to not lose the image (no need to await here).
      try {
        Gal.putImage(pickedImage.path, album: Constants.appName);
      } catch (_) {}
    }

    pickedMediaCallback(
      await _handlePickedImage(
        image: File(pickedImage?.path??''),
        maxSizeLimitInMB: maxAllowedImageSizeInMB,
      )
    );
  }

  // --- PICK SINGLE VIDEO ---
  static Future<void> pickVideo({
    required ImageSource source,
    required PickedSingleMediaCallback pickedMediaCallback,
    required PickerVideoProperties pickerVideoProperties,
  }) async {
    XFile? pickedVideo;
    switch (source) {
      case ImageSource.camera:
        await AppPermissions.instance.requestCameraPermission();
        break;

      case ImageSource.gallery:
        await AppPermissions.instance.requestMediaLibraryPermission();
        break;
    }
    pickedVideo = await _picker.pickVideo(
      source: source,
      maxDuration: pickerVideoProperties.maxRecordDuration ?? const Duration(minutes: AppLimits.maxVideoDurationInMinutes),
    );

    if (pickedVideo == null) {
      throw NoAttachmentPickedFailure();
    } else {
      if (source == ImageSource.camera) {
        //Save the video to the Gallery, to not lose the video.
        try {
          Gal.putVideo(pickedVideo.path, album: Constants.appName);
        } catch (_) {}
      }

      final file = await renameFile(pickedVideo);
      bool ignoreSize = pickerVideoProperties.ignoreSizeRestrictions;
      String videoExtension = MediaUtils.getFileExtension(file.path).toLowerCase();

      if (!MediaUtils.allowedVideoExtensions.contains(videoExtension)) {
        throw UnSupportedFileTypeFailure(allowedExtensions: MediaUtils.allowedVideoExtensions);
      }

      if (!ignoreSize) {
        final double sizeInMB = await getTotalSizeInMB(file);

        if (sizeInMB > pickerVideoProperties.maxAllowedSizeInMB) {
          throw FileSizeFailure(appLocalizer.maximumSizeLimitError(pickerVideoProperties.maxAllowedSizeInMB));
        }
      }

      String? videoThumbnailPath;

      if (pickerVideoProperties.generateThumbnail) {
        try {
          videoThumbnailPath = await injector<GetVideoThumbnailUseCase>().execute(videoPath: file.path);
        } catch (_) {}
      }

      pickedMediaCallback(
        Attachment(
          id: MediaUtils.generateUniqueId(index: 0),
          url: file.path,
          // sizeInByte: (await file.sizeInByte).toDouble(),
          type: AttachmentTypeEnum.video,
          thumbnail: ThumbnailAttachment(id: MediaUtils.generateUniqueId(index: 0), url: videoThumbnailPath??''),
          // mime: file.path.getMimeType,
        ),
      );
    }
  }

  static Future<void> pickImagesFromGallery({
    PickedMultipleMediaCallback? pickedImagesCallback,
    required PickerImagesProperty properties,
    bool withExceededLimitAttachments = false,
  }) async {
    await AppPermissions.instance.requestMediaLibraryPermission();

    int newMaxCount = properties.maxCount - properties.currentPickedImagesCount;

    if (newMaxCount <= 0) {
      throw FileSizeFailure(appLocalizer.maximumAllowedImages(properties.maxCount));
    }

    List<XFile> pickedImages = [];

    if (newMaxCount == 1) {
      final singleImage = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
        requestFullMetadata: false,
      );

      if (singleImage != null) {
        pickedImages.add(singleImage);
      }
    } else {
      pickedImages = await _picker.pickMultiImage(
          imageQuality: 100,
          requestFullMetadata: false,
          limit: newMaxCount
      );
    }


    List<File> images = pickedImages.map((xFile) => File(xFile.path)).toList();

    if (images.isEmpty) {
      throw NoAttachmentPickedFailure();
    }

   final handledImages = await _handlePickedImages(
      images: images,
      properties: properties,
    );

    pickedImagesCallback?.call(handledImages.pickedImages);

    if(handledImages.failure != null){
      throw handledImages.failure!;
    }
  }

  // --- HANDLERS ---
  static Future<({List<Attachment> pickedVideos, Failure? failure})> _handlePickedVideos({
    required List<File> videos,
    required PickerVideoProperties properties,
  }) async {
    final PickedMultiMediaLimitHandler pickedMultiMediaHandler = PickedMultiMediaLimitHandler(
        maxSizeLimit: properties.maxAllowedSizeInMB,
        maxCountLimit: properties.maxCount
    );

    for (int i = 0; i < videos.length; i++) {
      final video = (await renameFile(videos[i]));

      String? videoThumbnailPath;

      try {
        videoThumbnailPath = await injector<GetVideoThumbnailUseCase>().execute(videoPath: video.path);
      } catch (_) {}

      final attachment = Attachment(
          id: MediaUtils.generateUniqueId(index: i),
          url: video.path,
          type: AttachmentTypeEnum.video,
          // sizeInByte: (await video.sizeInByte).toDouble(),
          // mime: video.path.getMimeType,
          thumbnail: ThumbnailAttachment(id: MediaUtils.generateUniqueId(index: i), url: videoThumbnailPath??'')
      );

      //Check unSupported images
      if(!MediaUtils.isAllowedVideoExtension(video.path)){
        pickedMultiMediaHandler.addUnsupportedFormatAttachment(attachment);
        continue;
      }

      final sizeMB = await getTotalSizeInMB(video.path);
      log('sizeInMB $sizeMB');

      //Check size restrictions
      if (!properties.ignoreSizeRestrictions && sizeMB > properties.maxAllowedSizeInMB) {
        pickedMultiMediaHandler.addExceededSizeLimitAttachment(attachment);
        continue;
      }

      //Pick image if it passed all the checks
      pickedMultiMediaHandler.addAttachment(attachment);

      //check if exceeded max count
      if(pickedMultiMediaHandler.attachmentList.length > properties.maxCount){
        pickedMultiMediaHandler.addExceededMaxCount(videos.sublist(i+1).length);
        break;
      }
    }

    Failure? failure;

    if(pickedMultiMediaHandler.hasError){
      failure = MultiImagePickFailure(pickedMultiMediaHandler.getErrorMessage(), pickedMultiImagesEntity: pickedMultiMediaHandler);
    } else if(pickedMultiMediaHandler.attachmentList.isEmpty){
      failure = NoAttachmentPickedFailure();
    }

    return (pickedVideos: pickedMultiMediaHandler.attachmentList, failure: failure);

  }

  static Future<Attachment> _handlePickedImage({
    required File image,
    required int maxSizeLimitInMB,
  }) async {
    final sizeMB = await getTotalSizeInMB(image);

    if (sizeMB > maxSizeLimitInMB) {
      throw FileSizeFailure(
          appLocalizer.maximumSizeLimitError(maxSizeLimitInMB));
    }

    if (!MediaUtils.isAllowedImageExtension(image.path)) {
      throw UnSupportedFileTypeFailure(
          allowedExtensions: MediaUtils.allowedImageExtensions);
    }

    return Attachment(
      id: MediaUtils.generateUniqueId(index: 0),
      url: image.path,
      type: AttachmentTypeEnum.photo,
      // sizeInByte: (await image.sizeInByte).toDouble(),
      // mime: image.path.getMimeType,
    );
  }

  static Future<({List<Attachment> pickedImages, Failure? failure})> _handlePickedImages({
    required List<File> images,
    required PickerImagesProperty properties,
  }) async {
    final PickedMultiMediaLimitHandler pickedMultiImagesHandler = PickedMultiMediaLimitHandler(
        maxSizeLimit: properties.maxSizeLimitInMB,
        maxCountLimit: properties.maxCount
    );

    for (int i = 0; i < images.length; i++) {
      final imagePath = images[i].path;

      final pickedAttachment = Attachment(
        id: ('${RandomId.generate()}$i').toString(),
        url: imagePath,
        type: AttachmentTypeEnum.photo,
      );

      //Check unSupported images
      if(!MediaUtils.isAllowedImageExtension(imagePath)){
        pickedMultiImagesHandler.addUnsupportedFormatAttachment(pickedAttachment);
        continue;
      }

      //Check size restrictions
      final sizeInMB = await File(imagePath).sizeInMB;
      log('sizeInMB $sizeInMB');

      if (sizeInMB > properties.maxSizeLimitInMB) {
        pickedMultiImagesHandler.addExceededSizeLimitAttachment(pickedAttachment);
        continue;
      }

      //Pick image if it passed all the checks
      pickedMultiImagesHandler.addAttachment(pickedAttachment);

      //check if exceeded max count
      if(pickedMultiImagesHandler.attachmentList.length > properties.maxCount){
        pickedMultiImagesHandler.addExceededMaxCount(images.sublist(i+1).length);
        break;
      }
    }

    Failure? failure;

    if(pickedMultiImagesHandler.hasError){
      failure = MultiImagePickFailure(pickedMultiImagesHandler.getErrorMessage(), pickedMultiImagesEntity: pickedMultiImagesHandler);
    } else if(pickedMultiImagesHandler.attachmentList.isEmpty){
      failure = NoAttachmentPickedFailure();
    }

    return (pickedImages: pickedMultiImagesHandler.attachmentList, failure: failure);
  }

  static Future<void> handlePickerExceptions({required Future<void> Function() task}) async {
    final context = AppRouteNavigator.navigatorKey.currentContext!;

    try {
      await task();
    } on Failure catch (e) {
      if (e is NoAttachmentPickedFailure) {
        return;
      } else if (e is FileSizeFailure) {
        await AppAlerts.showDecisionDialog(
          context,
          title: appLocalizer.fileSizeError,
          description: e.errorMessage,
        );
      } else if (e is PermissionFailure && e.shouldOpenSettings) {
        AppAlerts.showOpenPermissionsSettingsDialog(context);
      } else if (e is MultiImagePickFailure) {
        AppAlerts.showCustomDialog(
          context,
          widget: MultiImagePickFailureAlert(pickedMultiImagesEntity: e.pickedMultiImagesEntity),
        );
      } else if (e is FileTypeFailure || e is UnSupportedFileTypeFailure) {
        await AppAlerts.showDecisionDialog(
          AppRouteNavigator.navigatorKey.currentContext!,
          title: e.errorMessage,
        );
      } else if (e is ExceededLimitAttachmentsFailure) {
        AppToasts.error(
          AppRouteNavigator.navigatorKey.currentContext!,
          message: appLocalizer.maximumSizeLimitWithSkippedError(
            e.maxSize,
            e.skippedNumber,
          ),
        );
      }else {
        await AppAlerts.showDecisionDialog(
          context,
          title: appLocalizer.errorPickingMedia,
          description: e.errorMessage,
          actionButtons: [
            DecisionButtonModel(
              title: appLocalizer.ok,
              onTap: (ctx) {
                AppRouteNavigator.pop(ctx);
              },
              isPrimary: true,
            ),
          ],
        );
      }
    } catch (e) {
      await AppAlerts.showDecisionDialog(
        context,
        title: appLocalizer.errorPickingMedia,
        actionButtons: [
          DecisionButtonModel(
            title: appLocalizer.ok,
            onTap: (ctx) {
              AppRouteNavigator.pop(ctx);
            },
            isPrimary: true,
          ),
        ],
      );
    }
  }
}
