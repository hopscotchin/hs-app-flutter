import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_defaults.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_events.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/wishlist_events.dart';

import '../support/analytics_test_harness.dart';

/// The wishlist events forward the backend's block and nothing else.
///
/// **This file imports no feature entities**, which is the point: the events take a
/// `Map`, so there is no per-surface mapper to test and no shape for a surface to get
/// wrong. What is left to pin is that values arrive unchanged, that app-owned keys
/// cannot be overwritten from the server, and what the resulting wire shape actually
/// is — because with nothing declared client-side, the tests and the golden are the
/// only place the shape is written down.
void main() {
  late AnalyticsTestHarness h;

  setUp(() async => h = await AnalyticsTestHarness.build());
  tearDown(() => h.tearDown());

  /// A recently-viewed tile's block, copied from a live `GET /api/v3/product/945499`
  /// response. Real rather than invented, because the naming and types here are
  /// exactly what the assertions below are about — in particular `category_name` and
  /// `on_sale`, which the product block calls `category` and `sale`.
  const tileBlock = <String, dynamic>{
    'widgetPosition': 0,
    'product_id': '931204',
    'category_name': 'Apparel - Children',
    'subcategory_name': 'Sets',
    'product_type_name': 'Short set',
    'subproduct_type_name': 'aman123456891',
    'product_name': 'Orange Baby Polo Half Sleeve Printed T-Shirt Set 1',
    'brand_name': '1st Care',
    'gender': "Boy's",
    'from_age': 12,
    'to_age': 36,
    'price': 449,
    'mrp': 499.0,
    'discount_percentage': 10.0,
    'image_url': 'https://q/z_full.jpg',
    'sku': 'FCA-2998686',
    'on_sale': 'No',
    'pre_order': 'No',
    'merch_type': 'Catalog',
    'available_quantity': 1,
    'low_inventory': 'Yes',
  };

  /// The product block (§1) of the same response — different spellings for the same
  /// dimensions.
  const productBlock = <String, dynamic>{
    'product_id': '945499',
    'name': 'Pink All Over Sleeveless Top',
    'category': 'Apparel - Children',
    'subcategory': 'Sets',
    'brand': 'Whaou',
    'gender': "Girl's",
    'price': 349,
    'mrp': 449.0,
    'on_sale': 'No',
  };

  Future<Map<String, Object?>> add({
    Map<String, dynamic>? meta = tileBlock,
    Map<String, dynamic>? skuMeta,
    String? fromLocation,
    String? sourceTileType = 'xl',
  }) async {
    await h.analytics.logProductAddedToWishlist(
      productId: '904219',
      fromScreen: FromScreens.product,
      trackingMeta: meta,
      skuTrackingMeta: skuMeta,
      sourceTileType: sourceTileType,
      fromLocation: fromLocation ?? FromLocations.wishlistButton,
    );
    final props = h.captured.single.props;
    h.clear();
    return props;
  }

  Future<Map<String, Object?>> remove({
    Map<String, dynamic>? meta = tileBlock,
    Map<String, dynamic>? skuMeta,
  }) async {
    await h.analytics.logProductRemovedFromWishlist(
      productId: '904219',
      fromScreen: FromScreens.product,
      trackingMeta: meta,
      skuTrackingMeta: skuMeta,
    );
    final props = h.captured.single.props;
    h.clear();
    return props;
  }

  group('the block reaches the wire verbatim', () {
    test('every key arrives under the name the backend used', () async {
      // `product_id` excepted: the call site owns the event's identity, so the block's
      // copy is skipped rather than merged. Its precedence is asserted below.
      final e = await add();
      for (final entry in tileBlock.entries) {
        if (entry.key == 'product_id') continue;
        expect(
          e[entry.key],
          entry.value,
          reason: '`${entry.key}` was renamed, converted or dropped',
        );
      }
      expect(e.length, greaterThan(tileBlock.length));
    });

    test('types survive — price int, mrp and discount double', () async {
      // Android's `Price` does not type them alike, verified in live captures.
      // Anything that re-parsed or normalised these would split the metric.
      final e = await add();
      expect(e['price'], isA<int>());
      expect(e['mrp'], isA<double>());
      expect(e['discount_percentage'], isA<double>());
      expect(e['available_quantity'], isA<int>());
    });

    test('no Yes/No round trip — a third value would survive', () async {
      // Typing these as bools would collapse any value other than "Yes" into "No"
      // with nothing to flag it. Forwarding cannot lose a value.
      final e = await add(
        meta: {...tileBlock, 'on_sale': 'Partially', 'pre_order': 'Maybe'},
      );
      expect(e['on_sale'], 'Partially');
      expect(e['pre_order'], 'Maybe');
    });

    test('a brand-new key needs no app release', () async {
      final e = await add(meta: {...tileBlock, 'merch_tier': 'core'});
      expect(e['merch_tier'], 'core');
    });

    test('casing is not filtered', () async {
      // `widgetPosition` is in the live block, so this is not hypothetical.
      final e = await add(meta: {...tileBlock, 'someNewField': 'x'});
      expect(e['widgetPosition'], 0);
      expect(e['someNewField'], 'x');
    });

    test('lists and maps are forwarded, not dropped', () async {
      final e = await add(
        meta: {
          ...tileBlock,
          'promo_tags': ['a', 'b'],
          'nested': {'k': 'v'},
        },
      );
      expect(e['promo_tags'], ['a', 'b']);
      expect(e['nested'], {'k': 'v'});
    });
  });

  group('what the app owns, the server cannot overwrite', () {
    test('a same-named server key loses to the computed value', () async {
      // The guard is the merge ORDER, not a name list: the blocks are chained
      // first and the app's journey facts merge last, so a server key cannot
      // replace real journey state. Same contract as `buildAnalyticsPayload`
      // on PDP.
      await h.prefs.setAtcUserType('repeat');
      final e = await add(
        meta: {
          ...tileBlock,
          'from_screen': 'HIJACKED',
          'from_location': 'HIJACKED',
          'product_id': 'HIJACKED',
          'source_tile_type': 'HIJACKED',
          'atc_user': 'HIJACKED',
          'from_collection': true,
        },
      );
      expect(e['from_screen'], FromScreens.product);
      expect(e['from_location'], FromLocations.wishlistButton);
      expect(e['product_id'], '904219');
      expect(e['source_tile_type'], 'xl');
      expect(e['from_collection'], isFalse);
      expect(e['atc_user'], 'repeat');
    });

    test('the order guards a key only while the app HAS a value', () async {
      // The honest limit of an order-based guard, and the same on PDP (a null
      // `add_from_details` drops the key, so a node of that name would survive).
      // `putAnalyticsKey` writes nothing for an unset pref, so there is no app
      // value to win. BE does not send `atc_user` in any block — if it ever
      // does, this is the shape that would carry it.
      final e = await add(meta: {...tileBlock, 'atc_user': 'FROM SERVER'});
      expect(e['atc_user'], 'FROM SERVER');
    });

    test('product_id is a STRING and comes from the call site', () async {
      // `904219` and `"904219"` are two Amplitude values. Android's PDP coerces its
      // int id, so the String is the contract — and it is guaranteed here rather
      // than left to whether the block happens to carry it.
      expect((await add())['product_id'], '904219');
      expect((await add(meta: null))['product_id'], '904219');
    });

    test('from_collection reaches the wire as boolean false', () async {
      // Android hardcodes `false` (`PLPAnalytics.kt:465`). Booleans are never
      // dropped, unlike a numeric 0 — so this one does arrive.
      expect((await add())['from_collection'], isFalse);
    });

    test(
      'atc_user is read from prefs, matching PrefUtils.aTCUserType',
      () async {
        await h.prefs.setAtcUserType('repeat');
        expect((await add())['atc_user'], 'repeat');
      },
    );

    test(
      'source_tile_type is omitted on a surface that is not a tile',
      () async {
        // PDP main is a page. Android's PDP payload has no such key either.
        expect(
          (await add(sourceTileType: null)).containsKey('source_tile_type'),
          isFalse,
        );
      },
    );

    test('from_location names the rail when one is passed', () async {
      // The only thing separating the three PDP surfaces — they all report
      // `from_screen: "Product details"`.
      expect(
        (await add(fromLocation: FromLocations.recoSection))['from_location'],
        FromLocations.recoSection,
      );
    });
  });

  group('the drop rules', () {
    test('a zero reaches the wire', () async {
      // Under a `num <= 0` drop rule `from_age: 0` does not arrive as 0, it does not
      // arrive at all — so newborn products are indistinguishable from products of
      // unknown age. The server owns the value and the client passes it through.
      //
      // ⚠️ Android still drops it (`Extentions.kt:150`), so this property's presence
      // differs by platform until that line goes too.
      final e = await add(meta: {...tileBlock, 'from_age': 0});
      expect(e['from_age'], 0);
      expect(e['available_quantity'], 1);
    });

    test('null and empty values are forwarded as sent', () async {
      // The block reaches the wire unfiltered, so what the backend puts in it is
      // what Segment records.
      //
      // ⚠️ A null lands on a dashboard as a real value called "unknown", beside
      // genuinely-absent; an empty collection reports a dimension with nothing to
      // group by. Both are the backend's to avoid sending.
      final e = await add(
        meta: {
          ...tileBlock,
          'merch_type': '',
          'brand_name': null,
          'promo_tags': <String>[],
          'nested': <String, String>{},
        },
      );
      for (final k in ['merch_type', 'brand_name', 'promo_tags', 'nested']) {
        expect(e.containsKey(k), isTrue, reason: '`$k` should be forwarded');
      }
      expect(e['merch_type'], '');
      expect(e['brand_name'], isNull);
      expect(e['promo_tags'], <String>[]);
      expect(e['nested'], <String, String>{});
    });

    test('a missing block still produces a usable event', () async {
      final e = await add(meta: null);
      expect(e['product_id'], '904219');
      expect(e['from_screen'], FromScreens.product);
    });
  });

  group('remove', () {
    test('price_status is the literal "none"', () async {
      // Android sends the literal — not a computed status.
      expect((await remove())['price_status'], AnalyticsDefaults.none);
    });

    test('low_inventory is forwarded, including "Sold out"', () async {
      // The client derives nothing. "Sold out" exists only because BE sends it —
      // Android's third value needs `canWishList`, which is not on our entity.
      for (final v in ['Yes', 'No', 'Sold out']) {
        expect(
          (await remove(
            meta: {...tileBlock, 'low_inventory': v},
          ))['low_inventory'],
          v,
        );
      }
    });

    test('no derivation from available_quantity', () async {
      // A stock count with no `low_inventory` yields no key rather than a guess:
      // "No" would assert healthy stock on no evidence, and a client derivation from
      // `quantity` could never produce "Sold out".
      final meta = {...tileBlock}..remove('low_inventory');
      for (final q in [0, 2, 99]) {
        final e = await remove(meta: {...meta, 'available_quantity': q});
        expect(e.containsKey('low_inventory'), isFalse, reason: 'quantity $q');
        expect(e['available_quantity'], q);
      }
    });

    test('carries the same block as the add event', () async {
      // ⚠️ A deliberate divergence: Android's remove payload is a SUBSET of its add
      // payload. Forwarding the block means this one is not. Additive — no existing
      // value moves — and the alternative is an app-side allow-list deciding which
      // server keys an event may report.
      final e = await remove();
      for (final k in ['mrp', 'pre_order', 'merch_type', 'image_url']) {
        expect(e[k], tileBlock[k], reason: '`$k` should be forwarded');
      }
    });
  });

  group('PDP main sends two blocks', () {
    const skuBlock = <String, dynamic>{
      'sku_id': 'WHA-3049920',
      'sku_size': '4-5 Y',
      'pdt_size': '4-5 Y',
      'available_quantity': 3,
      'low_inventory': 'Yes',
    };

    test('both are forwarded', () async {
      final e = await add(meta: productBlock, skuMeta: skuBlock);
      expect(e['name'], 'Pink All Over Sleeveless Top');
      expect(e['sku_id'], 'WHA-3049920');
      expect(e['sku_size'], '4-5 Y');
      expect(e['low_inventory'], 'Yes');
    });

    test('the SKU block wins where both carry a key', () async {
      // The size-specific value is the more precise one, and it is merged last.
      final e = await add(
        meta: {...productBlock, 'available_quantity': 999},
        skuMeta: skuBlock,
      );
      expect(e['available_quantity'], 3);
    });

    test('the selected size is whatever the SKU block calls it', () async {
      // No spelling is asserted here on purpose. The client reads no key by name, so
      // it cannot fall out of step with a server-side rename — the wire simply
      // carries what arrived. `sku_id` is what the live response sends today.
      final e = await add(meta: productBlock, skuMeta: skuBlock);
      expect(e['sku_id'], 'WHA-3049920');
      expect(e.containsKey('sku'), isFalse);

      final renamed = await add(
        meta: productBlock,
        skuMeta: {...skuBlock}
          ..remove('sku_id')
          ..['sku'] = 'WHA-3049920',
      );
      expect(renamed['sku'], 'WHA-3049920');
    });
  });

  group('no key is excluded by name', () {
    test('slug and isPidAplus are forwarded like any other key', () async {
      // Neither is wanted on the wire, and neither is filtered here: `slug` is a URL
      // fragment and `isPidAplus` is out of scope in Flutter, but the channel reads no
      // key by name, so what the block carries is what ships. Both survive the shape
      // rules too — `slug` is a non-empty string, `isPidAplus` a bool, and `false` is
      // a fact rather than an absence.
      //
      // Keeping them off the wire is a backend change: drop them from `trackingMeta`
      // and they stop arriving. `pdp_product_924925_range_price.json` still carries
      // both, so this is live behaviour, not a hypothetical.
      final e = await add(
        meta: {...tileBlock, 'slug': 'a-slug', 'isPidAplus': false},
      );
      expect(e['slug'], 'a-slug');
      expect(e['isPidAplus'], isFalse);
    });
  });

  group('one shape now depends on the blocks agreeing', () {
    test('a tile-sourced event carries the TILE spellings', () async {
      // Not a client defect — the record of a backend naming gap. The tile blocks
      // say `category_name` / `product_name` / `brand_name` / `on_sale` where the
      // product block says `category` / `name` / `brand` / `sale`, so the same
      // dimension arrives under two keys depending on which surface fired.
      //
      // Reconciling it here would be the renaming this channel exists to remove, so
      // it is pinned instead: when BE aligns §4/§5 with the wire names, this test
      // fails and is deleted.
      final tileEvent = await add(meta: tileBlock);
      final pdpEvent = await add(meta: productBlock);

      expect(tileEvent['category_name'], 'Apparel - Children');
      expect(tileEvent.containsKey('category'), isFalse);

      expect(pdpEvent['category'], 'Apparel - Children');
      expect(pdpEvent.containsKey('category_name'), isFalse);
    });

    test('preorder now arrives as pre_order, the name BE sends', () async {
      // The wire carries whatever BE calls it, and BE calls it `pre_order` in every
      // block while the Amplitude property is `preorder`. That belongs on the BE ask
      // alongside the taxonomy spellings — mapping it back here would be a rename.
      final e = await add(meta: {...tileBlock, 'pre_order': 'No'});
      expect(e['pre_order'], AnalyticsDefaults.no);
      expect(e.containsKey('preorder'), isFalse);
    });
  });

  group('the event names', () {
    test('are the Android strings', () async {
      await add();
      await remove();
      expect(
        AnalyticsEvents.productAddedToWishlist,
        'product_added_to_wishlist',
      );
      expect(
        AnalyticsEvents.productRemovedFromWishlist,
        'product_removed_from_wishlist',
      );
    });
  });
}
