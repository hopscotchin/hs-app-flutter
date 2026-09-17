import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/pdp_events.dart';
import 'package:hs_app_flutter/features/pdp/data/models/product_detail_model.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/pdp_entry_args.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/product_detail_entity.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/listing_product_entity.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/wishlist_events.dart';

import '../../support/analytics_test_harness.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/tile_entity.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/color_variants_entity.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/detail_entity.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/offer_entity.dart';
import '../support/node_fixtures.dart';

/// Snapshots the **exact wire format** of every PDP event — key, type and value —
/// against a checked-in golden file.
///
/// Two jobs:
///
/// 1. **Regression gate.** Any change to a key name, a value or a *type* fails
///    here. Type is captured deliberately: `product_id` as an int instead of a
///    String, or `price` as a double instead of an int, are silent
///    dashboard-splitting bugs that no other test would catch.
///
/// 2. **The artifact for the Android diff.** Phase 7 of the port requires
///    comparing Flutter's payload to Android's for the same PID. The golden is
///    that comparison's left-hand side, already normalised — so QA diffs Segment
///    output against a file instead of re-deriving expectations.
///
/// To regenerate after an intentional change:
/// ```
/// UPDATE_PDP_GOLDEN=1 flutter test test/analytics/pdp/pdp_wire_format_golden_test.dart
/// ```
/// Then **read the diff** before committing it. A golden that is updated without
/// being read is worse than no golden.
const _goldenPath = 'test/analytics/fixtures/pdp_wire_format.golden.json';

/// Keys that legitimately vary per run and would make the golden unstable.
/// Their presence is asserted separately below, so dropping them here does not
/// weaken the check.
const _volatileKeys = <String>{
  'timestamp',
  '[time] hour_of_day',
  '[time] day_of_week',
  '[time] day_of_month',
  '[time] month_of_year',
  '[time] week_of_year',
  'nav_screens',
};

/// Renders a value as `<Type> <value>` so the golden captures both. Type drift is
/// the failure mode this file exists to catch.
String _typed(Object? value) {
  if (value == null) return 'null';
  final type = switch (value) {
    int() => 'int',
    double() => 'double',
    bool() => 'bool',
    String() => 'String',
    List() => 'List<${value.isEmpty ? 'dynamic' : value.first.runtimeType}>',
    _ => value.runtimeType.toString(),
  };
  return '$type $value';
}

ProductDetailEntity _fixture(String name) {
  final raw = File('test/analytics/fixtures/$name').readAsStringSync();
  return ProductDetailModel.fromJson(jsonDecode(raw) as Map<String, dynamic>).toEntity();
}

