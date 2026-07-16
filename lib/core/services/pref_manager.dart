import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/models/user_info/user_info_model.dart';
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

  Future<bool> setCookies(String host, String json) => _prefs.setString(host, json);

  Future<bool> removeCookies(String host) => _prefs.remove(host);

  // ─── Session Tracking ─────────────────────────────────────────────

  int get sessionCount => _prefs.getInt(StorageKeys.sessionCount) ?? 0;

  String? get startSessionId => _prefs.getString(StorageKeys.startSessionId);

  String? get currentUserType => _prefs.getString(StorageKeys.currentUserType);

  String? get previousExperiments => _prefs.getString(StorageKeys.previousExperiments);

  Future<void> persistSessionData({
    required int sessionCount,
    required String? startSessionId,
    required String? currentUserType,
    required String? previousExperiments,
  }) async {
    await _prefs.setInt(StorageKeys.sessionCount, sessionCount);
    await _prefs.setString(StorageKeys.startSessionId, startSessionId ?? '');
    await _prefs.setString(StorageKeys.currentUserType, currentUserType ?? '');
    await _prefs.setString(StorageKeys.previousExperiments, previousExperiments ?? '');
  }

  // ─── AppConfig: Sort & Checkout ───────────────────────────────────

  bool get sortBarEnabled => _prefs.getBool(StorageKeys.sortBarEnabled) ?? false;
  Future<void> setSortBarEnabled(bool value) => _setBoolOrRemove(StorageKeys.sortBarEnabled, value);

  bool get recentlySortVisible => _prefs.getBool(StorageKeys.recentlySortVisible) ?? false;
  Future<void> setRecentlySortVisible(bool value) =>
      _setBoolOrRemove(StorageKeys.recentlySortVisible, value);

  bool get upiRefundsEnabled => _prefs.getBool(StorageKeys.upiRefundsEnabled) ?? false;
  Future<void> setUpiRefundsEnabled(bool value) =>
      _setBoolOrRemove(StorageKeys.upiRefundsEnabled, value);

  String? get instantCheckoutVariant => _prefs.getString(StorageKeys.instantCheckoutVariant);
  Future<void> setInstantCheckoutVariant(String? value) =>
      _setStringOrRemove(StorageKeys.instantCheckoutVariant, value);

  String? get customerCareContact => _prefs.getString(StorageKeys.customerCareContact);
  Future<void> setCustomerCareContact(String? value) =>
      _setStringOrRemove(StorageKeys.customerCareContact, value);

  // ─── AppConfig: Feature Flags ─────────────────────────────────────

  bool get featureFlagClarity => _prefs.getBool(StorageKeys.featureFlagClarity) ?? true;
  Future<void> setFeatureFlagClarity(bool value) =>
      _setBoolOrRemove(StorageKeys.featureFlagClarity, value);

  // ─── AppConfig: Remote Config Flags ───────────────────────────────

  bool get featureFlagInAppUpdate => _prefs.getBool(StorageKeys.featureFlagInAppUpdate) ?? true;
  Future<void> setFeatureFlagInAppUpdate(bool value) =>
      _setBoolOrRemove(StorageKeys.featureFlagInAppUpdate, value);

  bool get featureFlagRatingAfterShopping =>
      _prefs.getBool(StorageKeys.featureFlagRatingAfterShopping) ?? true;
  Future<void> setFeatureFlagRatingAfterShopping(bool value) =>
      _setBoolOrRemove(StorageKeys.featureFlagRatingAfterShopping, value);

  bool get featureFlagHomeAnalytics => _prefs.getBool(StorageKeys.featureFlagHomeAnalytics) ?? true;
  Future<void> setFeatureFlagHomeAnalytics(bool value) =>
      _setBoolOrRemove(StorageKeys.featureFlagHomeAnalytics, value);

  bool get featureFlagDeleteAccount =>
      _prefs.getBool(StorageKeys.featureFlagDeleteAccount) ?? false;
  Future<void> setFeatureFlagDeleteAccount(bool value) =>
      _setBoolOrRemove(StorageKeys.featureFlagDeleteAccount, value);

  // ─── AppConfig: Hard Update ───────────────────────────────────────

  bool get isHardUpdate => _prefs.getBool(StorageKeys.isHardUpdate) ?? false;
  Future<void> setIsHardUpdate(bool value) => _setBoolOrRemove(StorageKeys.isHardUpdate, value);

  String? get hardUpdateDialogTitle => _prefs.getString(StorageKeys.hardUpdateDialogTitle);
  Future<void> setHardUpdateDialogTitle(String? value) =>
      _setStringOrRemove(StorageKeys.hardUpdateDialogTitle, value);

  String? get hardUpdateDialogContent => _prefs.getString(StorageKeys.hardUpdateDialogContent);
  Future<void> setHardUpdateDialogContent(String? value) =>
      _setStringOrRemove(StorageKeys.hardUpdateDialogContent, value);

  // ─── AppConfig: JSON blobs ────────────────────────────────────────

  String? get videoAspectRatios => _prefs.getString(StorageKeys.videoAspectRatios);
  Future<void> setVideoAspectRatios(String? value) =>
      _setStringOrRemove(StorageKeys.videoAspectRatios, value);

  String? get cartMessageBars => _prefs.getString(StorageKeys.cartMessageBars);
  Future<void> setCartMessageBars(String? value) =>
      _setStringOrRemove(StorageKeys.cartMessageBars, value);

  // ─── Customer Info blob ───────────────────────────────────────────

  UserInfoModel? get customerInfo {
    final raw = _prefs.getString(StorageKeys.customerInfo);
    if (raw == null) return null;
    return UserInfoModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> setCustomerInfo(UserInfoModel model) =>
      _prefs.setString(StorageKeys.customerInfo, jsonEncode(model.toJson()));

  Future<void> clearCustomerInfo() => _prefs.remove(StorageKeys.customerInfo);

  // ─── Customer Info: delegates to blob ────────────────────────────

  bool get isLoggedIn => customerInfo?.isLoggedIn ?? false;
  String? get userId => customerInfo?.userId;
  String? get firstName => customerInfo?.firstName;
  String? get lastName => customerInfo?.lastName;
  String? get userName => customerInfo?.userName;
  String? get email => customerInfo?.email;
  String? get phoneNumber => customerInfo?.mobile;
  String? get mobileStatus => customerInfo?.mobileStatus;
  String? get profileImage => customerInfo?.profileImage;

  // ─── Customer Info: individual keys (updated independently) ──────

  String? get uuid => _prefs.getString(StorageKeys.uuid);
  Future<void> setUuid(String? value) => _setStringOrRemove(StorageKeys.uuid, value);

  bool get continueBrowsingEligibleVisitor =>
      _prefs.getBool(StorageKeys.continueBrowsingEligibleVisitor) ?? false;
  Future<void> setContinueBrowsingEligibleVisitor(bool value) =>
      _setBoolOrRemove(StorageKeys.continueBrowsingEligibleVisitor, value);

  String? get childCohorts => _prefs.getString(StorageKeys.childCohorts);
  Future<void> setChildCohorts(String? value) =>
      _setStringOrRemove(StorageKeys.childCohorts, value);

  String? get gender => _prefs.getString(StorageKeys.gender);
  Future<void> setGender(String? value) => _setStringOrRemove(StorageKeys.gender, value);

  bool get hasGuestData => _prefs.getBool(StorageKeys.hasGuestData) ?? false;
  Future<void> setHasGuestData(bool value) => _setBoolOrRemove(StorageKeys.hasGuestData, value);

  int get cartItemQty => _prefs.getInt(StorageKeys.cartItemQty) ?? 0;
  Future<void> setCartItemQty(int value) => _prefs.setInt(StorageKeys.cartItemQty, value);

  String? get persistentTicket => _prefs.getString(StorageKeys.persistentTicket);
  Future<void> setPersistentTicket(String? value) =>
      _setStringOrRemove(StorageKeys.persistentTicket, value);

  String? get productImageConfig => _prefs.getString(StorageKeys.productImageConfig);
  Future<void> setProductImageConfig(String? value) =>
      _setStringOrRemove(StorageKeys.productImageConfig, value);

  // ─── Device / Push ────────────────────────────────────────────────

  String? get pushToken => _prefs.getString(StorageKeys.pushToken);
  Future<void> setPushToken(String? value) => _setStringOrRemove(StorageKeys.pushToken, value);

  bool get isDeviceTokenSent => _prefs.getBool(StorageKeys.isDeviceTokenSent) ?? false;
  Future<void> setIsDeviceTokenSent(bool value) =>
      _setBoolOrRemove(StorageKeys.isDeviceTokenSent, value);

  // ─── Environment ──────────────────────────────────────────────────

  String? get selectedEnvironment => _prefs.getString(StorageKeys.selectedEnvironment);
  Future<void> setSelectedEnvironment(String? value) =>
      _setStringOrRemove(StorageKeys.selectedEnvironment, value);

  // ─── Addresses cache ──────────────────────────────────────────────

  String? get addressesJson => _prefs.getString(StorageKeys.addressesJson);
  Future<void> setAddressesJson(String? value) =>
      _setStringOrRemove(StorageKeys.addressesJson, value);

  /// Id of the address last selected from the pincode bottom sheet. `null`
  /// when the user last applied a raw pincode instead of picking an address.
  int? get lastSelectedPincodeAddressId =>
      _prefs.getInt(StorageKeys.lastSelectedPincodeAddressId);
  Future<void> setLastSelectedPincodeAddressId(int? value) =>
      _setIntOrRemove(StorageKeys.lastSelectedPincodeAddressId, value);

  bool? get isStoreButtonClicked => _prefs.getBool(StorageKeys.isFirstLogin);

  Future<void> setHasStoreButtonClicked(bool? value) =>
      _setBoolOrRemove(StorageKeys.isFirstLogin, value);

  // ─── Helpers ──────────────────────────────────────────────────────

  Future<void> _setStringOrRemove(String key, String? value) {
    if (value != null && value.isNotEmpty) {
      return _prefs.setString(key, value);
    }
    return _prefs.remove(key);
  }

  Future<void> _setBoolOrRemove(String key, bool? value) {
    if (value != null) {
      return _prefs.setBool(key, value);
    }
    return _prefs.remove(key);
  }

  Future<void> _setIntOrRemove(String key, int? value) {
    if (value != null) {
      return _prefs.setInt(key, value);
    }
    return _prefs.remove(key);
  }
}
