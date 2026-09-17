import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/events/modules/pdp_events.dart';
import 'package:hs_app_flutter/features/pdp/data/models/product_detail_model.dart';
import 'package:hs_app_flutter/features/pdp/domain/entities/product_detail_entity.dart';

import '../../support/analytics_test_harness.dart';

/// Closes finding **B5**, which blocked the port: nothing had confirmed that
/// Flutter's `v3/product` ships per-item `trackingMeta` inside `recentlyViewed`.
/// Without it, three of the four `clicked_product_*` properties on
/// `recently_viewed_products_clicked` would silently ship absent — the widest
/// unverified gap in the whole event catalogue.
///
/// A staging capture with the block populated settles it: every tile carries
/// `categoryName`, `subcategoryName` and `productTypeName`, exactly the three
/// fields Android's `ProductItemTrackingMeta` declares
/// (`common/.../carousel/ProductItemTrackingMeta.kt`). So the event is complete
/// on both platforms, and no backend work is required.
///
/// These tests drive the event from the **real fixture tiles** rather than a
/// hand-built entity, so they fail if the response shape regresses — which a
/// hand-built entity could never catch.
void main() {
  late AnalyticsTestHarness h;
  late ProductDetailEntity flat;

  setUp(() async {
    h = await AnalyticsTestHarness.build();
    flat =
        ProductDetailModel.fromJson(
          jsonDecode(
                File(
                  'test/analytics/fixtures/pdp_product_945499.json',
                ).readAsStringSync(),
              )
              as Map<String, dynamic>,
        ).toEntity();
  });
  tearDown(() => h.tearDown());

  group('the v3 response carries per-tile trackingMeta', () {
    test('recentlyViewed parses, and every tile has all three fields', () {
      final tiles = flat.recentlyViewed?.tiles ?? const [];
      expect(
        tiles,
        hasLength(4),
        reason: 'recentlyViewed failed to parse from the real response',
      );

      for (final tile in tiles) {
        expect(
          tile.trackingMeta,
          isNotNull,
          reason:
              'tile ${tile.product.id} lost its trackingMeta — clicked_product_type, '
              '_category and _subcategory would all ship absent',
        );
        // The tile node carries the already-prefixed click block. The product's
        // own block still uses unprefixed names, but no PDP event reads it.
        for (final key in const [
          'clicked_product_category',
          'clicked_product_subcategory',
          'clicked_product_type',
        ]) {
          expect(
            tile.trackingMeta![key],
            isA<String>().having((s) => s.isNotEmpty, 'non-empty', isTrue),
            reason: 'tile ${tile.product.id} is missing $key',
          );
        }
      }
    });

    test('widget_position is the real tile index', () {
      // The recently-viewed block sends the real index, so the key identifies a
      // tile's position and is worth forwarding — which the passthrough does, under
      // whatever name BE uses.
      //
      // ⚠️ The reco block sends `0` on every record. Same key, two surfaces, one
      // meaningful and one not, so anything grouping by it must segment on surface.
      // Lives on the tile's PRODUCT node, not the tile node — the tile node
      // carries only the click block. No PDP event chains the product node, so
      // this key reaches the wire on tile/impression surfaces, not from here.
      final positions = flat.recentlyViewed!.tiles
          .map((t) => t.product.trackingMeta!['widget_position'])
          .toList();
      expect(positions, List<int>.generate(positions.length, (i) => i));
    });
  });

  group('recently_viewed_products_clicked, driven from a real tile', () {
    test('all four clicked_product_* properties ship', () async {
      final clicked = flat.recentlyViewed!.tiles.first;
      await h.analytics.logRecentlyViewedProductsClicked(product: flat.product!, tile: clicked);

      final props = h.captured.single.props;
      expect(props['clicked_product_pid'], '932944');
      expect(props['clicked_product_type'], 'Short set');
      expect(props['clicked_product_category'], 'Apparel - Children');
      expect(props['clicked_product_subcategory'], 'Sets');
    });

    test('clicked_product_pid is a String, matching Android', () async {
      // Android's `ProductItem.id` is declared `String?`, so Gson coerces the
      // JSON number 932944 to "932944". Flutter must stringify to match, or
      // Amplitude buckets the two platforms separately (the finding-C1 failure
      // mode, on a second property).
      await h.analytics.logRecentlyViewedProductsClicked(
        product: flat.product!,
        tile: flat.recentlyViewed!.tiles.first,
      );
      expect(h.captured.single.props['clicked_product_pid'], isA<String>());
    });

    test('the base PDP block still rides along', () async {
      await h.analytics.logRecentlyViewedProductsClicked(
        product: flat.product!,
        tile: flat.recentlyViewed!.tiles.first,
      );
      final props = h.captured.single.props;
      // Android appends pdpPageProperties() last on this event, so the viewed
      // product's own identity must survive alongside the clicked tile's.
      expect(props['product_id'], '945499');
      expect(props['category'], 'Apparel - Children');
    });

    test('every tile produces a complete payload, not just the first', () async {
      for (final tile in flat.recentlyViewed!.tiles) {
        await h.analytics.logRecentlyViewedProductsClicked(product: flat.product!, tile: tile);
      }
      expect(h.captured, hasLength(4));
      for (final captured in h.captured) {
        for (final key in const [
          'clicked_product_pid',
          'clicked_product_type',
          'clicked_product_category',
          'clicked_product_subcategory',
        ]) {
          expect(
            captured.props.containsKey(key),
            isTrue,
            reason: '$key dropped for one of the tiles',
          );
        }
      }
    });
  });

  group('reco_product_clicked uses the identical projection', () {
    test('same four properties from the same tile shape', () async {
      // Android duplicates the block verbatim (PDPAnalytics.kt:311-315 mirrors
      // :297-300); Flutter shares one helper. Pinned so a change to the helper
      // cannot silently alter only one of the two events.
      final clicked = flat.recentlyViewed!.tiles.first;
      await h.analytics.logRecentlyViewedProductsClicked(product: flat.product!, tile: clicked);
      await h.analytics.logRecoProductClicked(product: flat.product!, tile: clicked);

      const clickedKeys = [
        'clicked_product_pid',
        'clicked_product_type',
        'clicked_product_category',
        'clicked_product_subcategory',
      ];
      Map<String, Object?> slice(int i) => {
        for (final k in clickedKeys) k: h.captured[i].props[k],
      };
      expect(slice(1), slice(0));
    });
  });

  group('feed_size derives from the parsed tile count', () {
    test('recently_viewed_products_loaded reports 4 for this response', () async {
      await h.analytics.logRecentlyViewedProductsLoaded(
        product: flat.product!,
        railTrackingMeta: flat.recentlyViewed!.trackingMeta,
      );
      expect(h.captured.single.props['feed_size'], 4);
    });
  });
}
