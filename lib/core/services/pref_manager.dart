import 'package:shared_preferences/shared_preferences.dart';
import 'package:injectable/injectable.dart';

import '../constants/storage_keys.dart';

@lazySingleton
class PrefManager {
  final SharedPreferences _prefs;

  PrefManager(this._prefs);

  static Future<PrefManager> init() async {
    final prefs = await SharedPreferences.getInstance();
    return PrefManager(prefs);
  }

  // ─── Cookie Store ─────────────────────────────────────────────────

  String? getCookies(String host) => _prefs.getString(host);

  Future<bool> setCookies(String host, String json) =>
      _prefs.setString(host, json);

  Future<bool> removeCookies(String host) => _prefs.remove(host);

  // ─── Session Tracking ─────────────────────────────────────────────

  int get sessionCount => _prefs.getInt(StorageKeys.sessionCount) ?? 0;

  String? get startSessionId => _prefs.getString(StorageKeys.startSessionId);

  String? get currentUserType => _prefs.getString(StorageKeys.currentUserType);

  String? get previousExperiments =>
      _prefs.getString(StorageKeys.previousExperiments);

  Future<void> persistSessionData({
    required int sessionCount,
    required String? startSessionId,
    required String? currentUserType,
    required String? previousExperiments,
  }) async {
    await _prefs.setInt(StorageKeys.sessionCount, sessionCount);
    await _prefs.setString(StorageKeys.startSessionId, startSessionId ?? '');
    await _prefs.setString(StorageKeys.currentUserType, currentUserType ?? '');
    await _prefs.setString(
      StorageKeys.previousExperiments,
      previousExperiments ?? '',
    );
  }

  // ─── AppConfig: Sort & Checkout ───────────────────────────────────

  bool get sortBarEnabled =>
      _prefs.getBool(StorageKeys.sortBarEnabled) ?? false;
  Future<void> setSortBarEnabled(bool value) =>
      _prefs.setBool(StorageKeys.sortBarEnabled, value);

  bool get recentlySortVisible =>
      _prefs.getBool(StorageKeys.recentlySortVisible) ?? false;
  Future<void> setRecentlySortVisible(bool value) =>
      _prefs.setBool(StorageKeys.recentlySortVisible, value);

  bool get upiRefundsEnabled =>
      _prefs.getBool(StorageKeys.upiRefundsEnabled) ?? false;
  Future<void> setUpiRefundsEnabled(bool value) =>
      _prefs.setBool(StorageKeys.upiRefundsEnabled, value);

  String? get instantCheckoutVariant =>
      _prefs.getString(StorageKeys.instantCheckoutVariant);
  Future<void> setInstantCheckoutVariant(String? value) =>
      _setStringOrRemove(StorageKeys.instantCheckoutVariant, value);

  String? get customerCareContact =>
      _prefs.getString(StorageKeys.customerCareContact);
  Future<void> setCustomerCareContact(String? value) =>
      _setStringOrRemove(StorageKeys.customerCareContact, value);

  // ─── AppConfig: Feature Flags ─────────────────────────────────────

  bool get featureFlagClarity =>
      _prefs.getBool(StorageKeys.featureFlagClarity) ?? true;
  Future<void> setFeatureFlagClarity(bool value) =>
      _prefs.setBool(StorageKeys.featureFlagClarity, value);

  // ─── AppConfig: Remote Config Flags ───────────────────────────────

  bool get featureFlagInAppUpdate =>
      _prefs.getBool(StorageKeys.featureFlagInAppUpdate) ?? true;
  Future<void> setFeatureFlagInAppUpdate(bool value) =>
      _prefs.setBool(StorageKeys.featureFlagInAppUpdate, value);

  bool get featureFlagRatingAfterShopping =>
      _prefs.getBool(StorageKeys.featureFlagRatingAfterShopping) ?? true;
  Future<void> setFeatureFlagRatingAfterShopping(bool value) =>
      _prefs.setBool(StorageKeys.featureFlagRatingAfterShopping, value);

  bool get featureFlagHomeAnalytics =>
      _prefs.getBool(StorageKeys.featureFlagHomeAnalytics) ?? true;
  Future<void> setFeatureFlagHomeAnalytics(bool value) =>
      _prefs.setBool(StorageKeys.featureFlagHomeAnalytics, value);

