part of tazkiyah;

abstract class TazkiyahRepository {
  /// Looks a provider up by exactly one contact: [email], or [phone] in full
  /// international form (`+201028762009`).
  Future<LookupProviderEntity?> searchProvider({String? email, String? phone});
  Future<void> postTazkiyah({
    required String providerId,
    required String reason,
    required bool agreedToOath,
  });
  Future<List<MyTazkiyahEntity>> getMyTazkiyahs();
}
