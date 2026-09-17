import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/pdp_events.dart';
import 'package:hs_app_flutter/features/pdp/data/models/product_detail_model.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/pdp_entry_args.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/tile_entity.dart';
import 'package:hs_app_flutter/features/plp/domain/entities/listing_product_entity.dart';

import '../../support/analytics_test_harness.dart';

/// What the passthrough must do with whatever shape the backend sends.
///
/// The app reads **one** shape now: a `trackingMeta` node, forwarded whole. There
/// is no rename bridge, no accepted-spellings list and no per-event key scoping —
/// those existed while the client still owned wire names, and each was a place a
/// backend change could silently fail to reach Segment.
///
/// So the properties worth pinning changed. Not "is this alias accepted", but:
/// does a node arrive intact, with its JSON types, on every event that chains it,
/// without the app inventing or dropping anything?
///
/// Contract: `docs/analytics/pdp/contract/passthrough-spec.md`.
void main() {
  late Map<String, dynamic> template;

  setUpAll(() {
    template =
        jsonDecode(
              File(
                'test/analytics/fixtures/pdp_product_945499.json',
              ).readAsStringSync(),
            )
            as Map<String, dynamic>;
  });

  Map<String, dynamic> rawWith(Map<String, dynamic> meta) {
    final raw = jsonDecode(jsonEncode(template)) as Map<String, dynamic>;
    (raw['product'] as Map<String, dynamic>)['trackingMeta'] = meta;
    return raw;
  }

  /// `product_viewed` with `product.trackingMeta` replaced by [meta].
  Future<Map<String, Object?>> emit(Map<String, dynamic> meta) async {
    final harness = await AnalyticsTestHarness.build();
    final entity = ProductDetailModel.fromJson(rawWith(meta)).toEntity();
    await harness.analytics.logProductViewed(
      product: entity.product!,
      entry: const PdpEntryArgs(),
    );
    final props = harness.captured.single.props;
    harness.tearDown();
    return props;
  }

  group('a node is forwarded whole', () {
    test('a key nobody has declared still reaches the wire', () async {
      final props = await emit({
        'product_id': '945499',
        'a_dimension_added_next_quarter': 'yes',
      });
      expect(props['a_dimension_added_next_quarter'], 'yes');
    });

    test('JSON types survive — no coercion anywhere', () async {
      final props = await emit({
        'product_id': '945499',
        'from_age': 36,
        'mrp': 449.0,
        'sale': 'No',
        'in_stock': true,
        'sku': const ['a', 'b'],
        'nested': const {'k': 'v'},
      });
      expect(props['from_age'], isA<int>());
      expect(props['mrp'], isA<double>());
      expect(props['sale'], isA<String>());
      expect(props['in_stock'], isA<bool>());
      expect(props['sku'], isA<List<dynamic>>());
      // Restricting the channel to scalars would silently drop a future
      // `promo_tags: [...]` and need an app release — the one thing this design
      // exists to avoid.
      expect(props['nested'], isA<Map<dynamic, dynamic>>());
    });

    test('zero is a value, not an absence', () async {
      final props = await emit({
        'product_id': '945499',
        'discount_percentage': 0,
        'from_age': 0,
      });
      expect(props['discount_percentage'], 0);
      expect(props['from_age'], 0);
    });

    test('nulls and empties are forwarded, not dropped', () async {
      // The channel filters nothing: a node reaches the wire as sent. Not sending
      // a null or an empty is the backend's job, not the client's.
      final props = await emit({
        'product_id': '945499',
        'nothing': null,
        'blank': '',
        'no_items': const <String>[],
      });
      expect(props.containsKey('nothing'), isTrue);
      expect(props['nothing'], isNull);
      expect(props['blank'], '');
      expect(props['no_items'], const <String>[]);
    });

    test('an empty node emits only what the app itself owns', () async {
      final props = await emit(const {});
      expect(props.containsKey('product_id'), isFalse);
      // Attribution properties still ride along.
      expect(props.keys, isNotEmpty);
    });
  });

  group('the product node rides every event, not just product_viewed', () {
    // The old channel was scoped to product_viewed, so a backend dimension only
    // ever described the page view. Now the node is on all 23 events.
    test('a new key reaches a tap event too', () async {
      final harness = await AnalyticsTestHarness.build();
      final entity = ProductDetailModel.fromJson(
        rawWith({'product_id': '945499', 'new_dimension': 'x'}),
      ).toEntity();
      await harness.analytics.logProductShareClicked(entity.product!);
      expect(harness.captured.single.props['new_dimension'], 'x');
      harness.tearDown();
    });
  });

  group('interaction facts win over the node', () {
    // Interaction merges last, which is what removed the need to hold app-owned
    // keys back by name. `from_location` stands in: it is computed from which UI
    // surface was tapped, so no node can answer it.
    test('a server key cannot overwrite an app-computed one', () async {
      final harness = await AnalyticsTestHarness.build();
      final entity = ProductDetailModel.fromJson(
        rawWith({'product_id': '945499', 'from_location': 'server-lied'}),
      ).toEntity();
      await harness.analytics.logSizeSelected(
        product: entity.product!,
        sku: entity.product!.skus.first,
        fromLocation: 'Size list upfront',
      );
      expect(
        harness.captured.single.props['from_location'],
        'Size list upfront',
      );
      harness.tearDown();
    });
  });

  group('rail tiles carry the click block on the tile node', () {
    test('the prefixed keys come from the tile, not its product', () async {
      final harness = await AnalyticsTestHarness.build();
      final entity = ProductDetailModel.fromJson(
        jsonDecode(jsonEncode(template)) as Map<String, dynamic>,
      ).toEntity();
      await harness.analytics.logRecoProductClicked(
        product: entity.product!,
        tile: const TileEntity(
          product: ListingProductEntity(id: 943726, name: 'x'),
          trackingMeta: {
            'clicked_product_pid': '943726',
            'clicked_product_type': 'Pant set',
          },
        ),
      );
      final props = harness.captured.single.props;
      expect(props['clicked_product_pid'], '943726');
      expect(props['clicked_product_type'], 'Pant set');
      // The source PDP survives — merging the tile's own product block would
      // have overwritten this.
      expect(props['product_id'], '945499');
      harness.tearDown();
    });

    test(
      'a tile with no node contributes nothing and does not crash',
      () async {
        final harness = await AnalyticsTestHarness.build();
        final entity = ProductDetailModel.fromJson(
          jsonDecode(jsonEncode(template)) as Map<String, dynamic>,
        ).toEntity();
        await harness.analytics.logRecentlyViewedProductsClicked(
          product: entity.product!,
          tile: const TileEntity(
            product: ListingProductEntity(id: 1, name: 'x'),
          ),
        );
        final props = harness.captured.single.props;
        expect(props.containsKey('clicked_product_pid'), isFalse);
        expect(props['product_id'], '945499');
        expect(
          harness.captured.single.name,
          AnalyticsEvents.recentlyViewedProductsClicked,
        );
        harness.tearDown();
      },
    );
  });
}
