import 'package:flutter_test/flutter_test.dart';
import 'package:hs_app_flutter/features/cart/data/models/cart_model.dart';

void main() {
  group('orderDetails parsing', () {
    test('top-level orderDetails is parsed, trackingMeta copy is left raw', () {
      final cart = CartModel.fromJson({
        'orderDetails': {
          'payAmount': 4898.0,
          'shipping': 50.0,
          'totalCredit': 0.0,
          'discountPercentage': 12,
          'totalAmount': 4848.0,
          'itemCount': 11,
          'productAmount': 5518.0,
          'discount': 670.0,
          'platformFee': 0.0,
        },
        // The bag holds 8 lines totalling 11 units — the two counts differ,
        // which is the whole point of reading itemCount off orderDetails.
        'cartItems': List.generate(8, (i) => {'sku': 'SKU-$i', 'quantity': 1}),
        'trackingMeta': {
          'atcUser': 'NB',
          'orderDetails': {'itemCount': 11},
        },
      });

      expect(cart.orderDetails?.itemCount, 11);
      expect(cart.orderDetails?.payAmount, 4898.0);
      expect(cart.orderDetails?.discountPercentage, 12);
      expect(cart.items.length, 8);
      // The analytics copy nested in `trackingMeta` is now parsed too — it is
      // the promo events' price source, and leaving it raw put a nested map on
      // the wire. Both copies carry the same figure, from different nodes.
      expect(cart.trackingMeta?.orderDetails?.itemCount, 11);
      // The flat block keeps only its own keys; the nested object is lifted out
      // so it cannot be forwarded to Segment by accident.
      expect(cart.trackingMeta?.analyticsProps, {'atcUser': 'NB'});
    });

    test('whole-number amounts decode as int without throwing', () {
      final cart = CartModel.fromJson({
        'orderDetails': {'shipping': 50, 'payAmount': 4898, 'itemCount': 3},
      });

      expect(cart.orderDetails?.shipping, 50.0);
      expect(cart.orderDetails?.payAmount, 4898.0);
      expect(cart.orderDetails?.itemCount, 3);
    });

    test('a response without orderDetails leaves it null', () {
      final cart = CartModel.fromJson({'cartItems': const []});
      expect(cart.orderDetails, isNull);
    });
  });
}
