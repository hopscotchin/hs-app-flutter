import 'dart:async';
import 'dart:convert';
import 'dart:io' show HttpClient, HttpOverrides, Platform, SecurityContext;

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:segment_analytics/analytics.dart';
import 'package:segment_analytics/client.dart';
import 'package:segment_analytics/event.dart';
import 'package:segment_analytics/flush_policies/count_flush_policy.dart';
import 'package:segment_analytics/flush_policies/startup_flush_policy.dart';
import 'package:segment_analytics/flush_policies/timer_flush_policy.dart';
import 'package:segment_analytics/state.dart';

import '../config/env_config.dart';
import '../services/pref_manager.dart';
import 'constants/analytics_properties.dart';
import 'debug/analytics_debug_log.dart';
import 'plugins/amplitude_session_plugin.dart';
import 'plugins/context_parity_plugin.dart';

/// Transport wrapper around the Segment SDK. Stamps `afUserId` +
/// `cleverTapId` on every track; enrichment lives in [AnalyticsHelper].
class AnalyticsService {
  AnalyticsService(this._prefs);

  final PrefManager _prefs;

  late final Analytics _segment;
  AppsflyerSdk? _appsFlyer;
  String _appsFlyerUid = '';

  // Full trait union re-sent on every identify.
  final Map<String, Object?> _accumulatedTraits = <String, Object?>{};

  String get appsFlyerUid => _appsFlyerUid;
  String get cleverTapId => _prefs.cleverTapId ?? '';

  Future<void> init() async {
    _hydrateAccumulatedTraits();
    await _initSegment();
    await _initAppsFlyer();
  }

