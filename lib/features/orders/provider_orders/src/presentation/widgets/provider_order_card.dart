part of provider_orders;

class ProviderOrderCard extends StatelessWidget {
  final ProviderOrderEntity order;

  const ProviderOrderCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.appColors.primary.shade400,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        controlAffinity: ListTileControlAffinity.leading,
        collapsedIconColor: context.appColors.neutral.shade900,
        iconColor: context.appColors.neutral.shade900,
        backgroundColor: context.appColors.primary.shade400,
        collapsedBackgroundColor: context.appColors.primary.shade400,
        expansionAnimationStyle: AnimationStyle(
          curve: Curves.ease,
          duration: const Duration(milliseconds: 400),
          reverseDuration: const Duration(milliseconds: 400),
          reverseCurve: Curves.easeIn,
        ),
        collapsedShape: const RoundedRectangleBorder(
          side: BorderSide.none,
        ),
        shape: const RoundedRectangleBorder(
          side: BorderSide.none,
        ),
        tilePadding: const EdgeInsetsDirectional.only(start: 12, end: 16),
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.beneficiaryName,
                    style: context.semiBold.copyWith(
                      color: context.appColors.neutral.shade900,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    appLocalizer.omrahForBeneficiary(order.beneficiaryType.toLocalizedName()),
                    style: context.regular.copyWith(
                      color: context.appColors.secondary.shade500,
                      fontSize: 10,
                    ),
                  ),
                  // Live "starts in ..." glance, only while the day has not come.
                  if (order.status == ProviderOrderStatus.accepted &&
                      !OmrahSchedule.hasStarted(order.targetDate)) ...[
                    const SizedBox(height: 4),
                    OmrahCountdownLabel(
                      targetDate: order.targetDate,
                      style: context.medium.copyWith(
                        color: context.appColors.neutral.shade900,
                        fontSize: 10,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                ],
              ),
            ),

            const SizedBox(width: 12),

            _StatusBadge(status: order.status),

            const SizedBox(width: 8),

            AppSvg(svgPath: AssetPaths.iconCheck),
          ],
        ),
        children: [
          Container(
            color: context.appColors.neutral.shade900,
            width: double.infinity,
            child: _OrderDetails(order: order),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ProviderOrderStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final label = status.toLocalizedName();
    if (label.isEmpty) return const SizedBox.shrink();

    final (background, foreground) = _statusColors();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: context.medium.copyWith(color: foreground, fontSize: 11),
      ),
    );
  }

  (Color background, Color foreground) _statusColors() {
    switch (status) {
      case ProviderOrderStatus.pending:
        return (const Color(0xFFFFF3CD), const Color(0xFF8A6D1B));
      case ProviderOrderStatus.assigned:
        return (const Color(0xFFE3F0FF), const Color(0xFF1B5FA8));
      case ProviderOrderStatus.accepted:
        return (const Color(0xFFE6F4EA), const Color(0xFF1E7B45));
      case ProviderOrderStatus.inProgress:
        return (const Color(0xFFE2CA91), const Color(0xFF4A3708));
      case ProviderOrderStatus.completed:
        return (const Color(0xFFD8F5EC), const Color(0xFF0F7A62));
      case ProviderOrderStatus.rejected:
        return (const Color(0xFFFDE3E1), const Color(0xFFC62828));
      case ProviderOrderStatus.cancelled:
        return (const Color(0xFFEDEDED), const Color(0xFF5A5A5A));
    }
  }
}

class _OrderDetails extends StatelessWidget {
  final ProviderOrderEntity order;

  const _OrderDetails({required this.order});

