import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/features/pdp/data/models/product_detail_model.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/offer_entity.dart';
import 'package:hs_app_flutter/core/analytics/pdp/pdp_analytics_tracker.dart';
import 'package:hs_app_flutter/features/pdp/presentation/widgets/pdp_offers.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../support/analytics_test_harness.dart';

/// `coupon_code_scrolled` must fire **only for a real finger drag**, and **at
/// most once per PDP view** — both gates copied from Android's `PromoView`
/// (`hspdp/.../ui/views/PromoView.kt:90-101`):
///
/// ```kotlin
/// if (newState == RecyclerView.SCROLL_STATE_DRAGGING) {   // never programmatic
///     isUserScrolling = true
///     if (!eventTriggered) {                              // never reset
///         viewModel.pdpAnalytics.sendEventCouponCodeScrolled()
///         eventTriggered = true
///     }
/// ```
///
/// The offers carousel auto-advances every two seconds. Before these gates
/// existed the event hung off a bare `ScrollController` listener that only
/// asked whether the snapped index had changed, so every auto-advance sent one
/// — roughly 30 a minute, indefinitely, while the user did nothing, against
/// Android's ceiling of one per view.
void main() {
  late AnalyticsTestHarness h;
  late PdpAnalyticsTracker tracker;

  const offers = [
    OfferEntity(couponCode: 'TEN', header: 'Flat 10% off', description: 'a'),
    OfferEntity(couponCode: 'TWENTY', header: 'Flat 20% off', description: 'b'),
    OfferEntity(couponCode: 'THIRTY', header: 'Flat 30% off', description: 'c'),
  ];

  /// Matches `_autoScrollInterval` + `_advanceDuration` in `pdp_offers.dart`.
  const tick = Duration(seconds: 2);
  const settle = Duration(milliseconds: 500);

  setUp(() async {
    // `PdpOffers` wraps itself in a `VisibilityDetector` (`pdp_offers.dart:284`)
    // to pause auto-scroll off screen. That schedules a 500 ms debounce timer
    // during paint, which is still pending when the test body ends — and
    // `testWidgets` fails on a pending timer, reporting it against whichever
    // test painted first rather than against the cause. Zero makes visibility
    // callbacks synchronous, so no timer is created and the assertions are
    // deterministic instead of depending on how much fake time elapsed.
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
    h = await AnalyticsTestHarness.build();
    tracker = PdpAnalyticsTracker(h.analytics);
    // Without a loaded product the tracker drops every event, which would make
    // the "no event" assertions below pass for the wrong reason.
    tracker.onProductLoaded(
      ProductDetailModel.fromJson(
        jsonDecode(
              File(
                'test/analytics/fixtures/pdp_product_945499.json',
              ).readAsStringSync(),
            )
            as Map<String, dynamic>,
      ).toEntity(),
    );
    h.clear();
  });
  tearDown(() => h.tearDown());

  int scrolls() => h.eventsNamed(AnalyticsEvents.couponCodeScrolled).length;

  double offset(WidgetTester tester) =>
      tester.widget<ListView>(find.byType(ListView)).controller!.position.pixels;

  Future<void> mount(WidgetTester tester) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: RepositoryProvider<PdpAnalyticsTracker>.value(
          value: tracker,
          child: const PdpOffers(offers: offers),
        ),
      ),
    ),
  );

  /// Ends the test cleanly. Two things must happen inside the test *body*:
  ///
  /// * unmount, so `dispose()` cancels the periodic auto-scroll timer —
  ///   otherwise the test ends with a pending timer;
  /// * clear `debugDefaultTargetPlatformOverride`, which
  ///   `AnalyticsTestHarness.build()` sets and its `tearDown()` clears.
  ///   `testWidgets` asserts every foundation debug variable is unset when the
  ///   body returns, which is *before* `tearDown` runs — so leaving it to the
  ///   harness fails the test. Plain `test()` has no such check, which is why
  ///   the other analytics tests never hit this.
  Future<void> finish(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    debugDefaultTargetPlatformOverride = null;
  }

  testWidgets('auto-scroll moves the carousel but fires nothing', (
    tester,
  ) async {
    await mount(tester);
    expect(offset(tester), 0);

    // Five auto-advances — the old behaviour sent one event per advance.
    // Track the peak rather than the final offset: `_advance()` wraps back to
    // the first card at the end (matching Android), so the carousel is legally
    // at 0 again on some iterations.
    var peak = 0.0;
    for (var i = 0; i < 5; i++) {
      await tester.pump(tick);
      await tester.pump(settle);
      peak = peak > offset(tester) ? peak : offset(tester);
    }

    expect(
      peak,
      greaterThan(0),
      reason:
          'the carousel must genuinely have advanced, or the assertion below '
          'passes for the wrong reason',
    );
    expect(
      scrolls(),
      0,
      reason:
          'auto-scroll is programmatic; Android never enters SCROLL_STATE_'
          'DRAGGING for it, so no coupon_code_scrolled is sent',
    );

    await finish(tester);
  });

  testWidgets('a finger drag fires it exactly once', (tester) async {
    await mount(tester);
    await tester.drag(find.byType(ListView), const Offset(-300, 0));
    await tester.pump();

    expect(scrolls(), 1);
    await finish(tester);
  });

  testWidgets('later drags do not fire again — Android latches eventTriggered', (
    tester,
  ) async {
    await mount(tester);
    for (var i = 0; i < 3; i++) {
      await tester.drag(find.byType(ListView), const Offset(-300, 0));
      await tester.pump(settle);
    }

    expect(
      scrolls(),
      1,
      reason:
          'PromoView.kt:91 sets eventTriggered on the first drag and never '
          'resets it, so a view sends at most one',
    );
    await finish(tester);
  });

  testWidgets('auto-scroll resuming after a drag adds nothing', (tester) async {
    // The two gates have to hold together: the drag consumes the single event,
    // and the auto-scroll that resumes ~3s later must not send more.
    await mount(tester);
    await tester.drag(find.byType(ListView), const Offset(-300, 0));
    await tester.pump();
    expect(scrolls(), 1);

    for (var i = 0; i < 4; i++) {
      await tester.pump(tick);
      await tester.pump(settle);
    }

    expect(scrolls(), 1);
    await finish(tester);
  });
}
