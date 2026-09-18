import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hs_app_flutter/core/analytics/analytics_service.dart';
import 'package:hs_app_flutter/core/analytics/attribution/lp_attribution_helper.dart';
import 'package:hs_app_flutter/core/analytics/attribution/order_attribution_helper.dart';
import 'package:hs_app_flutter/core/analytics/attribution/product_attribution_helper.dart';
import 'package:hs_app_flutter/core/analytics/attribution/utm_header_util.dart';
import 'package:hs_app_flutter/core/analytics/events/analytics_helper.dart';
import 'package:hs_app_flutter/core/analytics/home/home_track_analytic_manager.dart';
import 'package:hs_app_flutter/core/analytics/home/journey_worker.dart';
import 'package:hs_app_flutter/core/analytics/state/cart_timer.dart';
import 'package:hs_app_flutter/core/analytics/state/checkout_timer.dart';
import 'package:hs_app_flutter/core/analytics/state/experiments_util.dart';
import 'package:hs_app_flutter/core/constants/storage_keys.dart';
import 'package:hs_app_flutter/core/analytics/state/launch_timer.dart';
import 'package:hs_app_flutter/core/di/injection.dart';
import 'package:hs_app_flutter/core/router/navigation_observer.dart';
import 'package:hs_app_flutter/core/services/pref_manager.dart';

/// Test double for [AnalyticsService]. We mock ONLY the transport — every
/// helper above it (AnalyticsHelper, OrderAttributionHelper, LaunchTimer,
/// UtmHeaderUtil, …) runs real code so the tests exercise the full
/// enrichment chain end-to-end.
class MockAnalyticsService extends Mock implements AnalyticsService {}

class MockDeviceInfoPlugin extends Mock implements DeviceInfoPlugin {}

/// One reusable harness for every analytics event unit test. Wire in [setUp]:
///
/// ```dart
/// late AnalyticsTestHarness h;
/// setUp(() async {
///   h = await AnalyticsTestHarness.build();
/// });
/// tearDown(() => h.tearDown());
///
/// test('...', () async {
///   await h.analytics.logHomePageViewed(fromScreen: 'Discover');
///   final e = h.eventsNamed(AnalyticsEvents.homePageViewed).single;
///   expect(e[AnalyticsProperties.fromScreen], 'Discover');
/// });
/// ```
class AnalyticsTestHarness {
  AnalyticsTestHarness._({
    required this.service,
    required this.prefs,
    required this.analytics,
    required this.launchTimer,
    required this.cartTimer,
    required this.checkoutTimer,
    required this.utm,
    required this.orderAttribution,
    required this.lpAttribution,
    required this.productAttribution,
    required this.experiments,
    required this.captured,
    required this.identifies,
    required this.timeline,
    required this.navObserver,
  });

  final MockAnalyticsService service;
  final PrefManager prefs;
  final AnalyticsHelper analytics;
  final LaunchTimer launchTimer;

  /// Stamped by `AppNavigationObserver` on a cart-route push; read for `tti`.
  final CartTimer cartTimer;
  final CheckoutTimer checkoutTimer;
  final UtmHeaderUtil utm;
  final OrderAttributionHelper orderAttribution;
  final LpAttributionHelper lpAttribution;
  final ProductAttributionHelper productAttribution;
  final ExperimentsUtil experiments;
  final AppNavigationObserver navObserver;

  /// Every (event, payload) pair the transport received, in fire order.
  final List<CapturedEvent> captured;

  /// Every `identify` the transport received, in call order.
  final List<CapturedIdentify> identifies;

  /// Every transport call in one ordered list — `track:<event>`, `identify`,
  /// `reset`. For assertions about *relative order* across call kinds, which
  /// the per-kind lists cannot express.
  ///
  /// Sign-out is the case that needs it: `customer_logged_out` has to reach the
  /// wire before `resetIdentity` wipes the userId, so the contract is an
  /// ordering rather than a payload.
  final List<String> timeline;

  /// How many times identity was reset.
  int get resetCount => timeline.where((e) => e == 'reset').length;

  /// Force iOS in tests — [AnalyticsHelper._readCpuArch] then short-circuits to
  /// `AnalyticsDefaults.none` without touching the `device_info_plus` plugin
  /// channel (which isn't available in a unit-test host).
  static const TargetPlatform _testPlatform = TargetPlatform.iOS;

