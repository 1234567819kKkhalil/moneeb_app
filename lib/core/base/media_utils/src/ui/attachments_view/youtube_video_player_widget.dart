//
// import 'package:flutter/material.dart';
// import 'package:boilerplate/packages/media_utils/media_utils.dart';
// import 'package:boilerplate/packages/utils/utils.dart';
//
// class YoutubeVideoPlayerWidget extends StatefulWidget {
//   final Attachment attachment;
//   const YoutubeVideoPlayerWidget({Key? key,required this.attachment}) : super(key: key);
//
//   @override
//   State<YoutubeVideoPlayerWidget> createState() => _YoutubeVideoPlayerWidgetState();
// }
//
// class _YoutubeVideoPlayerWidgetState extends State<YoutubeVideoPlayerWidget> {
//   // late final PodPlayerController controller;
//
//   @override
//   void initState() {
//     super.initState();
//     // controller = PodPlayerController(
//     //   playVideoFrom: PlayVideoFrom.youtube(widget.attachment.url??''),
//     //   podPlayerConfig: const PodPlayerConfig(
//     //     videoQualityPriority: [720, 360],
//     //     autoPlay: false,
//     //   ),
//     // )..initialise();
//
//     // NestedNavObserver.instance.navStack.addListener(_pauseVideoWhenNotVisible);
//   }
//
//   @override
//   void deactivate() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       // controller.pause();
//     });
//     super.deactivate();
//   }
//
//   @override
//   void dispose() {
//     // NestedNavObserver.instance.navStack.removeListener(_pauseVideoWhenNotVisible);
//     // controller.dispose();
//     super.dispose();
//   }
//
//   _pauseVideoWhenNotVisible(){
//     // if(NestedNavObserver.instance.navStack.value.isNotEmpty){
//     //   if(NestedNavObserver.instance.navStack.value.last != ModalRoute.of(context)?.settings.name){
//     //     controller.pause();
//     //   }
//     // }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, size) {
//         return GestureDetector(
//           onLongPressStart: (details){
//             _showOpenLinkOption(details,size);
//           },
//           child: SizedBox(
//             width: context.width,
//             height: size.maxHeight,
//             child: SizedBox.shrink()
//             // PodVideoPlayer(
//             //     controller: controller,
//             //     frameAspectRatio: 2/1.65,
//             //     onLoading: (context) {
//             //       return const Center(
//             //         child: CircularProgressIndicator(color: context.appColors.primary.shade500),
//             //       );
//             //     },
//             //     podProgressBarConfig: PodProgressBarConfig(
//             //       circleHandlerColor: context.appColors.primary.shade500,
//             //       playingBarColor:  context.appColors.primary.shade500,
//             //       height: size.maxHeight*0.012,
//             //       padding: EdgeInsets.symmetric(horizontal: size.maxWidth * 0.045),
//             //       circleHandlerRadius: size.maxHeight*0.025,
//             //     ),
//             //
//             //     videoThumbnail: (widget.attachment.thumbnail?.isNotEmpty ?? false)
//             //         ? DecorationImage(
//             //       image: NetworkImage(concatWithBaseUrl(widget.attachment.thumbnail ?? '')),
//             //       fit: BoxFit.cover,
//             //     ) : null
//             // ),
//           ),
//         );
//       },
//
//     );
//   }
//
//   _showOpenLinkOption(details,BoxConstraints size) async{
//     final offset = details.globalPosition;
//
//     showMenu(
//         context: context,
//         useRootNavigator: true,
//         shape: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide.none,
//         ),
//         elevation: 4,
//
//         position: RelativeRect.fromLTRB(
//           offset.dx,
//           offset.dy,
//           size.maxWidth - offset.dx,
//           size.maxHeight - offset.dy,
//         ),
//         items: [
//           PopupMenuItem(
//             onTap: () async{
//               // final String? errorMessage = await appUrlLauncher((widget.attachment.url??''));
//               //
//               // if(errorMessage != null){
//               //   if(mounted){
//               //     showTopSnakeBar(
//               //       text: errorMessage,
//               //       context: context,
//               //       isSuccess: false,
//               //     );
//               //   }
//               // }
//             },
//
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 const Icon(Icons.link,color: context.appColors.primary.shade500,),
//
//                 SizedBox(width: PaddingDimensions.normal,),
//
//                 Padding( padding: EdgeInsets.zero,
//                   child: Text(
//                     "Open link",
//                     style: context.medium,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ]
//     );
//
//   }
// }
//
// /*class YoutubeVideoPlayerWidget extends StatefulWidget {
//   final Attachment attachment;
//   final Function()? onEnterFullScreenMode;
//   final Function()? onExitFullScreenMode;
//
//   static const routeName = "youtubePlayerPage";
//
//   const YoutubeVideoPlayerWidget({Key? key, this.onEnterFullScreenMode, this.onExitFullScreenMode, required this.attachment}) : super(key: key);
//
//   @override
//   State<YoutubeVideoPlayerWidget> createState() => _YoutubeVideoPlayerWidgetState();
// }
//
// class _YoutubeVideoPlayerWidgetState extends State<YoutubeVideoPlayerWidget> {
//   late YoutubePlayerController _controller;
//   String? videoID;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     videoID = YoutubePlayer.convertUrlToId(widget.attachment.url ?? '');
//
//     _controller = YoutubePlayerController(
//       initialVideoId: videoID ?? '',
//       flags: const YoutubePlayerFlags(
//         mute: false,
//         autoPlay: false,
//         disableDragSeek: false,
//         loop: false,
//         isLive: false,
//         forceHD: false,
//         enableCaption: false,
//         controlsVisibleAtStart: true,
//         hideThumbnail: true
//       ),);
//   }
//
//   @override
//   void deactivate() {
//     _controller.pause();
//     super.deactivate();
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: LayoutBuilder(
//         builder: (context, size) {
//           return OverflowBox(
//             minWidth: context.width-(MediaQuery.of(context).padding.right+MediaQuery.of(context).padding.left),
//             maxWidth: context.width-(MediaQuery.of(context).padding.right+MediaQuery.of(context).padding.left),
//
//             child: SizedBox(
//               height: size.maxHeight,
//               child: GestureDetector(
//                 onLongPressStart: (details) async{
//                   final offset = details.globalPosition;
//
//                   showMenu(
//                       context: context,
//                       useRootNavigator: true,
//                       shape: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8),
//                         borderSide: BorderSide.none,
//                       ),
//                       elevation: 4,
//
//                       position: RelativeRect.fromLTRB(
//                         offset.dx,
//                         offset.dy,
//                         size.maxWidth - offset.dx,
//                         size.maxHeight - offset.dy,
//                       ),
//                       items: [
//                         PopupMenuItem(
//                           onTap: () async{
//                             final String? errorMessage = await appUrlLauncher(widget.attachment.url ?? '');
//
//                             if(errorMessage != null){
//                               if(mounted){
//                                 showTopSnakeBar(
//                                   text: errorMessage,
//                                   context: context,
//                                   isSuccess: false,
//                                 );
//                               }
//                             }
//                           },
//
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               const Icon(Icons.link,color: context.appColors.primary.shade500,),
//
//                               SizedBox(width: PaddingDimensions.normal,),
//
//                               Padding( padding: EdgeInsets.zero,
//                                 child: Text(
//                                   "Open link",
//                                   style: context.medium,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ]
//                   );
//
//                 },
//                 child: YoutubePlayerBuilder(
//                     onEnterFullScreen: widget.onEnterFullScreenMode,
//                     onExitFullScreen: widget.onExitFullScreenMode,
//                     player: YoutubePlayer(
//                       controller: _controller,
//                       showVideoProgressIndicator: true,
//                       liveUIColor: AppColors.primaryColor,
//                       progressIndicatorColor: AppColors.primaryColor,
//                       aspectRatio: 2/1,
//                       onReady: () {
//                         isLoading = false;
//                         log(isLoading.toString());
//                         setState(() {});
//                       },
//
//                       onEnded: (_){
//                         _controller.pause();
//                       },
//                       progressColors: const ProgressBarColors(
//                         backgroundColor: AppColors.primary_50,
//                         playedColor: context.appColors.primary.shade500,
//                         handleColor: context.appColors.primary.shade500,
//                         bufferedColor: AppColors.primaryColor3,
//                       ),
//                     ),
//                     builder: (context, player){
//                       return SafeArea(
//                           child: player
//                       );
//                     }
//                 ),
//               ),
//             ),
//           );
//         },
//
//       ),
//     );
//   }
// }*/
