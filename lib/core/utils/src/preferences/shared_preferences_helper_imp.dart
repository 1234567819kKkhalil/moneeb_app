part of app_utils;

@Singleton(scope: 'persistent', as: SharedPreferencesHelper)
class SharedPreferencesHelperImp implements SharedPreferencesHelper {
  final SharedPreferences _sharedPreferences;
  SharedPreferencesHelperImp(this._sharedPreferences);

  @override
  bool get isUserSetLanguage => _sharedPreferences.getString(_PreferencesKeys.languageKey) != null;

  @override
  AppLangCodeEnum getLanguage() {
    final String? lang =
    _sharedPreferences.getString(_PreferencesKeys.languageKey);

    if (lang == null) {
      return AppLangCodeEnum.fromName(Platform.localeName.split("_").first);
    } else {
      return AppLangCodeEnum.fromName(lang);
    }
  }

  @override
  void setLanguage(AppLangCodeEnum langCode) {
    _sharedPreferences.setString(_PreferencesKeys.languageKey, langCode.name);
  }

  @override
  void deleteOTP() {
    _sharedPreferences.remove(_PreferencesKeys.otp);
  }

  @override
  OTP? getOTP() {
    final otp = _sharedPreferences.getString(_PreferencesKeys.otp);
    if (otp == null) {
      return null;
    }
    final Map<String, dynamic> decode = json.decode(otp);
    return OTP(
      decode['numberOTPInHour'],
      DateTime.parse(decode['firstOTPTime']),
      decode['isBlocked'],
    );
  }

  @override
  void setOTP(OTP otp) {
    try {
      Map<String, dynamic> otpObject = {
        'numberOTPInHour': otp.numberOTPInHour,
        'firstOTPTime': otp.firstOTPTime.toString(),
        'isBlocked': otp.isBlocked,
      };
      String encodedMap = json.encode(otpObject);
      _sharedPreferences.setString(_PreferencesKeys.otp, encodedMap);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void resetUserData() {
    _sharedPreferences.remove(_PreferencesKeys.isGuestKey);
  }

  @override
  bool isGuest() {
    final response = _sharedPreferences.getString(_PreferencesKeys.isGuestKey);
    if (response != null) {
      return true;
    }
    return false;
  }

  @override
  void setGuest() {
    _sharedPreferences.setString(_PreferencesKeys.isGuestKey, 'true');
  }

  @override
  void deleteGuest() {
    _sharedPreferences.remove(_PreferencesKeys.isGuestKey);
  }

  @override
  void cacheUserLocation(LocationData data) {
    _sharedPreferences.setString(_PreferencesKeys.locationCacheKey, json.encode(data.toJson()));
  }

  @override
  LocationData? getCacheUserLocation() {
    try {
      final raw = _sharedPreferences.getString(_PreferencesKeys.locationCacheKey);
      if (raw == null || raw.isEmpty) return null;
      return LocationData.fromJson(json.decode(raw) as Map<String, dynamic>);
    } catch (e) {
      developer.log(
        '[LocationService] reading cached location failed: $e',
        name: 'LocationService',
      );
      return null;
    }
  }

  @override
  Set<String> getGuestViewedStoryIds() {
    clearExpiredGuestStories();
    final raw = _sharedPreferences.getString(_PreferencesKeys.guestViewedStoriesKey);
    if (raw == null || raw.isEmpty) return {};
    final Map<String, dynamic> map = json.decode(raw);
    return map.keys.toSet();
  }

  @override
  void saveGuestViewedStory(String storyId, String expiresAt) {
    final raw = _sharedPreferences.getString(_PreferencesKeys.guestViewedStoriesKey);
    final Map<String, dynamic> map = (raw != null && raw.isNotEmpty)
        ? (json.decode(raw) as Map<String, dynamic>)
        : {};
    map[storyId] = expiresAt;
    _sharedPreferences.setString(_PreferencesKeys.guestViewedStoriesKey, json.encode(map));
  }

  @override
  void clearExpiredGuestStories() {
    final raw = _sharedPreferences.getString(_PreferencesKeys.guestViewedStoriesKey);
    if (raw == null || raw.isEmpty) return;
    final Map<String, dynamic> map = json.decode(raw);
    final now = DateTime.now();
    map.removeWhere((_, value) {
      try {
        return DateTime.parse(value as String).isBefore(now);
      } catch (_) {
        return true;
      }
    });
    _sharedPreferences.setString(_PreferencesKeys.guestViewedStoriesKey, json.encode(map));
  }

  @override
  bool isOmrahRated(String orderId) {
    return _ratedOmrahOrderIds().contains(orderId);
  }

  @override
  void saveRatedOmrah(String orderId) {
    final ids = _ratedOmrahOrderIds()..add(orderId);

    _sharedPreferences.setStringList(
      _PreferencesKeys.ratedOmrahOrdersKey,
      ids.toList(),
    );
  }

  Set<String> _ratedOmrahOrderIds() {
    return (_sharedPreferences.getStringList(_PreferencesKeys.ratedOmrahOrdersKey) ?? [])
        .toSet();
  }
}

class _PreferencesKeys {
  _PreferencesKeys._();

  static const languageKey = "languageKey";
  static const otp = "otp";
  static const isGuestKey = 'isGuestKey';
  static const String locationCacheKey = 'cached_user_location';
  static const String guestViewedStoriesKey = 'guest_viewed_stories';
  static const String ratedOmrahOrdersKey = 'rated_omrah_orders';
}
