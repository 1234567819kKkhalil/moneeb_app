part of image_editor;

class ImageEditorPage extends StatelessWidget {
  final String path;
  final bool isCircleCrop;
  final Function(String filePath) onImageEdited;

  const ImageEditorPage({
    super.key,
    required this.path,
    this.isCircleCrop = false,
    required this.onImageEdited,
  });

  static const String routeName = "ImageEditorPage";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImageEditorCubit(),
      child: _ImageEditorBody(
        onImageEdited: onImageEdited,
        path: path,
        isCircleCrop: isCircleCrop,
      ),
    );
  }
}


class _ImageEditorBody extends StatefulWidget {
  final String path;
  final bool isCircleCrop;
  final Function(String filePath) onImageEdited;

  const _ImageEditorBody({
    super.key,
    required this.path,
    this.isCircleCrop = false,
    required this.onImageEdited,
  });

  @override
  State<_ImageEditorBody> createState() => _ImageEditorBodyState();
}

class _ImageEditorBodyState extends State<_ImageEditorBody> {
  final List<AspectRatioModel> _aspectRatios = [
    AspectRatioModel(text: appLocalizer.custom, value: CropAspectRatios.custom),
    AspectRatioModel(text: appLocalizer.original, value: CropAspectRatios.original),
    const AspectRatioModel(text: '1*1', value: CropAspectRatios.ratio1_1),
    const AspectRatioModel(text: '4*3', value: CropAspectRatios.ratio4_3),
    const AspectRatioModel(text: '3*4', value: CropAspectRatios.ratio3_4),
    const AspectRatioModel(text: '16*9', value: CropAspectRatios.ratio16_9),
    const AspectRatioModel(text: '9*16', value: CropAspectRatios.ratio9_16)
  ];

  late final ValueNotifier<AspectRatioModel> _aspectRatio;

  late EditorCropLayerPainter? _cropLayerPainter;
  final ImageEditorController _editorController = ImageEditorController();
  final MyRulerController _rulerPickerController = MyRulerController(value: 0.0);
  late ImageProvider imageProvider;

  double maxZoom = 8;

  @override
  void initState() {
    _aspectRatio = ValueNotifier<AspectRatioModel>(_aspectRatios.first);

    imageProvider = AppImage.getImageProvider(path: widget.path,cacheRawData: true);

    if (widget.isCircleCrop) {
      _cropLayerPainter = const CircleEditorCropLayerPainter();
      _setCircleAspectRatio();
      maxZoom = 5;
    } else {
      _cropLayerPainter = const EditorCropLayerPainter();
    }

    super.initState();
  }

  @override
  void dispose() {
    _editorController.dispose();
    _rulerPickerController.dispose();
    _aspectRatio.dispose();
    super.dispose();
  }

