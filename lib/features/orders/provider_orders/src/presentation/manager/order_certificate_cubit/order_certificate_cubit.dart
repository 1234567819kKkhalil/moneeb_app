part of provider_orders;

/// Owns the whole certificate flow of a single order: issuing it on the server,
/// caching the pdf locally, rasterizing it for the preview, saving it to the
/// gallery and sharing it with other apps.
class OrderCertificateCubit extends BaseCubit<OrderCertificateState> {
  static const String _cacheDirName = 'order_certificates';

  /// Progress steps smaller than this are dropped so the download does not
  /// rebuild the ui on every received chunk.
  static const double _progressEmitThreshold = 0.02;

  /// Width the pages are rasterized at, which keeps them sharp when zoomed
  /// without upscaling pages that are already high resolution. Certificates are
  /// exported at 150dpi (1754pt wide), so blindly scaling by the device ratio
  /// would ask for a bitmap several times larger than needed.
  static const double _targetRenderWidth = 1800;

  /// A page never renders below its natural size, and never above twice it.
  static const double _minRenderScale = 1;
  static const double _maxRenderScale = 2;

  /// Upper bound on the rasterized page area. A page is drawn into a single
  /// ARGB_8888 bitmap (4 bytes a pixel), so an unbounded scale makes the native
  /// renderer throw instead of returning an image.
  static const double _maxRenderPixels = 4000000;

  final String orderId;

  /// Only used to name the file the provider downloads and shares.
  final String serialNumber;

  /// Only used in the share message.
  final String beneficiaryName;

  late final ProviderOrdersRepository _repository;
  CancelToken? _downloadCancelToken;

  OrderCertificateCubit({
    required this.orderId,
    required this.serialNumber,
    required this.beneficiaryName,
    String? certificateUrl,
  }) : super(OrderCertificateState.initial(certificateUrl)) {
    _repository = injector();
  }

  OrderCertificateCubit.forOrder(ProviderOrderEntity order, {String? certificateUrl})
    : this(
        orderId: order.id,
        serialNumber: order.serialNumber,
        beneficiaryName: order.beneficiaryName,
        certificateUrl: certificateUrl.isEmptyOrNull
            ? order.certificateUrl
            : certificateUrl,
      );

  Future<void> generateCertificate() async {
    if (state.certificate.isLoading) return;

    emit(state.reduce(certificate: const StateBox.loading()));

    await collect(
      task: () async {
        final certificateUrl = await _repository.generateCertificate(orderId);
        emit(state.reduce(certificate: StateBox.success(certificateUrl)));
      },
      onError: (failure) {
        emit(state.reduce(certificate: StateBox.failure(failure)));
      },
    );
  }

  /// Fetches the pdf into the cache directory, reusing it when it is already
  /// there so re-opening the preview is instant, then rasterizes it.
  Future<void> loadCertificate() async {
    final certificateUrl = state.certificateUrl;

    if (state.file.isLoading || state.pages.isLoading) return;

    if (certificateUrl.isEmptyOrNull) {
      emit(
        state.reduce(
          file: StateBox.failure(
            UnExpectedFailure(appLocalizer.couldNotDownloadFile),
          ),
        ),
      );
      return;
    }

    emit(state.reduce(file: const StateBox.loading(), downloadProgress: 0));

    final filePath = await collect<String>(
      task: () async {
        final savePath = await AppUtilsDirectoriesPaths.getDirPathFor(
          dirName: _cacheDirName,
          dirType: AppDirType.tempDirectory,
          joinWithDirectories: [_cacheKeyOf(certificateUrl!)],
          joinWithFileName: fileName,
        );

        final cachedFile = File(savePath);
        final isCached =
            await cachedFile.exists() && await cachedFile.length() > 0;

        if (!isCached) {
          _downloadCancelToken = CancelToken();

          await _repository.downloadCertificate(
            url: certificateUrl,
            savePath: savePath,
            cancelToken: _downloadCancelToken,
            onReceiveProgress: _onDownloadProgress,
          );
        }

        emit(
          state.reduce(file: StateBox.success(savePath), downloadProgress: 1),
        );

        return savePath;
      },
      onError: (failure) {
        emit(state.reduce(file: StateBox.failure(failure), downloadProgress: 0));
      },
    );

    _downloadCancelToken = null;

    if (filePath != null) {
      await _renderPages(filePath);
    }
  }

  /// Re-rasterizes an already downloaded pdf, for the retry button.
  Future<void> retryRendering() async {
    final filePath = state.file.data;

    if (filePath == null) {
      await loadCertificate();
      return;
    }

    await _renderPages(filePath);
  }