  static Future<AnalyticsTestHarness> build({
    Map<String, Object> initialPrefs = const {},
    String appVersion = '1.99.0',
    String buildNumber = '99999',
  }) async {
    // `HomeTrackAnalyticManager.constructor` calls
    // `WidgetsBinding.instance.addObserver(this)` for background flushes,
    // so the binding has to exist before we register the tracker.
    // Idempotent.
    TestWidgetsFlutterBinding.ensureInitialized();
    debugDefaultTargetPlatformOverride = _testPlatform;

    // Default the AppConfig home-analytics flag to ON — production reflects
    // that state once `AppConfig` lands from the server, and every
    // impression-oriented test assumes it. Callers that specifically
    // exercise the OFF branch (`gate_home_analytics_test.dart`) either
    // pass `false` in `initialPrefs` or flip it via
    // `PrefManager.setFeatureFlagHomeAnalytics(false)` after `build()`.
    // Explicit caller-provided values in `initialPrefs` win.
    final prefsSeed = <String, Object>{
      StorageKeys.featureFlagHomeAnalytics: true,
      ...initialPrefs,
    };
    SharedPreferences.setMockInitialValues(prefsSeed);
    final sharedPrefs = await SharedPreferences.getInstance();

    PackageInfo.setMockInitialValues(
      appName: 'hs_app_flutter',
      packageName: 'in.hopscotch.android',
      version: appVersion,
      buildNumber: buildNumber,
      buildSignature: '',
    );
    final packageInfo = await PackageInfo.fromPlatform();

    final prefs = PrefManager(sharedPrefs);
    final service = MockAnalyticsService();
    final launchTimer = LaunchTimer();
    final cartTimer = CartTimer();
    final checkoutTimer = CheckoutTimer();
    final experiments = ExperimentsUtil(prefs);
    final orderAttribution = OrderAttributionHelper();
    final lpAttribution = LpAttributionHelper();
    final productAttribution = ProductAttributionHelper();
    final utm = UtmHeaderUtil(prefs);
    // Empty stack by default → contributes no `nav_screen_*` keys. Tests that
    // want nav stamping fire `observer.didPush(...)` manually.
    final navObserver = AppNavigationObserver(
      orderAttribution,
      lpAttribution,
      productAttribution,
      launchTimer,
      cartTimer,
    );

    // `AppNavigationObserver._homeTrack` uses `sl<HomeTrackAnalyticManager>()`
    // (lazy lookup, breaks the DI cycle). Register a real instance backed by
    // the harness collaborators so observer callbacks (flushCarouselScrolls,
    // extraData setter, resetVisibilityState, clearLpAttribution) don't
    // throw in tests that drive didPush/didPop.
    if (sl.isRegistered<HomeTrackAnalyticManager>()) {
      await sl.unregister<HomeTrackAnalyticManager>();
    }
    if (sl.isRegistered<JourneyWorker>()) {
      await sl.unregister<JourneyWorker>();
    }
    final analyticsForTrack = AnalyticsHelper(
      service,
      prefs,
      packageInfo,
      MockDeviceInfoPlugin(),
      launchTimer,
      checkoutTimer,
      experiments,
      orderAttribution,
      lpAttribution,
      productAttribution,
      utm,
      navObserver,
    );
    // InlineJourneyWorker routes through the harness AnalyticsHelper,
    // which lands captured events on `MockAnalyticsService.track`.
    // Isolate-backed production impl would need a RootIsolateToken and
    // a real Segment SDK — neither exists in a unit-test host.
    sl.registerLazySingleton<JourneyWorker>(
      () => JourneyWorker(analyticsForTrack),
    );
    sl.registerLazySingleton<HomeTrackAnalyticManager>(
      () => HomeTrackAnalyticManager(
        analytics: analyticsForTrack,
        orderAttribution: orderAttribution,
        lpAttribution: lpAttribution,
        prefs: prefs,
        journeyWorker: sl<JourneyWorker>(),
      ),
    );

    final captured = <CapturedEvent>[];
    final identifies = <CapturedIdentify>[];
    final timeline = <String>[];
    when(() => service.track(any(), any())).thenAnswer((invocation) async {
      final name = invocation.positionalArguments[0] as String;
      final props = Map<String, Object?>.of(
        invocation.positionalArguments[1] as Map<String, Object?>,
      );
      captured.add(CapturedEvent(name, props));
      timeline.add('track:$name');
    });
    when(
      () => service.identify(
        userId: any(named: 'userId'),
        traits: any(named: 'traits'),
      ),
    ).thenAnswer((invocation) async {
      identifies.add(
        CapturedIdentify(
          invocation.namedArguments[const Symbol('userId')] as String?,
          Map<String, Object?>.of(
            invocation.namedArguments[const Symbol('traits')]
                as Map<String, Object?>,
          ),
        ),
      );
      timeline.add('identify');
    });
    when(service.reset).thenAnswer((_) async {
      timeline.add('reset');
    });
    when(() => service.appsFlyerUid).thenReturn('');
    when(() => service.cleverTapId).thenReturn('');

    final analytics = AnalyticsHelper(
      service,
      prefs,
      packageInfo,
      MockDeviceInfoPlugin(),
      launchTimer,
      checkoutTimer,
      experiments,
      orderAttribution,
      lpAttribution,
      productAttribution,
      utm,
      navObserver,
    );

    return AnalyticsTestHarness._(
      service: service,
      prefs: prefs,
      analytics: analytics,
      launchTimer: launchTimer,
      cartTimer: cartTimer,
      checkoutTimer: checkoutTimer,
      utm: utm,
      orderAttribution: orderAttribution,
      lpAttribution: lpAttribution,
      productAttribution: productAttribution,
      experiments: experiments,
      captured: captured,
      identifies: identifies,
      timeline: timeline,
      navObserver: navObserver,
    );
  }

  /// Restore the global platform override.
  void tearDown() {
    debugDefaultTargetPlatformOverride = null;
  }

  /// All events with this name, in fire order.
  List<Map<String, Object?>> eventsNamed(String eventName) => [
        for (final e in captured)
          if (e.name == eventName) e.props,
      ];

  /// The single event with this name, or throws if 0 or >1 matched.
  Map<String, Object?> singleEvent(String eventName) {
    final matches = eventsNamed(eventName);
    if (matches.length != 1) {
      fail('expected exactly one "$eventName"; got ${matches.length}. '
          'All events: ${captured.map((e) => e.name).toList()}');
    }
    return matches.single;
  }

  bool hasEvent(String eventName) => captured.any((e) => e.name == eventName);

  void clear() {
    captured.clear();
    identifies.clear();
    timeline.clear();
  }
}

class CapturedEvent {
  CapturedEvent(this.name, this.props);
  final String name;
  final Map<String, Object?> props;
}

class CapturedIdentify {
  CapturedIdentify(this.userId, this.traits);
  final String? userId;
  final Map<String, Object?> traits;
}

class CapturedIdentify {
  CapturedIdentify(this.userId, this.traits);
  final String? userId;
  final Map<String, Object?> traits;
}
