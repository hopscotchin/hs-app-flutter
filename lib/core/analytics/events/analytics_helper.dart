import 'dart:async';
import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../router/navigation_observer.dart';
import '../../services/pref_manager.dart';
import '../analytics_service.dart';
import '../debug/analytics_debug_log.dart';
import '../attribution/lp_attribution_helper.dart';
import '../attribution/order_attribution_helper.dart';
import '../attribution/utm_header_util.dart';
import '../constants/analytics_defaults.dart';
import '../constants/analytics_events.dart';
import '../constants/analytics_properties.dart';
import '../state/checkout_timer.dart';
import '../state/experiments_util.dart';
import '../state/launch_timer.dart';

/// THE aggregator. Mirrors Android `AnalyticsHelper` — every module-specific
/// event method lives in an `extension AnalyticsHelper` file under
/// `events/modules/` and delegates to [logEvent] / [logScrollEvent].
///
/// Two low-level paths:
/// - [logEvent] — the standard track call. Enriches with time buckets,
///   attribution (when `attribution: true`), timestamp.
/// - [logScrollEvent] — same as logEvent but without the `timestamp` field.
///   Supports the `useSavedAttribution` branch (reads the snapshot taken at
///   shell mount / tab change instead of live OrderAttributionHelper state).
///
/// Identity paths:
/// - [identifyAnonymous] — first call at cold start. Stamps hs_site,
///   hs_device_id, user_type (cached), cleverTapId.
/// - [identifyLoggedIn] / [identifyRegistered] — login/registration success.
/// - [identifyOnCookieChange] — fired by `CookieAnalyticsInterceptor` after
///   every HTTP response (size > 2 guard inside).
/// - [identifyForChildCohorts], [identifyGender], [identifyGokwikRisk],
///   [identifyContinueBrowsingEligibleUser] — single-trait writes.
/// - [resetIdentity] — wipes anonymous id on logout (guarded by
///   `!prefManager.isLoggedIn`).
///
/// Lifecycle:
/// - [fireSessionStartedEvent] — fired by cookie interceptor when sessionId
///   rotates.
/// - [fireApplicationOpenedEvent] — fired indirectly via [fireLifeCycleEvents]
///   on the first cold start of a new install / version.
/// - [logAppLaunched] — fired by the first viewable screen's Bloc. Self-guards
///   via [LaunchTimer.isStopped].
@lazySingleton
class AnalyticsHelper {
  AnalyticsHelper(
    this._service,
    this._prefs,
    this._packageInfo,
    this._deviceInfo,
    this._launchTimer,
    this._checkoutTimer,
    this._experiments,
    this._orderAttribution,
    this._lpAttribution,
    this._utm,
    this._navObserver,
  );

  final AnalyticsService _service;
  final PrefManager _prefs;
  final PackageInfo _packageInfo;
  final DeviceInfoPlugin _deviceInfo;
  final LaunchTimer _launchTimer;
  final CheckoutTimer _checkoutTimer;
  final ExperimentsUtil _experiments;
  final OrderAttributionHelper _orderAttribution;
  final LpAttributionHelper _lpAttribution;
  final UtmHeaderUtil _utm;
  final AppNavigationObserver _navObserver;

  // Public accessors used by module extensions to read state. Keeps the
  // extension files from having to wire every collaborator manually.

  LaunchTimer get launchTimer => _launchTimer;
  CheckoutTimer get checkoutTimer => _checkoutTimer;
  OrderAttributionHelper get orderAttribution => _orderAttribution;
  LpAttributionHelper get lpAttribution => _lpAttribution;
  UtmHeaderUtil get utm => _utm;
  PrefManager get prefs => _prefs;

  // ────────────────────────────────────────────────────────────────────
  //  Event enrichment
  // ────────────────────────────────────────────────────────────────────

