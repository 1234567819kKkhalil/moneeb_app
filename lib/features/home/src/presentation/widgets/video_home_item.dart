part of home;

class VideoHomeItem extends StatelessWidget {
  final AppSettings video;

  const VideoHomeItem({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12),
      width: 140,
      height: 200,
      decoration: BoxDecoration(
        color: context.appColors.primary.shade500,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (video.icon != null)
              AppImage(path: video.icon!, width: 60, height: 60),
            const SizedBox(height: 8),
            Text(
              video.title,
              textAlign: TextAlign.center,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: context.appColors.neutral.shade900
              ),
            ),
          ],
        ),
      ),
    );
  }
}
