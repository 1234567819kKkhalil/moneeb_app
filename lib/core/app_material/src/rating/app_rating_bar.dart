part of app_material;

class AppRatingBar extends StatelessWidget {
  const AppRatingBar({
    super.key,
    this.onRatingUpdate,
    this.initialRating,
    this.ignoreGestures,
    this.itemSize,
    this.filledIconColor,
    this.emptyIconColor,
    this.itemPadding,
    this.useEmptyOutlineIcon = true,
    this.itemCount,
  });
  final void Function(double)? onRatingUpdate;
  final double? initialRating;
  final bool? ignoreGestures;
  final bool useEmptyOutlineIcon;
  final double? itemSize;
  final Color? filledIconColor;
  final Color? emptyIconColor;
  final double? itemPadding;
  final int? itemCount;

  @override
  Widget build(BuildContext context) {
    return RatingBar(
        initialRating: initialRating ?? 0,
        ignoreGestures: ignoreGestures ?? false,
        itemCount: itemCount ?? 5,
        itemSize: itemSize ?? 32,
        glow: false,
        ratingWidget: RatingBarIconTypes(
          full: const Icon(
            Icons.star_rounded,
            color: AppColors.warning500,
          ),
          empty: Icon(
            Iconsax.star,
            color: emptyIconColor ?? AppColors.neutral50,
          ),
          half: const Icon(
            Icons.star_half_rounded,
            color: AppColors.warning500,
          ),
        ),
        glowColor: context.appColors.neutral.shade50,
        textDirection: TextDirection.ltr,
        itemPadding: EdgeInsets.symmetric(horizontal: itemPadding ?? 3.0),
        onRatingUpdate: onRatingUpdate ?? (rate) {});
  }
}
