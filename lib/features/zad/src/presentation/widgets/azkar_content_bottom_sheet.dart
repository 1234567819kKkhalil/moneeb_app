part of zad;

class AzkarContentBottomSheet extends StatelessWidget {
  final String slug;
  final String title;
  final String? subtitle;

  const AzkarContentBottomSheet({
    super.key,
    required this.slug,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          injector<AzkarContentCubit>()..fetchAzkarContent(slug),
      child: BlocBuilder<AzkarContentCubit, AzkarContentState>(
        builder: (context, state) {
          final bool isLoading = state.azkarContent.isLoading;
          final AzkarContentModel data =
              state.azkarContent.data ?? AzkarContentModel.initial();

          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 24),
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
                // SizedBox(height: 16),
                Text(
                  title,
                  style: context.semiBold.copyWith(
                    fontSize: Dimensions.xxLarge,
                    color: context.appColors.secondary.shade500,
                  ),
                ),
                const SizedBox(height: PaddingDimensions.small),
                Text(
                  subtitle?.isNotEmpty ?? false
                      ? subtitle!
                      : appLocalizer
                            .repeatTheseAzkarWithHumilityAndSincerityToGod,
                  style: context.regular.copyWith(
                    fontSize: Dimensions.normal,
                    color: context.appColors.neutral.shade500,
                  ),
                ),
                const SizedBox(height: PaddingDimensions.large),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.appColors.primary.shade500.withValues(
                        alpha: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(
                        Dimensions.largeRadius,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: PaddingDimensions.normal,
                      vertical: PaddingDimensions.large,
                    ),
                    child: Skeletonizer(
                      enabled: isLoading,
                      containersColor: context.appColors.neutral.shade300
                          .withValues(alpha: 0.5),
                      effect: ShimmerEffect(
                        highlightColor: context.appColors.neutral.shade300
                            .withValues(alpha: 0.5),
                        baseColor: context.appColors.neutral.shade300
                            .withValues(alpha: 0.5),
                        duration: Duration(seconds: 1),
                      ),
                      child: ListView.builder(
                        itemCount: data.items.length,
                        itemBuilder: (context, index) {
                          final item = data.items[index];
                          return _AzkarItemWidget(data: item);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AzkarItemWidget extends StatelessWidget {
  final AzkarItemModel data;

  const _AzkarItemWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: context.appColors.neutral.shade900,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(width: Dimensions.large),
            Expanded(
              child: Text(
                data.text,
                style: context.regular.copyWith(
                  fontSize: Dimensions.large,
                  color: context.appColors.neutral.shade900,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
        if (data.count > 1) ...[
          const SizedBox(height: Dimensions.small),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 22.0),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: context.appColors.neutral.shade500,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: Dimensions.small),
                Text(
                  'يُقال ${data.count} مرة على الأقل',
                  style: context.regular.copyWith(
                    fontSize: Dimensions.normal,
                    color: context.appColors.neutral.shade500,
                  ),
                ),
              ],
            ),
          ),
        ],
        if (data.reference != null && data.reference!.isNotEmpty) ...[
          const SizedBox(height: Dimensions.small),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 22.0),
            child: Text(
              '(${data.reference})',
              style: context.medium.copyWith(
                fontSize: Dimensions.normal,
                color: context.appColors.neutral.shade500,
              ),
            ),
          ),
        ],
        const SizedBox(height: PaddingDimensions.large),
      ],
    );
  }
}
