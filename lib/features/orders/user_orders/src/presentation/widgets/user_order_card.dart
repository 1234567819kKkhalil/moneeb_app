part of user_orders;

class UserOrderCard extends StatelessWidget {
  final UserOrderEntity order;
  // final UserOrderStatus currentTab;

  const UserOrderCard({
    super.key,
    required this.order,
    // required this.currentTab,
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
        collapsedShape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.circular(16),
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: context.appColors.neutral.shade900),
          borderRadius: BorderRadius.circular(16),
        ),
        tilePadding: const EdgeInsetsDirectional.only(start: 12, end: 16),
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appLocalizer.umrahForBeneficiary(
                      order.beneficiaryType.toLocalizedName(),
                    ), // Assuming beneficiary type indicates this
                    style: context.semiBold.copyWith(
                      color: context.appColors.neutral.shade900,
                      fontSize: 11,
                    ),
                  ),
                  // Live "starts in ..." glance, only while the day has not come.
                  if (order.status == UserOrderStatus.accepted &&
                      !OmrahSchedule.hasStarted(order.targetDate)) ...[
                    const SizedBox(height: 4),
                    OmrahCountdownLabel(
                      targetDate: order.targetDate,
                      style: context.medium.copyWith(
                        color: context.appColors.secondary.shade500,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            _StatusBadge(status: order.status),
            const SizedBox(width: 8),
            AppSvg(svgPath: AssetPaths.iconCheck),
            // const SizedBox(width: 16),
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
  final UserOrderStatus status;

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
      case UserOrderStatus.pending:
        return (const Color(0xFFFFF3CD), const Color(0xFF8A6D1B));
      case UserOrderStatus.assigned:
        return (const Color(0xFFE3F0FF), const Color(0xFF1B5FA8));
      case UserOrderStatus.accepted:
        return (const Color(0xFFE6F4EA), const Color(0xFF1E7B45));
      case UserOrderStatus.inProgress:
        return (const Color(0xFFE2CA91), const Color(0xFF4A3708));
      case UserOrderStatus.completed:
        return (const Color(0xFFD8F5EC), const Color(0xFF0F7A62));
      case UserOrderStatus.rejected:
        return (const Color(0xFFFDE3E1), const Color(0xFFC62828));
      case UserOrderStatus.cancelled:
        return (const Color(0xFFEDEDED), const Color(0xFF5A5A5A));
    }
  }
}

class _OrderDetails extends StatelessWidget {
  final UserOrderEntity order;
  // final UserOrderStatus currentTab;

  const _OrderDetails({required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Column(
        children: [
          _dataRow(context, appLocalizer.orderNumber, order.serialNumber),
          AppDivider(thickness: 1, color: context.appColors.primary.shade300),

          _dataRow(
            context,
            appLocalizer.beneficiaryCondition,
            order.beneficiaryType.toLocalizedName(),
          ),
          AppDivider(thickness: 1, color: context.appColors.primary.shade300),

          _dataRow(
            context,
            appLocalizer.beneficiaryNameHint,
            order.beneficiaryName,
          ),
          AppDivider(thickness: 1, color: context.appColors.primary.shade300),
          _dataRow(
            context,
            appLocalizer.beneficiaryGenderLabel,
            order.beneficiaryGender?.localizedName ?? '--',
          ),
          /* AppDivider(thickness: 1, color: context.appColors.primary.shade300),
          _dataRow(
            context,
            'صورة المعتمر له',
            order.,
            withImage: true,
          ), */
          AppDivider(thickness: 1, color: context.appColors.primary.shade300),
          _dataRow(
            context,
            appLocalizer.requestDate,
            order.targetDate?.toDDMMMyyyy ?? '--',
          ),

          if (order.status == UserOrderStatus.pending ||
              order.status == UserOrderStatus.assigned) ...[
            const SizedBox(height: 16),
            _ActionButtons(order: order),
          ],

          // Accepted but not started: let the requester see how long is left.
          if (order.status == UserOrderStatus.accepted &&
              order.targetDate != null) ...[
            const SizedBox(height: 16),
            OmrahStartCountdownCard(
              targetDate: order.targetDate,
              isProvider: false,
            ),
          ],

          if (order.status == UserOrderStatus.inProgress) ...[
            const SizedBox(height: 16),

            AppPrimaryButton(
              text: appLocalizer.continueOmrah,
              isExpanded: true,
              onPressed: () {
                AppRouteNavigator.push(
                  context,
                  UserOmrahInspectorPage.routeName(order.id),
                  UserOmrahInspectorPage(
                    orderId: order.id,
                    beneficiaryName: order.beneficiaryName,
                  ),
                );
              },
            ),
          ],

          if (order.status == UserOrderStatus.completed) ...[
            const SizedBox(height: 16),

            AppPrimaryButton(
              text: appLocalizer.viewOmrah,
              isExpanded: true,
              onPressed: () {
                AppRouteNavigator.push(
                  context,
                  UserOmrahInspectorPage.routeName(order.id),
                  UserOmrahInspectorPage(
                    orderId: order.id,
                    beneficiaryName: order.beneficiaryName,
                  ),
                );
              },
            ),

            const SizedBox(height: 12),
            _CertificateAction(order: order),
          ],
        ],
      ),
    );
  }

