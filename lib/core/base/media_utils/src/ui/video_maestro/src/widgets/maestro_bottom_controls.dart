part of video_maestro;

class MaestroBottomControls extends StatelessWidget {
  final MaestroController controller;
  final int orientation;
  final OptionsVisibilityControl optionsVisibility;
  const MaestroBottomControls({super.key, required this.controller, required this.orientation, required this.optionsVisibility,});

  // void _openSpeedBottomSheet(BuildContext context) {
  //   final double currentPlaybackSpeed = controller.videoPlayerController.value.playbackSpeed;
  //
  //   AppBottomSheets.showPlaybackSpeedBottomSheet(
  //       context,
  //       currentPlaybackSpeed: currentPlaybackSpeed,
  //       onTap: (context, speed){
  //         controller.videoPlayerController.setPlaybackSpeed(speed);
  //         AppRouteNavigator.pop(context);
  //       }
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: GestureDetector(
        onTap: () {},
        onHorizontalDragStart: (_) {},  // absorb start
        onHorizontalDragUpdate: (_) {}, // absorb movement
        onHorizontalDragEnd: (_) {},    // absorb end
        behavior: HitTestBehavior.opaque, // ensure it catches touches
        child: Container(
          padding: const EdgeInsets.only(
            left: PaddingDimensions.pageHorizontalPadding,
            right: PaddingDimensions.pageHorizontalPadding,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black12,
                Colors.black54,
                Colors.black87,
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Directionality(
                textDirection: TextDirection.ltr,
                child: MaestroSeekControlBar(
                  maestroController: controller,
                  orientation: orientation,
                ),
              ),

              const Gap(2),

              Flexible(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MaestroPlayPauseButton(
                      videoPlayerController: controller.videoPlayerController,
                    ),
                
                    const Gap(4),
                
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: MaestroTimeView(
                          videoPlayerController: controller.videoPlayerController,
                        ),
                      ),
                    ),

                    //SPEED BUTTON
                    // if(optionsVisibility.showSpeedButton)
                    // GestureDetector(
                    //   onTap: () {
                    //     _openSpeedBottomSheet(context);
                    //   },
                    //   child: const Padding(
                    //     padding: EdgeInsetsDirectional.only(bottom: 12,end: 4,start: 4),
                    //     child: Icon(
                    //       Icons.speed,
                    //       color: Colors.white,
                    //       size: 24,
                    //     ),
                    //   ),
                    // ),
                
                    //FULL SCREEN BUTTON
                    if(optionsVisibility.showFullScreenButton) ...[
                      const Gap(4),
                
                      GestureDetector(
                        onTap: () {
                          if(controller.isInFullScreen){
                            AppRouteNavigator.pop(context);
                          } else {
                            AppRouteNavigator.pushWithDragToPopTransition(context, VideoMaestroFullScreen.routeName, VideoMaestroFullScreen(controller: controller));
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsetsDirectional.only(bottom: 12,start: 8),
                          child: Icon(
                            Icons.fullscreen,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                      )
                    ]
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}