part of video_maestro;

class MaestroTimeView extends StatelessWidget {
  final VideoPlayerController videoPlayerController;
  const MaestroTimeView({super.key, required this.videoPlayerController});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: videoPlayerController,
      builder: (context, value, child) {
        return RichText(
          text: TextSpan(
            text: "${formatToMinutesAndSeconds(value.position)} / ",
            style: context.medium.copyWith(
              color: Colors.white,
              fontSize: Dimensions.large,
            ),
            children: [
              TextSpan(
                text: formatToMinutesAndSeconds(value.duration),
                style: context.medium.copyWith(
                  color: Colors.white.withAlpha(220),
                  fontSize: Dimensions.large,
                ),
              )
            ]
          )
        );
      },
    );
  }

  String formatToMinutesAndSeconds(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (twoDigits(duration.inHours) != '00') {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }
}
