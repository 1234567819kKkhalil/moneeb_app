part of home;

class RealTrustItem extends StatelessWidget {
  final Stage stage;
  final int index;

  const RealTrustItem({super.key, required this.stage, required this.index});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 72 / 112,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          AppImage(
            path: stage.imageUrl,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(12),
          ),
          Text(
            stage.name,
            textAlign: TextAlign.center,
            style: context.bold.copyWith(
              fontSize: 13,
              color: context.appColors.neutral.shade900,
            ),
          ),
        ],
      ),
    );
  }
}
