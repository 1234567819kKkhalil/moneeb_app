part of provider_orders;

abstract class ProviderOrdersRepository {
  Future<PaginatedData<ProviderOrderEntity>> getProviderOrders({
    ProviderOrderStatus? status,
    int page = 1,
    int limit = 20,
  });

  Future<void> acceptOrder(String id);
  Future<void> cancelOrder(String id);
  Future<void> rejectOrder(String id, String reason);
  Future<void> completeOrder(String id);

  /// Asks the backend to issue the omrah certificate for [id] and returns the
  /// server relative url of the generated pdf.
  Future<String> generateCertificate(String id);

  /// Every certificate the signed in user is party to, most recent first.
  Future<List<OrderCertificateEntity>> getMyCertificates();

  /// Downloads the certificate pdf sitting at [url] into [savePath].
  Future<void> downloadCertificate({
    required String url,
    required String savePath,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  });
}
