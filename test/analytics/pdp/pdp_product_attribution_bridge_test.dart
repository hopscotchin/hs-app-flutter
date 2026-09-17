import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/pdp_events.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/plp_events.dart';
import 'package:hs_app_flutter/core/constants/route_names.dart';
import 'package:hs_app_flutter/features/pdp/data/models/product_detail_model.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/pdp_entry_args.dart';

import '../support/analytics_test_harness.dart';

/// End-to-end proof that a PLP tile tap's `productAttribution` push lands on
/// the PDP events the destination fires. If this fails, the "not merging"
/// symptom is here — bisect the failing key against `_commonEventProperties`.
void main() {
  Route<void> _page(String name) => MaterialPageRoute<void>(
        settings: RouteSettings(name: name),
        builder: (_) => const SizedBox(),
      );

  test('PLP push → PDP product_viewed carries the top entry', () async {
    final h = await AnalyticsTestHarness.build();
    addTearDown(h.tearDown);

    // 1. User navigates HP → PLP. Observer opens the plp scope.
    h.navObserver.didPush(_page(RouteNames.plpName), null);
    expect(h.productAttribution.entries, isEmpty,
        reason: 'sanity: scope open but no push yet');

    // 2. User taps a tile. Push the PLP's page-level + product's tile blob.
    h.analytics.logPlpTileClicked(
      trackingMeta: const <String, dynamic>{
        'source_tile_type': 'normal',
        'position': 3,
      },
      pageMeta: const <String, dynamic>{
        'plp': 'P12038',
        'redirected_from_cluster_eligible_plp': 'No',
      },
    );
    expect(h.productAttribution.entries, hasLength(1),
        reason: 'scope was open, so push must land');

    // 3. Nav to PDP.
    h.navObserver.didPush(_page(RouteNames.pdpName), _page(RouteNames.plpName));

    // 4. PDP fires product_viewed with its own product node. Load a fixture
    //    so the payload includes real product keys, then check that the
    //    productAttribution top spread onto the wire alongside them.
    final detail = ProductDetailModel.fromJson(
      jsonDecode(
        File('test/analytics/fixtures/pdp_product_945499.json').readAsStringSync(),
      ) as Map<String, dynamic>,
    ).toEntity();

    await h.analytics.logProductViewed(
      product: detail.product!,
      entry: const PdpEntryArgs(),
    );

    final e = h.singleEvent(AnalyticsEvents.productViewed);
    // Keys unique to the PLP click (no collision with the PDP product node)
    // must survive `_commonEventProperties → properties` overlay.
    expect(e['plp'], 'P12038');
    expect(e['redirected_from_cluster_eligible_plp'], 'No');
    expect(e['source_tile_type'], 'normal');
    expect(e['position'], 3);
  });
}
