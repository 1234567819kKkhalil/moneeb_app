part of omra_request;

class OmraGenderItem extends StatelessWidget {
  final OmraSetting gender;

  const OmraGenderItem({super.key, required this.gender});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.read<OmraRequestCubit>().selectGender(gender.data),
      child: Padding(
        padding: const EdgeInsetsDirectional.only(end: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Radio<String>(
              value: gender.data,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              gender.title,
              style: context.regular.copyWith(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
