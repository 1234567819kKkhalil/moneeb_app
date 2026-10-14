part of video_maestro;

class MaestroDoubleSpeedView extends StatelessWidget {
  final VideoPlayerController controller;
  const MaestroDoubleSpeedView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(8)
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 2,
          children: [
            Text("2x", style: context.medium.copyWith(color: Colors.white, fontSize: Dimensions.large),),

            //todo: handle direction
            const Icon(
              Icons.fast_forward_rounded,
              size: 20,
              color: Colors.white70,
            )
          ],
        ),
      ),
    );
  }
}
