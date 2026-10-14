part of settings;

class AppSettingsBottomSheet extends StatefulWidget {
  final String slug;
  final String title;

  const AppSettingsBottomSheet({
    super.key,
    required this.slug,
    required this.title,
  });

  @override
  State<AppSettingsBottomSheet> createState() => _AppSettingsBottomSheetState();
}

class _AppSettingsBottomSheetState extends State<AppSettingsBottomSheet> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsCubit>().fetchAppSettings(widget.slug);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final bool isLoading = state.appSettingsData.isLoading;
        final AppSettingsModel data =
            state.appSettingsData.data ?? AppSettingsModel.initial();

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
              const SizedBox(height: 16),
              Text(
                widget.title,
                style: context.semiBold.copyWith(
                  fontSize: Dimensions.xxLarge,
                  color: context.appColors.secondary.shade500,
                ),
              ),
              const SizedBox(height: PaddingDimensions.small),
              Text(
                appLocalizer.pleaseReadContentCarefully,
                style: context.regular.copyWith(
                  fontSize: Dimensions.normal,
                  color: context.appColors.neutral.shade500,
                ),
              ),
              const SizedBox(height: PaddingDimensions.large),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.appColors.primary.shade500.withValues(
                      alpha: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(Dimensions.largeRadius),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: PaddingDimensions.normal,
                    vertical: PaddingDimensions.large,
                  ),
                  child: state.appSettingsData.isFailure
                      ? FailureWidget(
                          failure: state.appSettingsData.failure,
                          textColor: context.appColors.neutral.shade50,
                          onRetryPressed: () {
                            context.read<SettingsCubit>().fetchAppSettings(
                              widget.slug,
                            );
                          },
                        )
                      : Skeletonizer(
                          enabled: isLoading,
                          containersColor: context.appColors.neutral.shade300
                              .withValues(alpha: 0.5),
                          effect: ShimmerEffect(
                            highlightColor: context.appColors.neutral.shade300
                                .withValues(alpha: 0.5),
                            baseColor: context.appColors.neutral.shade300
                                .withValues(alpha: 0.5),
                            duration: const Duration(seconds: 1),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              data.content,
                              style: context.regular.copyWith(
                                fontSize: Dimensions.large,
                                color: context.appColors.neutral.shade900,
                                height: 1.8,
                              ),
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: PaddingDimensions.large),
            ],
          ),
        );
      },
    );
  }
}