void main() {
  late AnalyticsTestHarness h;
  late ProductDetailEntity flat;

  // Fixed entry context so the golden is deterministic. The retired fields
  // (`position`, `sourceTileType`, `tabPage`) are gone — any wire value now
  // comes from a chained backend node, not the client.
  const entry = PdpEntryArgs(
    fromScreen: FromScreens.plp,
    fromPage: FromPage.recommendation,
    fromFeedSize: 40,
  );

  const clicked = ListingProductEntity(
    id: 943726,
    name: 'Multi D-Stripes lace Top And Short Set',
    trackingMeta: {
      'category_name': 'Apparel - Children',
      'subcategory_name': 'Sets',
      'product_type_name': 'Pant set',
    },
  );

  setUp(() async {
    h = await AnalyticsTestHarness.build();
    flat = _fixture('pdp_product_945499.json');
  });
  tearDown(() => h.tearDown());

  /// Fires every in-scope PDP event once, in a fixed order.
  Future<void> fireAll() async {
    final p = flat.product!;
    final a = h.analytics;
    await a.logProductViewed(product: p, entry: entry, offersTrackingMeta: flat.offersTrackingMeta);
    await a.logPdpImagesScrolled(product: p, uniqueImagesScrolled: 2);
    await a.logProductShareClicked(p);
    await a.logSizeSelected(
      product: p,
      fromLocation: FromLocations.sizeListUpfront,
      sku: p.skus[1],
    );
    await a.logSizeChartClicked(p);
    await a.logProductDetailsExpanded(p);
    await a.logProductDetailsCollapsed(p);
    await a.logProductDetailsTabClicked(
      product: p,
      tab: const DetailEntity(
        tabName: 'Specification',
        trackingMeta: {'tab_name': 'Specification'},
      ),
    );
    await a.logPincodeFormOpened(p);
    await a.logPincodeChange(product: p, serviceable: true);
    await a.logCouponCodeClicked(
      product: p,
      callToAction: AnalyticsDefaults.couponCodeCopied,
      offer: const OfferEntity(couponCode: 'TEST450', trackingMeta: {'coupon_code': 'TEST450'}),
    );
    await a.logCouponCodeScrolled(product: p);
    await a.logRecentlyViewedProductsLoaded(product: p, railTrackingMeta: const {'feed_size': 6});
    await a.logRecentlyViewedProductsScrolled(
      product: p,
      scrollDepth: 4,
      railTrackingMeta: const {'feed_size': 6},
    );
    await a.logRecentlyViewedProductsClicked(
      product: p,
      tile: TileEntity(product: clicked, trackingMeta: tileClickMeta(clicked)),
    );
    await a.logRecoViewed(product: p, railTrackingMeta: const {'feed_size': 10});
    await a.logRecoProductClicked(
      product: p,
      tile: TileEntity(product: clicked, trackingMeta: tileClickMeta(clicked)),
    );
    await a.logNewColorSelected(
      product: p,
      variant: const ColorVariantEntity(
        productId: 906575,
        trackingMeta: {'new_product_id_selected': '906575'},
      ),
    );
    await a.logProductAddedToCart(product: p, entry: entry, selectedSku: p.skus.first);
    await a.logBuyNowClicked(
      product: p,
      // Buy Now now chains the sku node — Android sends no size or sku on it at
      // all, which the spec records as a deliberate widening.
      selectedSku: p.skus.first,
    );
    // Through the shared module, the same way the PDP emits it. Kept in the golden
    // because the wire format of a PDP-originated wishlist is exactly what this file
    // exists to pin — and now that the block is forwarded rather than mapped, the
    // golden is the only thing that shows which keys each event ends up with.
    for (final fire in [a.logProductAddedToWishlist, a.logProductRemovedFromWishlist]) {
      await fire(
        productId: '${p.id}',
        fromScreen: FromScreens.product,
        trackingMeta: p.trackingMeta,
        skuTrackingMeta: p.skus[1].trackingMeta,
      );
    }
  }

  test('every PDP event matches the golden wire format', () async {
    await fireAll();

    final actual = <String, Map<String, String>>{};
    for (final captured in h.captured) {
      final props = <String, String>{};
      for (final entry in captured.props.entries) {
        if (_volatileKeys.contains(entry.key)) continue;
        props[entry.key] = _typed(entry.value);
      }
      // Sorted so the golden is stable and diffs read cleanly.
      actual[captured.name] = Map.fromEntries(
        props.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
      );
    }

    const encoder = JsonEncoder.withIndent('  ');
    final rendered = encoder.convert(
      Map.fromEntries(actual.entries.toList()..sort((a, b) => a.key.compareTo(b.key))),
    );

    final golden = File(_goldenPath);
    if (Platform.environment['UPDATE_PDP_GOLDEN'] == '1') {
      golden.writeAsStringSync('$rendered\n');
      // ignore: avoid_print
      print('golden rewritten: $_goldenPath');
      return;
    }

    expect(
      golden.existsSync(),
      isTrue,
      reason:
          'Golden missing. Generate it with '
          'UPDATE_PDP_GOLDEN=1 flutter test $_goldenPath',
    );
    expect(
      rendered,
      golden.readAsStringSync().trimRight(),
      reason:
          'PDP wire format changed. If intentional, regenerate with '
          'UPDATE_PDP_GOLDEN=1 and READ the diff — a key, value or type change '
          'here is a dashboard change.',
    );
  });

  test('fires exactly the 22 in-scope events, each once', () async {
    // The 22 include `product_removed_from_wishlist`, which is new on the PDP:
    // Android's `hspdp` module never emitted it, though the old PDP did
    // (ProductDetailPageActivityNew.java:4966).
    await fireAll();
    final names = h.captured.map((e) => e.name).toList();
    expect(names, hasLength(22));
    expect(names.toSet().length, 22, reason: 'an event fired twice: $names');
  });

  test('volatile keys are present on every event (excluded from the golden)', () async {
    await fireAll();
    for (final captured in h.captured) {
      expect(
        captured.props.keys,
        containsAll(<String>['timestamp', '[time] hour_of_day']),
        reason: '${captured.name} lost its enrichment keys',
      );
    }
  });

  test('no event ships a null-valued property', () async {
    await fireAll();
    for (final captured in h.captured) {
      final nulls = captured.props.entries.where((e) => e.value == null).map((e) => e.key).toList();
      expect(nulls, isEmpty, reason: '${captured.name} has null-valued keys: $nulls');
    }
  });
}