  bool get featureFlagDeleteAccount =>
      _prefs.getBool(StorageKeys.featureFlagDeleteAccount) ?? false;
  Future<void> setFeatureFlagDeleteAccount(bool value) =>
      _prefs.setBool(StorageKeys.featureFlagDeleteAccount, value);

  // ─── AppConfig: Hard Update ───────────────────────────────────────

  bool get isHardUpdate => _prefs.getBool(StorageKeys.isHardUpdate) ?? false;
  Future<void> setIsHardUpdate(bool value) =>
      _prefs.setBool(StorageKeys.isHardUpdate, value);

  String? get hardUpdateDialogTitle =>
      _prefs.getString(StorageKeys.hardUpdateDialogTitle);
  Future<void> setHardUpdateDialogTitle(String? value) =>
      _setStringOrRemove(StorageKeys.hardUpdateDialogTitle, value);

  String? get hardUpdateDialogContent =>
      _prefs.getString(StorageKeys.hardUpdateDialogContent);
  Future<void> setHardUpdateDialogContent(String? value) =>
      _setStringOrRemove(StorageKeys.hardUpdateDialogContent, value);

  // ─── AppConfig: JSON blobs ────────────────────────────────────────

  String? get videoAspectRatios =>
      _prefs.getString(StorageKeys.videoAspectRatios);
  Future<void> setVideoAspectRatios(String? value) =>
      _setStringOrRemove(StorageKeys.videoAspectRatios, value);

  String? get cartMessageBars => _prefs.getString(StorageKeys.cartMessageBars);
  Future<void> setCartMessageBars(String? value) =>
      _setStringOrRemove(StorageKeys.cartMessageBars, value);

  // ─── Customer Info ────────────────────────────────────────────────

  String? get userId => _prefs.getString(StorageKeys.userId);
  Future<void> setUserId(String? value) =>
      _setStringOrRemove(StorageKeys.userId, value);

  String? get firstName => _prefs.getString(StorageKeys.firstName);
  Future<void> setFirstName(String? value) =>
      _setStringOrRemove(StorageKeys.firstName, value);

  String? get lastName => _prefs.getString(StorageKeys.lastName);
  Future<void> setLastName(String? value) =>
      _setStringOrRemove(StorageKeys.lastName, value);

  String? get userName => _prefs.getString(StorageKeys.userName);
  Future<void> setUserName(String? value) =>
      _setStringOrRemove(StorageKeys.userName, value);

  String? get email => _prefs.getString(StorageKeys.email);
  Future<void> setEmail(String? value) =>
      _setStringOrRemove(StorageKeys.email, value);

  String? get phoneNumber => _prefs.getString(StorageKeys.phoneNumber);
  Future<void> setPhoneNumber(String? value) =>
      _setStringOrRemove(StorageKeys.phoneNumber, value);

  String? get gender => _prefs.getString(StorageKeys.gender);
  Future<void> setGender(String? value) =>
      _setStringOrRemove(StorageKeys.gender, value);

  String? get profileImage => _prefs.getString(StorageKeys.profileImage);
  Future<void> setProfileImage(String? value) =>
      _setStringOrRemove(StorageKeys.profileImage, value);

  String? get mobileStatus => _prefs.getString(StorageKeys.mobileStatus);
  Future<void> setMobileStatus(String? value) =>
      _setStringOrRemove(StorageKeys.mobileStatus, value);

  bool get isLoggedIn => _prefs.getBool(StorageKeys.isLoggedIn) ?? false;
  Future<void> setIsLoggedIn(bool value) =>
      _prefs.setBool(StorageKeys.isLoggedIn, value);

  bool get hasGuestData => _prefs.getBool(StorageKeys.hasGuestData) ?? false;
  Future<void> setHasGuestData(bool value) =>
      _prefs.setBool(StorageKeys.hasGuestData, value);

  int get cartItemQty => _prefs.getInt(StorageKeys.cartItemQty) ?? 0;
  Future<void> setCartItemQty(int value) =>
      _prefs.setInt(StorageKeys.cartItemQty, value);

  String? get persistentTicket =>
      _prefs.getString(StorageKeys.persistentTicket);
  Future<void> setPersistentTicket(String? value) =>
      _setStringOrRemove(StorageKeys.persistentTicket, value);

  // ─── Helpers ──────────────────────────────────────────────────────

  Future<void> _setStringOrRemove(String key, String? value) {
    if (value != null && value.isNotEmpty) {
      return _prefs.setString(key, value);
    }
    return _prefs.remove(key);
  }
}
