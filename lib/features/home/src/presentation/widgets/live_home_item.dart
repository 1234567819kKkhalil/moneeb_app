part of home;

class LiveHomeItem extends StatelessWidget {
  final UserTest live;

  const LiveHomeItem({super.key, required this.live});

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
            AppImage(path: live.imageUrl, width: 80, height: 80),
            const SizedBox(height: 12),
            Text(
              live.name,
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
