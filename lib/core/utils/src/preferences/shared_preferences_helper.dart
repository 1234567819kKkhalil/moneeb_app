part of app_utils;

abstract class SharedPreferencesHelper {
  void setLanguage(AppLangCodeEnum language);
  AppLangCodeEnum getLanguage();
  bool get isUserSetLanguage;

  void setOTP(OTP otp);
  void deleteOTP();
  OTP? getOTP();

  void setGuest();
  bool isGuest();
  void deleteGuest();



  void resetUserData();

  void cacheUserLocation(LocationData data);
  LocationData? getCacheUserLocation();

  // Guest story view tracking (local only, expires with the story's expiresAt)
  Set<String> getGuestViewedStoryIds();
  void saveGuestViewedStory(String storyId, String expiresAt);
  void clearExpiredGuestStories();

  /// Omrahs this device has already submitted a rating for. An omrah is rated
  /// once and only once; the server is the source of truth, this only keeps the
  /// answer available across restarts and while offline.
  bool isOmrahRated(String orderId);
  void saveRatedOmrah(String orderId);
}
