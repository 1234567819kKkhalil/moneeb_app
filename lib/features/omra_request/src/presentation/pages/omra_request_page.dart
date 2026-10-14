part of omra_request;

class OmraRequestPage extends StatelessWidget {
  const OmraRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: injector<OmraRequestCubit>(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBars.defaultBar(
          context,
          centerTitle: true,
          text: appLocalizer.requestOmraNav,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(right: 16, left: 16),
          child: BlocBuilder<OmraRequestCubit, OmraRequestState>(
            buildWhen: (previous, current) =>
                previous.resetKey != current.resetKey,
            builder: (context, state) {
              return Column(
                key: ValueKey(state.resetKey),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: Dimensions.xxLarge),
                  Text(
                    appLocalizer.enterRequiredFields,
                    style: context.medium.copyWith(
                      fontSize: Dimensions.xxLarge,
                      color: context.appColors.secondary.shade500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    appLocalizer.beneficiaryCondition,
                    style: context.medium.copyWith(
                      fontSize: Dimensions.xLarge,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: Dimensions.xLarge),
                  BlocBuilder<OmraRequestCubit, OmraRequestState>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: state.omraTypes.map((type) {
                                return OmraTypeItem(type: type);
                              }).toList(),
                            ),
                          ),
                          if (state.validationStatus.isFailure &&
                              state.omraTypeSelected.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                                right: 8.0,
                              ),
                              child: Text(
                                appLocalizer.pleaseSelectOmraType,
                                style: TextStyle(
                                  color: Colors.redAccent.shade200,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<OmraRequestCubit, OmraRequestState>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextFormField(
                            hint: appLocalizer.beneficiaryNameHint,
                            onChange: (val) => context
                                .read<OmraRequestCubit>()
                                .updateBeneficiaryName(val),
                            prefixIcon: const Padding(
                              padding: EdgeInsets.all(12),
                              child: AppSvg(svgPath: AssetPaths.iconPilgrim),
                            ),
                          ),
                          if (state.validationStatus.isFailure &&
                              state.beneficiaryName.trim().isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                                right: 8.0,
                              ),
                              child: Text(
                                appLocalizer.pleaseEnterBeneficiaryName,
                                style: TextStyle(
                                  color: Colors.redAccent.shade200,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  Text(
                    appLocalizer.gender,
                    style: context.medium.copyWith(
                      fontSize: Dimensions.xLarge,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<OmraRequestCubit, OmraRequestState>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RadioGroup<String>(
                            groupValue: state.genderSelected,
                            onChanged: (value) => context
                                .read<OmraRequestCubit>()
                                .selectGender(value ?? ''),
                            child: Row(
                              children: state.gender.map((genderOption) {
                                return OmraGenderItem(gender: genderOption);
                              }).toList(),
                            ),
                          ),
                          if (state.validationStatus.isFailure &&
                              state.genderSelected.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                                right: 8.0,
                              ),
                              child: Text(
                                appLocalizer.pleaseSelectGender,
                                style: TextStyle(
                                  color: Colors.redAccent.shade200,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  AppTextFormField(
                    hint: appLocalizer.writeYourNotes,
                    onChange: (val) =>
                        context.read<OmraRequestCubit>().updateCustomDua(val),
                    maxLines: 4,
                    minLines: 4,
                  ),
                  const SizedBox(height: 18),
                  BlocBuilder<OmraRequestCubit, OmraRequestState>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => context
                                .read<OmraRequestCubit>()
                                .showDateDialog(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const AppSvg(svgPath: AssetPaths.iconDate),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      state.dateStarted.isEmpty
                                          ? appLocalizer.requestDate
                                          : state.dateStarted,
                                      style: context.medium.copyWith(
                                        color:
                                            context.appColors.primary.shade500,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: context.appColors.primary.shade500,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (state.validationStatus.isFailure &&
                              state.dateStarted.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                                right: 8.0,
                              ),
                              child: Text(
                                appLocalizer.pleaseSelectRequestDate,
                                style: TextStyle(
                                  color: Colors.redAccent.shade200,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      BlocBuilder<OmraRequestCubit, OmraRequestState>(
                        builder: (context, state) {
                          return Checkbox(
                            value: state.isCheck,
                            onChanged: (val) => context
                                .read<OmraRequestCubit>()
                                .updateCheck(val ?? false),
                            checkColor: context.appColors.secondary.shade500,
                            activeColor: context.appColors.primary.shade500,
                            side: const BorderSide(color: Colors.white),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity(
                              horizontal: VisualDensity.minimumDensity,
                              vertical: VisualDensity.minimumDensity,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appLocalizer.assignUmrahProvider,
                              style: context.medium.copyWith(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  BlocBuilder<OmraRequestCubit, OmraRequestState>(
                    builder: (context, state) {
                      if (state.isCheck && state.selectedPilgrim != null) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: UmrahPilgrimItem(
                            changeButtomName: true,
                            provider: state.selectedPilgrim!,
                            onTap: () {
                              AppRouteNavigator.push(
                                context,
                                AllProvidersPage.routeName,
                                const AllProvidersPage(),
                              );
                            },
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 30),

                  Padding(
                    padding: EdgeInsets.only(
                      right: 16,
                      left: 16,
                      bottom: Dimensions.bottomNavBarSafePadding(context),
                    ),
                    child: BlocConsumer<OmraRequestCubit, OmraRequestState>(
                      listenWhen: (previous, current) =>
                          previous.submitStatus != current.submitStatus,
                      listener: (context, state) {
                        if (state.submitStatus.isFailure) {
                          AppAlerts.showDecisionDialog(
                            context,
                            title: appLocalizer.errorOccurred,
                            description:
                                state.submitStatus.failure?.errorMessage ??
                                appLocalizer.submitOrderErrorDesc,
                            actionButtons: [
                              DecisionButtonModel(
                                title: appLocalizer.ok,
                                onTap: (ctx) => AppRouteNavigator.pop(ctx),
                                isPrimary: true,
                              ),
                            ],
                          );
                        } else if (state.submitStatus.isSuccess) {
                          context.read<OmraRequestCubit>().clearData();
                          AppToasts.success(
                            context,
                            message: appLocalizer.orderSubmittedSuccessfully,
                          );
                          NavObserver.instance.changeTab(
                            MainHostPageTabsEnum.orders,
                          );
                        }
                      },
                      builder: (context, state) {
                        final bool showContinue =
                            state.isCheck && state.selectedPilgrim == null;
                        return AppPrimaryButton(
                          text: showContinue
                              ? appLocalizer.continueText
                              : appLocalizer.confirmText,
                          isExpanded: true,
                          isLoading: state.submitStatus.isLoading,
                          onPressed: () {
                            if (showContinue) {
                              AppRouteNavigator.push(
                                context,
                                AllProvidersPage.routeName,
                                const AllProvidersPage(),
                              );
                            } else {
                              context.read<OmraRequestCubit>().submitOrder();
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
