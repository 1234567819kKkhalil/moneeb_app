part of helper_widgets;

class SelectProfileImageWidget extends StatelessWidget {
  final void Function(String? imagePath) onImageSelected;
  final String? imagePath;
  final UserRoleEnum userRole;
  final double size;

  const SelectProfileImageWidget({
    super.key,
    required this.onImageSelected,
    this.imagePath,
    required this.userRole,
    this.size = 80,
  });

  // void onSelectImageTap(BuildContext context) {
  //   AppBottomSheets.showMediaPickerUtilsBottomSheet(
  //     context: context,
  //     pickConfigs: const [
  //       MediaPickImageConfig.single(isCamera: false),
  //       MediaPickImageConfig.single(isCamera: true),
  //     ],
  //     onPickMedia: (media) {
  //       onImageSelected(media.url);
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: SizedBox(
          width: size,
          height: size,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: const ShapeDecoration(
                    shape: CircleBorder(side: BorderSide(width: 2)),
                  ),
                  child: AppImage.profileImage(path: imagePath ?? ''),
                ),
              ),
              // if (userRole == UserRoleEnum.consultant)
              const PositionedDirectional(
                start: 0,
                bottom: -2,
                child: Icon(
                  Icons.close,
                  // color: context.appColors.neutral.shade50,
                ),
              ),
              PositionedDirectional(
                bottom: -2,
                end: 0,
                child: GestureDetector(
                  onTap: () {
                    //todo:
                    //onSelectImageTap(context);
                  },
                  child: imagePath?.isEmpty ?? true
                      ? Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const ShapeDecoration(
                            // gradient: LinearGradient(
                            //   begin: Alignment(1.00, 0.00),
                            //   end: Alignment(-1, 0),
                            //   colors: AppColors.primaryGradiantColors,
                            // ),
                            shape: CircleBorder(
                              side: BorderSide(width: 1.5, color: Colors.white),
                            ),
                          ),
                          child: Icon(
                            Icons.close,
                            size: IconDimensions.small,
                            color: context.appColors.appBackgroundColor,
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.all(6),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          child: const AppShader(
                            child: Icon(
                              Icons.close,
                              size: IconDimensions.xSmall,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
