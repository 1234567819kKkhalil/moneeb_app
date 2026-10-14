part of home;

class UmrahStageItem extends StatelessWidget {
  final UmraTimeLine stage;
  final int index;

  const UmrahStageItem({super.key, required this.stage, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16),
      width: 80,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xff1C1C1C),
              border: Border.all(
                color: stage.status == 'UNDERWAY' 
                    ? context.appColors.secondary.shade500 
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: AppSvg(
              svgPath: stage.icon,
              width: 24,
              height: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            stage.title,
            textAlign: TextAlign.center,
            style: context.theme.textTheme.bodyMedium?.copyWith(
              fontSize: 12,
              color: context.appColors.neutral.shade900
            ),
          ),
        ],
      ),
    );
  }
}
