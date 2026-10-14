class OmrahEndpoint {
  OmrahEndpoint._();

  static String omrahSteps(String orderId) => 'orders/$orderId/rituals/steps';

  static String submitProof(String orderId, String step) =>
      'orders/$orderId/rituals/steps/$step/proof';

  static String validateStep(String orderId, String step) =>
      'orders/$orderId/rituals/steps/$step/validate';

  /// Road-snapped GeoJSON LineString for the order, ready to draw on the map.
  static String trackingRoute(String orderId) => 'tracking/$orderId/route';

  /// Raw GPS points kept in the live (24h) tracking window.
  static String trackingPath(String orderId) => 'tracking/$orderId/path';

  /// Durable, paginated GPS history for the order. Outlives the 24h live
  /// window, so it is the source for an omrah that is already completed.
  static String trackingHistory(String orderId) => 'tracking/$orderId/history';

  static String validateMiqat(String orderId) =>
      'tracking/$orderId/validate/miqat';

  static String validateTawaf(String orderId) =>
      'tracking/$orderId/validate/tawaf';

  static String addReview(String orderId) => 'reviews/orders/$orderId';
}
