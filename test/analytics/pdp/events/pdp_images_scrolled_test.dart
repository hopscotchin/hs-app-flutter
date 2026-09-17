import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/pdp_events.dart';

import '../support/pdp_event_case.dart';

/// `pdp_images_scrolled` — fired on route exit, not per swipe.
///
/// The count is of DISTINCT pages the carousel settled on, which excludes the
/// initial page because no scroll settles on it. The `+ 1` adds it back, so the
/// emitted value is total distinct images viewed — compensation, not an
/// off-by-one.
void main() {
  late PdpEventCase c;

  setUp(() async => c = await PdpEventCase.build());
  tearDown(() => c.tearDown());

  test('fires once, carrying the product node', () async {
    await c.h.analytics.logPdpImagesScrolled(product: c.product, uniqueImagesScrolled: 2);
    expectProductNode(c.single(AnalyticsEvents.pdpImagesScrolled));
  });

  test('adds only unique_images_scrolled', () async {
    await c.h.analytics.logPdpImagesScrolled(product: c.product, uniqueImagesScrolled: 2);
    expectAddsExactly(
        c.single(AnalyticsEvents.pdpImagesScrolled), const {'unique_images_scrolled'});
  });

  test('reports the count plus the initial image', () async {
    await c.h.analytics.logPdpImagesScrolled(product: c.product, uniqueImagesScrolled: 2);
    expect(c.single(AnalyticsEvents.pdpImagesScrolled)['unique_images_scrolled'], 3);
  });

  test('a zero-scroll caller still gets the initial image counted', () async {
    await c.h.analytics.logPdpImagesScrolled(product: c.product, uniqueImagesScrolled: 0);
    expect(c.single(AnalyticsEvents.pdpImagesScrolled)['unique_images_scrolled'], 1,
        reason: 'the > 1 gate that suppresses a never-swiped visitor belongs to '
            'the caller, not to this builder');
  });
}
