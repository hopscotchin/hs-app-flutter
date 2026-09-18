import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/core/analytics/constants/analytics_properties.dart';
import 'package:hs_app_flutter/core/analytics/product_tracking_props.dart';
import 'package:hs_app_flutter/features/cart/data/models/cart_model.dart';

/// `itemLevelTrackingData` is the backend's per-SKU block, stamped at
/// add-to-cart time. It carries the backend's **own** field names, so unlike
/// the cart-level and `wishlistInfo` blocks it has to be mapped, not forwarded.
///
/// `product_added_to_wishlist` takes only the nine merchandising attributes —
/// the exact set `CartObserver.handleProductWishListedEvent` lifts out of
/// `setProductOrderedData`. A move-to-wishlist reports what the product *is*,
/// not the funnel that first put it in the bag.
void main() {
  /// One SKU's block, copied from the QA `/shopping-cart` response. Note the
  /// camelCase names and that `country` is absent here — the backend does not
  /// send it on every line.
  const ninBlock = <String, dynamic>{
    'atcUser': 'NB',
    'hbt': 'T3',
    'merchType': 'Catalog',
    'source': '',
    'atcSite': 'ios',
    'atcDate': '2026-08-31T09:46:08Z',
    'taste': 'Classic',
    'season': 'Autumn Winter',
    'style': 'Half sleeves',
    'pattern': 'Typography',
    'weave': 'Woven',
  };

  group('merchandising mapping', () {
    test('maps every attribute the backend sent onto its wire key', () {
      final props = ProductTrackingProps.merchandising(ninBlock);
      expect(props[AnalyticsProperties.hbt], 'T3');
      expect(props[AnalyticsProperties.taste], 'Classic');
      expect(props[AnalyticsProperties.season], 'Autumn Winter');
      expect(props[AnalyticsProperties.style], 'Half sleeves');
      expect(props[AnalyticsProperties.pattern], 'Typography');
      expect(props[AnalyticsProperties.weave], 'Woven');
      // The rename: backend `merchType` → wire `merch_type`.
      expect(props[AnalyticsProperties.merchType], 'Catalog');
    });

    test('country becomes v_country', () {
      // The one genuine rename in the set, and the reason spreading the block
      // raw produced nothing for this dimension.
      final props = ProductTrackingProps.merchandising({...ninBlock, 'country': 'India'});
      expect(props['v_country'], 'India');
      expect(props.containsKey('country'), isFalse);
    });

    test('no backend field name reaches the wire', () {
      // The bug this replaced: the block was spread raw, so `merchType` and
      // `atcSite` landed under the backend's spelling.
      final props = ProductTrackingProps.merchandising(ninBlock);
      for (final key in ['merchType', 'atcSite', 'atcUser', 'atcDate', 'country']) {
        expect(props.containsKey(key), isFalse, reason: '`$key` leaked');
      }
    });

    test('carries only the nine, never the attribution keys', () {
      // Android drops these deliberately — they describe the journey that put
      // the item in the bag, not the product.
      final props = ProductTrackingProps.merchandising({
        ...ninBlock,
        'funnel': 'Discover',
        'funnelTile': 'CT1443',
        'section': 'from_plp',
        'plp': '',
        'sortBar': 'All',
        'atcUser': 'NB',
      });
      expect(props.keys.toSet(), {
        AnalyticsProperties.hbt,
        AnalyticsProperties.taste,
        AnalyticsProperties.merchType,
        AnalyticsProperties.style,
        AnalyticsProperties.season,
        AnalyticsProperties.pattern,
        AnalyticsProperties.weave,
      });
    });

    test('an absent attribute is dropped, not sent empty', () {
      // `character` is missing and `source` is empty in the real payload.
      final props = ProductTrackingProps.merchandising(ninBlock);
      expect(props.containsKey(AnalyticsProperties.character), isFalse);
      expect(props.containsKey(AnalyticsProperties.country), isFalse);
    });

    test('a null or empty block maps to nothing', () {
      expect(ProductTrackingProps.merchandising(null), isEmpty);
      expect(ProductTrackingProps.merchandising(const {}), isEmpty);
    });
  });

  group('the per-SKU lookup resolves both response shapes', () {
    Map<String, dynamic> cartJson(Map<String, dynamic> extra) => {
      'cartItems': [
        {'sku': 'NIB-3043512', 'quantity': 1},
      ],
      ...extra,
    };

    test('from trackingMeta.itemLevelTrackingData', () {
      final cart = CartModel.fromJson(
        cartJson({
          'trackingMeta': {
            'itemLevelTrackingData': {'NIB-3043512': ninBlock},
          },
        }),
      );
      expect(cart.trackingForSku('NIB-3043512')?['weave'], 'Woven');
    });

    test('from the top-level orderAttributionData node', () {
      // The shape the live QA response actually uses.
      final cart = CartModel.fromJson(
        cartJson({
          'orderAttributionData': {
            'itemLevelTrackingData': {'NIB-3043512': ninBlock},
          },
        }),
      );
      expect(cart.trackingForSku('NIB-3043512')?['weave'], 'Woven');
    });

    test('a SKU the backend omitted reads as absent, not a crash', () {
      // The old call site indexed straight into the map, so any line the
      // backend had no block for threw on move-to-wishlist.
      final cart = CartModel.fromJson(
        cartJson({
          'orderAttributionData': {
            'itemLevelTrackingData': {'OTHER-SKU': ninBlock},
          },
        }),
      );
      expect(cart.trackingForSku('NIB-3043512'), isNull);
      expect(ProductTrackingProps.merchandising(cart.trackingForSku('NIB-3043512')), isEmpty);
    });

    test('no tracking data at all reads as absent', () {
      final cart = CartModel.fromJson(cartJson(const {}));
      expect(cart.trackingForSku('NIB-3043512'), isNull);
    });
  });
}
