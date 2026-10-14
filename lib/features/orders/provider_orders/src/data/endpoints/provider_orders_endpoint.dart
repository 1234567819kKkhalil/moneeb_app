part of provider_orders;

class ProviderOrdersEndpoint {
  ProviderOrdersEndpoint._();

  static const String orders = "/orders";
  
  static String acceptOrder(String id) => "/orders/$id/accept";
  static String cancelOrder(String id) => "/orders/$id/cancel";
  static String rejectOrder(String id) => "/orders/$id/reject";
  static String completeOrder(String id) => "/orders/$id/complete";
  static String orderCertificate(String id) => "/orders/$id/certificate";

  static const String myCertificates = "/orders/certificates/mine";
}
