part of provider_orders;

class OrderCertificateState extends Equatable {
  /// The server relative url of the issued certificate pdf.
  final StateBox<String> certificate;

  /// Local path of the downloaded pdf, ready to be previewed / shared.
  final StateBox<String> file;

  /// Download completion between 0 and 1, stays at 0 while the response has no
  /// content-length so the ui can fall back to an indeterminate indicator.
  final double downloadProgress;

  /// The rasterized pdf pages, used both by the preview and by the gallery
  /// save so a page is never rendered twice.
  final StateBox<List<Uint8List>> pages;

  final StateBox<String> saveToGallery;
  final bool isSharing;

  const OrderCertificateState({
    required this.certificate,
    required this.file,
    required this.downloadProgress,
    required this.pages,
    required this.saveToGallery,
    required this.isSharing,
  });

  factory OrderCertificateState.initial(String? certificateUrl) {
    return OrderCertificateState(
      certificate: certificateUrl.isEmptyOrNull
          ? const StateBox.initial()
          : StateBox.success(certificateUrl!),
      file: const StateBox.initial(),
      downloadProgress: 0,
      pages: const StateBox.initial(),
      saveToGallery: const StateBox.initial(),
      isSharing: false,
    );
  }

  String? get certificateUrl => certificate.data;

  bool get hasCertificate => !certificate.data.isEmptyOrNull;

  /// The pdf is on disk, so it can be shared even when it cannot be rendered.
  bool get canShare => file.isSuccess;

  bool get canSaveToGallery => pages.isSuccess;

  OrderCertificateState reduce({
    StateBox<String>? certificate,
    StateBox<String>? file,
    double? downloadProgress,
    StateBox<List<Uint8List>>? pages,
    StateBox<String>? saveToGallery,
    bool? isSharing,
  }) {
    return OrderCertificateState(
      certificate: certificate ?? this.certificate,
      file: file ?? this.file,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      pages: pages ?? this.pages,
      saveToGallery: saveToGallery ?? this.saveToGallery,
      isSharing: isSharing ?? this.isSharing,
    );
  }

  @override
  List<Object?> get props => [
    certificate,
    file,
    downloadProgress,
    pages,
    saveToGallery,
    isSharing,
  ];
}
