part of provider_orders;

/// Previews the issued omrah certificate and lets the provider save it to the
/// gallery or hand the pdf over to any other app.
class OrderCertificatePage extends StatelessWidget {
  final String orderId;
  final String serialNumber;
  final String beneficiaryName;
  final String? certificateUrl;

  const OrderCertificatePage({
    super.key,
    required this.orderId,
    required this.serialNumber,
    required this.beneficiaryName,
    this.certificateUrl,
  });

  static const String routeName = "OrderCertificatePage";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderCertificateCubit(
        orderId: orderId,
        serialNumber: serialNumber,
        beneficiaryName: beneficiaryName,
        certificateUrl: certificateUrl,
      )..loadCertificate(),
      child: const _OrderCertificateBody(),
    );
  }
}

class _OrderCertificateBody extends StatelessWidget {
  const _OrderCertificateBody();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBars.defaultBar(
        context,
        text: appLocalizer.omrahCertificate,
        centerTitle: true,
        useCloseButton: true,
      ),
      body: SafeArea(
        child: BlocConsumer<OrderCertificateCubit, OrderCertificateState>(
          listener: _onStateChanged,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: PaddingDimensions.large,
                vertical: PaddingDimensions.medium,
              ),
              child: Column(
                children: [
                  Expanded(child: _CertificateViewer(state: state)),

                  const Gap(PaddingDimensions.large),

                  _CertificateActions(state: state),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onStateChanged(BuildContext context, OrderCertificateState state) {
    if (state.saveToGallery.isSuccess) {
      AppToasts.success(
        context,
        message: appLocalizer.certificateSavedToGallery,
      );
    } else if (state.saveToGallery.isFailure) {
      AppToasts.error(
        context,
        message:
            state.saveToGallery.failure?.errorMessage ??
            appLocalizer.failedToSaveCertificate,
      );
    }
  }
}

class _CertificateViewer extends StatefulWidget {
  final OrderCertificateState state;

  const _CertificateViewer({required this.state});

  @override
  State<_CertificateViewer> createState() => _CertificateViewerState();
}

class _CertificateViewerState extends State<_CertificateViewer> {
  final PageController _pageController = PageController();

  int _currentPage = 1;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    // The download failed, so there is nothing on disk to fall back to.
    if (state.file.isFailure) {
      return FailureWidget(
        failure: state.file.failure,
        onRetryPressed: () =>
            context.read<OrderCertificateCubit>().loadCertificate(),
      );
    }

    // The pdf is on disk but could not be rasterized. Sharing still works, so
    // this is a soft failure rather than a dead end.
    if (state.pages.isFailure) {
      return FailureWidget(
        failure: state.pages.failure,
        onRetryPressed: () =>
            context.read<OrderCertificateCubit>().retryRendering(),
      );
    }

    final pages = state.pages.data;

    if (pages == null) {
      return _LoadingIndicator(
        progress: state.file.isSuccess ? 1 : state.downloadProgress,
        message: state.file.isSuccess
            ? appLocalizer.generatingCertificate
            : appLocalizer.loadingCertificate,
      );
    }

    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Dimensions.largeRadius),
              border: Border.all(color: context.appColors.neutral.shade300),
              boxShadow: [
                BoxShadow(
                  color: context.appColors.neutral.shade900.withValues(
                    alpha: 0.08,
                  ),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: pages.length,
              physics: pages.length == 1
                  ? const NeverScrollableScrollPhysics()
                  : null,
              onPageChanged: (index) =>
                  setState(() => _currentPage = index + 1),
              itemBuilder: (_, index) => InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Padding(
                  padding: const EdgeInsets.all(PaddingDimensions.normal),
                  child: Image.memory(
                    pages[index],
                    fit: BoxFit.contain,
                    width: double.infinity,
                    gaplessPlayback: true,
                  ),
                ),
              ),
            ),
          ),
        ),

        if (pages.length > 1) ...[
          const Gap(PaddingDimensions.medium),
          Text(
            appLocalizer.certificatePageIndicator(_currentPage, pages.length),
            style: context.regular.copyWith(
              fontSize: Dimensions.large,
              color: context.appColors.neutral.shade600,
            ),
          ),
        ],
      ],
    );
  }
}

class _LoadingIndicator extends StatelessWidget {
  final double progress;
  final String message;

  const _LoadingIndicator({required this.progress, required this.message});

  @override
  Widget build(BuildContext context) {
    final hasProgress = progress > 0 && progress < 1;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOut,
                    tween: Tween(begin: 0, end: progress),
                    builder: (context, value, _) => CircularProgressIndicator(
                      value: hasProgress ? value : null,
                      strokeWidth: 4,
                      strokeCap: StrokeCap.round,
                      backgroundColor: context.appColors.neutral.shade300,
                      color: context.appColors.primary.shade400,
                    ),
                  ),
                ),

                if (hasProgress)
                  Text(
                    '${(progress * 100).round()}%',
                    style: context.semiBold.copyWith(
                      fontSize: Dimensions.large,
                      color: context.appColors.neutral.shade700,
                    ),
                  ),
              ],
            ),
          ),

          const Gap(PaddingDimensions.large),

          Text(
            message,
            style: context.regular.copyWith(
              color: context.appColors.neutral.shade600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CertificateActions extends StatelessWidget {
  final OrderCertificateState state;

  const _CertificateActions({required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppPrimaryButton.outline(
            text: appLocalizer.saveToGallery,
            isLoading: state.saveToGallery.isLoading,
            leadingWidget: const Padding(
              padding: EdgeInsetsDirectional.only(end: PaddingDimensions.small),
              child: Icon(Iconsax.import, size: IconDimensions.normal),
            ),
            onPressed: state.canSaveToGallery
                ? () => context
                      .read<OrderCertificateCubit>()
                      .saveCertificateToGallery()
                : null,
          ),
        ),

        const Gap(PaddingDimensions.medium),

        Expanded(
          child: AppPrimaryButton(
            text: appLocalizer.share,
            isExpanded: true,
            isLoading: state.isSharing,
            leadingWidget: const Padding(
              padding: EdgeInsetsDirectional.only(end: PaddingDimensions.small),
              child: Icon(Icons.share_outlined, size: IconDimensions.normal),
            ),
            onPressed: state.canShare
                ? () => context.read<OrderCertificateCubit>().shareCertificate(
                    sharePositionOrigin: _sharePositionOrigin(context),
                  )
                : null,
          ),
        ),
      ],
    );
  }

  /// Needed so the share sheet gets an anchor on iPad.
  Rect? _sharePositionOrigin(BuildContext context) {
    final box = context.findRenderObject() as RenderBox?;

    if (box == null) return null;

    return box.localToGlobal(Offset.zero) & box.size;
  }
}