  void _hydrateAccumulatedTraits() {
    final raw = _prefs.accumulatedTraits;
    if (raw == null || raw.isEmpty) return;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        _accumulatedTraits.addAll(decoded);
      }
    } catch (_) {
      unawaited(_prefs.setAccumulatedTraits(null));
    }
  }

  Future<void> _initSegment() async {
    final writeKey = EnvConfig.segmentWriteKey;
    final apiHost = EnvConfig.segmentApiHost;

    final config = Configuration(
      writeKey,
      apiHost: apiHost.isNotEmpty ? apiHost : null,
      defaultIntegrationSettings: {
        'Segment.io': {'apiHost': apiHost},
      },
      trackApplicationLifecycleEvents: false,
      trackDeeplinks: false,
      collectDeviceId: false,
      debug: kDebugMode,
      autoAddSegmentDestination: true,
      // Persist the event queue on disk, matching Android Java SDK default —
      // failed batches survive across cold starts and re-flush on next launch.
      storageJson: true,
      // Match Android Java SDK defaults: flush every 20 events OR every 30s,
      // whichever fires first. Flutter SDK's defaults are 30/20s — same knobs
      // inverted, which makes uat dashboards drift compared to Android cohorts.
      flushPolicies: [
        StartupFlushPolicy(),
        TimerFlushPolicy(30000),
        CountFlushPolicy(20),
      ],
      // The Hopscotch Segment proxy (`segment-uat.hopscotch.in/batch` /
      // `segment.hopscotch.in/batch`) is wired for the official Segment Java
      // SDK wire format: POST to the proxy host with no extra path, plus
      // `Authorization: Basic base64(writeKey:)`. The Flutter community plugin
      // appends `/b` and puts the writeKey in the JSON body — proxy returns
      // 301 (path mismatch) / 401 (missing auth). Strip the `/b` and inject
      // the Basic Auth header here so we match Android exactly.
      requestFactory: writeKey.isEmpty
          ? null
          : (req) => _rewriteForHopscotchProxy(req, writeKey),
    );

    // Route Segment's HTTP traffic through the same debugging proxy
    // `NetworkClient.enableProxy()` wires for Dio. The Flutter Segment SDK
    // calls `package:http`'s `Request.send()` from many call-sites — and one
    // of them (count-based flushes triggered from `track()`) runs in the
    // caller's zone, not whatever zone `createClient()` was invoked in. So
    // a `runWithClient` wrapper misses those flushes. `HttpOverrides.global`
    // is zone-independent: it intercepts every `new HttpClient()` in the
    // isolate, which covers both Segment's batch upload + settings GET and
    // doesn't disturb Dio (which already configures its own proxy).
    _maybeInstallToolkitHttpOverrides();

    _segment = createClient(config);
    _segment.addPlugin(AmplitudeSessionPlugin(_prefs));
    _segment.addPlugin(ContextParityPlugin(_prefs));
  }

  /// Debug-only: routes every `new HttpClient()` in the isolate through the
  /// HTTP debugging proxy so Segment's zone-blind flushes get captured.
  void _maybeInstallToolkitHttpOverrides() {
    if (!kDebugMode || kIsWeb || !EnvConfig.enableHttpToolkitProxy) return;
    if (HttpOverrides.current is _ToolkitProxyHttpOverrides) return;

    const host = '127.0.0.1';
    const port = 8000;
    HttpOverrides.global = _ToolkitProxyHttpOverrides(host: host, port: port);
  }

  /// Rewrites the SDK request for the Hopscotch proxy: strips the `/b` suffix
  /// from batch uploads, stamps `channel: "mobile"` on every event, and adds
  /// Basic Auth with the write key.
  http.Request _rewriteForHopscotchProxy(http.Request req, String writeKey) {
    final uri = req.url;
    http.Request next;
    // Batch upload: path ends in `/b`. Android's apiHost already encodes the
    // proxy's full path (`segment-uat.hopscotch.in/batch`) and posts directly
    // to it, so strip the SDK-appended `/b` instead of replacing it. Appending
    // any extra segment (e.g. `/v1/batch`) makes the proxy 301-redirect.
    //
    // Also stamps `channel: "mobile"` on every event in the batch — the
    // Flutter SDK doesn't set it (no field on `RawEvent`, no Configuration
    // hook), but Hopscotch's analytics warehouse keys off this top-level
    // field. Android sends it natively.
    if (uri.path.endsWith('/b')) {
      final newPath = uri.path.substring(0, uri.path.length - 2);
      next = http.Request(req.method, uri.replace(path: newPath))
        ..headers.addAll(req.headers)
        ..body = _stampChannelOnBatch(req.body);
    } else {
      next = req;
    }
    // Basic Auth on EVERY request — settings + batch upload both want it on
    // the proxy. Header format mirrors Segment Java SDK:
    //   Authorization: Basic base64(writeKey + ":")
    final token = base64Encode(utf8.encode('$writeKey:'));
    next.headers['Authorization'] = 'Basic $token';
    return next;
  }

  /// Inserts `"channel": "mobile"` on every event in the batch. Lenient —
  /// malformed JSON leaves the body untouched.
  String _stampChannelOnBatch(String body) {
    if (body.isEmpty) return body;
    try {
      final decoded = jsonDecode(body);
      if (decoded is! Map<String, dynamic>) return body;
      final batch = decoded['batch'];
      if (batch is! List) return body;
      for (final event in batch) {
        if (event is Map<String, dynamic>) {
          event['channel'] = 'mobile';
        }
      }
      return jsonEncode(decoded);
    } catch (_) {
      return body;
    }
  }

  // AppsFlyer Flutter SDK enforces this regex on `appId`; pre-validate so
  // a misconfigured `.env` logs a warning instead of asserting.
  static final RegExp _appsFlyerAppIdPattern = RegExp(r'^\d{8,11}$');
  static const String _androidAppIdPlaceholder = '00000000';

  Future<void> _initAppsFlyer() async {
    final devKey = EnvConfig.appsFlyerKey;
    if (devKey.isEmpty) return;

    String appId;
    if (!kIsWeb && Platform.isIOS) {
      appId = EnvConfig.appleAppId;
      if (appId.isEmpty || !_appsFlyerAppIdPattern.hasMatch(appId)) {
        if (kDebugMode) {
          debugPrint(
            '[AnalyticsService] AppsFlyer iOS init skipped — APPLE_APP_ID '
            '"$appId" is not 8-11 digits; afUserId will stay empty.',
          );
        }
        return;
      }
    } else {
      // Android (and any non-iOS): appId is unused by the native SDK but the
      // Flutter wrapper asserts the regex. Pass a placeholder so init succeeds
      // and the afUserId pipeline comes online.
      appId = _androidAppIdPlaceholder;
    }

    final options = AppsFlyerOptions(
      afDevKey: devKey,
      appId: appId,
      showDebug: kDebugMode,
    );
    _appsFlyer = AppsflyerSdk(options);

    await _appsFlyer!.initSdk(
      registerConversionDataCallback: false,
      registerOnAppOpenAttributionCallback: false,
      registerOnDeepLinkingCallback: true,
    );

    try {
      final uid = await _appsFlyer!.getAppsFlyerUID();
      if (uid != null && uid.isNotEmpty) _appsFlyerUid = uid;
    } catch (e) {
      if (kDebugMode) debugPrint('[AnalyticsService] AF UID fetch failed: $e');
    }
  }

  /// Fire a Segment `track` with `afUserId` + `cleverTapId` stamped on.
  /// Amplitude `session_id` is injected later by [AmplitudeSessionPlugin].
  Future<void> track(String event, Map<String, Object?> properties) async {
    final enriched = <String, Object?>{
      ...properties,
      AnalyticsProperties.afUserId: _appsFlyerUid,
      AnalyticsProperties.cleverTapId: cleverTapId,
    };
    AnalyticsDebugLog.record(event, enriched);
    await _segment.track(event, properties: enriched);
  }

  /// Fire a Segment `identify`. Always ships the full accumulated trait set —
  /// Flutter SDK's wholesale-merge would otherwise drop prior traits.
  Future<void> identify({
    String? userId,
    required Map<String, Object?> traits,
  }) async {
    _accumulatedTraits.addAll(traits);
    _accumulatedTraits[AnalyticsProperties.cleverTapId] = cleverTapId;
    unawaited(_prefs.setAccumulatedTraits(jsonEncode(_accumulatedTraits)));
    final userTraits = UserTraits(
      custom: Map<String, dynamic>.from(_accumulatedTraits),
    );
    await _segment.identify(userId: userId, userTraits: userTraits);
    AnalyticsDebugLog.record('identify', userTraits.toJson());
    if (kDebugMode) {
      debugPrint('[identify] userId=$userId $_accumulatedTraits');
    }
  }

  /// Caller MUST guard with `if (!prefs.isLoggedIn)` — resetting while the
  /// user is still logged in nukes the anonymous id and breaks attribution.
  Future<void> reset() {
    _accumulatedTraits.clear();
    unawaited(_prefs.setAccumulatedTraits(null));
    return _segment.reset(resetAnonymousId: true);
  }

  /// `hs_site` trait value.
  static String platformLabel() {
    if (kIsWeb) return 'web';
    if (Platform.isIOS) return 'ios';
    return 'android';
  }
}

/// Global [HttpOverrides] that routes every `new HttpClient()` through the
/// debugging proxy. Accepts the proxy's MITM certificate.
class _ToolkitProxyHttpOverrides extends HttpOverrides {
  _ToolkitProxyHttpOverrides({required this.host, required this.port});

  final String host;
  final int port;

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.findProxy = (uri) => 'PROXY $host:$port';
    client.badCertificateCallback = (_, _, _) => true;
    return client;
  }
}
