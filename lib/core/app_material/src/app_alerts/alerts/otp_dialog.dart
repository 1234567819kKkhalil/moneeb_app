part of app_material;

class OtpDialog extends StatefulWidget {
  final OTP otp;

  const OtpDialog({super.key, required this.otp});

  @override
  State<OtpDialog> createState() => _OtpDialogState();
}

class _OtpDialogState extends State<OtpDialog> {
  Timer? timer;
  int timeRemainingInSeconds = 0;
  int blockTime = 0;
  final dateNow = DateTime.now();
  Duration? duration;

  @override
  void initState() {
    duration = widget.otp.firstOTPTime
        .add(const Duration(minutes: Constants.blocOtpDurationInMinutes))
        .difference(dateNow);
    blockTime = (duration?.inSeconds ?? 0);
    timeRemainingInSeconds = blockTime;
    startTimer();
    super.initState();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      blockTime--;
      timeRemainingInSeconds = blockTime;
      if (timeRemainingInSeconds >= 0) {
        setState(() {
          timeRemainingInSeconds;
        });
      } else {
        timer.cancel();
        Navigator.pop(context);
      }
    });
  }

  String prettyRemainingTime() {
    int sec = timeRemainingInSeconds % 60;
    int min = (timeRemainingInSeconds / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute:$second";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: PaddingDimensions.large),
      child: RichText(
        text: TextSpan(
          text: appLocalizer.otpNumberExceeded,
          style: context.medium,
          children: [
            TextSpan(
              text: "\t${prettyRemainingTime()}\t ${appLocalizer.minutes}",
              style: context.semiBold,
            ),
          ],
        ),
      ),
    );
  }
}