  Future<void> _renderPages(String filePath) async {
    if (state.pages.isLoading) return;

    emit(state.reduce(pages: const StateBox.loading()));

    try {
      final renderedPages = <Uint8List>[];
      final document = await PdfDocument.openFile(filePath);

      try {
        for (
          int pageNumber = 1;
          pageNumber <= document.pagesCount;
          pageNumber++
        ) {
          final page = await document.getPage(pageNumber);

          try {
            final (width, height) = _rasterSizeOf(page.width, page.height);

            final rendered = await page.render(
              width: width,
              height: height,
              format: PdfPageImageFormat.png,
              backgroundColor: '#FFFFFF',
            );

            if (rendered != null) renderedPages.add(rendered.bytes);
          } finally {
            await page.close();
          }
        }
      } finally {
        await document.close();
      }

      if (renderedPages.isEmpty) {
        throw const FormatException('the pdf renderer returned no pages');
      }

      emit(state.reduce(pages: StateBox.success(renderedPages)));
    } catch (e, s) {
      developer.log(
        '[OrderCertificateCubit] failed to render $filePath',
        error: e,
        stackTrace: s,
      );

      emit(
        state.reduce(
          pages: StateBox.failure(
            UnExpectedFailure(
              kDebugMode
                  ? '${appLocalizer.certificatePreviewUnavailable}\n\n$e'
                  : appLocalizer.certificatePreviewUnavailable,
            ),
          ),
        ),
      );
    }
  }

  /// Keeps the rasterized page within [_maxRenderPixels]; a single oversized
  /// bitmap is the usual reason a native pdf renderer fails outright.
  (double width, double height) _rasterSizeOf(
    double pageWidth,
    double pageHeight,
  ) {
    if (pageWidth <= 0 || pageHeight <= 0) {
      return (_targetRenderWidth, _targetRenderWidth);
    }

    final scale = (_targetRenderWidth / pageWidth).clamp(
      _minRenderScale,
      _maxRenderScale,
    );

    final width = pageWidth * scale;
    final height = pageHeight * scale;

    final pixels = width * height;

    if (pixels <= _maxRenderPixels) return (width, height);

    final budgetScale = math.sqrt(_maxRenderPixels / pixels);

    return (width * budgetScale, height * budgetScale);
  }

  /// Drops the rendered pages into the device gallery, the only place a
  /// downloaded document reliably lands on both platforms.
  Future<void> saveCertificateToGallery() async {
    final renderedPages = state.pages.data;

    if (renderedPages == null || state.saveToGallery.isLoading) return;

    emit(state.reduce(saveToGallery: const StateBox.loading()));

    // Saving into a named album needs full library access on iOS, so fall back
    // to the app's default album rather than failing the whole save.
    final canUseAlbum = await Gal.requestAccess(toAlbum: true);

    if (!canUseAlbum && !await Gal.requestAccess()) {
      emit(
        state.reduce(
          saveToGallery: StateBox.failure(
            UnExpectedFailure(appLocalizer.givePermissionsManually),
          ),
        ),
      );
      emit(state.reduce(saveToGallery: const StateBox.initial()));
      return;
    }

    try {
      for (int index = 0; index < renderedPages.length; index++) {
        await Gal.putImageBytes(
          renderedPages[index],
          album: canUseAlbum ? Constants.appName : null,
          name: renderedPages.length == 1
              ? fileNameWithoutExtension
              : '${fileNameWithoutExtension}_${index + 1}',
        );
      }

      emit(state.reduce(saveToGallery: const StateBox.successWithoutData()));
    } catch (e, s) {
      developer.log(
        '[OrderCertificateCubit] failed to save the certificate',
        error: e,
        stackTrace: s,
      );

      final isAccessDenied =
          e is GalException && e.type == GalExceptionType.accessDenied;

      emit(
        state.reduce(
          saveToGallery: StateBox.failure(
            UnExpectedFailure(
              isAccessDenied
                  ? appLocalizer.givePermissionsManually
                  : appLocalizer.failedToSaveCertificate,
            ),
          ),
        ),
      );
    }

    emit(state.reduce(saveToGallery: const StateBox.initial()));
  }

  Future<void> shareCertificate({Rect? sharePositionOrigin}) async {
    final filePath = state.file.data;

    if (filePath == null || state.isSharing) return;

    emit(state.reduce(isSharing: true));

    try {
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(filePath, mimeType: 'application/pdf', name: fileName)],
          text: appLocalizer.certificateShareMessage(beneficiaryName),
          subject: appLocalizer.omrahCertificate,
          sharePositionOrigin: sharePositionOrigin,
        ),
      );
    } catch (e, s) {
      developer.log(
        '[OrderCertificateCubit] failed to share the certificate',
        error: e,
        stackTrace: s,
      );
    }

    emit(state.reduce(isSharing: false));
  }

  /// File name the certificate is stored and shared with.
  String get fileName => '$fileNameWithoutExtension.pdf';

  String get fileNameWithoutExtension {
    final reference = serialNumber.isNotEmpty ? serialNumber : orderId;

    return 'umrah_certificate_${_sanitized(reference)}';
  }

  /// Keeps a regenerated certificate from being served from the previous cache
  /// entry, since only the remote url changes between issues.
  String _cacheKeyOf(String certificateUrl) {
    final lastSegment = Uri.tryParse(certificateUrl)?.pathSegments.lastOrNull;

    return _sanitized((lastSegment ?? certificateUrl).split('.').first);
  }

  String _sanitized(String value) =>
      value.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_');

  void _onDownloadProgress(int received, int total) {
    if (total <= 0) return;

    final progress = (received / total).clamp(0.0, 1.0);

    if (progress < 1 &&
        (progress - state.downloadProgress).abs() < _progressEmitThreshold) {
      return;
    }

    emit(state.reduce(downloadProgress: progress));
  }

  @override
  Future<void> close() {
    _downloadCancelToken?.cancel();
    return super.close();
  }
}