  Map<String, Object?> _commonEventProperties({
    required bool attribution,
    required bool useSavedAttribution,
  }) {
    final props = <String, Object?>{};
    _addTimeBuckets(props);

    if (attribution && !useSavedAttribution) {
      // Two-store attribution: OrderAttribution carries HP unprefixed keys +
      // funnel + sortbar; LpAttribution carries the LP click deque as
      // `lp{n}_*`. Composed here; both stores' `clear`/write lifecycles
      // are independent (LP wipes on back-to-shell, HP persists across
      // funnel switch until next HP click overrides specific keys).
      props.addAll(_orderAttribution.segmentParams);
      props.addAll(_lpAttribution.segmentParams);
    } else if (attribution && useSavedAttribution) {
      final snapshot = _readScrollAttributionSnapshot();
      if (snapshot.isNotEmpty) props.addAll(snapshot);
    }
    props.addAll(_navObserver.navigationTrackerParams);

    return props;
  }

  Map<String, Object?> _readScrollAttributionSnapshot() {
    // Stored as a JSON object string by the shell route on mount / tab change
    // (PrefManager.attributionSnapshotForScroll). Decoded here at read time.
    final raw = _prefs.attributionSnapshotForScroll;
    if (raw == null || raw.isEmpty) return const <String, Object?>{};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return Map<String, Object?>.from(decoded);
      }
    } catch (_) {
      // fall through
    }
    return const <String, Object?>{};
  }

  void _addTimeBuckets(Map<String, Object?> props) {
    // Asia/Kolkata bucketing — mirrors Android `Calendar.getInstance(TimeZone.getTimeZone("Asia/Calcutta"))`.
    // Dart's DateTime has no built-in timezone DB; we apply a fixed +05:30
    // UTC offset which is correct for IST year-round (no DST).
    final nowUtc = DateTime.now().toUtc();
    final ist = nowUtc.add(const Duration(hours: 5, minutes: 30));
    props[AnalyticsProperties.hourOfDay] = ist.hour;
    // Android Calendar.DAY_OF_WEEK is 1-based with Sunday = 1.
    // Dart DateTime.weekday is 1-based with Monday = 1, Sunday = 7.
    // Translate: Sun=1, Mon=2, ..., Sat=7 (Android shape).
    final dartWeekday = ist.weekday; // 1=Mon..7=Sun
    final androidDayOfWeek = dartWeekday == 7 ? 1 : dartWeekday + 1;
    props[AnalyticsProperties.dayOfWeek] = androidDayOfWeek;
    props[AnalyticsProperties.dayOfMonth] = ist.day;
    props[AnalyticsProperties.monthOfYear] = ist.month;
    final weekOfYear = _isoWeekOfYear(ist);
    final weekStr = weekOfYear.toString().padLeft(2, '0');
    props[AnalyticsProperties.weekOfYear] = '${ist.year}$weekStr';
  }

  // ISO-8601 week-of-year. Android Calendar.WEEK_OF_YEAR uses ISO-8601 by
  // default with first day of week = Monday and minimum days in first week = 4
  // (the locale defaults on most JVMs). Compute the same here.
  int _isoWeekOfYear(DateTime date) {
    final thursday = DateTime.utc(date.year, date.month, date.day)
        .add(Duration(days: 3 - ((date.weekday + 6) % 7)));
    final firstThursday = DateTime.utc(thursday.year, 1, 4);
    final firstThursdayOffset = (firstThursday.weekday + 6) % 7;
    final week1Monday = firstThursday.subtract(Duration(days: firstThursdayOffset));
    final diffDays = thursday.difference(week1Monday).inDays;
    return (diffDays ~/ 7) + 1;
  }

  // ────────────────────────────────────────────────────────────────────
  //  Track entry points
  // ────────────────────────────────────────────────────────────────────

  /// Fire a Segment `track` event.
  ///
  /// - [attribution] = true → merge OrderAttributionHelper + LP + TabPage params.
  /// - Merge order: attribution FIRST, then the caller's [properties]. The
  ///   caller's own keys (component's trackingMeta on impressions, click
  ///   meta on clicks, etc.) WIN over any attribution collision so an
  ///   impression's `banner_name` reflects the impressed component, not
  ///   whatever the last click stored in OrderAttribution.
  Future<void> logEvent(
    String event,
    Map<String, Object?> properties, {
    bool attribution = true,
  }) async {
    final enriched = <String, Object?>{
      ..._commonEventProperties(
        attribution: attribution,
        useSavedAttribution: false,
      ),
      ...properties,
      AnalyticsProperties.timestamp: DateTime.now().toUtc().toIso8601String(),
    };
    await _service.track(event, enriched);
  }

  /// Fire a Segment `track` event without the `timestamp` field, with the
  /// option to read attribution from the persisted snapshot instead of the
  /// live OrderAttributionHelper. Same merge order as [logEvent].
  Future<void> logScrollEvent(
    String event,
    Map<String, Object?> properties, {
    bool attribution = true,
    bool useSavedAttribution = false,
  }) async {
    final enriched = <String, Object?>{
      ..._commonEventProperties(
        attribution: attribution,
        useSavedAttribution: useSavedAttribution,
      ),
      ...properties,
    };
    await _service.track(event, enriched);
  }

  // ────────────────────────────────────────────────────────────────────
  //  Identify
  // ────────────────────────────────────────────────────────────────────

  /// Baseline identify traits stamped on every `identify()` call. Mirrors
  /// Android `AnalyticsHelper.callIdentify` (hs_site + hs_device_id +
  /// advertisingId/Type) and iOS `sendIdentificationToSegment`.
  ///
  /// - `hs_device_id` reads the native device id resolved by
  ///   `DeviceProbeService` (ANDROID_ID on Android, identifierForVendor on
  ///   iOS) — NOT the server-issued `auth.uuid`.
  /// - `advertisingId` + `advertisingIdType` are stamped together when the
  ///   user granted LAT/ATT; omitted entirely when denied (matches iOS native
  ///   which silently drops the keys instead of sending all-zeros).
  Map<String, Object?> _getUserTraits() {
    final traits = <String, Object?>{
      AnalyticsProperties.hsSite: AnalyticsService.platformLabel(),
      AnalyticsProperties.hsDeviceId: _prefs.hsDeviceId ?? '',
    };
    final adId = _prefs.advertisingId;
    if (adId != null && adId.isNotEmpty) {
      traits[AnalyticsProperties.advertisingId] = adId;
      traits[AnalyticsProperties.advertisingIdType] =
          defaultTargetPlatform == TargetPlatform.iOS ? 'IDFA' : 'AAID';
    }
    return traits;
  }

  Future<void> _callIdentify(Map<String, Object?> traits) async {
    final userId = _prefs.userId;
    await _service.identify(
      userId: (userId != null && userId.isNotEmpty) ? userId : null,
      traits: traits,
    );
  }

  /// First identify of the session. Stamps hs_site, hs_device_id, user_type
  /// (cached), cleverTapId. Safe to call before any user action.
  Future<void> identifyAnonymous() async {
    final traits = _getUserTraits();
    _identifyWithUserType(traits);
    await _callIdentify(traits);
  }

  /// Customer logged in. Adds email, name, mobile, mobile_status,
  /// continue_browsing_eligible_visitor traits.
  Future<void> identifyLoggedIn({
    String? email,
    String? phone,
    String? userId,
    String? userName,
    String? mobileStatus,
    bool isEligibleForContinueBrowsing = false,
  }) {
    return _identifyWithUser(
      email: email,
      phone: phone,
      userName: userName,
      mobileStatus: mobileStatus,
      isEligibleForContinueBrowsing: isEligibleForContinueBrowsing,
      isRegistered: false,
    );
  }

  /// Customer just registered. Same as [identifyLoggedIn] plus `createdAt`
  /// (UTC ISO-8601 of now).
  Future<void> identifyRegistered({
    String? email,
    String? phone,
    String? userId,
    String? userName,
    String? mobileStatus,
    bool isEligibleForContinueBrowsing = false,
  }) {
    return _identifyWithUser(
      email: email,
      phone: phone,
      userName: userName,
      mobileStatus: mobileStatus,
      isEligibleForContinueBrowsing: isEligibleForContinueBrowsing,
      isRegistered: true,
    );
  }

  Future<void> _identifyWithUser({
    String? email,
    String? phone,
    String? userName,
    String? mobileStatus,
    required bool isRegistered,
    required bool isEligibleForContinueBrowsing,
  }) async {
    final traits = _getUserTraits();
    _identifyWithUserType(traits);
    if (email != null && email.isNotEmpty) traits['email'] = email;
    if (userName != null && userName.isNotEmpty) traits['name'] = userName;
    if (phone != null && phone.isNotEmpty) {
      traits[AnalyticsProperties.mobile] = phone;
    }
    if (isRegistered) {
      traits['createdAt'] = DateTime.now().toUtc().toIso8601String();
    }
    if (mobileStatus != null && mobileStatus.isNotEmpty) {
      traits[AnalyticsProperties.mobileStatus] = mobileStatus;
    }
    traits[AnalyticsProperties.continueBrowsingEligibleVisitor] =
        isEligibleForContinueBrowsing;
    await _callIdentify(traits);
  }

  /// Gender trait. Single-key identify.
  Future<void> identifyGender(String gender) async {
    if (gender.isEmpty) return;
    final traits = <String, Object?>{'gender': gender};
    await _callIdentify(traits);
  }

  /// Continue-browsing eligibility trait.
  Future<void> identifyContinueBrowsingEligibleUser(bool eligible) async {
    final traits = <String, Object?>{
      AnalyticsProperties.continueBrowsingEligibleVisitor: eligible,
    };
    await _callIdentify(traits);
  }

  /// Gokwik risk score traits (paired write).
  Future<void> identifyGokwikRisk({
    required double score,
    required String factor,
  }) async {
    final traits = <String, Object?>{
      AnalyticsProperties.gokwikRiskScore: score,
      AnalyticsProperties.gokwikRiskFactor: factor,
    };
    await _callIdentify(traits);
  }

  /// Child-cohort counters. Always writes the six cohort keys (zero-padded
  /// when null) plus `total_child_profiles`. Mirrors Android
  /// `identifyForChildCohorts`.
  Future<void> identifyForChildCohorts(Map<String, int>? cohorts) async {
    const requiredKeys = <String>[
      'boy_infant',
      'boy_toddler',
      'boy_child',
      'girl_infant',
      'girl_toddler',
      'girl_child',
    ];
    const suffix = '_child_profile';
    final traits = <String, Object?>{};
    var total = 0;
    for (final key in requiredKeys) {
      final value = cohorts?[key] ?? 0;
      traits['$key$suffix'] = value;
      total += value;
    }
    traits[AnalyticsProperties.totalChildProfiles] = total;
    await _callIdentify(traits);
  }

  /// Cookie-driven aggregated identify. Fired by `CookieAnalyticsInterceptor`
  /// after every HTTP response. The interceptor diffs the four cookies and
  /// passes the change flags here; this method assembles the trait map and
  /// only fires when at least one of the flags is true.
  ///
  /// Guarding on the flags (not `traits.length > 2`) matches Android
  /// `AnalyticsHelper.identify(session, utm, userType, experiment)` exactly:
  /// Android's baseline is always 2 keys (`hs_site` + `hs_device_id`), so
  /// `size > 2` there means "something changed". Flutter's baseline can be
  /// 4 (with `advertisingId` + `advertisingIdType`), so the size check would
  /// spam identifies on every cookie response even when no flag is set.
  Future<void> identifyOnCookieChange({
    required bool sessionChange,
    required bool utmChange,
    required bool userTypeChange,
    required bool experimentChange,
  }) async {
    if (!sessionChange && !utmChange && !userTypeChange && !experimentChange) {
      return;
    }
    final traits = _getUserTraits();
    if (userTypeChange) _identifyWithUserType(traits);
    if (sessionChange) _identifyOnSessionChange(traits);
    if (utmChange) await _identifyOnUtmChange(traits);
    if (experimentChange) _identifyOnExperimentChange(traits);
    await _callIdentify(traits);
  }

  void _identifyWithUserType(Map<String, Object?> traits) {
    final userType = _prefs.userType;
    if (userType != null && userType.isNotEmpty) {
      traits[AnalyticsProperties.userType] = userType;
      return;
    }
    final segmentUserType = _prefs.segmentUserType;
    if (segmentUserType != null && segmentUserType.isNotEmpty) {
      traits[AnalyticsProperties.userType] = segmentUserType;
    }
  }

  void _identifyOnSessionChange(Map<String, Object?> traits) {
    final lastVisit = _prefs.lastVisitDate;
    if (lastVisit != null && lastVisit.isNotEmpty) {
      traits[AnalyticsProperties.lastVisitDate] = lastVisit;
    }
    final daysSince = _prefs.daysSinceLastVisit;
    if (daysSince != -1) {
      traits[AnalyticsProperties.daysSinceLastVisit] = daysSince;
    }
    traits[AnalyticsProperties.visitorType] = _prefs.isNewVisitor
        ? AnalyticsDefaults.newVisitor
        : AnalyticsDefaults.repeatVisitor;
    if (_prefs.isNewVisitor) {
      // Flip after the first session-change identify fires.
      unawaited(_prefs.setIsNewVisitor(false));
    }
  }

  Future<void> _identifyOnUtmChange(Map<String, Object?> traits) async {
    traits[AnalyticsProperties.utmSource] = _utm.utmSource ?? AnalyticsDefaults.none;
    traits[AnalyticsProperties.utmMedium] = _utm.utmMedium ?? AnalyticsDefaults.none;
    traits[AnalyticsProperties.utmCampaign] = _utm.utmCampaign ?? AnalyticsDefaults.none;
    traits[AnalyticsProperties.utmContent] = _utm.utmContent ?? AnalyticsDefaults.none;
    traits[AnalyticsProperties.utmTerm] = _utm.utmTerm ?? AnalyticsDefaults.none;
    traits[AnalyticsProperties.deeplink] = _utm.deeplink ?? AnalyticsDefaults.none;
    traits[AnalyticsProperties.utmGender] = _utm.utmGender ?? AnalyticsDefaults.none;
    if (traits.length > 2) {
      final now = DateTime.now();
      final stamp = '${now.year.toString().padLeft(4, '0')}-'
          '${now.month.toString().padLeft(2, '0')}-'
          '${now.day.toString().padLeft(2, '0')} '
          '${(now.hour % 12 == 0 ? 12 : now.hour % 12).toString().padLeft(2, '0')}:'
          '${now.minute.toString().padLeft(2, '0')}:'
          '${now.second.toString().padLeft(2, '0')}';
      traits[AnalyticsProperties.utmDate] = stamp;
    }
  }

  void _identifyOnExperimentChange(Map<String, Object?> traits) {
    final list = List<String>.of(_experiments.experimentsList);
    // Mirror Android: if list has > 1 entries and the FIRST is "none", drop it.
    if (list.length > 1 && list.first.toLowerCase() == AnalyticsDefaults.none) {
      list.removeAt(0);
    }
    traits[AnalyticsProperties.experiments] = list;
  }

  /// Logout-time reset. Wipes Segment anonymous id + cached traits.
  /// **Caller must check `!prefs.isLoggedIn` first** — mirrors Android guard.
  Future<void> resetIdentity() async {
    if (_prefs.isLoggedIn) return;
    await _service.reset();
  }

  // ────────────────────────────────────────────────────────────────────
  //  Lifecycle
  // ────────────────────────────────────────────────────────────────────

  /// Session-started event. Fired by the cookie interceptor when the
  /// sessionId cookie rotates. Mirrors Android
  /// `AnalyticsHelper.fireSessionStartedEvent` (`AnalyticsHelper.java:408-426`)
  /// — five optional `session_utm_*` fields conditionally stamped when the
  /// UTM helper has values, then `logEvent(SESSION_STARTED, props, false, false)`.
  ///
  /// Payload matches the Android wire format 1:1; enrichment (time buckets,
  /// timestamp, afUserId, cleverTapId, integrations.Amplitude.session_id)
  /// arrives through `logEvent` + `AnalyticsService.track` + AmplitudeSessionPlugin.
  Future<void> fireSessionStartedEvent() async {
    final props = <String, Object?>{};
    if (_utm.utmSource != null && _utm.utmSource!.isNotEmpty) {
      props[AnalyticsProperties.sessionUtmSource] = _utm.utmSource;
    }
    if (_utm.utmCampaign != null && _utm.utmCampaign!.isNotEmpty) {
      props[AnalyticsProperties.sessionUtmCampaign] = _utm.utmCampaign;
    }
    if (_utm.utmMedium != null && _utm.utmMedium!.isNotEmpty) {
      props[AnalyticsProperties.sessionUtmMedium] = _utm.utmMedium;
    }
    if (_utm.deeplink != null && _utm.deeplink!.isNotEmpty) {
      props[AnalyticsProperties.sessionDeeplink] = _utm.deeplink;
    }
    if (_utm.utmGender != null && _utm.utmGender!.isNotEmpty) {
      props[AnalyticsProperties.sessionUtmGender] = _utm.utmGender;
    }
    await logEvent(AnalyticsEvents.sessionStarted, props);
  }

  /// Resolve install type from cached-version prefs + current package info.
  /// Pure read — no side effects. Returns:
  ///   • `"New"` on first install (prevVersionCode==0 AND `isFirstInstall`),
  ///   • `"Update"` on version bump (or prevVersionCode==0 with the
  ///     first-install flag already cleared, matching
  ///     [fireLifeCycleEvents]'s fallback branch),
  ///   • `null` when version is unchanged (no install/update to report).
  String? _resolveInstallType() {
    final previousVersionCode = _prefs.cachedVersionCode;
    if (previousVersionCode == 0) {
      return _prefs.isFirstInstall
          ? AnalyticsDefaults.newInstall
          : AnalyticsDefaults.update;
    }
    final previousVersionName = _prefs.cachedVersionName ?? '';
    if (previousVersionName.toLowerCase() !=
        _packageInfo.version.toLowerCase()) {
      return AnalyticsDefaults.update;
    }
    return null;
  }

  /// Pre-compute install type and stamp it onto [LaunchTimer] at bootstrap
  /// — mirrors Android `SplashActivity.onCreate` which resolves install
  /// type upfront so the first screen's `app_launched` carries the correct
  /// value. Must run BEFORE the first `logAppLaunched` call (i.e. before
  /// any screen mounts). Idempotent — safe to call multiple times.
  ///
  /// Doesn't fire `application_opened` or touch prefs — that's
  /// [fireLifeCycleEvents]'s job when the first screen's Bloc runs the
  /// launch chain.
  void bootstrapInstallType() {
    _launchTimer.installType = _resolveInstallType();
  }

  /// Decide whether `application_opened` needs to fire based on cached vs
  /// current version. Mirrors Android `fireLifeCycleEvents`.
  Future<void> fireLifeCycleEvents() async {
    final previousVersionName = _prefs.cachedVersionName ?? '';
    final previousVersionCode = _prefs.cachedVersionCode;
    final currentVersionName = _packageInfo.version;
    final currentVersionCode = int.tryParse(_packageInfo.buildNumber) ?? 0;
    const defaultPreviousVersionName = 'v1.10.2';
    const defaultPreviousVersionCode = 2016102904;

    if (previousVersionCode == 0) {
      if (_prefs.isFirstInstall) {
        _launchTimer.installType = AnalyticsDefaults.newInstall;
        await fireApplicationOpenedEvent(
          installType: AnalyticsDefaults.newInstall,
          prevVersionName: '',
          prevVersionCode: 0,
          sendExtraParams: true,
        );
        await _prefs.setIsFirstInstall(false);
        await _prefs.setApplicationStatusFlag(false);
      } else {
        await _prefs.setIsUpdated(true);
        _launchTimer.installType = AnalyticsDefaults.update;
        await fireApplicationOpenedEvent(
          installType: AnalyticsDefaults.update,
          prevVersionName: defaultPreviousVersionName,
          prevVersionCode: defaultPreviousVersionCode,
          sendExtraParams: true,
        );
        await _prefs.setApplicationStatusFlag(false);
        await _prefs.setIsFirstInstall(false);
      }
    } else if (previousVersionName.toLowerCase() !=
        currentVersionName.toLowerCase()) {
      await _prefs.setIsUpdated(true);
      _launchTimer.installType = AnalyticsDefaults.update;
      await fireApplicationOpenedEvent(
        installType: AnalyticsDefaults.update,
        prevVersionName: previousVersionName,
        prevVersionCode: previousVersionCode,
        sendExtraParams: true,
      );
      await _prefs.setApplicationStatusFlag(false);
      await _prefs.setIsFirstInstall(false);
    } else {
      await _prefs.setIsUpdated(false);
    }
    await _prefs.setCachedVersionName(currentVersionName);
    await _prefs.setCachedVersionCode(currentVersionCode);
  }

  /// `application_opened` event. Mirrors Android `fireApplicationOpenedEvent`.
  Future<void> fireApplicationOpenedEvent({
    required String installType,
    required String prevVersionName,
    required int prevVersionCode,
    required bool sendExtraParams,
  }) async {
    final props = <String, Object?>{
      AnalyticsProperties.versionName: _packageInfo.version,
      AnalyticsProperties.versionCode: int.tryParse(_packageInfo.buildNumber) ?? 0,
    };
    final deviceProfile = _prefs.deviceProfile;
    if (_prefs.isDeviceProfileSet && deviceProfile != null && deviceProfile.isNotEmpty) {
      props[AnalyticsProperties.deviceProfile] = deviceProfile;
    }
    if (sendExtraParams) {
      if (installType.isNotEmpty) {
        props[AnalyticsProperties.installType] = installType;
      }
      if (prevVersionName.isNotEmpty) {
        props[AnalyticsProperties.previousVersionName] = prevVersionName;
      }
      if (prevVersionCode != 0) {
        props[AnalyticsProperties.previousVersionCode] = prevVersionCode;
      }
    }
    props[AnalyticsProperties.pushEnabled] = _yesNo(_prefs.pushEnabledAnalytics);
    props[AnalyticsProperties.fmessenger] = _yesNo(_prefs.isFbAvailable);
    props[AnalyticsProperties.waInstalled] = _yesNo(_prefs.isWaAvailable);
    props[AnalyticsProperties.fcInstalled] = _yesNo(_prefs.isFcAvailable);
    props[AnalyticsProperties.myInstalled] = _yesNo(_prefs.isMyAvailable);
    props[AnalyticsProperties.rooted] = _yesNo(_prefs.isDeviceRooted);
    props[AnalyticsProperties.deviceCpuArch] = await _readCpuArch();
    await _prefs.setApplicationStatusFlag(false);
    await logEvent(AnalyticsEvents.applicationOpened, props);
  }

  Future<String> _readCpuArch() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final info = await _deviceInfo.androidInfo;
      return info.supportedAbis.isNotEmpty
          ? info.supportedAbis.first
          : AnalyticsDefaults.none;
    }
    return AnalyticsDefaults.none;
  }

  /// First viewable screen's "app_launched" event. Self-guards via
  /// [LaunchTimer.isStopped]. Safe to call from every screen-viewed handler —
  /// only the first one wins.
  Future<void> logAppLaunched(String fromScreen) async {
    if (_launchTimer.isStopped) return;
    // `ttl` was stamped earlier by `AppNavigationObserver.didPush` on the
    // first non-splash route commit — Android parity with `Activity.
    // onCreate`. `tti` fires now, matching Android's `logTTI` at the
    // "screen is interactive" moment (first viewable screen's Bloc calling
    // this method). ttl ≤ tti (delta = paint + interactive-ready).
    _launchTimer.logTti();
    final props = <String, Object?>{
      AnalyticsProperties.fromScreen:
          fromScreen.isNotEmpty ? fromScreen : AnalyticsDefaults.none,
      AnalyticsProperties.ttl: _launchTimer.ttl,
      AnalyticsProperties.tti: _launchTimer.tti,
      AnalyticsProperties.installType:
          _launchTimer.installType ?? AnalyticsDefaults.none,
      AnalyticsProperties.fromSource:
          _launchTimer.launchSource ?? AnalyticsDefaults.none,
    };
    await logEvent(AnalyticsEvents.appLaunched, props);
    _launchTimer.stop();
    await fireLifeCycleEvents();
    if (_prefs.applicationStatusFlag) {
      await fireApplicationOpenedEvent(
        installType: '',
        prevVersionName: _prefs.cachedVersionName ?? '',
        prevVersionCode: _prefs.cachedVersionCode,
        sendExtraParams: false,
      );
      await _prefs.setApplicationStatusFlag(false);
    }
  }

  /// Fires on EVERY background→ foreground transition, regardless
  /// of duration.
  Future<void> identifyFromBackground() => identifyOnCookieChange(
    sessionChange: true,
    utmChange: true,
    userTypeChange: true,
    experimentChange: true,
  );

  /// Foreground-return re-arms LaunchTimer,
  /// then fires `app_launched` with `from_screen = "Background"`. Caller
  /// is responsible for firing [identifyFromBackground] first (Android
  /// runs both unconditionally on the same resume).
  Future<void> logAppLaunchedFromBackground() async {
    _launchTimer.recordProcessStart();
    await logAppLaunched(AnalyticsDefaults.background);
  }

  /// `atc_user` + `checkout_user` + step_duration + total_duration +
  /// background_time merge for the checkout chain. Mirrors Android
  /// `addUserTypeAndDuration(reset)`.
  Map<String, Object?> addUserTypeAndDuration({bool reset = true}) {
    final props = <String, Object?>{};
    final atcUser = _prefs.atcUserType;
    if (atcUser != null && atcUser.isNotEmpty) {
      props[AnalyticsProperties.atcUser] = atcUser;
    }
    final checkoutUser = _prefs.checkoutFlowUserType;
    if (checkoutUser != null && checkoutUser.isNotEmpty) {
      props[AnalyticsProperties.checkoutUser] = checkoutUser;
    }
    props[AnalyticsProperties.stepDuration] =
        _checkoutTimer.timeSinceLastEvent(updateWithCurrentTime: reset);
    props[AnalyticsProperties.totalDuration] = _checkoutTimer.timeSinceFirstEvent;
    final bg = _checkoutTimer.backgroundDuration;
    props[AnalyticsProperties.backgroundTime] = bg;
    if (bg > 0) _checkoutTimer.resetBackgroundTimer();
    return props;
  }

  /// `atc_user` + `checkout_user` only (no durations). Used by
  /// non-time-tracked checkout events. Mirrors Android `addUserType()`.
  Map<String, Object?> addUserType() {
    final props = <String, Object?>{};
    final atcUser = _prefs.atcUserType;
    if (atcUser != null && atcUser.isNotEmpty) {
      props[AnalyticsProperties.atcUser] = atcUser;
    }
    final checkoutUser = _prefs.checkoutFlowUserType;
    if (checkoutUser != null && checkoutUser.isNotEmpty) {
      props[AnalyticsProperties.checkoutUser] = checkoutUser;
    }
    return props;
  }

  String _yesNo(bool value) => value ? AnalyticsDefaults.yes : AnalyticsDefaults.no;
}
