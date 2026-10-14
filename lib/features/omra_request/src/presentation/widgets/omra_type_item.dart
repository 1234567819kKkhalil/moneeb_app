part of omra_request;

class OmraTypeItem extends StatelessWidget {
  final OmraSetting type;

  const OmraTypeItem({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<OmraRequestCubit>().selectOmraType(type.data),
      child: Container(
        margin: const EdgeInsetsDirectional.only(end: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: type.isSelected
              ? context.appColors.secondary.shade500
              : context.appColors.neutral.shade900,
          borderRadius: BorderRadius.circular(12),
          /*  border: Border.all(
            color: type.isSelected
                ? context.appColors.neutral
                : Colors.white24,
          ), */
        ),
        child: Text(
          type.title,
          style: context.medium.copyWith(
            color: type.isSelected
                ? context.appColors.neutral.shade900
                : context.appColors.neutral.shade50,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
