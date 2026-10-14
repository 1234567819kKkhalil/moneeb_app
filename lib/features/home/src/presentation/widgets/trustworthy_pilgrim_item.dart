part of home;

class TrustworthyPilgrimItem extends StatelessWidget {
  final UserTest user;

  const TrustworthyPilgrimItem({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12),
      width: 100,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: context.appColors.secondary.shade500, width: 2),
            ),
            child: ClipOval(
              child: AppImage(path: user.imageUrl, width: 80, height: 80),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            user.name,
            textAlign: TextAlign.center,
            style: context.theme.textTheme.bodyMedium?.copyWith(
              fontSize: 12,
              color: context.appColors.neutral.shade900
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star, color: AppColors.secondary500, size: 12),
              const SizedBox(width: 4),
              Text(
                user.rate,
                style: context.theme.textTheme.bodySmall?.copyWith(
                  color: context.appColors.neutral.shade900,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