  void _setCircleAspectRatio() {
    _aspectRatio.value = _aspectRatios.firstWhereOrNull(
            (element) => element.value == CropAspectRatios.ratio1_1) ??
        _aspectRatios.first;
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = context.appColors.primary.shade700;
    final double systemGestureInsets =
        MediaQuery.systemGestureInsetsOf(context).right;

    return BlocListener<ImageEditorCubit,ImageEditorState>(
      listener: (context, state) {
        if(state.editImage.isLoading){
          AppBlockerLoader.showLoader(
            context,
            text: state.isSavingToGallery == true
                ? appLocalizer.savingToGallery
                : appLocalizer.editingImagePleaseWait,
          );
        }else{
          AppBlockerLoader.removeLoader();
        }

        if(state.editImage.isFailure){
          AppToasts.error(context, message: state.editImage.failure?.errorMessage ?? '');
        }else if(state.editImage.isSuccess){
          if(state.isSavingToGallery == true){
            AppToasts.success(context, message: appLocalizer.imageSavedToGallery);
          }else{
            widget.onImageEdited(state.editImage.data!);
            AppRouteNavigator.pop(context);
          }
        }
      },
      child: Scaffold(
        appBar: AppBars.defaultBar(
          context,
          text: appLocalizer.imageEditor,

          useCloseButton: true,
          actions: <Widget>[
            // AppIconButton(
            //   iconData: Icons.download,
            //   size: IconDimensions.normal,
            //   startPadding: PaddingDimensions.normal,
            //   endPadding: PaddingDimensions.large,
            //   color: context.appColors.neutral.shade900,
            //   onPressed: () {
            //     context.read<ImageEditorCubit>().editImage(
            //       filePath: widget.path,
            //       editorController: _editorController,
            //       isSavingToGallery: true
            //     );
            //   },
            // ),
            AppIconButton(
              iconData: Icons.done,
              startPadding: PaddingDimensions.normal,
              endPadding: PaddingDimensions.large,
              color: context.appColors.neutral.shade900,
              onPressed: () async {
                context.read<ImageEditorCubit>().editImage(
                  filePath: widget.path,
                  editorController: _editorController,
                  isSavingToGallery: false
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          bottom: true,
          child: Column(
            children: <Widget>[
              Expanded(
                child: ExtendedImage(
                  image: imageProvider,
                  fit: BoxFit.contain,
                  mode: ExtendedImageMode.editor,
                  enableLoadState: true,
                  initEditorConfigHandler: (ExtendedImageState? state) {
                    return EditorConfig(
                      maxScale: maxZoom,
                      cornerColor: context.appColors.neutral.shade900,
                      cropRectPadding: EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: systemGestureInsets == 0
                              ? 16
                              : systemGestureInsets),
                      hitTestSize: 20.0,
                      cropLayerPainter: _cropLayerPainter!,
                      initCropRectType: InitCropRectType.layoutRect,
                      cropAspectRatio: _aspectRatio.value.value,
                      controller: _editorController,
                    );
                  },
                ),
              ),

              const Divider(),

              ButtonTheme(
                minWidth: 0.0,
                padding: EdgeInsets.zero,
                child: Row(
                  children: <Widget>[
                    ChangeNotifierBuilder(
                      changeNotifier: _editorController,
                      builder: (_) {
                        //UNDO
                        return ButtonTheme(
                          minWidth: 0.0,
                          padding: EdgeInsets.zero,
                          child: Row(children: <Widget>[
                            _ButtonIconWithLabel(
                              icon: Icon(
                                Icons.undo,
                                color: _editorController.canUndo
                                    ? primaryColor
                                    : Colors.grey,
                              ),
                              label: Text(
                                appLocalizer.undo,
                                style: context.regular.copyWith(
                                  fontSize: Dimensions.normal,
                                  color: _editorController.canUndo
                                      ? primaryColor
                                      : Colors.grey,
                                ),
                              ),
                              textColor: Colors.white,
                              onPressed: () {
                                _onUndoOrRedo(() {
                                  _editorController.undo();
                                });
                              },
                            ),

                            //REDO
                            _ButtonIconWithLabel(
                              icon: Icon(
                                Icons.redo,
                                color: _editorController.canRedo
                                    ? primaryColor
                                    : Colors.grey,
                              ),
                              label: Text(
                                appLocalizer.redo,
                                style: context.regular.copyWith(fontSize: Dimensions.normal, color: _editorController.canRedo
                                  ? primaryColor
                                  : Colors.grey,),
                              ),
                              textColor: Colors.white,
                              onPressed: () {
                                _onUndoOrRedo(() {
                                  _editorController.redo();
                                });
                              },
                            ),
                          ]),
                        );
                      },
                    ),

                    const Spacer(),

                    //RESET
                    _ButtonIconWithLabel(
                      icon: const Icon(Icons.restore),
                      label: Text(
                        appLocalizer.reset,
                        style: context.regular.copyWith(fontSize: Dimensions.normal),
                      ),
                      textColor: Colors.white,
                      onPressed: () {
                        _editorController.reset();
                        _rulerPickerController.value = 0;

                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),

              //FLIP
              ButtonTheme(
                minWidth: 0.0,
                padding: EdgeInsets.zero,
                child: Row(
                  children: <Widget>[
                    //FLIP
                    _ButtonIconWithLabel(
                      icon: const Icon(Icons.flip),
                      label: Text(
                        appLocalizer.flip,
                        style: context.regular.copyWith(fontSize: Dimensions.normal),
                      ),
                      textColor: Colors.white,
                      onPressed: () {
                        _editorController.flip(
                          animation: true,
                        );
                      },
                    ),

                    //RULER
                    Expanded(
                      child: LayoutBuilder(
                        builder: (BuildContext _, BoxConstraints constraints) {
                          return RulerPicker(
                            controller: _rulerPickerController,
                            rulerBackgroundColor: context.appColors.appBackgroundColor,
                            rulerScaleTextStyle: const TextStyle(
                              color: Color.fromARGB(255, 188, 194, 203),
                              fontSize: 10,
                            ),
                            marker: Transform.translate(
                              offset: const Offset(0, -5),
                              child: Container(
                                width: 2,
                                height: 44,
                                color: primaryColor,
                              ),
                            ),
                            onValueChanged: (num value) {
                              if (_rulerPickerController.value
                                      .toDouble()
                                      .equalTo(value.toDouble()) &&
                                  !_onUndoOrRedoing) {
                                return;
                              }
                              HapticFeedback.lightImpact();

                              _editorController.rotate(
                                degree: value.toDouble() -
                                    _rulerPickerController.value,
                              );

                              _rulerPickerController.setValueWithOutNotify(value);
                            },
                            width: constraints.maxWidth,
                            height: 50,
                            onBuildRulerScaleText:
                                (int index, num rulerScaleValue) {
                              return '$rulerScaleValue';
                            },
                            ranges: const <RulerRange>[
                              RulerRange(begin: -45, end: 45, scale: 1),
                            ],
                          );
                        },
                      ),
                    ),

                    //ROTATE
                    _ButtonIconWithLabel(
                      icon: const Icon(Icons.rotate_right),
                      label: Text(
                        appLocalizer.rotateRight,
                        style: context.regular.copyWith(fontSize: Dimensions.small),
                      ),
                      textColor: Colors.white,
                      onPressed: () {
                        _editorController.rotate(
                          degree: 90,
                          animation: true,
                          rotateCropRect: true,
                        );
                      },
                    ),
                  ],
                ),
              ),

              //ASPECT RATIO CONTAINERS
              SizedBox(
                height: 85,
                child: ValueListenableBuilder<AspectRatioModel>(
                  valueListenable: _aspectRatio,
                  builder: (BuildContext context, AspectRatioModel value,
                      Widget? child) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, index) {
                        final AspectRatioModel item = _aspectRatios[index];

                        return GestureDetector(
                          onTap: () {
                            _editorController.updateCropAspectRatio(item.value);
                            _aspectRatio.value = item;
                          },
                          child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 4),
                              child: CustomPaint(
                                size: const Size(70, 60),
                                painter: AspectRatioPainter(
                                  aspectRatio: item.value,
                                  aspectRatioText: item.text,
                                  isSelected: item == _aspectRatio.value,
                                  selectedColor: primaryColor
                                ),
                              )),
                        );
                      },
                      itemCount: _aspectRatios.length,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _onUndoOrRedoing = false;

  void _onUndoOrRedo(Function fn) {
    final double oldRotateDegrees = _editorController.rotateDegrees;
    final double? oldCropAspectRatio =
        _editorController.originalCropAspectRatio;
    _onUndoOrRedoing = true;
    fn();
    _onUndoOrRedoing = false;
    final double newRotateDegrees = _editorController.rotateDegrees;
    final double? newCropAspectRatio =
        _editorController.originalCropAspectRatio;
    if (oldRotateDegrees != newRotateDegrees &&
        !(newRotateDegrees - oldRotateDegrees).isZero &&
        (newRotateDegrees - oldRotateDegrees) % 90 != 0) {
      _rulerPickerController.value =
          _rulerPickerController.value + (newRotateDegrees - oldRotateDegrees);
    }

    if (oldCropAspectRatio != newCropAspectRatio) {
      if (newCropAspectRatio == null) {
        _aspectRatio.value = _aspectRatios.first;
      } else {
        _aspectRatio.value = _aspectRatios.firstWhere(
          (AspectRatioModel element) => element.value == newCropAspectRatio,
          orElse: () => _aspectRatios.first,
        );
      }
    }
  }


}

class _ButtonIconWithLabel extends TextButton {
  _ButtonIconWithLabel({
    Color? textColor,
    required Widget icon,
    required Widget label,
    required VoidCallback super.onPressed,
  }) : super(
          style: textColor != null
              ? ButtonStyle(
                  textStyle: WidgetStateProperty.all<TextStyle>(
                  TextStyle(color: textColor),
                ))
              : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              icon,
              const SizedBox(height: PaddingDimensions.xSmall),
              label,
            ],
          ),
        );
}
