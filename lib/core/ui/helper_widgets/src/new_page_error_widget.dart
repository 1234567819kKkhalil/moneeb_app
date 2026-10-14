part of helper_widgets;

class NewPageErrorWidget extends StatelessWidget {
  final Failure failure;
  final Function() onReloadTap;
  final Color? color;

  const NewPageErrorWidget({
    super.key,
    required this.failure,
    required this.onReloadTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AppShader(
          child: AppIconButton(
            iconData: Icons.close, ////TODO:- change icons
            onPressed: onReloadTap,
            color: color,
          ),
        ),
        const SizedBox(height: PaddingDimensions.small),
        Text(
          failure.errorMessage,
          style: context.medium.copyWith(color: color),
        ),
      ],
    );
  }
}
