part of tazkiyah;

@LazySingleton(as: TazkiyahRepository)
class TazkiyahRepositoryImpl implements TazkiyahRepository {
  final DioHelper _dioHelper;

  TazkiyahRepositoryImpl(this._dioHelper);

  @override
  Future<LookupProviderEntity?> searchProvider({
    String? email,
    String? phone,
  }) async {
    final response = await _dioHelper.get(
      TazkiyahEndpoint.searchProviders,
      query: {
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
      },
    );

    if (response.data != null && response.data['data'] != null) {
      final Map<String, dynamic> dataMap = response.data['data'];
      return LookupProviderModel.fromJson(dataMap);
    }
    return null;
  }

  @override
  Future<void> postTazkiyah({
    required String providerId,
    required String reason,
    required bool agreedToOath,
  }) async {
    await _dioHelper.post(
      TazkiyahEndpoint.postTazkiyah(providerId),
      data: {'reason': reason, 'agreedToOath': agreedToOath},
    );
  }

  @override
  Future<List<MyTazkiyahEntity>> getMyTazkiyahs() async {
    final response = await _dioHelper.get(TazkiyahEndpoint.getMyTazkiyahs);
    final List<dynamic> data = response.data['data'] ?? [];
    return data
        .map((e) => MyTazkiyahModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
