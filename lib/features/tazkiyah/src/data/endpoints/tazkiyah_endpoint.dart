part of tazkiyah;

class TazkiyahEndpoint {
  TazkiyahEndpoint._();

  static const String searchProviders = 'providers/lookup';
  static String postTazkiyah(String providerId) => 'tazkiyah/providers/$providerId';
  static const String getMyTazkiyahs = 'tazkiyah/me';
}