  @override
  Widget build(BuildContext context) {
    final Widget _divider = AppDivider(
      thickness: 0.4,
      color: context.appColors.primary.shade800,
    );

    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Column(
        children: [
          _dataRow(
            context,
            appLocalizer.beneficiaryCondition,
            order.beneficiaryType.toLocalizedName(),
          ),

          _divider,

          _dataRow(
            context,
            appLocalizer.beneficiaryNameHint,
            order.beneficiaryName,
          ),

          _divider,

          _dataRow(
            context,
            appLocalizer.beneficiaryGenderLabel,
            order.beneficiaryGender?.localizedName ?? '--',
          ),

          _divider,

          // اسم طالب الخدمة (صاحب الحساب) مخفي عن مقدم الخدمة
          // _dataRow(
          //   context,
          //   appLocalizer.requesterName,
          //   order.requester?.fullName ?? '--',
          // ),
          //
          // _divider,

          _dataRow(
            context,
            appLocalizer.requestDate,
            order.targetDate?.toDDMMMyyyy ?? '--'
          ),

          _divider,

          if (order.status == ProviderOrderStatus.pending ||
              order.status == ProviderOrderStatus.assigned) ...[
            const SizedBox(height: 16),
            _AcceptOrRejectButtons(order: order),
          ],

          if (order.status == ProviderOrderStatus.accepted || order.status == ProviderOrderStatus.inProgress)...[
            const SizedBox(height: 16),

            // The rituals may only begin on the day the requester picked; the
            // card flips to a "time has come" state by itself when it arrives.
            if (order.status == ProviderOrderStatus.accepted &&
                order.targetDate != null) ...[
              OmrahStartCountdownCard(
                targetDate: order.targetDate,
                isProvider: true,
              ),
              const SizedBox(height: 12),
            ],

            Row(
              spacing: 8,
              children: [
                Expanded(
                  child: _RitualsButton(order: order),
                ),

                // if(currentTab == ProviderOrderStatus.inProgress)
                // Expanded(
                //   child: AppPrimaryButton(
                //     text: appLocalizer.finishOmrah,
                //     isExpanded: false,
                //     buttonStyle: (currentStyle) {
                //       return currentStyle?.copyWith(
                //         backgroundColor: WidgetStatePropertyAll(const Color(0xFFE53935),)
                //        );
                //      },
                //     onPressed: () {
                //       AppAlerts.showDecisionDialog(
                //         context,
                //         title: appLocalizer.didYouFinishOmrah,
                //         description: "هل اديت كل مناسك العمره؟",
                //         actionButtons: [
                //           DecisionButtonModel(
                //             title: appLocalizer.yesIFinishedOmrah,
                //             isPrimary: true,
                //             onTap: (_) {
                //               context.read<ProviderActionsCubit>().completeOrder(order.id,);
                //               AppRouteNavigator.pop(context);
                //             },
                //           ),
                //           DecisionButtonModel(
                //             title: appLocalizer.noNotYet,
                //             isPrimary: false,
                //             onTap: (_) {
                //               AppRouteNavigator.pop(context);
                //             },
                //           )
                //         ]
                //       );
                //     },
                //   ),
                // ),
              ],
            )
          ],
        ],
      ),
    );
  }

  Widget _dataRow(BuildContext context, String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: context.regular.copyWith(
              color: context.appColors.primary.shade400,
              fontSize: 12,
            ),
          ),
        ),
        Text(
          value,
          style: context.regular.copyWith(
            color: context.appColors.primary.shade400,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _AcceptOrRejectButtons extends StatelessWidget {
  final ProviderOrderEntity order;

  const _AcceptOrRejectButtons({required this.order});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProviderActionsCubit, ProviderActionsState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: AppPrimaryButton(
                text: appLocalizer.accept,
                isLoading: state.acceptState.isLoading,
                onPressed: () {
                  context.read<ProviderActionsCubit>().acceptOrder(
                    order.id,
                    ForWhomEntity(
                      beneficiaryName: order.beneficiaryName,
                      beneficiaryType: order.beneficiaryType
                    ),
                    order.targetDate,
                  );
                },
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: AppPrimaryButton(
                text: appLocalizer.rejectBtn,
                buttonStyle: (currentStyle) {
                  return currentStyle?.copyWith(
                      backgroundColor: WidgetStatePropertyAll(const Color(0xFFE53935),)
                  );
                },
                isLoading: state.rejectState.isLoading,
                onPressed: () {
                  context.read<ProviderActionsCubit>().rejectOrder(
                      order.id,
                      "" //todo: add rejection reason
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }
}

/// Opens the rituals of an order. Before the day the requester picked it stays
/// locked (and says when it opens); it unlocks by itself the moment the day
/// arrives.
class _RitualsButton extends StatelessWidget {
  final ProviderOrderEntity order;

  const _RitualsButton({required this.order});

  void _open(BuildContext context) {
    AppRouteNavigator.push(
      context,
      ProviderOmrahPage.routeName,
      ProviderOmrahPage(
        orderId: order.id,
        forWhom: ForWhomEntity(
          beneficiaryName: order.beneficiaryName,
          beneficiaryType: order.beneficiaryType,
        ),
        targetDate: order.targetDate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // An order already in progress has begun, whatever its date says.
    if (order.status == ProviderOrderStatus.inProgress) {
      return _unlocked(context);
    }

    return OmrahCountdownBuilder(
      targetDate: order.targetDate,
      builder: (context, remaining) {
        final bool isLocked = remaining != Duration.zero;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          switchInCurve: Curves.easeOutBack,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          ),
          child: isLocked ? _locked(context) : _unlocked(context),
        );
      },
    );
  }

  Widget _unlocked(BuildContext context) {
    final gold = context.appColors.secondary.shade500;

    return Container(
      key: const ValueKey('unlocked'),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: gold.withValues(alpha: 0.35),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: AppPrimaryButton(
        text: appLocalizer.ritualsList,
        isExpanded: true,
        leadingWidget: const Padding(
          padding: EdgeInsetsDirectional.only(end: PaddingDimensions.normal),
          child: Icon(Iconsax.play_circle, size: IconDimensions.normal),
        ),
        onPressed: () => _open(context),
      ),
    );
  }

  Widget _locked(BuildContext context) {
    final color = context.appColors.primary.shade400;
    final startDate = OmrahSchedule.startOf(order.targetDate);
    final label = startDate == null
        ? appLocalizer.ritualsList
        : appLocalizer.ritualsLockedUntil(startDate.toDDMMMyyyy);

    return GestureDetector(
      key: const ValueKey('locked'),
      onTap: () => AppToasts.error(
        context,
        message: startDate == null
            ? appLocalizer.ritualsList
            : appLocalizer.omrahNotStartedYet(startDate.toDDMMMyyyy),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Iconsax.lock_1, size: IconDimensions.normal, color: color.withValues(alpha: 0.6)),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.medium.copyWith(
                  fontSize: 13,
                  color: color.withValues(alpha: 0.7),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
