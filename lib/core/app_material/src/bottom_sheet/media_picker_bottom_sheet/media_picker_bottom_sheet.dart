part of app_material;

/// Main widget that builds and displays a media picker bottom sheet.
class MediaPickerBottomSheet extends StatelessWidget {
  final BuildContext pageContext;
  final PickedSingleMediaCallback? onPickMedia;
  final PickedMultipleMediaCallback? onPickMultiMedia;
  final List<MediaPickItemConfig> picksConfig;
  final VoidCallback? onPickStart;
  final Function()? onPickEnd;

  final List<Widget> _items = [];
  bool _isPicking = false;

  MediaPickerBottomSheet({
    super.key,
    required this.pageContext,
    required this.onPickMedia,
    required this.onPickMultiMedia,
    required this.picksConfig,
    this.onPickStart,
    this.onPickEnd,
  }) {
    for (var config in picksConfig) {
      _items.add(_buildTileFromModel(config));
    }
  }

  Widget _buildTileFromModel(MediaPickItemConfig config) {
    switch (config) {

      // HANDLE IMAGES
      case MediaPickImageConfig() :
        if(config.isMultiple){
          return _Tile(
            label: config.label ?? appLocalizer.chooseFromLibrary,
            iconData: config.icon ?? Iconsax.image,
            secondLabel: config.secondLabel,
            onTap: (context) => _onPickPressed(
              context,
              pickTask: () async {
                await MediaPicker.pickImagesFromGallery(
                  properties: config.multiPicksProperties,
                  pickedImagesCallback: onPickMultiMedia,
                );
              },
            ),
          );
        } else {
          return _Tile(
            label: config.label ?? (config.isCamera ? appLocalizer.takePhoto :appLocalizer.chooseFromLibrary),
            iconData: config.icon ?? (config.isCamera ? Iconsax.camera : Iconsax.image),
            secondLabel: config.secondLabel,
            onTap: (context) => _onPickPressed(
              context,
              pickTask: () async {
                await _onPickAndModify(
                  source: config.isCamera ? ImageSource.camera : ImageSource.gallery,
                  canModifyImage: config.canModifyImage
                );
              },
            ),
          );
        }

        // VIDEOS
        case MediaPickVideoConfig() :
          return _Tile(
            label: config.label ?? (config.isCamera ? appLocalizer.takeVideo : appLocalizer.chooseFromLibrary),
            iconData: config.icon ?? (config.isCamera ? Iconsax.video : Iconsax.gallery),
            secondLabel: config.secondLabel,
            onTap: (context) => _onPickPressed(
              context,
              pickTask: () async {
                await MediaPicker.pickVideo(
                  pickedMediaCallback: onPickMedia!,
                  source: config.isCamera ? ImageSource.camera : ImageSource.gallery,
                  pickerVideoProperties: config.pickerVideoProperties,
                );
              },
            ),
          );

      // MEDIA (VIDEOS OR IMAGES)
      case MediaPickMediaConfig():
        return _Tile(
          label: config.label ?? appLocalizer.chooseFromLibrary,
          iconData: config.icon ?? Iconsax.image,
          secondLabel: config.secondLabel,
          onTap: (context) => _onPickPressed(
            context,
            pickTask: () async {
              await MediaPicker.pickMultipleMediaFromGallery(
                pickedMediaCallback: onPickMultiMedia,
                imagesProperties: config.imagesProperties,
                videoProperties: config.videoProperties,
                maxAllowedMediaCount: config.imagesProperties.maxCount,
              );
            },
          ),
        );

      // CUSTOM
      case MediaPickCustomConfig() :
        return _Tile(
          label: config.label ?? '',
          iconData: config.icon ?? Iconsax.trash,
          secondLabel: config.secondLabel,
          onTap: (context) {
            config.callback?.call();
          },
        );

    }
  }

  Future<void> _onPickAndModify({required ImageSource source,required bool canModifyImage}) async {
    Attachment? pickedAttachment;
    await MediaPicker.pickImage(
      pickedMediaCallback: (media) {
        pickedAttachment = media;
        if (canModifyImage && pickedAttachment != null) {
          if (!pageContext.mounted) return;

          AppRouteNavigator.push(
            pageContext,
            ImageEditorPage.routeName,
            ImageEditorPage(
              path: pickedAttachment!.url,
              onImageEdited: (filePath) =>
                  onPickMedia?.call(pickedAttachment!.modify(url: filePath)),
              isCircleCrop: false,
            ),
          );
        } else {
          onPickMedia?.call(pickedAttachment!);
        }
      },
      source: source,
    );
  }

  void _onPickPressed(BuildContext context, {required Future<void> Function() pickTask}) async {
    if (context.mounted) AppRouteNavigator.pop(context);

    _isPicking = true;
    onPickStart?.call();

    await MediaPicker.handlePickerExceptions(task: pickTask);

    _isPicking = false;
    onPickEnd?.call();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop && !_isPicking) {
          onPickEnd?.call();
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _items,
      ),
    );
  }
}

/// A reusable tile used in the bottom sheet to represent each media option.
class _Tile extends StatelessWidget {
  final IconData iconData;
  final Color? iconColor;
  final String label;
  final String? secondLabel;
  final void Function(BuildContext context) onTap;

  const _Tile({
    required this.iconData,
    this.iconColor,
    required this.label,
    this.secondLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => onTap(context),
          behavior: HitTestBehavior.translucent,
          child: Row(
            children: [
              Icon(
                iconData,
                size: IconDimensions.normal,
                color: iconColor ?? AppColors.neutral900
              ),
              const SizedBox(width: PaddingDimensions.regular),
              Text(
                label,
                style: context.regular.copyWith(
                  color:AppColors.neutral900,
                ),
              ),
              if (secondLabel?.isNotEmpty ?? false) ...[
                const SizedBox(width: PaddingDimensions.normal),
                Flexible(
                  child: Text(
                    secondLabel!,
                    style: context.regular.copyWith(
                      color: AppColors.neutral900,
                      fontSize: Dimensions.xxLarge,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ]
            ],
          ),
        ),
        const SizedBox(height: PaddingDimensions.mLarge - 2),
      ],
    );
  }
}