  Widget _dataRow(
    BuildContext context,
    String label,
    String value, {
    bool withImage = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: Text(
              label,
              textDirection: TextDirection.rtl,
              style: context.regular.copyWith(
                color: context.appColors.primary.shade400,
                fontSize: 10,
              ),
            ),
          ),
          if (withImage)
            AppImage(path: value, width: 24, height: 24)
          else
            Text(
              value,
              textDirection: TextDirection.rtl,
              style: context.regular.copyWith(
                color: context.appColors.primary.shade400,
                fontSize: 10,
              ),
            ),
        ],
      ),
    );
  }
}

/// Issues the omrah certificate of a completed order, then opens its preview.
///
/// Scoped per card so the loading state never bleeds into the other orders.
class _CertificateAction extends StatelessWidget {
  final UserOrderEntity order;

  const _CertificateAction({required this.order});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderCertificateCubit(
        orderId: order.id,
        serialNumber: order.serialNumber,
        beneficiaryName: order.beneficiaryName,
        certificateUrl: order.certificateUrl,
      ),
      child: _CertificateButton(order: order),
    );
  }
}

class _CertificateButton extends StatelessWidget {
  final UserOrderEntity order;

  const _CertificateButton({required this.order});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrderCertificateCubit, OrderCertificateState>(
      listenWhen: (previous, current) =>
          previous.certificate.isLoading && !current.certificate.isLoading,
      listener: (context, state) {
        if (state.certificate.isSuccess) {
          AppToasts.success(
            context,
            message: appLocalizer.certificateGeneratedSuccessfully,
          );
          _openPreview(context, state.certificateUrl);
        } else if (state.certificate.isFailure) {
          AppToasts.error(
            context,
            message: state.certificate.failure?.errorMessage ?? '',
          );
        }
      },
      builder: (context, state) {
        final hasCertificate = state.hasCertificate;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!hasCertificate) ...[
              Text(
                appLocalizer.certificateHintForUser,
                style: context.regular.copyWith(
                  fontSize: 11,
                  color: AppColors.neutral400,
                ),
              ),
              const SizedBox(height: 12),
            ],

            AppPrimaryButton(
              text: hasCertificate
                  ? appLocalizer.viewCertificate
                  : appLocalizer.generateCertificate,
              isExpanded: true,
              isLoading: state.certificate.isLoading,
              leadingWidget: Padding(
                padding: const EdgeInsetsDirectional.only(
                  end: PaddingDimensions.normal,
                ),
                child: Icon(
                  hasCertificate ? Iconsax.document_text : Iconsax.medal_star,
                  size: IconDimensions.normal,
                ),
              ),
              onPressed: () {
                if (hasCertificate) {
                  _openPreview(context, state.certificateUrl);
                } else {
                  context.read<OrderCertificateCubit>().generateCertificate();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _openPreview(BuildContext context, String? certificateUrl) {
    AppRouteNavigator.push(
      context,
      OrderCertificatePage.routeName,
      OrderCertificatePage(
        orderId: order.id,
        serialNumber: order.serialNumber,
        beneficiaryName: order.beneficiaryName,
        certificateUrl: certificateUrl,
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final UserOrderEntity order;

  const _ActionButtons({required this.order});

  @override
  Widget build(BuildContext context) {
    // The user can only cancel an order that is pending or assigned
    return BlocBuilder<UserOrdersCubit, UserOrdersCubitState>(
      builder: (context, state) {
        final isLoading = state
            .orders
            .isLoading; // Simple way, better to have a separate cubit but fine for now

        return Row(
          children: [
            Expanded(
              child: _buildButton(
                context,
                label: appLocalizer.cancelOrderBtn,
                color: const Color(0xFFE53935),
                isLoading: isLoading,
                onTap: () {
                  context.read<UserOrdersCubit>().cancelOrder(
                    order.id,
                    onSuccess: () {
                      if (!context.mounted) return;
                      AppToasts.success(
                        context,
                        message: appLocalizer.orderCanceledSuccess,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String label,
    required Color color,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: context.semiBold.copyWith(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
      ),
    );
  }
}
