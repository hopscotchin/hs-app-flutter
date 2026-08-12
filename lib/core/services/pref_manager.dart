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
  //
  // These four keys are the change-detection anchors used by
  // CookieAnalyticsInterceptor — each new cookie value is diffed against the
  // cached one before identify/session_started fires. Mirrors Android
  // AppRecordData session-tracking fields written by CookiesBasedEventsUtil.

  int get sessionCount => _prefs.getInt(StorageKeys.sessionCount) ?? 0;
  Future<void> setSessionCount(int value) =>
      _prefs.setInt(StorageKeys.sessionCount, value);

  String? get startSessionId => _prefs.getString(StorageKeys.startSessionId);
  Future<void> setStartSessionId(String? value) =>
      _setStringOrRemove(StorageKeys.startSessionId, value);

  String? get currentUserType => _prefs.getString(StorageKeys.currentUserType);
  Future<void> setCurrentUserType(String? value) =>
      _setStringOrRemove(StorageKeys.currentUserType, value);

  String? get previousExperiments => _prefs.getString(StorageKeys.previousExperiments);
  Future<void> setPreviousExperiments(String? value) =>
      _setStringOrRemove(StorageKeys.previousExperiments, value);

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

  // ─── Analytics ────────────────────────────────────────────────────

  String? get cleverTapId => _prefs.getString(StorageKeys.cleverTapId);
  Future<void> setCleverTapId(String? value) =>
      _setStringOrRemove(StorageKeys.cleverTapId, value);

  /// JSON blob of the accumulated identify-trait union. Read on
  /// `AnalyticsService` init to hydrate `_accumulatedTraits`; rewritten on
  /// every `identify()` call. Cleared by `reset()`.
  String? get accumulatedTraits =>
      _prefs.getString(StorageKeys.accumulatedTraits);
  Future<void> setAccumulatedTraits(String? value) =>
      _setStringOrRemove(StorageKeys.accumulatedTraits, value);

  String? get hsDeviceId => _prefs.getString(StorageKeys.hsDeviceId);
  Future<void> setHsDeviceId(String? value) =>
      _setStringOrRemove(StorageKeys.hsDeviceId, value);

  String? get advertisingId => _prefs.getString(StorageKeys.advertisingId);
  Future<void> setAdvertisingId(String? value) =>
      _setStringOrRemove(StorageKeys.advertisingId, value);

  // ─── Analytics: identity / session traits ─────────────────────────
  //
  // Written by CookieAnalyticsInterceptor from the four server-set cookies;
  // read by AnalyticsHelper.identifyOnCookieChange to produce identify traits.
  // userType is the value sent in `user_type` trait; currentUserType (above)
  // is the change-detection cache.

  String? get userType => _prefs.getString(StorageKeys.userType);
  Future<void> setUserType(String? value) =>
      _setStringOrRemove(StorageKeys.userType, value);

  String? get segmentUserType => _prefs.getString(StorageKeys.segmentUserType);
  Future<void> setSegmentUserType(String? value) =>
      _setStringOrRemove(StorageKeys.segmentUserType, value);

  /// Set at ATC time by the cart repository. Survives `order_placed` (unlike
  /// [segmentUserType]) — see checkout_chain.md.
  String? get atcUserType => _prefs.getString(StorageKeys.atcUserType);
  Future<void> setAtcUserType(String? value) =>
      _setStringOrRemove(StorageKeys.atcUserType, value);

  /// Set during checkout flow. Survives `order_placed`.
  String? get checkoutFlowUserType => _prefs.getString(StorageKeys.checkoutFlowUserType);
  Future<void> setCheckoutFlowUserType(String? value) =>
      _setStringOrRemove(StorageKeys.checkoutFlowUserType, value);

  String? get lastVisitDate => _prefs.getString(StorageKeys.lastVisitDate);
  Future<void> setLastVisitDate(String? value) =>
      _setStringOrRemove(StorageKeys.lastVisitDate, value);

  int get daysSinceLastVisit => _prefs.getInt(StorageKeys.daysSinceLastVisitAnalytics) ?? 0;
  Future<void> setDaysSinceLastVisit(int value) =>
      _prefs.setInt(StorageKeys.daysSinceLastVisitAnalytics, value);

  /// Defaults to true on a fresh install. Flipped to false after the first
  /// identify-on-session-change fires `visitor_type = "new visitor"`.
  bool get isNewVisitor => _prefs.getBool(StorageKeys.isNewVisitor) ?? true;
  Future<void> setIsNewVisitor(bool value) =>
      _prefs.setBool(StorageKeys.isNewVisitor, value);

  // ─── Analytics: lifecycle / install detection ─────────────────────

  /// Defaults to true on fresh install. Flipped to false by
  /// AnalyticsHelper.fireLifeCycleEvents after deciding install_type = "New".
  bool get isFirstInstall => _prefs.getBool(StorageKeys.isFirstInstall) ?? true;
  Future<void> setIsFirstInstall(bool value) =>
      _prefs.setBool(StorageKeys.isFirstInstall, value);

  /// Defaults to true so `application_opened` fires once on the first cold
  /// start of a session. Lifecycle observer sets true when app moves to
  /// foreground; fireApplicationOpenedEvent flips back to false after firing.
  bool get applicationStatusFlag =>
      _prefs.getBool(StorageKeys.applicationStatusFlag) ?? true;
  Future<void> setApplicationStatusFlag(bool value) =>
      _prefs.setBool(StorageKeys.applicationStatusFlag, value);

  String? get cachedVersionName => _prefs.getString(StorageKeys.cachedVersionName);
  Future<void> setCachedVersionName(String? value) =>
      _setStringOrRemove(StorageKeys.cachedVersionName, value);

  int get cachedVersionCode => _prefs.getInt(StorageKeys.cachedVersionCode) ?? 0;
  Future<void> setCachedVersionCode(int value) =>
      _prefs.setInt(StorageKeys.cachedVersionCode, value);

  bool get isUpdated => _prefs.getBool(StorageKeys.isUpdated) ?? false;
  Future<void> setIsUpdated(bool value) =>
      _prefs.setBool(StorageKeys.isUpdated, value);

  // ─── Analytics: device probes (read by application_opened) ────────

  String? get deviceProfile => _prefs.getString(StorageKeys.deviceProfile);
  Future<void> setDeviceProfile(String? value) =>
      _setStringOrRemove(StorageKeys.deviceProfile, value);

  bool get isDeviceProfileSet =>
      _prefs.getBool(StorageKeys.isDeviceProfileSet) ?? false;
  Future<void> setIsDeviceProfileSet(bool value) =>
      _prefs.setBool(StorageKeys.isDeviceProfileSet, value);

  bool get pushEnabledAnalytics => _prefs.getBool(StorageKeys.pushEnabled) ?? true;
  Future<void> setPushEnabledAnalytics(bool value) =>
      _prefs.setBool(StorageKeys.pushEnabled, value);

  bool get isFbAvailable => _prefs.getBool(StorageKeys.isFbAvailable) ?? false;
  Future<void> setIsFbAvailable(bool value) =>
      _prefs.setBool(StorageKeys.isFbAvailable, value);

  bool get isWaAvailable => _prefs.getBool(StorageKeys.isWaAvailable) ?? false;
  Future<void> setIsWaAvailable(bool value) =>
      _prefs.setBool(StorageKeys.isWaAvailable, value);

  bool get isFcAvailable => _prefs.getBool(StorageKeys.isFcAvailable) ?? false;
  Future<void> setIsFcAvailable(bool value) =>
      _prefs.setBool(StorageKeys.isFcAvailable, value);

  bool get isMyAvailable => _prefs.getBool(StorageKeys.isMyAvailable) ?? false;
  Future<void> setIsMyAvailable(bool value) =>
      _prefs.setBool(StorageKeys.isMyAvailable, value);

  bool get isDeviceRooted => _prefs.getBool(StorageKeys.isDeviceRooted) ?? false;
  Future<void> setIsDeviceRooted(bool value) =>
      _prefs.setBool(StorageKeys.isDeviceRooted, value);

  // ─── Analytics: misc ──────────────────────────────────────────────

  String? get homePageSkin => _prefs.getString(StorageKeys.homePageSkin);
  Future<void> setHomePageSkin(String? value) =>
      _setStringOrRemove(StorageKeys.homePageSkin, value);

  bool get isOrderPaid => _prefs.getBool(StorageKeys.isOrderPaid) ?? false;
  Future<void> setIsOrderPaid(bool value) =>
      _prefs.setBool(StorageKeys.isOrderPaid, value);

  /// Snapshot of attribution params taken at shell mount / tab change /
  /// app resume, used by `logScrollEvent(useSavedAttribution: true)`.
  String? get attributionSnapshotForScroll =>
      _prefs.getString(StorageKeys.attributionSnapshotForScroll);
  Future<void> setAttributionSnapshotForScroll(String? value) =>
      _setStringOrRemove(StorageKeys.attributionSnapshotForScroll, value);

  // ─── Analytics: UTM disk mirror (UtmHeaderUtil) ───────────────────

  String? get utmSource => _prefs.getString(StorageKeys.utmSource);
  Future<void> setUtmSource(String? value) =>
      _setStringOrRemove(StorageKeys.utmSource, value);

  String? get utmMedium => _prefs.getString(StorageKeys.utmMedium);
  Future<void> setUtmMedium(String? value) =>
      _setStringOrRemove(StorageKeys.utmMedium, value);

  String? get utmCampaign => _prefs.getString(StorageKeys.utmCampaign);
  Future<void> setUtmCampaign(String? value) =>
      _setStringOrRemove(StorageKeys.utmCampaign, value);

  String? get utmContent => _prefs.getString(StorageKeys.utmContent);
  Future<void> setUtmContent(String? value) =>
      _setStringOrRemove(StorageKeys.utmContent, value);

  String? get utmTerm => _prefs.getString(StorageKeys.utmTerm);
  Future<void> setUtmTerm(String? value) =>
      _setStringOrRemove(StorageKeys.utmTerm, value);

  String? get utmGender => _prefs.getString(StorageKeys.utmGender);
  Future<void> setUtmGender(String? value) =>
      _setStringOrRemove(StorageKeys.utmGender, value);

  String? get utmDeeplink => _prefs.getString(StorageKeys.utmDeeplink);
  Future<void> setUtmDeeplink(String? value) =>
      _setStringOrRemove(StorageKeys.utmDeeplink, value);

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
