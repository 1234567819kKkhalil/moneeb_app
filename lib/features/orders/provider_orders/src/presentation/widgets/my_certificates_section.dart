part of provider_orders;

/// Horizontal strip of the certificates the signed in user is party to.
///
/// Drops itself from the layout when there is nothing to show, so a provider
/// with no completed omrah does not get an empty section.
class MyCertificatesSection extends StatelessWidget {
  static const double _cardWidth = 180;
  static const double _cardHeight = 150;
  static const int _skeletonCount = 3;

  const MyCertificatesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MyCertificatesCubit()..fetchCertificates(),
      child: const _MyCertificatesBody(),
    );
  }
}

class _MyCertificatesBody extends StatelessWidget {
  const _MyCertificatesBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyCertificatesCubit, MyCertificatesState>(
      builder: (context, state) {
        final isLoading =
            state.certificates.isLoading || state.certificates.isInitial;

        final certificates = state.certificates.data ?? const [];

        // Nothing to show and nothing to retry, so stay out of the layout.
        if (!isLoading &&
            certificates.isEmpty &&
            !state.certificates.isFailure) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appLocalizer.myCertificates,
              style: context.bold.copyWith(
                fontSize: 14,
                color: context.appColors.secondary.shade500,
              ),
            ),

            const Gap(16),

            if (state.certificates.isFailure)
              FailureWidget(
                failure: state.certificates.failure,
                onRetryPressed: () =>
                    context.read<MyCertificatesCubit>().fetchCertificates(),
              )
            else
              AppSkeletonizer(
                isEnabled: isLoading,
                child: SizedBox(
                  height: MyCertificatesSection._cardHeight,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.zero,
                    itemCount: isLoading
                        ? MyCertificatesSection._skeletonCount
                        : certificates.length,
                    separatorBuilder: (_, _) => const Gap(12),
                    itemBuilder: (_, index) => _CertificateCard(
                      certificate: isLoading
                          ? OrderCertificateEntity.skeleton()
                          : certificates[index],
                      isPlaceholder: isLoading,
                    ),
                  ),
                ),
              ),

            const Gap(40),
          ],
        );
      },
    );
  }
}

class _CertificateCard extends StatelessWidget {
  final OrderCertificateEntity certificate;
  final bool isPlaceholder;

  const _CertificateCard({
    required this.certificate,
    required this.isPlaceholder,
  });

  @override
  Widget build(BuildContext context) {
    final date = certificate.completedAt ?? certificate.targetDate;

    return GestureDetector(
      onTap: isPlaceholder ? null : () => _openPreview(context),
      child: Container(
        width: MyCertificatesSection._cardWidth,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: context.appColors.primary.shade400,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: context.appColors.secondary.shade500),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: context.appColors.secondary.shade500.withValues(
                      alpha: 0.18,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Iconsax.medal_star,
                    size: IconDimensions.small,
                    color: context.appColors.secondary.shade500,
                  ),
                ),

                const Gap(8),

                Expanded(
                  child: Text(
                    certificate.serialNumber,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.ltr,
                    style: context.medium.copyWith(
                      fontSize: 10,
                      color: context.appColors.secondary.shade500,
                    ),
                  ),
                ),
              ],
            ),

            const Gap(12),

            Text(
              certificate.beneficiaryName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.bold.copyWith(
                fontSize: 13,
                color: context.appColors.neutral.shade900,
              ),
            ),

            const Gap(4),

            Text(
              appLocalizer.omrahCertificate,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.regular.copyWith(
                fontSize: 10,
                color: context.appColors.neutral.shade700,
              ),
            ),

            const Spacer(),

            Row(
              children: [
                if (date != null)
                  Expanded(
                    child: Text(
                      date.toDDMMMyyyy,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.regular.copyWith(
                        fontSize: 10,
                        color: context.appColors.neutral.shade700,
                      ),
                    ),
                  )
                else
                  const Spacer(),

                Icon(
                  Icons.remove_red_eye_outlined,
                  size: IconDimensions.xSmall,
                  color: context.appColors.secondary.shade500,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openPreview(BuildContext context) {
    AppRouteNavigator.push(
      context,
      OrderCertificatePage.routeName,
      OrderCertificatePage(
        orderId: certificate.orderId,
        serialNumber: certificate.serialNumber,
        beneficiaryName: certificate.beneficiaryName,
        certificateUrl: certificate.certificateUrl,
      ),
    );
  }
}
