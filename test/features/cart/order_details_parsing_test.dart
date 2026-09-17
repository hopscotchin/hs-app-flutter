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
      // Analytics-only, never parsed into an entity.
      expect(cart.trackingMeta?['orderDetails'], isA<Map<String, dynamic>>());
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
