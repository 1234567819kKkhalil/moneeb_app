part of home;

class UmrahTrackingSection extends StatelessWidget {
  final String orderId;
  final ForWhomEntity forWhom;

  const UmrahTrackingSection({
    super.key,
    required this.orderId,
    required this.forWhom,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (context.read<AuthenticationBloc>().getUserRole ==
                UserRoleEnum.provider) {
              AppRouteNavigator.push(
                context,
                ProviderOmrahPage.routeName,
                ProviderOmrahPage(
                  orderId: orderId,
                  forWhom: forWhom,
                ),
              );
            } else {
              AppRouteNavigator.push(
                context,
                UserOmrahInspectorPage.routeName(orderId),
                UserOmrahInspectorPage(
                  orderId: orderId,
                  beneficiaryName: forWhom.beneficiaryName,
                ),
              );
            }
          },
          child: Container(
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            padding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 18,
            ),
            decoration: BoxDecoration(
              color: context.appColors.primary.shade500,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppSvg(
                  svgPath: AssetPaths.iconUmrah,
                ),
                const SizedBox(height: 8),
                Text(
                  appLocalizer.umrahTracking,
                  style: context.bold.copyWith(
                    color: context.appColors.neutral.shade900,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 14),
                Skeletonizer(
                  enabled: state.timeLines.isEmpty,
                  child: SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          state.timeLines.isEmpty ? 3 : state.timeLines.length,
                          (index) {
                            if (state.timeLines.isEmpty) {
                              return UmrahStageItem(
                                stage: UmraTimeLine(
                                  title: 'Loading...',
                                  content: '',
                                  type: '',
                                  status: '',
                                  iconStatus: '',
                                  icon: '',
                                ),
                                index: index,
                              );
                            }
                            UmraTimeLine stage = state.timeLines[index];
                            return UmrahStageItem(
                              stage: stage,
                              index: index,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
